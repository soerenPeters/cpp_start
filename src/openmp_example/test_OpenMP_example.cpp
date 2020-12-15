#include <gmock/gmock.h>

#include "OpenMP_example.h"

TEST(OpenMP_exampleTest, abc)
{
    cpp_start::OpenMP_example sut;

    const auto result = sut.add({1,2},{3,4});


    ASSERT_THAT(result, testing::ElementsAre(4, 6));
}
