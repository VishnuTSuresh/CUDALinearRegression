## CUDA Linear Regression
A matrix class that does basic operations including create 
matrix from csv file, or 0 matrix from number of columns and rows, output
matrix to ostream properly indented, fetch and assign elements, matrix 
multiplication, transpose, inverse, create identity matrix, fetch height and 
width.

Also implements Linear Regression in main function

## Author
Vishnu T Suresh ( vishnutsuresh@live.com )

## Usage
To use make sure you have CUDA 4.2 and CULA Dense R15 installed (all the environment variables must be set and shared libraries visible).

then:
1) 'cd' to src and run 'g++ -o pop.o populate.cpp'.
2) run './pop.o'

You will be prompted for number of entries. The output will be X.csv and Y.csv which represents the independant and dependant variables respectively. Edit source code of populate.cpp to change the coefficients or increase number of variables as needed. 

after that:
1) run 'make'
2) run './main.o'
you will get the calculated values of the coefficients.

You can also use the Matrix Class to do the operations as listed at the top of the file.

## License
Code is under [The MIT License (MIT)](http://opensource.org/licenses/MIT)
