cmake_minimum_required(VERSION 3.14)

project(CppStart CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

include(CMake/cpp_starter.cmake)

list(APPEND COMPILER_FLAG -Wall)

add_subdirectory(src)
