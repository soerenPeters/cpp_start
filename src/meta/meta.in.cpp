#include "meta_export.h"

namespace meta
{
META_EXPORT const char *gitCommitHash() { return "@git_commit_hash@"; }
META_EXPORT const char *gitBranch() { return "@git_branch@"; }
META_EXPORT const char *buildType() { return "@CMAKE_BUILD_TYPE@"; }
META_EXPORT const char *sourceDir() { return "@CMAKE_SOURCE_DIR@"; }
META_EXPORT const char *binaryDir() { return "@CMAKE_BINARY_DIR@"; }
}
