# cpp_start

[![Gitter](https://badges.gitter.im/cpp_start/lobby.svg)](https://gitter.im/cpp_start/lobby?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)
![CI](https://github.com/soerenPeters/cpp_start/workflows/build/badge.svg)
[![Quality Gate Status](https://sonarcloud.io/api/project_badges/measure?project=soerenPeters_cpp_start&metric=alert_status)](https://sonarcloud.io/dashboard?id=soerenPeters_cpp_start)

cpp_start is a cmake - C++ starter project. 

## Build  
```console
$ git clone https://github.com/soerenPeters/cpp_start.git
$ cd cpp_start && mkdir build && cd build
$ cmake ..
$ make
$ ctest
```

### CMake Options
- BUILD_SHARED_LIBS : Build all targets as shared libraries in this project. (ON)
- BUILD_WARNINGS_AS_ERRORS : Make all warnings into errors. (OFF)
- BUILD_UNIT_TESTS : Create unit test targets. (ON)
  

- BUILD_COVERAGE : Add the --coverage compiler flag. (OFF)  
- BUILD_CLANG_TIDY : Enable clang-tidy checks. (OFF)
- BUILD_CPPCHECK : Enable cppcheck.  (OFF)
  

- BUILD_USE_OPENMP : use OpenMP. (OFF)
- BUILD_USE_MPI : use MPI. (OFF)

### Compiler flags
Compiler flags can be set individually for each compiler in "CMake/compilerflags/[COMPILER_FLAGS_CXX](https://cmake.org/cmake/help/latest/variable/CMAKE_LANG_COMPILER_ID.html) .cmake". 
The following cmake lists will be set as private properties for each target:
- COMPILER_FLAGS_CXX
- COMPILER_FLAGS_CXX_DEBUG
- COMPILER_FLAGS_CXX_RELEASE
- COMPILER_DEFINITION
- LINK_OPTIONS


## Github workflow:
 - build
   - Linux - gnu
   - MacOS - clang
   - Windows - msvc
 - analyse
     - code coverage [gcovr](https://gcovr.com/en/stable/)
     - [clang-tidy](https://clang.llvm.org/extra/clang-tidy/)
     - [cppcheck](http://cppcheck.sourceforge.net)
     - [lizard](https://github.com/terryyin/lizard)  
     - deployment to [sonarcloud.io](https://sonarcloud.io/dashboard?id=soerenPeters_cpp_start)
 
 
Set up Sonarcloud:
 - link the github project on sonarcloud.io
 - generate a security token on sonarcloud.io: **User > My Account > Security**
 - add this token as a github project secret with the name **SONAR_TOKEN**
 
 Note: sonar-project.properties needs to be adapted individually. Further information can be found here in the [sonarcloud](https://docs.sonarqube.org/latest/analysis/languages/cfamily/) docs.
 To exclude the test files from the sonarcloud code coverage report, the test files must be named after the pattern 'sonar.coverage.exclusions'. 
 
## Dependencies
There are dependencies on the following projects. These are fetched into the build order during cmake.
-  unit test framework [googletest](https://github.com/google/googletest)
-  logging framework [spdlog](https://github.com/gabime/spdlog)

Further dependencies are not included. If they are enable in a [cmake option](#cmake-options) they must be provided within the environment.
- Boost
- OpenMP
- MPI


- cppcheck
- clang-tidy
- lizard

## Usage
### Add new targets
- create a new folder in the src/ directory (e.g. by copying the adder directory.)
- add a new CMakeLists.txt file and the corresponding source and test files
```cmake
project(project_name CXX)

set(TARGET_NAME
        my_target_name)

set(SOURCE_FILES
        foo.cpp)

set(TEST_FILES
        test_foo.cpp)

set(PUBLIC_LINK)

set(PRIVATE_LINK)

add_target()
```
- add an add_subdirectory() in the root CMakeLists.txt

If the option BUILD_UNIT_TESTS is set to ON and TEST_FILES are added in the CMakeLists, cmake will create a test executable target with the name <my_target_name>Test and add it to ctest.

### Use in other projects
This cmake template can easily be used in other projects:
```cmake
include(FetchContent)
FetchContent_Declare(
        cpp_start
        GIT_REPOSITORY https://github.com/soerenpeters/cpp_start.git
        GIT_TAG        v0.1-alpha
)
FetchContent_Populate(cpp_start)

include(${CMAKE_BINARY_DIR}/_deps/cpp_start-src/CMake/cpp_starter.cmake)
```
An example usage can be found [here](https://github.com/soerenPeters/cpp_start_example).
