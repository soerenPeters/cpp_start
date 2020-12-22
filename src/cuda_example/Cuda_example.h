//
// Created by Soeren Peters on 21.12.20.
//

#ifndef CPPSTART_CUDA_EXAMPLE
#define CPPSTART_CUDA_EXAMPLE

#include <vector>

#include "cuda_example_export.h"

namespace cpp_start
{

class Cuda_example
{
public:
    CUDA_EXAMPLE_EXPORT std::vector<int> add(const std::vector<int> &a, const std::vector<int> &b) const;

    CUDA_EXAMPLE_EXPORT void print() const;
};

}

#endif // CUDA_EXAMPLE
