#include <gmock/gmock.h>

#include "meta.h"

#include <iostream>
#include <string.h>


TEST(GitTest, getGitRevision)
{
    auto gitBranch = meta::gitBranch();

    ASSERT_TRUE(gitBranch);

    std::cout << gitBranch << std::endl;
}


TEST(GitTest, getGitCommitHash)
{
    auto gitCommitHash = meta::gitCommitHash();

    EXPECT_TRUE(gitCommitHash);
    EXPECT_THAT(strlen(gitCommitHash), testing::Eq(40)); // git commit hash length: 40 characters.

    std::cout << gitCommitHash << std::endl;
}
