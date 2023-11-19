#include <stdio.h>

__global__ void oddEvenSort(int *arr, int n)
{
    int tid = threadIdx.x + blockIdx.x * blockDim.x;
    int phase, i, temp;

    for (phase = 0; phase < n; phase++)
    {
        if (phase % 2 == 0)
        { // Even phase
            if (tid % 2 == 0 && tid < n - 1)
            {
                if (arr[tid] > arr[tid + 1])
                {
                    // Swap adjacent elements
                    temp = arr[tid];
                    arr[tid] = arr[tid + 1];
                    arr[tid + 1] = temp;
                }
            }
        }
        else
        { // Odd phase
            if (tid % 2 == 1 && tid < n - 1)
            {
                if (arr[tid] > arr[tid + 1])
                {
                    // Swap adjacent elements
                    temp = arr[tid];
                    arr[tid] = arr[tid + 1];
                    arr[tid + 1] = temp;
                }
            }
        }
        __syncthreads(); // Synchronize threads before next phase
    }
}

int main()
{
    const int n = 8;
    int hostArray[n] = {5, 2, 9, 3, 1, 6, 8, 4};
    int *deviceArray;

    // Allocate memory on the GPU
    cudaMalloc((void **)&deviceArray, n * sizeof(int));

    // Copy data from host to device
    cudaMemcpy(deviceArray, hostArray, n * sizeof(int), cudaMemcpyHostToDevice);

    // Define the block and grid dimensions
    int block_size = 4;
    int grid_size = (n + block_size - 1) / block_size;

    // Launch the kernel
    oddEvenSort<<<grid_size, block_size>>>(deviceArray, n);

    // Copy data back from device to host
    cudaMemcpy(hostArray, deviceArray, n * sizeof(int), cudaMemcpyDeviceToHost);

    // Clean up
    cudaFree(deviceArray);

    // Print sorted array
    printf("Sorted array: ");
    for (int i = 0; i < n; i++)
    {
        printf("%d ", hostArray[i]);
    }
    printf("\n");

    return 0;
}
