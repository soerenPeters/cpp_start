project(OpenMP_example CXX)

set(TARGET_NAME
        OpenMP_example)

set(SOURCE_FILES
        OpenMP_example.cpp)

set(TEST_FILES
        test_OpenMP_example.cpp)

set(PUBLIC_LINK)

set(PRIVATE_LINK)

linkOpenMP()

add_target()