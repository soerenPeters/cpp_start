#include <gmock/gmock.h>

#include "MPI_example.h"

#include <spdlog/spdlog.h>

TEST(MPI_exampleTest, getThreadNumber)
{
    cpp_start::MPI_example sut;

    const auto result = sut.getThreadNumber();

    spdlog::info("MPI thread: {0}", result);

    ASSERT_THAT(result, testing::Eq(0));
}


TEST(MPI_exampleTest, getMaxThreads)
{
    cpp_start::MPI_example sut;

    const auto result = sut.getMaxThreads();

    spdlog::info("Max MPI threads: {0}", result);

    ASSERT_THAT(result, testing::Eq(1));
}
