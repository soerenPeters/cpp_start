cmake_minimum_required(VERSION 3.14)

project(CppStart CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

set(COMPILER_FLAGS_CXX)
set(COMPILER_FLAGS_CXX_DEBUG)
set(COMPILER_FLAGS_CXX_RELEASE)
set(COMPILER_DEFINITION)
set(LINK_OPTIONS)

# Set this variable to the path with the self-written compiler flag files.
# set(BUILD_COMPILER_FILE_PATH "${CMAKE_CURRENT_LIST_DIR}/path/to/my/flags/")

include(CMake/cpp_starter.cmake)


add_subdirectory(src/adder)
add_subdirectory(src/meta)

