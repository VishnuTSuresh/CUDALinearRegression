IDIR =-I../include -I$(CULA_INC_PATH)
CC=nvcc
CFLAGS=$(IDIR) $(LDIR)

ODIR=obj
LDIR =-L../lib -L/usr/local/cuda/lib64 -L$(CULA_LIB_PATH_64)

LIBS= -lcublas -lcula_core -lcula_lapack

all:
	$(CC) -o main.o *.cu $(IDIR) $(LDIR) $(LIBS)

.PHONY: clean

clean:
	rm -f $(ODIR)/*.o *~ core $(INCDIR)/*~ 


