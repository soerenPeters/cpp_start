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


# run conan install
# find_program(conan conan)
# if(NOT EXISTS ${conan})
#     message(FATAL_ERROR "Conan not found on the system. Please install conan from here: https://conan.io/downloads.html")
# endif()

# execute_process(COMMAND ${conan} install ${CMAKE_CURRENT_SOURCE_DIR}
#                 OUTPUT_VARIABLE output
#                 RESULT_VARIABLE result)
# message(STATUS "conan output:" ${output})

# if(NOT ${result} EQUAL 0)
#     message(FATAL_ERROR "conan install command failed with error code: ${result}")
# endif()


# conan
if(NOT EXISTS ${CMAKE_BINARY_DIR}/conanbuildinfo.cmake)
    MESSAGE(FATAL_ERROR "conanbuildinfo.cmake not found. Probably missing: conan install .. ")
endif()
include(${CMAKE_BINARY_DIR}/conanbuildinfo.cmake)
conan_basic_setup(KEEP_RPATHS)

if(APPLE)
    set(CMAKE_INSTALL_RPATH "@executable_path/../lib")
else()
    set(CMAKE_INSTALL_RPATH "$ORIGIN/../lib")
endif()
set(CMAKE_BUILD_WITH_INSTALL_RPATH ON) # <-- this is the line which is missing in the Conan documentation!

message(STATUS "conan libraries found: ${CONAN_LIBS}")

# unit-tests
if(CS_BUILD_UNIT_TESTS)

    # code coverage gcov
    if (CS_ENABLE_COVERAGE AND ${CMAKE_CXX_COMPILER_ID} STREQUAL "GNU")
        list(APPEND CS_COMPILER_FLAGS_CXX "--coverage")
        list(APPEND CS_LINK_OPTIONS "--coverage")
    endif()

    include(Catch)
    include(GoogleTest)

    list(APPEND CMAKE_PREFIX_PATH ${CMAKE_BINARY_DIR})
    list(APPEND CMAKE_MODULE_PATH ${CMAKE_BINARY_DIR})

    find_package(Catch2 REQUIRED)

    list(APPEND UNIT_TESTS_LIBRARIES gmock_main gmock gtest Catch2::Catch2)

    enable_testing()

endif()
