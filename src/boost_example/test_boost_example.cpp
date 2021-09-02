//
// Created by Soeren Peters on 17.12.20.
//

#include <gmock/gmock.h>

#include <spdlog/spdlog.h>

#include "Boost_example.h"


TEST(BoostExampleTest, chechBoostRegex)
{
    cpp_start::Boost_example sut;

    const auto match = sut.match("Boost Libraries", "\\w+\\s\\w+");

    ASSERT_TRUE(match);
}
