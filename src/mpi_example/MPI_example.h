//
// Created by Soeren Peters on 15.12.20.
//

#ifndef CPPSTART_MPI_EXAMPLE
#define CPPSTART_MPI_EXAMPLE

#include <vector>

#include "MPI_example_export.h"

namespace cpp_start
{

class MPI_EXAMPLE_EXPORT MPI_example
{
public:
    MPI_example();

    ~MPI_example();

    int getThreadNumber() const;

    int getMaxThreads() const;
};

}

#endif // CPPSTART_MPI_EXAMPLE
