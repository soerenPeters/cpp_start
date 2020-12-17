cmake_minimum_required(VERSION 3.14)

project(CppStart CXX)

option(BUILD_BOOST_EXAMPLE "Build the boost example." ON)

if(BUILD_BOOST_EXAMPLE) # As boost is using deprecated C++ features (like auto_ptr) we must stay on C++14.
    set(CMAKE_CXX_STANDARD 14)
else()
    set(CMAKE_CXX_STANDARD 17)
endif()

set(CMAKE_CXX_STANDARD_REQUIRED ON)

set(COMPILER_FLAGS_CXX)
set(COMPILER_FLAGS_CXX_DEBUG)
set(COMPILER_FLAGS_CXX_RELEASE)
set(COMPILER_DEFINITION)
set(LINK_OPTIONS)

# Set this variable to the path with the self-written compiler flag files.
# set(BUILD_COMPILER_FILE_PATH "${CMAKE_CURRENT_LIST_DIR}/path/to/my/flags/")

# Set this variable to the path with the self-written machine files.
# set(BUILD_MACHINE_FILE_PATH "${CMAKE_CURRENT_LIST_DIR}/path/to/my/machine/files/")

include(CMake/cpp_starter.cmake)


add_subdirectory(src/adder)
add_subdirectory(src/meta)

if(BUILD_BOOST_EXAMPLE)
    add_subdirectory(src/boost_example)
endif()

add_subdirectory(src/openmp_example)
add_subdirectory(src/mpi_example)
