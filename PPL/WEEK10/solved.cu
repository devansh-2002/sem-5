//Matrix multiplication of 4x4 matrix
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <cuda_runtime.h>
#define BLOCK_w 2
#define TILE_w 2
#define w 4

__global__ void MatMulElementThreadShared(int *a, int *b, int *c) {
__shared__ int MDs[TILE_w][TILE_w];
__shared__ int NDs[TILE_w][TILE_w];
int m;
int bx=blockIdx.x; int by=blockIdx.y;
int tx=threadIdx.x; int ty=threadIdx.y;
int Row=by*TILE_w + ty;
int Col= bx*TILE_w + tx;
int Pvalue=0;
for(m=0; m<w/TILE_w; m++){
MDs[ty][tx]=a[Row*w+m*TILE_w+tx];
NDs[ty][tx]=b[(m*TILE_w+ty)*w+Col];
__syncthreads();
for (int k = 0; k < TILE_w; k++){
	Pvalue += MDs[ty][k]*NDs[k][tx];
				}
	__syncthreads();
	}
	c[Row*w+Col] = Pvalue;
}

int main() {
int *matA, *matB, *matProd;
int *da, *db, *dc;
printf("\n== Enter elements of Matrix A (4x4) ==\n");
matA = (int*)malloc(sizeof(int) * w * w);
for(int i = 0; i < w * w; i++)
{
scanf("%d", &matA[i]);
}
printf("\n== Enter elements of Matrix B (4x4) ==\n");
matB = (int*)malloc(sizeof(int) * w * w);
for(int i = 0; i < w * w; i++)
{
scanf("%d", &matB[i]);
}
matProd = (int*)malloc(sizeof(int) * w * w);
cudaMalloc((void **) &da, sizeof(int) * w * w);
cudaMalloc((void **) &db, sizeof(int) * w * w);
cudaMalloc((void **) &dc, sizeof(int) * w * w);
cudaMemcpy(da, matA, sizeof(int) * w *w, cudaMemcpyHostToDevice);
cudaMemcpy(db, matB, sizeof(int) * w *w, cudaMemcpyHostToDevice);
int NumBlocks = w / BLOCK_w;
dim3 grid_conf (NumBlocks, NumBlocks);
dim3 block_conf (BLOCK_w, BLOCK_w);
MatMulElementThreadShared<<<grid_conf, block_conf>>>(da, db, dc);
cudaMemcpy(matProd,dc,sizeof(int)* w *w,cudaMemcpyDeviceToHost);
printf("\n-=Result of Addition=-\n");
printf("\n");
for (int i = 0; i < w; i++ ) {
for (int j = 0; j < w; j++) {
printf("%6d ", matProd[i * w + j]);
}printf("\n");
}
cudaFree(da);
cudaFree(db);
cudaFree(dc);
free(matA);
free(matB);
free(matProd);
return 0;
}
