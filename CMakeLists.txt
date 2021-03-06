cmake_minimum_required(VERSION 3.15..3.19 FATAL_ERROR)

project(CppStart CXX)

option(BUILD_BOOST_EXAMPLE "Build the boost example." OFF)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# Set this variable to the path with the self-written compiler flag files.
# set(BUILD_COMPILER_FILE_PATH "${CMAKE_CURRENT_LIST_DIR}/path/to/my/flags/")

# Set this variable to the path with the self-written machine files.
# set(BUILD_MACHINE_FILE_PATH "${CMAKE_CURRENT_LIST_DIR}/path/to/my/machine/files/")

include(CMake/cpp_starter.cmake)


add_subdirectory(src/catch_example)
add_subdirectory(src/meta)

if(BUILD_BOOST_EXAMPLE)
    add_subdirectory(src/boost_example)
endif()

add_subdirectory(src/openmp_example)
add_subdirectory(src/mpi_example)

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