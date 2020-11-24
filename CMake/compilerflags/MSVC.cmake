###################################################
## MSVC compiler file
###################################################
list(APPEND COMPILER_FLAGS_CXX "/W4")

if(BUILD_WARNINGS_AS_ERRORS)
    list(APPEND COMPILER_FLAGS_CXX "/WX")
endif()
