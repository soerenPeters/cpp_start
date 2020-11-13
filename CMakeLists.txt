cmake_minimum_required(VERSION 3.14)


project(CppStart CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)


include(FetchContent)
FetchContent_Declare(
        googletest
        GIT_REPOSITORY https://github.com/google/googletest.git
        GIT_TAG        release-1.10.0
)

FetchContent_MakeAvailable(googletest)

set(target_name app)
add_executable(${target_name} main.cpp)

set(test_name appTest)
add_executable(${test_name} test.cpp)
target_link_libraries(${test_name} PRIVATE gmock_main)

enable_testing()
include(GoogleTest)
gtest_add_tests(TARGET ${test_name})