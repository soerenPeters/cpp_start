cmake_minimum_required(VERSION 3.15)

# global properties
set_property(GLOBAL PROPERTY USE_FOLDERS ON)
set_property(GLOBAL PROPERTY PREDEFINED_TARGETS_FOLDER ".cmake")

# options
option(CMAKE_VERBOSE_OUTPUT "Enable additional CMake output per target." ON)

option(BUILD_COVERAGE "Add the --coverage compiler flag." OFF)
option(BUILD_CLANG_TIDY "Enable clang-tidy checks." OFF)
option(BUILD_UNIT_TESTS "Add the unit test targets." ON)
option(BUILD_WARNINGS_AS_ERRORS "Make all warnings into errors." OFF)

option(BUILD_SHARED_LIBS "Build all targets as shared libs in this project." ON)


# vars
set(lib_folder "libs")
set(app_folder "apps")
set(test_folder "tests")
set(third_folder "3rd")

# include helper functions
include(${CMAKE_CURRENT_LIST_DIR}/build_utilities.cmake)

######################################################################################################################
## Load additional compiler flags                                                                                   ##
## the file needs to be named after one of the following compiler with file ending *.cmake:                         ##
## https://cmake.org/cmake/help/latest/variable/CMAKE_LANG_COMPILER_ID.html#variable:CMAKE_<LANG>_COMPILER_ID       ##
######################################################################################################################
if(NOT DEFINED BUILD_COMPILER_FILE_PATH)
    status("Use intern compiler flags: ${CMAKE_CURRENT_LIST_DIR}/compilerflags/")
    status("For own compiler flags, the variable BUILD_COMPILER_FILE_PATH must be set before the include.")
    set(BUILD_COMPILER_FILE_PATH "${CMAKE_CURRENT_LIST_DIR}/compilerflags/")
endif()
if(EXISTS "${BUILD_COMPILER_FILE_PATH}/${CMAKE_CXX_COMPILER_ID}.cmake")
    status("Load compiler file: ${BUILD_COMPILER_FILE_PATH}/${CMAKE_CXX_COMPILER_ID}.cmake")
    include(${BUILD_COMPILER_FILE_PATH}/${CMAKE_CXX_COMPILER_ID}.cmake)
else()
    status("${CMAKE_CXX_COMPILER_ID}.cmake file not found.")
endif()



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

    set_target_properties(gmock PROPERTIES FOLDER ${third_folder})
    set_target_properties(gmock_main PROPERTIES FOLDER ${third_folder})
    set_target_properties(gtest PROPERTIES FOLDER ${third_folder})
    set_target_properties(gtest_main PROPERTIES FOLDER ${third_folder})

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

set_target_properties(spdlog PROPERTIES FOLDER ${third_folder})