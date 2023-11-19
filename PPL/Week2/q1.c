#include<stdio.h>
#include<stdlib.h>
#include<mpi.h>
#include<string.h>
#define MCW MPI_COMM_WORLD
int main(int argc, char *argv[])
{
	int rank,size;
	char string[50];

	MPI_Init(&argc,&argv);
	MPI_Comm_rank(MCW,&rank);
	MPI_Comm_size(MCW,&size);
	MPI_Status status;

	if(rank==0)
	{

		printf("Enter a word: ");
		scanf("%s",string);
		
		MPI_Ssend(&string,sizeof(string),MPI_CHAR,1,0,MCW);
		
		MPI_Recv(&string,sizeof(string),MPI_CHAR,1,0,MCW,&status);
		
		printf("\n***Received the word ***\n");

	}
	if(rank==1)
	{
		MPI_Recv(&string,sizeof(string),MPI_CHAR,0,0,MCW,&status);

		for(int counter=0;counter <= strlen(string) ;counter++)
		{
			if(string[counter]>='A'&& string[counter]<='Z')
				string[counter]+=32;
			else if(string[counter] >='a'&& string[counter]<='z')
				string[counter]-=32;
		}

		MPI_Ssend(&string,1,MPI_CHAR,0,0,MCW);
		printf("%d",rank);
	}

	printf("The toggled word is %s\n",string);
	MPI_Finalize();
	return 0;
}
