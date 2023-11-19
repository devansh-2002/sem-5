#include<stdio.h>
#include"mpi.h"
#include<stdlib.h>
#define MCW MPI_COMM_WORLD
int factorial(int n)
{
	int f=1;

	for(int i=1;i<=n;i++)
		f *= i;

	return f;
}

int main(int argc, char* argv[]){

int rank, size, arr[20], recv, f;

MPI_Init(&argc,&argv);
MPI_Comm_rank(MCW,&rank);
MPI_Comm_size(MCW,&size);

	if(rank == 0){
		printf("Enter %d numbers : ",size);

		for(int i=0;i<size;i++)
			scanf("%d",&arr[i]);
	}

MPI_Scatter(arr,1,MPI_INT,&recv,1,MPI_INT,0,MCW);

int fact = factorial(recv);

printf("Process %d : received %d from root process, factorial is %d.\n",rank,recv,fact);

	MPI_Reduce(&fact,&f,1,MPI_INT,MPI_SUM,0,MCW);

	if(rank == 0)
	 printf("The sum of all factorials computed is %d.\n",f);

MPI_Finalize();
}
