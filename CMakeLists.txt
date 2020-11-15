cmake_minimum_required(VERSION 3.14)


project(CppStart CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

option(BUILD_COVERAGE "Add the --coverage compiler flag." OFF)

if (BUILD_COVERAGE AND ${CMAKE_CXX_COMPILER_ID} STREQUAL "GNU")
    list(APPEND COMPILER_FLAG "--coverage")
    set(CMAKE_EXE_LINKER_FLAGS ${CMAKE_EXE_LINKER_FLAGS} " --coverage")
endif()

include(FetchContent)
FetchContent_Declare(
        googletest
        GIT_REPOSITORY https://github.com/google/googletest.git
        GIT_TAG        release-1.10.0
)

FetchContent_MakeAvailable(googletest)

set(target_name Adder)
add_library(${target_name} STATIC src/Adder.cpp)
message("additional compiler flags CXX: ${COMPILER_FLAG}")
foreach(flag IN LISTS COMPILER_FLAG)
    target_compile_options(${target_name} PRIVATE "$<$<COMPILE_LANGUAGE:CXX>:${flag}>")
endforeach()

set(test_name appTest)
add_executable(${test_name} src/AdderTest.cpp)
target_link_libraries(${test_name} PRIVATE gmock_main ${target_name})


foreach(flag IN LISTS COMPILER_FLAG)
    target_compile_options(${test_name} PRIVATE "$<$<COMPILE_LANGUAGE:CXX>:${flag}>")
endforeach()

enable_testing()
include(GoogleTest)
gtest_add_tests(TARGET ${test_name})