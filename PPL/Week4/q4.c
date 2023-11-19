#include <stdio.h>
#include "mpi.h"
#define MCW MPI_COMM_WORLD
int main(int argc, char* argv[]) {
	int rank, size, inpmat[4][4], outmat[4][4], inarr[4], outarr[4];
	
MPI_Init(&argc, &argv);
MPI_Comm_rank(MCW, &rank);
MPI_Comm_size(MCW, &size);
	
	if(rank == 0) {
		printf("Enter the 4x4 input matrix:\n");
		for(int i=0; i<4; i++) {
			for(int j=0; j<4; j++) {
				scanf("%d", inpmat[i] + j);
			}
		}
	}
	
MPI_Scatter(*inpmat, 4, MPI_INT, inarr, 4, MPI_INT, 0, MCW);
MPI_Scan(inarr, outarr, 4, MPI_INT, MPI_SUM, MCW); 	
MPI_Gather(outarr, 4, MPI_INT, *outmat, 4, MPI_INT, 0, MCW);
	
	if(rank == 0) {
		printf("\nOutput matrix:\n");
		for(int i=0; i<4; i++) {
			for(int j=0; j<4; j++) {
				printf("\t%d", outmat[i][j]);
			}
			printf("\n");
		}
	}
	
MPI_Finalize();
return 0;
}
