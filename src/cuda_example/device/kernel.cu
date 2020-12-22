#include "kernel.cuh"

#include <cuda_runtime_api.h>
#include <device_launch_parameters.h>


__global__ void add_cuda_kernel(int *c, const int *a, const int *b)
{
    int i = threadIdx.x;
    c[i]  = a[i] + b[i];
}
