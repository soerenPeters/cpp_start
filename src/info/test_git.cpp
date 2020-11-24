#include <gmock/gmock.h>

#include "git.h"

#include <iostream>
#include <string.h>


TEST(GitTest, getGitRevision)
{
    auto gitBranch = buildInfo::gitBranch();

    ASSERT_TRUE(gitBranch);

    std::cout << gitBranch << std::endl;
}


TEST(GitTest, getGitCommitHash)
{
    auto gitCommitHash = buildInfo::gitCommitHash();

    EXPECT_TRUE(gitCommitHash);
    EXPECT_THAT(strlen(gitCommitHash), testing::Eq(40)); // git commit hash length: 40 characters.

    std::cout << gitCommitHash << std::endl;
}
