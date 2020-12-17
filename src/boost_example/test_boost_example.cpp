//
// Created by Soeren Peters on 17.12.20.
//

#include <gmock/gmock.h>

#include <spdlog/spdlog.h>

#include "Boost_example.h"


TEST(BoostExampleTest, checkThatCurrentPath_isNotEmpty)
{
    cpp_start::Boost_example sut;

    const auto path = sut.getCurrentPath();

    spdlog::info("Current path: {0}", path);

    ASSERT_THAT(path, testing::StrNe(""));
}
