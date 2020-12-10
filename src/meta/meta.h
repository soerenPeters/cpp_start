#ifndef META_H
#define META_H

#include "meta_export.h"

namespace meta
{
META_EXPORT const char *gitCommitHash();
META_EXPORT const char *gitBranch();
META_EXPORT const char *buildType();
META_EXPORT const char *sourceDir();
META_EXPORT const char *binaryDir();
}

#endif
