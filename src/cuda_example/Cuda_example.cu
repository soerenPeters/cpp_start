//
// Created by Soeren Peters on 15.12.20.
//

#include "Cuda_example.h"

#include <sstream>
#include <string>

#include <cuda_runtime_api.h>

#include <spdlog/spdlog.h>

#include "device/kernel.cuh"

namespace cpp_start
{

cudaError_t addWithCuda(int *c, const int *a, const int *b, unsigned int size);

std::vector<int> Cuda_example::add(const std::vector<int> &a, const std::vector<int> &b) const
{
    const auto size = a.size();
    std::vector<int> result(size);

    // Add vectors in parallel.
    cudaError_t cudaStatus = addWithCuda(result.data(), a.data(), b.data(), (unsigned int)size);
    if (cudaStatus != cudaSuccess) {
        fprintf(stderr, "addWithCuda failed!");
        return {};
    }

    // cudaDeviceReset must be called before exiting in order for profiling and
    // tracing tools such as Nsight and Visual Profiler to show complete traces.
    cudaStatus = cudaDeviceReset();
    if (cudaStatus != cudaSuccess) {
        fprintf(stderr, "cudaDeviceReset failed!");
        return {};
    }

    return result;
}

int Cuda_example::getNumberOfDevices() const
{
    int nDevices;

    cudaGetDeviceCount(&nDevices);

    return nDevices;
}

std::string Cuda_example::getDeviceName(int deviceNumber) const
{
    checkDeviceNumber(deviceNumber);

    cudaDeviceProp prop;
    cudaGetDeviceProperties(&prop, deviceNumber);

    return { prop.name };
}

std::string Cuda_example::getComputeCapability(int deviceNumber) const
{
    checkDeviceNumber(deviceNumber);

    cudaDeviceProp prop;
    cudaGetDeviceProperties(&prop, deviceNumber);

    std::stringstream cc;
    cc << prop.major << "." << prop.minor;

    return cc.str();
}

size_t Cuda_example::getTotalGlobalMemory(int deviceNumber) const
{
    checkDeviceNumber(deviceNumber);

    cudaDeviceProp prop;
    cudaGetDeviceProperties(&prop, deviceNumber);

    return prop.totalGlobalMem;
}

double Cuda_example::getPeakMemoryBandwidth(int deviceNumber) const
{
    checkDeviceNumber(deviceNumber);

    cudaDeviceProp prop;
    cudaGetDeviceProperties(&prop, deviceNumber);

    return 2.0 * prop.memoryClockRate * (prop.memoryBusWidth / 8) / 1.0e6;
}

void Cuda_example::checkDeviceNumber(int deviceNumber) const
{
    const auto numberOfDevices = getNumberOfDevices();

    std::stringstream error_message;
    error_message << "Device number " << deviceNumber << "not valid. Number of devices: " << numberOfDevices;

    if (deviceNumber >= numberOfDevices)
        throw std::runtime_error(error_message.str());
}


cudaError_t addWithCuda(int *c, const int *a, const int *b, unsigned int size)
{
    int *dev_a = 0;
    int *dev_b = 0;
    int *dev_c = 0;
    cudaError_t cudaStatus;

    // Choose which GPU to run on, change this on a multi-GPU system.
    cudaStatus = cudaSetDevice(0);
    if (cudaStatus != cudaSuccess) {
        fprintf(stderr, "cudaSetDevice failed!  Do you have a CUDA-capable GPU installed?");
        goto Error;
    }

    // Allocate GPU buffers for three vectors (two input, one output)    .
    cudaStatus = cudaMalloc((void **)&dev_c, size * sizeof(int));
    if (cudaStatus != cudaSuccess) {
        fprintf(stderr, "cudaMalloc failed!");
        goto Error;
    }

    cudaStatus = cudaMalloc((void **)&dev_a, size * sizeof(int));
    if (cudaStatus != cudaSuccess) {
        fprintf(stderr, "cudaMalloc failed!");
        goto Error;
    }

    cudaStatus = cudaMalloc((void **)&dev_b, size * sizeof(int));
    if (cudaStatus != cudaSuccess) {
        fprintf(stderr, "cudaMalloc failed!");
        goto Error;
    }

    // Copy input vectors from host memory to GPU buffers.
    cudaStatus = cudaMemcpy(dev_a, a, size * sizeof(int), cudaMemcpyHostToDevice);
    if (cudaStatus != cudaSuccess) {
        fprintf(stderr, "cudaMemcpy failed!");
        goto Error;
    }

    cudaStatus = cudaMemcpy(dev_b, b, size * sizeof(int), cudaMemcpyHostToDevice);
    if (cudaStatus != cudaSuccess) {
        fprintf(stderr, "cudaMemcpy failed!");
        goto Error;
    }

    // Launch a kernel on the GPU with one thread for each element.
    add_cuda_kernel<<<1, size>>>(dev_c, dev_a, dev_b);

    // Check for any errors launching the kernel
    cudaStatus = cudaGetLastError();
    if (cudaStatus != cudaSuccess) {
        fprintf(stderr, "addKernel launch failed: %s\n", cudaGetErrorString(cudaStatus));
        goto Error;
    }

    // cudaDeviceSynchronize waits for the kernel to finish, and returns
    // any errors encountered during the launch.
    cudaStatus = cudaDeviceSynchronize();
    if (cudaStatus != cudaSuccess) {
        fprintf(stderr, "cudaDeviceSynchronize returned error code %d after launching addKernel!\n", cudaStatus);
        goto Error;
    }

    // Copy output vector from GPU buffer to host memory.
    cudaStatus = cudaMemcpy(c, dev_c, size * sizeof(int), cudaMemcpyDeviceToHost);
    if (cudaStatus != cudaSuccess) {
        fprintf(stderr, "cudaMemcpy failed!");
        goto Error;
    }

Error:
    cudaFree(dev_c);
    cudaFree(dev_a);
    cudaFree(dev_b);

    return cudaStatus;
}

} // namespace cpp_start
