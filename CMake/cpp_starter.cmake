cmake_minimum_required(VERSION 3.15)


# global properties
set_property(GLOBAL PROPERTY USE_FOLDERS ON)
set_property(GLOBAL PROPERTY PREDEFINED_TARGETS_FOLDER ".cmake")


# options
option(CMAKE_VERBOSE_OUTPUT "Enable additional CMake output per target." ON)

option(BUILD_SHARED_LIBS "Build all targets as shared libs in this project." ON)


option(CS_USE_OPENMP "use OpenMP" OFF)
option(CS_USE_MPI "use MPI" OFF)

option(CS_BUILD_WARNINGS_AS_ERRORS "Make all warnings into errors." OFF)
option(CS_BUILD_UNIT_TESTS "Add the unit test targets." ON)

option(CS_ENABLE_CATCH2 "Links the Unit-Test against catch2." ON)
option(CS_ENABLE_GTEST "Links the unit-tests against googletest." ON)
option(CS_ENABLE_COVERAGE "Add the --coverage compiler flag." OFF)
option(CS_ENABLE_CLANG_TIDY "Enable clang-tidy checks." OFF)
option(CS_ENABLE_CPPCHECK "Enable cppcheck." OFF)
option(CS_ENABLE_INCLUDE_WHAT_YOU_USE "Enable Include what you use." OFF)


# cpp flags and options
set(CS_COMPILER_FLAGS_CXX)
set(CS_COMPILER_FLAGS_CXX_DEBUG)
set(CS_COMPILER_FLAGS_CXX_RELEASE)
set(CS_COMPILER_DEFINITION)
set(CS_LINK_OPTIONS)


# set IDE folder group names
set(lib_folder "libs")
set(app_folder "apps")
set(test_folder "tests")
set(third_folder "3rd")


# set global project file endings for automatic file finding
list(APPEND CS_GLOB_FILE_ENDINGS
        *.cpp
        *.c
        *.h
        *.cu
        *.cuh
        *.hpp )

# set test files identifier for automatic file finding
list(APPEND CS_TEST_FILES_IDENTIFIER
        test_
        mock_ )


# include helper functions
include(${CMAKE_CURRENT_LIST_DIR}/macros.cmake)


# load additional files
load_compiler_flags()
load_machine_file()


# set the msvc runtime library for all targets
set(WIN_SHARED_LIBS_ENDING "")
if(BUILD_SHARED_LIBS)
    set(WIN_SHARED_LIBS_ENDING "DLL")
endif()
set(CMAKE_MSVC_RUNTIME_LIBRARY "MultiThreaded$<$<CONFIG:Debug>:Debug>${WIN_SHARED_LIBS_ENDING}")


# parallel - openmp
if(CS_USE_OPENMP)
    find_package(OpenMP)
    if(NOT OpenMP_CXX_FOUND)
        message(FATAL_ERROR "OpenMP was requested but not found on the system. Consider running cmake with -DCS_USE_OPENMP=OFF")
    endif()
endif()


# parallel - mpi
if(CS_USE_MPI)
    find_package(MPI)
    if(NOT MPI_FOUND)
        message(FATAL_ERROR "MPI was requested but not found on the system. Consider running cmake with -DCS_USE_MPI=OFF")
    endif()
endif()


# logging library spdlog
include(FetchContent)
FetchContent_Declare(
        spdlog
        GIT_REPOSITORY https://github.com/gabime/spdlog.git
        GIT_TAG        v1.8.1
)
FetchContent_MakeAvailable(spdlog)
set_target_properties(spdlog PROPERTIES FOLDER ${third_folder})


# unit-tests
if(CS_BUILD_UNIT_TESTS)

    # code coverage gcov
    if (CS_ENABLE_COVERAGE AND ${CMAKE_CXX_COMPILER_ID} STREQUAL "GNU")
        list(APPEND CS_COMPILER_FLAGS_CXX "--coverage")
        list(APPEND CS_LINK_OPTIONS "--coverage")
    endif()

    # fetch catch2
    if(CS_ENABLE_CATCH2)
        FetchContent_Declare(
                Catch2
                GIT_REPOSITORY https://github.com/catchorg/Catch2.git
                GIT_TAG        v2.13.3
        )

        FetchContent_MakeAvailable(Catch2)

        list(APPEND UNIT_TESTS_LIBRARIES Catch2::Catch2)

        # https://github.com/catchorg/Catch2/issues/2103
        list(APPEND CMAKE_MODULE_PATH ${catch2_SOURCE_DIR}/contrib)
        include(Catch)
        include(ParseAndAddCatchTests)
    endif()

    # fetch googletest
    if(CS_ENABLE_GTEST)
        set(gtest_force_shared_crt ON CACHE BOOL "" FORCE) # gtest link dynamic

        include(FetchContent)
        FetchContent_Declare(
                googletest
                GIT_REPOSITORY https://github.com/google/googletest.git
                GIT_TAG        release-1.10.0
        )

        FetchContent_MakeAvailable(googletest)

        set_target_properties(gmock PROPERTIES FOLDER ${third_folder})
        set_target_properties(gmock_main PROPERTIES FOLDER ${third_folder})
        set_target_properties(gtest PROPERTIES FOLDER ${third_folder})
        set_target_properties(gtest_main PROPERTIES FOLDER ${third_folder})

        include(GoogleTest)

        list(APPEND UNIT_TESTS_LIBRARIES gmock_main)
    endif()

    enable_testing()

endif()
