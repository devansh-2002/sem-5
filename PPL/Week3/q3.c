#include "mpi.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#define MCW MPI_COMM_WORLD
int main(int argc, char *argv[]){

int rank, size, l, r, v=0, c, sum=0, cArr[10];
char str[50], ch[10];


MPI_Init(&argc,&argv);
MPI_Comm_rank(MCW, &rank);
MPI_Comm_size(MCW, &size);

if(rank==0)
{
printf("Enter String (with length divisible by '%d') : ", size);
	scanf("%s", str);
	l = strlen(str);
} 

MPI_Bcast(&l, 1, MPI_INT, 0, MCW);

r = (l/size);

MPI_Scatter(str, r, MPI_CHAR, ch, r, MPI_CHAR, 0, MCW);

ch[r] = '\0';

for(int i=0; i<r; i++){
	if (ch[i] == 'a' || ch[i] == 'e' || ch[i] == 'i' || ch[i] == 'o' || ch[i] == 'u' || ch[i] == 'A' || ch[i] == 'E' || ch[i] == 'I' || ch[i] == 'O' || ch[i] == 'U')
	            v++;
	}

c = r - v;

MPI_Gather(&c, 1, MPI_INT, cArr, 1, MPI_INT, 0, MCW);

if(rank==0){
	for(int i=0; i<size; i++){
	   printf("Number of consonants in process %d : %d\n", i, cArr[i]);
		sum += cArr[i];
		}
		
	printf("\nThe total Number of non-vovels are : %d\n", sum);
}

MPI_Finalize();
return 0;
}
