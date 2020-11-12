cmake_minimum_required(VERSION 3.14)

project(CppStart)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)


set(target_name app)
add_executable(${target_name} main.cpp)

