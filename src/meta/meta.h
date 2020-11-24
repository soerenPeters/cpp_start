#ifndef META_H
#define META_H

namespace meta
{
const char *gitCommitHash();
const char *gitBranch();
const char *buildType();
const char *sourceDir();
const char *binaryDir();
}

#endif
