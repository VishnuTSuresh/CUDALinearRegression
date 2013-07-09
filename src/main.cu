/* ---------------------------------------------------------------------------
** main.h
** This is main function. Here is a demonstration of doing Linear Regression.
**
** Author: Vishnu T Suresh
** -------------------------------------------------------------------------*/
#include <iostream>
#include "Matrix.h"
int main(){
	Matrix Y=Matrix("Y.csv");
	Matrix X=Matrix("X.csv");
	Matrix B=inverse(trans(X)*X)*trans(X)*Y;
	std::cout<<B;
	return 0;
}
