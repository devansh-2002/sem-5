#include<stdio.h>
#include<stdlib.h>
#include<mpi.h>
#define MCW MPI_COMM_WORLD
int main(int argc, char * argv[]){
int num,rank,size,fact=1, sum=0,err1,err2,len;
char errstr[20];
MPI_Init(&argc,&argv);
MPI_Comm_rank(MCW,&rank);
MPI_Comm_size(MCW,&size);
MPI_Errhandler_set(MCW, MPI_ERRORS_RETURN);

num=rank+1;

err1 = MPI_Scan(&num,&fact,1,MPI_INT,MPI_PROD,sum);
if(err1!=MPI_SUCCESS)
printf("Error in factorial computation\n");
	MPI_Error_string(err1,errstr,&len);
	printf("%s",errstr);
	
printf("rank %d: %d!= %d\n",rank,num,fact);

err2 = MPI_Scan(&fact,&sum,1,MPI_INT,MPI_SUM,MCW);
if(err2!=MPI_SUCCESS)
printf("Error in factorial computation\n");
	MPI_Error_string(err2,errstr,&len);
	printf("%s",errstr);
	
printf("rank %d: %d!= %d\n",rank,sum,fact);


if(rank==size-1){
printf("Partial Sum of 1! +....%d = %d",rank,sum);}
MPI_Finalize();
exit(0);
}
