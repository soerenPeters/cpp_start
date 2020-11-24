###################################################
## GNU compiler file
###################################################

# debug
list(APPEND COMPILER_FLAGS_CXX_DEBUG -g)  # generates debug information. Works best with -O0.
list(APPEND COMPILER_FLAGS_CXX_DEBUG -O0)

# release
list(APPEND COMPILER_FLAGS_CXX_RELEASE -O3) # optimization level (-O3: most optimization which also could result in larger binaries)

# warning level
list(APPEND COMPILER_FLAGS_CXX -Wall)
list(APPEND COMPILER_FLAGS_CXX -Wextra)