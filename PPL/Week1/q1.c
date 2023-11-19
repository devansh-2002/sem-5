#include "mpi.h"
#include <stdio.h>
#include<math.h>
int main(int argc,char *argv[]){
int rank;
MPI_Init(&argc,&argv);
MPI_Comm_rank(MPI_COMM_WORLD,&rank);
double sol=pow(5,rank);
printf("my rank is %d and pow(5,rank) is %lf\n",rank,sol);

MPI_Finalize();
return 0;
}
