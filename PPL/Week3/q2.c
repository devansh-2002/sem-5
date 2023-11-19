#include<stdio.h>
#include<mpi.h>
#include<stdlib.h>
#define MCW MPI_COMM_WORLD
int main(int argc, char* argv[])
{
	int rank, size, arr[50], recv[20], n;
	float avg, sum;

	MPI_Init(&argc,&argv);
	MPI_Comm_rank(MCW,&rank);
	MPI_Comm_size(MCW,&size);

	if(rank == 0)
	{
		printf("Enter a number : ");
		scanf("%d",&n);

		printf("Enter %d elements : ",n*size);
		for(int i=0;i<n*size;i++)
			scanf("%d",&arr[i]);
	}

MPI_Bcast(&n,1,MPI_INT,0,MCW);
MPI_Scatter(arr,n,MPI_INT,recv,n,MPI_INT,0,MCW);

	for(int i=0;i<n;i++)
		avg += recv[i];

avg /= n;

printf("Average of values in process %d : is %f.\n",rank,avg);

MPI_Reduce(&avg,&sum,1,MPI_FLOAT,MPI_SUM,0,MCW);

sum /= size;

     if(rank == 0)
        fprintf(stdout,"Total average of all values is %f.\n",sum);

MPI_Finalize();
}
