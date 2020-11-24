cmake_minimum_required(VERSION 3.14)

# options
option(CMAKE_VERBOSE_OUTPUT "Enable additional CMake output per target." ON)

option(BUILD_COVERAGE "Add the --coverage compiler flag." OFF)
option(BUILD_CLANG_TIDY "Enable clang-tidy checks." OFF)
option(BUILD_UNIT_TESTS "Add the unit test targets." ON)
option(BUILD_WARNINGS_AS_ERRORS "Make all warnings into errors." OFF)

include(CMake/build_utilities.cmake)

# windows: use multi-threaded dynamically-linked runtime library
set(CMAKE_MSVC_RUNTIME_LIBRARY "MultiThreaded$<$<CONFIG:Debug>:Debug>DLL")


# code coverage gcov
if (BUILD_COVERAGE AND ${CMAKE_CXX_COMPILER_ID} STREQUAL "GNU")
    list(APPEND COMPILER_FLAGS_CXX "--coverage")
    set(CMAKE_EXE_LINKER_FLAGS ${CMAKE_EXE_LINKER_FLAGS} " --coverage")
endif()

# unit-tests
if(BUILD_UNIT_TESTS)
    set(gtest_force_shared_crt ON CACHE BOOL "" FORCE) # gtest link dynamic

    include(FetchContent)
    FetchContent_Declare(
            googletest
            GIT_REPOSITORY https://github.com/google/googletest.git
            GIT_TAG        release-1.10.0
    )

    FetchContent_MakeAvailable(googletest)

    enable_testing()
    include(GoogleTest)
endif()

# logging library spdlog
include(FetchContent)
FetchContent_Declare(
        spdlog
        GIT_REPOSITORY https://github.com/gabime/spdlog.git
        GIT_TAG        v1.8.1
)

FetchContent_MakeAvailable(spdlog)
