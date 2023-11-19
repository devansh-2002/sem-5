#include "mpi.h"
#include <stdio.h>
int main(int argc,char *argv[]){
char s[]="hello";
int rank,m,n;
MPI_Init(&argc,&argv);
MPI_Comm_rank(MPI_COMM_WORLD,&rank);
m=s[rank];
n=(char)(int)m+32;
printf("rank %d, toggle %c to %c\n",rank,m,n);
MPI_Finalize();
return 0;
}
