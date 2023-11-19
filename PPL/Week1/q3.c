#include "mpi.h"
#include <stdio.h>
int main(int argc,char *argv[]){
int x=5,y=6;
int rank,size;
MPI_Init(&argc,&argv);
MPI_Comm_rank(MPI_COMM_WORLD,&rank);

if(rank==0){
printf("my rank is 0 and addition of %d and %d is %d\n",x,y,x+y);}
else if(rank==1){
printf("my rank is 1 and subtraction of %d and %d is %d\n",x,y,x-y);}
else if(rank==2){
printf("my rank is 2 and multiplication of %d and %d is %d\n",x,y,x*y);}
else if(rank==3){
printf("my rank is 3 and division of %d and %d is %f\n",x,y,(float)x/y);}

MPI_Finalize();
return 0;
}
