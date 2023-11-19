#include <stdio.h>
#include "mpi.h"
#define MCW MPI_COMM_WORLD
int main(int argc, char* argv[]) {
	int rank, size, n;
long double t, f, x, pie, val = 0.0;
	
MPI_Init(&argc, &argv);
MPI_Comm_rank(MCW, &rank);
MPI_Comm_size(MCW, &size);
	
if(rank == 0) {
	printf("Enter the number of intervals, n: ");
	scanf("%d", &n);
}
	
MPI_Bcast(&n, 1, MPI_INT, 0, MCW);

t = 1.0 / n; 
	
for(int i=rank; i<n; i+=size) {
	x = (i + 0.5) * t;
	f = 4.0 / (1 + x * x);
	val += f * t;
}
	
MPI_Reduce(&val, &pie, 1, MPI_LONG_DOUBLE, MPI_SUM, 0, MCW);
	
if(rank == 0) 
printf("Value of pie approximated with %d intervals = %Lf\n", n, pie);
	
MPI_Finalize();
return 0;
}
