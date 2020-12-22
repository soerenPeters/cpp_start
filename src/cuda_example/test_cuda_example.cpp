#include <gmock/gmock.h>

#include "Cuda_example.h"

TEST(Cuda_exampleTest, abc)
{
    cpp_start::Cuda_example sut;

    sut.print();
}

TEST(Cuda_exampleTest, addWithCuda)
{
    cpp_start::Cuda_example sut;

    const auto result = sut.add({ 1, 2 }, { 3, 4 });

    ASSERT_THAT(result, testing::ElementsAre(4, 6));
}
