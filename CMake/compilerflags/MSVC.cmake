###################################################
## MSVC compiler file
###################################################
list(APPEND CS_COMPILER_FLAGS_CXX "/W4")

if(CS_BUILD_WARNINGS_AS_ERRORS)
    list(APPEND CS_COMPILER_FLAGS_CXX "/WX")
endif()
