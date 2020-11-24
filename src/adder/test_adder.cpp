#include <gmock/gmock.h>

#include "Adder.h"

TEST(AdderTest, add)
{
    const myapi::Adder sut;

    ASSERT_THAT(sut.add(1.5, 0.25), testing::DoubleEq(1.75));
}
