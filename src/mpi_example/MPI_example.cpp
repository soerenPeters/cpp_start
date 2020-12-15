//
// Created by Soeren Peters on 15.12.20.
//

#include "MPI_example.h"

#if defined(_MPI)
#include <mpi.h>
#endif

#include <spdlog/spdlog.h>

namespace cpp_start
{

MPI_example::MPI_example()
{
#if defined(_MPI)
    MPI_Init(NULL, NULL);
#endif
}

MPI_example::~MPI_example()
{
#if defined(_MPI)
    MPI_Finalize();
#endif
}


int MPI_example::getThreadNumber() const
{
    int threadNumber {0};

#if defined(_MPI)
    int world_rank;
    MPI_Comm_rank(MPI_COMM_WORLD, &world_rank);
    threadNumber = world_rank;
#endif

    return threadNumber;
}

int MPI_example::getMaxThreads() const
{
    int maxThreads {1};

#if defined(_MPI)
    int world_size;
    MPI_Comm_size(MPI_COMM_WORLD, &world_size);
    maxThreads = world_size;
#endif

    return maxThreads;
}


}
