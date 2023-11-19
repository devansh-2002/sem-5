#include <stdio.h>
#include <math.h>
#include "cuda_runtime.h"
#include "device_launch_parameters.h"

__global__ void calculateSine(float *angles, float *sineResults, int numAngles) {
    int tid = blockIdx.x * blockDim.x + threadIdx.x;

    if (tid < numAngles) {
        sineResults[tid] = sinf(angles[tid]);
    }
}
int main() {
    int numAngles = 5; 
    float h_angles[] = {41.0, 42.0, 43.0, 44.0, 45.0}; 
    float h_sineResults[numAngles]; 

    float *d_angles, *d_sineResults;
    int size = numAngles * sizeof(float); 

    cudaMalloc((void **)&d_angles, size);
    cudaMalloc((void **)&d_sineResults, size);

    cudaMemcpy(d_angles, h_angles, size, cudaMemcpyHostToDevice);
    int blockSize = 256;
    int numBlocks = (numAngles + blockSize - 1) / blockSize;

    calculateSine<<<numBlocks, blockSize>>>(d_angles, d_sineResults, numAngles);

    cudaMemcpy(h_sineResults, d_sineResults, size, cudaMemcpyDeviceToHost);

    printf("Input Angles (in radians):\n");
    for (int i = 0; i < numAngles; i++) {
        printf("%.2f ", h_angles[i]);
    }
    printf("\n\nSine Results:\n");
    for (int i = 0; i < numAngles; i++) {
        printf("%.4f ", h_sineResults[i]);
    }
    printf("\n");

    cudaFree(d_angles);
    cudaFree(d_sineResults);
    return 0;
}






