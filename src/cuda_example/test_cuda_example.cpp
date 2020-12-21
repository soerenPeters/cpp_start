#include <gmock/gmock.h>

#include "Cuda_example.h"

TEST(Cuda_exampleTest, abc)
{
    cpp_start::Cuda_example sut;

    sut.print();
}
