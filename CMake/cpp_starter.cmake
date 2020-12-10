cmake_minimum_required(VERSION 3.15)

# options
option(CMAKE_VERBOSE_OUTPUT "Enable additional CMake output per target." ON)

option(BUILD_COVERAGE "Add the --coverage compiler flag." OFF)
option(BUILD_CLANG_TIDY "Enable clang-tidy checks." OFF)
option(BUILD_UNIT_TESTS "Add the unit test targets." ON)
option(BUILD_WARNINGS_AS_ERRORS "Make all warnings into errors." OFF)

option(BUILD_SHARED_LIBS "Build all targets as shared libs in this project." ON)

include(${CMAKE_CURRENT_LIST_DIR}/build_utilities.cmake)

# set the msvc runtime library for all targets
set(WIN_SHARED_LIBS_ENDING "")
if(BUILD_SHARED_LIBS)
    set(WIN_SHARED_LIBS_ENDING "DLL")
endif()
set(CMAKE_MSVC_RUNTIME_LIBRARY "MultiThreaded$<$<CONFIG:Debug>:Debug>${WIN_SHARED_LIBS_ENDING}")

# code coverage gcov
if (BUILD_COVERAGE AND ${CMAKE_CXX_COMPILER_ID} STREQUAL "GNU")
    list(APPEND COMPILER_FLAGS_CXX "--coverage")
    list(APPEND LINK_OPTIONS "--coverage")
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
