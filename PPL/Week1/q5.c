#include "mpi.h"
#include <stdio.h>
int main(int argc,char *argv[]){

int rank,i,fact=1,f=1,f1=1,t=0;
MPI_Init(&argc,&argv);
MPI_Comm_rank(MPI_COMM_WORLD,&rank);

if(rank%2==0){
	for (i=1;i<=rank;i++){
	 fact=fact*i;}
	printf("for rank %d , factorial is %d \n",rank,fact);
}

else{
	for(i=0;i<rank;i++){
	f=f1+t;
	t=f1;	
	f1=f;}
	printf("for rank %d , Fibonacci Number is %d \n",rank,t);
	}
MPI_Finalize();
return 0;
}
