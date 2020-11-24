#include <gmock/gmock.h>

#include "meta.h"

#include <iostream>
#include <cstring>


TEST(MetaTest, getGitRevision)
{
    const auto* gitBranch = meta::gitBranch();

    ASSERT_TRUE(gitBranch);

    std::cout << gitBranch << "\n";
}

TEST(MetaTest, getGitCommitHash)
{
    const auto* gitCommitHash = meta::gitCommitHash();

    EXPECT_TRUE(gitCommitHash);

    // git commit hash length: 40 characters.
    EXPECT_THAT(strlen(gitCommitHash), testing::Eq(40));

    std::cout << gitCommitHash << "\n";
}

TEST(MetaTest, getBuildType)
{
    const auto* buildType = meta::buildType();

    EXPECT_TRUE(buildType);

    std::cout << buildType << "\n";
}

TEST(MetaTest, getSourceDir)
{
    const auto* sourceDir = meta::sourceDir();

    EXPECT_TRUE(sourceDir);

    std::cout << sourceDir << "\n";
}

TEST(MetaTest, getBinaryDir)
{
    const auto* binaryDir = meta::binaryDir();

    EXPECT_TRUE(binaryDir);

    std::cout << binaryDir << "\n";
}
