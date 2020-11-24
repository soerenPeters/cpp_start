#include <gmock/gmock.h>

#include "meta.h"

#include <iostream>
#include <cstring>


TEST(MetaTest, getGitRevision)
{
    auto gitBranch = meta::gitBranch();

    ASSERT_TRUE(gitBranch);

    std::cout << gitBranch << std::endl;
}

TEST(MetaTest, getGitCommitHash)
{
    auto gitCommitHash = meta::gitCommitHash();

    EXPECT_TRUE(gitCommitHash);
    EXPECT_THAT(strlen(gitCommitHash), testing::Eq(40)); // git commit hash length: 40 characters.

    std::cout << gitCommitHash << std::endl;
}

TEST(MetaTest, getBuildType)
{
    auto buildType = meta::buildType();

    EXPECT_TRUE(buildType);

    std::cout << buildType << std::endl;
}

TEST(MetaTest, getSourceDir)
{
    auto sourceDir = meta::sourceDir();

    EXPECT_TRUE(sourceDir);

    std::cout << sourceDir << std::endl;
}

TEST(MetaTest, getBinaryDir)
{
    auto binaryDir = meta::binaryDir();

    EXPECT_TRUE(binaryDir);

    std::cout << binaryDir << std::endl;
}
