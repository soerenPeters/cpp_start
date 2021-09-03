cmake_minimum_required(VERSION 3.15..3.21 FATAL_ERROR)

project(CppStart
        VERSION 1.0.0
        DESCRIPTION "C++ Starter project"
        HOMEPAGE_URL "https://github.com/soerenPeters/cpp_start"
        LANGUAGES CXX)

if(NOT CMAKE_BUILD_TYPE)
    set(CMAKE_BUILD_TYPE Release)
endif()
message(STATUS "CMAKE_BUILD_TYPE: ${CMAKE_BUILD_TYPE}")

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# Set this variable to the path with the self-written compiler flag files.
# set(BUILD_COMPILER_FILE_PATH "${CMAKE_CURRENT_LIST_DIR}/path/to/my/flags/")

# Set this variable to the path with the self-written machine files.
# set(BUILD_MACHINE_FILE_PATH "${CMAKE_CURRENT_LIST_DIR}/path/to/my/machine/files/")

include(CMake/cpp_starter.cmake)


add_subdirectory(src/meta)
add_subdirectory(src/boost_example)
add_subdirectory(src/openmp_example)
add_subdirectory(src/mpi_example)

# cuda
include(CheckLanguage)
check_language(CUDA)

if(CMAKE_CUDA_COMPILER)
    message(STATUS "CUDA found: ${CMAKE_CUDA_COMPILER}. Adding cuda example.")
    set(CMAKE_CUDA_STANDARD 11)
    set(CMAKE_CUDA_STANDARD_REQUIRED ON)

    set(CMAKE_CUDA_ARCHITECTURES 30)

    add_subdirectory(src/cuda_example)
else()
    message(STATUS "CUDA not found. Skipping cuda example.")
endif()