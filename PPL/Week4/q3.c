#include <stdio.h>
#include "mpi.h"
#define MCW MPI_COMM_WORLD
int main(int argc, char* argv[]) {

int rank, size, mat[3][3], arr[3],i,j, found=0, count, ele;
	
MPI_Init(&argc, &argv);
MPI_Comm_rank(MCW, &rank);
MPI_Comm_size(MCW, &size);
	
	if(rank == 0) {
		printf("Enter a 3x3 matrix:\n");
		for( i=0; i<3; i++) {
			for( j=0; j<3; j++) {
				scanf("%d", mat[i] + j);
			}
		}
		
		printf("Enter the search element: ");
		scanf("%d", &ele);
	}
	
MPI_Bcast(&ele, 1, MPI_INT, 0, MCW); 
	
MPI_Scatter(*mat, 3, MPI_INT, arr, 3, MPI_INT, 0, MCW);
	
	for( i=0; i<3; i++) {
		if(arr[i] == ele) {
			found++;
		}
	}	
	
MPI_Reduce(&found, &count, 1, MPI_INT, MPI_SUM, 0, MCW);
	
	if(rank == 0) {
fprintf(stdout, "Occurences of %d is %d times in the matrix.\n", ele, count);
fflush(stdout);
	}
	
	MPI_Finalize();
	return 0;
}
