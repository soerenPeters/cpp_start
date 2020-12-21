//
// Created by Soeren Peters on 15.12.20.
//

#include "Cuda_example.h"

#include <cuda_runtime_api.h>

#include <spdlog/spdlog.h>

#include "kernel.cuh"

namespace cpp_start
{

std::vector<double> Cuda_example::add(const std::vector<double>& a, const std::vector<double>& b) const
{

    return {};
}


void Cuda_example::print() const
{
    int nDevices;

  cudaGetDeviceCount(&nDevices);
  for (int i = 0; i < nDevices; i++) {
    cudaDeviceProp prop;
    cudaGetDeviceProperties(&prop, i);
    printf("Device Number: %d\n", i);
    printf("  Device name: %s\n", prop.name);
    printf("  Memory Clock Rate (KHz): %d\n",
           prop.memoryClockRate);
    printf("  Memory Bus Width (bits): %d\n",
           prop.memoryBusWidth);
    printf("  Peak Memory Bandwidth (GB/s): %f\n\n",
           2.0*prop.memoryClockRate*(prop.memoryBusWidth/8)/1.0e6);
  }
}



}
