#include <stdio.h>
#include <stdlib.h>
#include <cuda.h>

const int N = 8; // The number of elements in the array

__global__ void merge(int *arr, int *temp, int left, int middle, int right)
{
    int i = left;
    int j = middle + 1;

    for (int k = left; k <= right; k++)
    {
        if (i <= middle && (j > right || arr[i] <= arr[j]))
        {
            temp[k] = arr[i];
            i++;
        }
        else
        {
            temp[k] = arr[j];
            j++;
        }
    }

    for (int k = left; k <= right; k++)
    {
        arr[k] = temp[k];
    }
}

__global__ void mergeSort(int *arr, int *temp, int n)
{
    for (int currentSize = 1; currentSize < n; currentSize *= 2)
    {
        for (int leftStart = 0; leftStart < n - 1; leftStart += 2 * currentSize)
        {
            int middle = min(leftStart + currentSize - 1, n - 1);
            int rightEnd = min(leftStart + 2 * currentSize - 1, n - 1);
        }
    }
}
__host__ void hostMergeSort(int *deviceArray, int *deviceTemp, int n)
{
    for (int currentSize = 1; currentSize < n; currentSize *= 2)
    {
        for (int leftStart = 0; leftStart < n - 1; leftStart += 2 * currentSize)
        {
            int middle = min(leftStart + currentSize - 1, n - 1);
            int rightEnd = min(leftStart + 2 * currentSize - 1, n - 1);
            merge<<<1, 1>>>(deviceArray, deviceTemp, leftStart, middle, rightEnd);
            cudaDeviceSynchronize(); // Wait for the kernel to finish
        }
    }
}

int main()
{
    int hostArray[N] = {5, 2, 9, 3, 1, 6, 8, 4};
    int *deviceArray, *deviceTemp;

    // Allocate memory on the GPU
    cudaMalloc((void **)&deviceArray, N * sizeof(int));
    cudaMalloc((void **)&deviceTemp, N * sizeof(int));

    // Copy data from host to device
    cudaMemcpy(deviceArray, hostArray, N * sizeof(int), cudaMemcpyHostToDevice);

    // Call the hostMergeSort function
    hostMergeSort(deviceArray, deviceTemp, N);

    // Copy data back from device to host
    cudaMemcpy(hostArray, deviceArray, N * sizeof(int), cudaMemcpyDeviceToHost);

    // Clean up
    cudaFree(deviceArray);
    cudaFree(deviceTemp);

    // Print sorted array
    printf("Sorted array: ");
    for (int i = 0; i < N; i++)
    {
        printf("%d ", hostArray[i]);
    }
    printf("\n");

    return 0;
}
