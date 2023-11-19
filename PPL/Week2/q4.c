#include<stdio.h>
#include<stdlib.h>
#include<mpi.h>
#define MCW MPI_COMM_WORLD
int main(int argc, char *argv[])
{
	int rank,size,num;

	MPI_Init(&argc,&argv);
	MPI_Comm_size(MCW,&size);
	MPI_Comm_rank(MCW,&rank);
	MPI_Status status;

	if(rank==0)
	{
		printf("Enter the number: ");
		scanf("%d",&num);

		MPI_Send(&num,1,MPI_INT,1,0,MCW);
		MPI_Recv(&num,1,MPI_INT,size-1,0,MCW,&status);

		printf("%d received by process no: 0\n",num);
	}
	else
	{
		MPI_Recv(&num,1,MPI_INT,rank-1,0,MCW,&status);

		printf("%d received by process no: %d\n",num,rank);

		num++;

		if(rank==size-1)
		{
			MPI_Send(&num,1,MPI_INT,0,0,MCW);
		}
		else
		{
			MPI_Send(&num,1,MPI_INT,rank+1,0,MCW);
		}
	}

	MPI_Finalize();

	return 0;

}
