project(OpenMP_example CXX)

set(TARGET_NAME
        OpenMP_example)

set(SOURCE_FILES
        OpenMP_example.cpp)

set(TEST_FILES
        test_OpenMP_example.cpp)

set(PUBLIC_LINK)

set(PRIVATE_LINK)

if(OpenMP_CXX_FOUND)
    list(APPEND PRIVATE_LINK
            OpenMP::OpenMP_CXX)
endif()

add_target()