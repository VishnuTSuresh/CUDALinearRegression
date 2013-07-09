/* ---------------------------------------------------------------------------
** Populate.cpp
** Use this to populate X.csv and Y.csv using equation y=a*x1+b*x2+c*x3+d
**
** Author: Vishnu T Suresh
** -------------------------------------------------------------------------*/
#include <iostream>
#include <fstream>
#include <stdlib.h>
using namespace std;

int main(){
	ofstream xfile("X.csv");
	ofstream yfile("Y.csv");
	int n;
	cout<<"Enter Number of Entries:\n>>";
	cin>>n;
	if(xfile.is_open()&&yfile.is_open()){
		int a=5,b=6,c=2,d=3;
		for(int i=0;i<n;i++)
		{
			int x1=rand()%10,x2=rand()%10,x3=rand()%10;
			float y=a*x1+b*x2+c*x3+d;
			xfile << x1 <<","<< x2 <<","<< x3 <<","<< 1 <<"\n";
			yfile << y<<"\n";
		}
		xfile.close();
		yfile.close();
	}
	else
		cout<<"error1";
	return 0;
}
