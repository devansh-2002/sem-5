#include<stdio.h>
#include<stdlib.h>
#include<cuda_runtime.h>
#define TILE_w 2
#define w 4

__device__ int getTid(){
    int blockRow = blockIdx.y;
    int blockCol = blockIdx.x;
    int rowInBlock = threadIdx.y;
    int colInBlock = threadIdx.x;
    int globalRow = blockRow * blockDim.y + rowInBlock;
    int globalCol = blockCol * blockDim.x + colInBlock;
    return (globalRow*w + globalCol);
}

__global__ void matMul(int* a,int* b, int* c){
    int row = blockIdx.y*blockDim.y + threadIdx.y;
    int col = blockIdx.x*blockDim.x + threadIdx.x;
    int sum = 0;
    for (int k = 0; k < w; k++)
        sum += a[row*w + k] * b[k*w + col];
    c[row*w + col] = sum;
} 

int main(){
    int* matA,*matB,*matC,*da,*db,*dc;
    printf("Enter the elements of (4x4) matrix A:\n");
    matA = (int*)malloc(sizeof(int)*w*w);
    for (int i = 0; i < w*w; i++)
        scanf("%d",&matA[i]);
    printf("Enter the elements of (4x4) matrix B:\n");
    matB = (int*)malloc(sizeof(int)*w*w);
    for (int i = 0; i < w*w; i++)
        scanf("%d",&matB[i]);
    matC = (int*)malloc(sizeof(int)*w*w);
    cudaMalloc((void**) &da,sizeof(int)*w*w);
    cudaMalloc((void**) &db,sizeof(int)*w*w);
    cudaMalloc((void**) &dc,sizeof(int)*w*w);
    cudaMemcpy(da,matA,sizeof(int)*w*w,cudaMemcpyHostToDevice);
    cudaMemcpy(db,matB,sizeof(int)*w*w,cudaMemcpyHostToDevice);
    dim3 grid_conf(w/TILE_w,w/TILE_w);
    dim3 block_conf(TILE_w,TILE_w);
    matMul<<<grid_conf,block_conf>>>(da,db,dc);
    cudaMemcpy(matC,dc,sizeof(int)*w*w,cudaMemcpyDeviceToHost);
    printf("Result:\n");
    for (int i = 0; i < w; i++){
        for (int j = 0; j < w; j++){
            printf("%6d ",matC[i*w + j]);
        }
        printf("\n");
    }
    cudaFree(da);
    cudaFree(db);
    cudaFree(dc);
    return 0;
}
