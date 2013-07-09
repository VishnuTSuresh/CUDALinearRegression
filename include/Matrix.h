/* ---------------------------------------------------------------------------
** Matrix.h
**
** This class represents a matrix. it can do basic operations including create 
** matrix from csv file, or 0 matrix from number of columns and rows, output
** matrix to ostream properly indented, fetch and assign elements, matrix 
** multiplication, transpose, inverse, create identity matrix, fetch height and 
** width.
**
** Author: Vishnu T Suresh
** -------------------------------------------------------------------------*/
#ifndef MATRIX_H
#define MATRIX_H
#include <iostream>
#include <vector>
#include <string>
#include "cublas_v2.h"
class Matrix{
	int w,h;
	bool trans;
	std::vector<float> v;

public:
	Matrix(std::string);
	Matrix(int,int);
	friend std::ostream& operator<< (std::ostream &out,Matrix mat);
	float& operator()(int,int);
	Matrix operator*(Matrix);
	friend Matrix trans(Matrix);
	friend Matrix inverse(Matrix);
	static Matrix IdentityMatrix(int);
	int height();
	int width();
};
#endif
