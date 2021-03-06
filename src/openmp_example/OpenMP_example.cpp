//
// Created by Soeren Peters on 15.12.20.
//

#include "OpenMP_example.h"

#if defined(_OPENMP)
#include <omp.h>
#endif

#include <spdlog/spdlog.h>

namespace cpp_start
{

std::vector<double> OpenMP_example::add(const std::vector<double>& a, const std::vector<double>& b) const
{
    spdlog::info("Max OpenMP threads: {0}", getMaxThreads());

#ifdef _MSC_VER
    int i {0}; // As msvc only supports openMP 2.0 so far, this variable needs to be an integer.
#else
    unsigned long long i {0};
#endif
    const auto size = a.size();
    std::vector<double> result (size);
#if defined(_OPENMP)
#pragma omp parallel for
#endif
    for (i = 0; i < size; ++i) {
        spdlog::info("OpenMP thread: {0}", getThreadNumber());
        result[i] = a[i] + b[i];
    }

    return result;
}


int OpenMP_example::getThreadNumber() const
{
    int threadNumber {0};

#if defined(_OPENMP)
    threadNumber = omp_get_thread_num();
#endif

    return threadNumber;
}

int OpenMP_example::getMaxThreads() const
{
    int maxThreads {1};

#if defined(_OPENMP)
    maxThreads = omp_get_max_threads();
#endif

    return maxThreads;
}


}
