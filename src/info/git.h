#ifndef buildInfo_H
#define buildInfo_H

namespace buildInfo
{
const char *gitCommitHash();
const char *gitBranch();
const char *buildType();
const char *sourceDir();
const char *binaryDir();
}

#endif
