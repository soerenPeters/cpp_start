#include <gmock/gmock.h>
#include <spdlog/spdlog.h>

#include "meta.h"


TEST(MetaTest, getGitRevision)
{
    const auto* gitBranch = meta::gitBranch();

    ASSERT_TRUE(gitBranch);
    
    spdlog::info("Git Branch: {0}", gitBranch);
}

TEST(MetaTest, getGitCommitHash)
{
    const auto* gitCommitHash = meta::gitCommitHash();

    EXPECT_TRUE(gitCommitHash);

    // git commit hash length: 40 characters.
    EXPECT_THAT(strlen(gitCommitHash), testing::Eq(40));

    spdlog::info("Git commit hash: {0}", gitCommitHash);
}

TEST(MetaTest, getBuildType)
{
    const auto* buildType = meta::buildType();

    EXPECT_TRUE(buildType);

    spdlog::info("Build type: {0}", buildType);
}

TEST(MetaTest, getSourceDir)
{
    const auto* sourceDir = meta::sourceDir();

    EXPECT_TRUE(sourceDir);

    spdlog::info("Source directory: {0}", sourceDir);
}

TEST(MetaTest, getBinaryDir)
{
    const auto* binaryDir = meta::binaryDir();

    EXPECT_TRUE(binaryDir);

    spdlog::info("Binary directory: {0}", binaryDir);
}
