#include "git.h"


namespace buildInfo
{
const char *gitCommitHash() { return "@git_commit_hash@"; }
const char *gitBranch() { return "@git_branch@"; }
const char *buildType() { return "@CMAKE_BUILD_TYPE@"; }
const char *sourceDir() { return "@CMAKE_SOURCE_DIR@"; }
const char *binaryDir() { return "@CMAKE_BINARY_DIR@"; }
}
