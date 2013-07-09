/* ---------------------------------------------------------------------------
** Matrix.cu
** See Matrix.h for more details
**
** Author: Vishnu T Suresh
** -------------------------------------------------------------------------*/
#include "Matrix.h"
#include <iostream>
#include <stdlib.h>
#include <string>
#include <fstream>
#include <sstream>

#include "cublas_v2.h"
#include <cula.h>
#include <cula_lapack.h>
Matrix::Matrix(std::string filename){
	w=0;
	h=0;
	trans=false;
	std::ifstream infile(filename.c_str());
	bool ind_var=false;
	if(infile.is_open()){
		std::string line = "";
		while (getline(infile, line))
		{
			h++;
			std::stringstream strstr(line);
			std::string value = "";
			while (std::getline(strstr,value, ','))
			{
				if(!ind_var)
				{
					w++;
				}
				v.push_back((float)atof(value.c_str()));

			}
			ind_var=true;
		}
	}
	else
		exit(EXIT_FAILURE);
}
float& Matrix::operator()(int i,int j){
	return v[(j-1)*w +(i-1)];
}
std::ostream& operator<< (std::ostream &out, Matrix mat){
	if(!mat.trans)
		for(int j=1;j<=mat.h;j++)
		{
			for(int i=1;i<=mat.w;i++)
			{
				out<<mat(i,j)<<"\t";
			}
			out<<"\n";
		}
	else
		for(int j=1;j<=mat.w;j++)
		{
			for(int i=1;i<=mat.h;i++)
			{
				out<<mat(j,i)<<"\t";
			}
			out<<"\n";
		}
	
	return out;
}
Matrix Matrix::operator* (Matrix mat){
	cudaError_t cudaStat;
	cublasStatus_t stat;
	cublasHandle_t handle;

	float* dv,*dv2,*dc;
	cudaStat = cudaMalloc ((void**)&dv, w*h*sizeof(float));
	if (cudaStat != cudaSuccess) {
		printf ("device memory allocation failed");
		exit(EXIT_FAILURE);
	}
	cudaStat = cudaMalloc ((void**)&dv2, (mat.w)*(mat.h)*sizeof(float));
	if (cudaStat != cudaSuccess) {
		printf ("device memory allocation failed");
		exit(EXIT_FAILURE);
	}

	int ch,cw,k;
	cublasOperation_t transa,transb;
	if(trans)
	{
		ch=w;
		k=h;
		transa=CUBLAS_OP_N;
	}
	else
	{
		ch=h;
		k=w;
		transa=CUBLAS_OP_T;
	}
	if(mat.trans)
	{
		cw=mat.h;
		transb=CUBLAS_OP_N;
	}
	else
	{
		cw=mat.w;
		transb=CUBLAS_OP_T;
	}
	cudaStat = cudaMalloc ((void**)&dc, ch*cw*sizeof(float));
	if (cudaStat != cudaSuccess) {
		printf ("device memory allocation failed");
		exit(EXIT_FAILURE);
	}
	stat = cublasCreate(&handle);
	if (stat != CUBLAS_STATUS_SUCCESS) {
		printf ("CUBLAS initialization failed\n");
		exit(EXIT_FAILURE);
	}
	stat = cublasSetMatrix (w, h, sizeof(float), &v[0], w, dv, w);
	if (stat != CUBLAS_STATUS_SUCCESS) {
		printf ("data download failed");
		cudaFree (dv);
		cublasDestroy(handle);
		exit(EXIT_FAILURE);
	}
	stat = cublasSetMatrix (mat.w, mat.h, sizeof(float), &(mat.v[0]), mat.w, dv2, mat.w);
	if (stat != CUBLAS_STATUS_SUCCESS) {
		printf ("data download failed");
		cudaFree (dv);
		cublasDestroy(handle);
		exit(EXIT_FAILURE);
	}
	const float alpha=1.0f,beta=0.0f;
	cublasSgemm(handle,transa,transb,ch,cw,k,&alpha,dv,w,dv2,mat.w,&beta,dc,ch);
	Matrix C(ch,cw);
	C.trans=true;
	stat=cublasGetMatrix(cw,ch,sizeof(float),dc,cw,&(C.v[0]),cw);
	cudaFree(dv);
	cudaFree(dv2);
	cudaFree(dc);
	if (stat != CUBLAS_STATUS_SUCCESS) {
		if(stat == CUBLAS_STATUS_INVALID_VALUE)
			fprintf (stderr, "!!!! invalid value\n");
		fprintf (stderr, "!!!! device read error\n");
		exit(EXIT_FAILURE);
	}

	return C;
}
Matrix::Matrix(int width,int height){
	w=width;
	h=height;
	trans=false;
	v.resize(w*h,0);
}
Matrix trans(Matrix mat){
	mat.trans=true;
	return mat;
}
Matrix inverse(Matrix mat){
	int size=mat.h;
	int *ipiv;
	float *cache,*devOutput,*Output;
	int size2 = size * size * sizeof(float);
	
	Output=(float*)malloc(size2);
	cudaMalloc(&ipiv, size2);
	cudaMalloc(&cache, size2);
	cudaMalloc(&devOutput, size2);
	
	cudaMemcpy(cache, &(mat.v[0]), size2, cudaMemcpyHostToDevice);
	cudaMemcpy(devOutput, &((Matrix::IdentityMatrix(size)).v[0]), size2, cudaMemcpyHostToDevice);
	
	culaInitialize();
	culaDeviceSgesv(size, size, cache, size, ipiv, devOutput, size);
	culaShutdown();
	cudaMemcpy(Output,devOutput, size2, cudaMemcpyDeviceToHost);
		for(int j = 1; j <= size; ++j)
		        	for(int i = 1; i <= size; ++i)
		        		mat(i,j)=Output[(j-1)*size+(i-1)];
	cudaFree(ipiv);
	cudaFree(cache);
	cudaFree(devOutput);
	free(Output);
	return mat;
}
Matrix Matrix::IdentityMatrix(int n){
	Matrix mat(n,n);
	for(int i=1;i<=n;i++)
	{
		mat(i,i)=1;
	}
	return mat;
}
int Matrix::height(){
	return h;
}
int Matrix::width(){
	return w;
}
