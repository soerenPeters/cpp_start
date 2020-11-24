project(meta CXX)

include(meta.cmake)

set(TARGET_NAME
        meta)

set(SOURCE_FILES
        ${metaSourceFile})

set(TEST_FILES
        test_meta.cpp)

set(PUBLIC_LINK)


add_target(BUILDTYPE static)
