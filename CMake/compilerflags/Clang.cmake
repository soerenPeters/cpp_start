###################################################
## Clang compiler file
###################################################

# debug
list(APPEND CS_COMPILER_FLAGS_CXX_DEBUG -g)  # generates debug information. Works best with -O0.
list(APPEND CS_COMPILER_FLAGS_CXX_DEBUG -O0)

# release
list(APPEND CS_COMPILER_FLAGS_CXX_RELEASE -O3) # optimization level (-O3: most optimization which also could result in larger binaries)

# warning level
list(APPEND CS_COMPILER_FLAGS_CXX -Wall)
list(APPEND CS_COMPILER_FLAGS_CXX -Wextra)

if(CS_BUILD_WARNINGS_AS_ERRORS)
    list(APPEND CS_COMPILER_FLAGS_CXX -Werror)
endif()

if(BUILD_SHARED_LIBS)
    list(APPEND CS_COMPILER_FLAGS_CXX -fPIC)
endif()