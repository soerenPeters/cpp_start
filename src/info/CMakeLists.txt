project(info CXX)

include(git.cmake)

set(TARGET_NAME
        info)

set(SOURCE_FILES
        ${buildInfoPath}/${buildInfoFile})

set(TEST_FILES
        gitTest.cpp)

set(PUBLIC_LINK)


add_target(BUILDTYPE static)
