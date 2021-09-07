cmake_minimum_required(VERSION 3.15)


# global properties
set_property(GLOBAL PROPERTY USE_FOLDERS ON)
set_property(GLOBAL PROPERTY PREDEFINED_TARGETS_FOLDER ".cmake")

set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

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



# conan
list(APPEND CMAKE_PREFIX_PATH ${CMAKE_BINARY_DIR})
list(APPEND CMAKE_MODULE_PATH ${CMAKE_BINARY_DIR})

if(NOT EXISTS "${CMAKE_BINARY_DIR}/conan.cmake")
  message(STATUS "Downloading conan.cmake from https://github.com/conan-io/cmake-conan")
  file(DOWNLOAD "https://raw.githubusercontent.com/conan-io/cmake-conan/v0.16.1/conan.cmake"
                "${CMAKE_BINARY_DIR}/conan.cmake"
                EXPECTED_HASH SHA256=396e16d0f5eabdc6a14afddbcfff62a54a7ee75c6da23f32f7a31bc85db23484
                TLS_VERIFY ON)
endif()

include(${CMAKE_BINARY_DIR}/conan.cmake)

    message(STATUS "COMPILER " ${CMAKE_CXX_COMPILER})
    message(STATUS "COMPILER " ${CMAKE_CXX_COMPILER_ID})
    message(STATUS "VERSION " ${CMAKE_CXX_COMPILER_VERSION})
    message(STATUS "FLAGS " ${CMAKE_LANG_FLAGS})
    message(STATUS "LIB ARCH " ${CMAKE_CXX_LIBRARY_ARCHITECTURE})
    message(STATUS "BUILD TYPE " ${CMAKE_BUILD_TYPE})
    message(STATUS "GENERATOR " ${CMAKE_GENERATOR})
    message(STATUS "GENERATOR WIN64 " ${CMAKE_CL_64})

conan_cmake_autodetect(settings)

message(STATUS "Conan settings: ${settings}")


conan_cmake_install(PATH_OR_REFERENCE ${CMAKE_CURRENT_SOURCE_DIR}
                    BUILD missing
                    REMOTE conan-center
                    SETTINGS ${settings})


include(${CMAKE_BINARY_DIR}/conanbuildinfo.cmake)
conan_basic_setup()

conan_define_targets()
conan_set_rpath()

if(APPLE)
    set(CMAKE_INSTALL_RPATH "@executable_path/../lib")
else()
    set(CMAKE_INSTALL_RPATH "$ORIGIN/../lib")
endif()

set(CMAKE_BUILD_WITH_INSTALL_RPATH ON)

message(STATUS "conan libraries found: ${CONAN_LIBS}")

# unit-tests
if(CS_BUILD_UNIT_TESTS)

    # code coverage gcov
    if (CS_ENABLE_COVERAGE AND ${CMAKE_CXX_COMPILER_ID} STREQUAL "GNU")
        list(APPEND CS_COMPILER_FLAGS_CXX "--coverage")
        list(APPEND CS_LINK_OPTIONS "--coverage")
    endif()

    include(GoogleTest)

    list(APPEND UNIT_TESTS_LIBRARIES gmock_main gmock gtest)
    if(UNIX AND NOT APPLE)
    list(APPEND UNIT_TESTS_LIBRARIES pthread)
    endif()

    enable_testing()

endif()
