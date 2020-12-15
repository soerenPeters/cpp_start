//
// Created by Soeren Peters on 15.12.20.
//

#ifndef CPPSTART_OPENMP_EXAMPLE
#define CPPSTART_OPENMP_EXAMPLE

#include <vector>

#include "OpenMP_example_export.h"

namespace cpp_start
{

class OpenMP_example
{
public:
    OPENMP_EXAMPLE_EXPORT std::vector<double> add(const std::vector<double>& a, const std::vector<double>& b) const;

    OPENMP_EXAMPLE_EXPORT int getThreadNumber() const;

    OPENMP_EXAMPLE_EXPORT int getMaxThreads() const;
};

}

#endif // CPPSTART_OPENMP_EXAMPLE
