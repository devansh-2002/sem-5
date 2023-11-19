#include <stdio.h>
#include <stdlib.h>
#include <cuda_runtime.h>

#define TILE_w 2
#define w 4
#define MASK_w 3

__global__ void convolution(int *input, int *mask, int *output) {
    int row = blockIdx.y * blockDim.y + threadIdx.y;
    int col = blockIdx.x * blockDim.x + threadIdx.x;

    int sum = 0;

    for (int i = 0; i < MASK_w; i++) {
        for (int j = 0; j < MASK_w; j++) {
            int inputRow = row + i - MASK_w / 2;
            int inputCol = col + j - MASK_w / 2;

            if (inputRow >= 0 && inputRow < w && inputCol >= 0 && inputCol < w) {
                sum += input[inputRow * w + inputCol] * mask[i * MASK_w + j];
            }
        }
    }

    output[row * w + col] = sum;
}

int main() {
    int *input, *mask, *output, *d_input, *d_mask, *d_output;

    printf("Enter the elements of (4x4) input matrix:\n");
    input = (int*)malloc(sizeof(int) * w * w);
    for (int i = 0; i < w * w; i++) {
        scanf("%d", &input[i]);
    }

    printf("Enter the elements of (3x3) mask matrix:\n");
    mask = (int*)malloc(sizeof(int) * MASK_w * MASK_w);
    for (int i = 0; i < MASK_w * MASK_w; i++) {
        scanf("%d", &mask[i]);
    }

    output = (int*)malloc(sizeof(int) * w * w);
    cudaMalloc((void**)&d_input, sizeof(int) * w * w);
    cudaMalloc((void**)&d_mask, sizeof(int) * MASK_w * MASK_w);
    cudaMalloc((void**)&d_output, sizeof(int) * w * w);

    cudaMemcpy(d_input, input, sizeof(int) * w * w, cudaMemcpyHostToDevice);
    cudaMemcpy(d_mask, mask, sizeof(int) * MASK_w * MASK_w, cudaMemcpyHostToDevice);

    dim3 grid_conf(w / TILE_w, w / TILE_w);
    dim3 block_conf(TILE_w, TILE_w);

    convolution<<<grid_conf, block_conf>>>(d_input, d_mask, d_output);

    cudaMemcpy(output, d_output, sizeof(int) * w * w, cudaMemcpyDeviceToHost);

    printf("Result of Convolution:\n");
    for (int i = 0; i < w; i++) {
        for (int j = 0; j < w; j++) {
            printf("%6d ", output[i * w + j]);
        }
        printf("\n");
    }

    cudaFree(d_input);
    cudaFree(d_mask);
    cudaFree(d_output);
    free(input);
    free(mask);
    free(output);

    return 0;
}
