cmake_minimum_required(VERSION 3.14)

project(CppStart CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

set(COMPILER_FLAGS_CXX)
set(COMPILER_FLAGS_CXX_DEBUG)
set(COMPILER_FLAGS_CXX_RELEASE)
set(COMPILER_DEFINITION)
set(LINK_OPTIONS)

include(CMake/cpp_starter.cmake)


add_subdirectory(src)
