#################################################################################
## set global project file endings
#################################################################################
list(APPEND GLOB_FILE_ENDINGS
        *.cpp
        *.c
        *.h
        *.cu
        *.cuh
        *.hpp )

#################################################################################
## set test files identifier
#################################################################################
list(APPEND TEST_FILES_IDENTIFIER
        test_
        mock_
        )

#################################################################################
## helper
#################################################################################
function(status msg)
    if(CMAKE_VERBOSE_OUTPUT)
        message(STATUS "  ${msg}")
    endif()
endfunction()

function(status_lib msg)
    if(CMAKE_VERBOSE_OUTPUT)
        message(STATUS "    ${msg}")
    endif()
endfunction()

include (GenerateExportHeader)
function(generateExportHeader target_name)
    GENERATE_EXPORT_HEADER	(${target_name}
            EXPORT_FILE_NAME ${CMAKE_BINARY_DIR}/${target_name}_export.h
            )
endfunction(generateExportHeader)


#########################################################################################
## Access the hostname and loads a optional machine file hostname.cmake
## The machine file path BUILD_MACHINE_FILE_PATH must be set before.
#########################################################################################
macro(load_machine_file)

    site_name(MACHINE_NAME)

    if(NOT DEFINED BUILD_MACHINE_FILE_PATH)
        status("Use intern machine files: ${CMAKE_CURRENT_LIST_DIR}/machinefiles/")
        status("For self-written machine files, the variable BUILD_MACHINE_FILE_PATH must be set.")
        set(BUILD_MACHINE_FILE_PATH "${CMAKE_CURRENT_LIST_DIR}/machinefiles/")
    endif()

    set(MACHINE_FILE "${BUILD_MACHINE_FILE_PATH}/${MACHINE_NAME}.config.cmake")

    IF(NOT EXISTS ${MACHINE_FILE})
        status("No configuration file found: ${MACHINE_FILE}.")
    ELSE()
        status("Load configuration file: ${MACHINE_FILE}")
        include(${MACHINE_FILE})
    ENDIF()

endmacro()


######################################################################################################################
## Load additional compiler flags                                                                                   ##
## the file needs to be named after one of the following compiler with file ending *.cmake:                         ##
## https://cmake.org/cmake/help/latest/variable/CMAKE_LANG_COMPILER_ID.html#variable:CMAKE_<LANG>_COMPILER_ID       ##
######################################################################################################################
macro(load_compiler_flags)
    if(NOT DEFINED BUILD_COMPILER_FILE_PATH)
        status("Use intern compiler flags: ${CMAKE_CURRENT_LIST_DIR}/compilerflags/")
        status("For own compiler flags, the variable BUILD_COMPILER_FILE_PATH must be set.")
        set(BUILD_COMPILER_FILE_PATH "${CMAKE_CURRENT_LIST_DIR}/compilerflags/")
    endif()
    if(EXISTS "${BUILD_COMPILER_FILE_PATH}/${CMAKE_CXX_COMPILER_ID}.cmake")
        status("Load compiler file: ${BUILD_COMPILER_FILE_PATH}/${CMAKE_CXX_COMPILER_ID}.cmake")
        include(${BUILD_COMPILER_FILE_PATH}/${CMAKE_CXX_COMPILER_ID}.cmake)
    else()
        status("${CMAKE_CXX_COMPILER_ID}.cmake file not found.")
    endif()
endmacro()


######################################################################################################################
## Finds files recursively and sort these into test and source files.                                               ##
## NOTE: cmake warns to set all files manually https://cmake.org/cmake/help/latest/command/file.html#glob-recurse   ##
######################################################################################################################
macro(find_files_recursively)
    file(GLOB_RECURSE all_files ${GLOB_FILE_ENDINGS})

    # iterate over all found files
    foreach(file ${all_files})
        get_filename_component(file_name ${file} NAME)

        # check if is a test files
        set(is_test_file false)

        if(NOT DEFINED ADD_TEST_FILES_TO_MAIN_TARGET) # add test files to test target
            foreach(test_identifier ${TEST_FILES_IDENTIFIER})
                if(${file_name} MATCHES ${test_identifier})
                    list(APPEND TEST_FILES ${file})
                    set(is_test_file true)
                endif()
            endforeach()
        endif()

        # else the file is passed to the source files
        if(NOT is_test_file)
            list(APPEND SOURCE_FILES ${file})
        endif()
    endforeach()
endmacro()


######################################################################################################################
##  If the file has no file path the current CMakeLists.txt path is added.                                          ##
##  Afterwards all SOURCE_FILES and TEST_FILES are with filepath.                                                   ##
######################################################################################################################
macro(set_file_path)

    foreach(file ${SOURCE_FILES})
        get_filename_component(path ${file} PATH)
        if(path STREQUAL "")
            set(file ${CMAKE_CURRENT_LIST_DIR}/${file})
        endif()
        list(APPEND file_list ${file})
    endforeach()
    set(SOURCE_FILES ${file_list})

    foreach(file ${TEST_FILES})
        get_filename_component(path ${file} PATH)
        if(path STREQUAL "")
            set(file ${CMAKE_CURRENT_LIST_DIR}/${file})
        endif()
        list(APPEND file_list_ ${file})
    endforeach()
    set(TEST_FILES ${file_list_})

endmacro()

######################################################################################################################
## Find boost and add the components to the private link libraries.                                                 ##
##                                                                                                                  ##
## parameter:                                                                                                       ##
## VERSION     - minimum required boost version                                                                     ##
## COMPONENTS  - needed boost components                                                                            ##
######################################################################################################################
macro(link_boost)

    set( options )
    set( oneValueArgs VERSION)
    set( multiValueArgs COMPONENTS)
    cmake_parse_arguments( ARG "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN} )

    set(Boost_USE_MULTITHREADED ON)
    set(Boost_USE_STATIC_LIBS OFF)
    set(Boost_USE_STATIC_RUNTIME OFF)

    if(NOT BUILD_SHARED_LIBS)
        set(Boost_USE_STATIC_LIBS ON)
        set(Boost_USE_STATIC_RUNTIME ON)
    endif()

    # disable auto linking in boost
    if (WIN32)
        add_definitions( -DBOOST_ALL_NO_LIB )
    endif()


    find_package(Boost ${ARG_VERSION} REQUIRED COMPONENTS ${ARG_COMPONENTS})
    message(STATUS "Found Boost version: ${Boost_VERSION}")

    foreach(component ${ARG_COMPONENTS})
        list(APPEND PRIVATE_LINK Boost::${component})
    endforeach()

endmacro()

######################################################################################################################
## When OpenMP was found the library is added to the private link libraries.                                        ##
##                                                                                                                  ##
######################################################################################################################
macro(linkOpenMP)
    if(OpenMP_CXX_FOUND)
        list(APPEND PRIVATE_LINK
                OpenMP::OpenMP_CXX)
    endif()
endmacro()

######################################################################################################################
## When MPI was found the library is added to the private link libraries.                                           ##
## Additionally _MPI is added to the compiler definitions.                                                          ##
######################################################################################################################
macro(linkMPI)
    if(MPI_FOUND)
        list(APPEND PRIVATE_LINK
                MPI::MPI_CXX)

        list(APPEND COMPILER_DEFINITION _MPI)
    endif()
endmacro()

#################################################################################
## Add a target with the name TARGET_NAME and add SOURCE_FILES.
## Link the libraries PUBLIC_LINK and PRIVATE_LINK and add compiler flags to the target.
## If TEST_FILES are set a test executable is build.
## Activates clang-tidy if set.
#################################################################################
function(add_target)

    if(NOT DEFINED BUILDTYPE)
        if(BUILD_SHARED_LIBS)
            set(BUILDTYPE "shared")
        else()
            set(BUILDTYPE "static")
        endif()
    endif()

    set_file_path()

    if(DEFINED FIND_FILES_AUTOMATICALLY)
        find_files_recursively()
    endif()

    _add_target(
            NAME ${TARGET_NAME}
            BUILDTYPE ${BUILDTYPE}
            PUBLIC_LINK ${PUBLIC_LINK}
            PRIVATE_LINK ${PRIVATE_LINK}
            FILES ${SOURCE_FILES})

    if(DEFINED TEST_FILES)
        _add_test()
    endif()

    # clang-tidy
    if(CPPSTART_ENABLE_CLANG_TIDY)
        find_program(CLANG_TIDY_PROGRAM NAMES clang-tidy)

        if(NOT CLANG_TIDY_PROGRAM)
            message(FATAL_ERROR "Could not find the program clang-tidy.")
        endif()

        set_target_properties(${TARGET_NAME}
                PROPERTIES
                CXX_CLANG_TIDY ${CLANG_TIDY_PROGRAM})

        status("${TARGET_NAME}: clang-tidy enabled")
    endif()


    unset(TARGET_NAME)
    unset(SOURCE_FILES)
    unset(TEST_FILES)
    unset(PUBLIC_LINK)
    unset(PRIVATE_LINK)

endfunction()



function(_add_test)

    set(test_name ${TARGET_NAME}Test)

    _add_target(
            NAME ${test_name}
            BUILDTYPE executable
            PUBLIC_LINK ${UNIT_TESTS_LIBRARIES}
            PRIVATE_LINK ${TARGET_NAME}
            FILES ${TEST_FILES})

    if(CPPSTART_ENABLE_GTEST)
        gtest_add_tests(TARGET ${test_name})
    endif()
    if(CPPSTART_ENABLE_CATCH2)
       # catch_discover_tests(${test_name})
        ParseAndAddCatchTests(${test_name})
    endif()

    set_target_properties(${test_name} PROPERTIES FOLDER ${test_folder})

endfunction()




#################################################################################
## Add a target, link the libraries and add the compiler flags to the target
##
## parameter:
## NAME      - Name of the target.
## BUILDTYPE - static; shared; executable
## PUBLIC_LINK  - public libraries to link
## PRIVATE_LINK - private libraries to link
## FILES     - adds these files to the target
##
#################################################################################
function(_add_target)

    set( options )
    set( oneValueArgs NAME BUILDTYPE)
    set( multiValueArgs PUBLIC_LINK PRIVATE_LINK FILES)
    cmake_parse_arguments( ARG "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN} )

    status("Configure target: ${ARG_NAME} (${ARG_BUILDTYPE})...")

    # set source group for files within the CMakeLists.txt folder
    foreach(file ${ARG_FILES})
        if(${file} MATCHES "^${CMAKE_CURRENT_LIST_DIR}")
            source_group(TREE ${CMAKE_CURRENT_LIST_DIR} FILES ${file})
        endif()
    endforeach()

    # Create the target
    if(${ARG_BUILDTYPE} MATCHES executable)
        add_executable(${ARG_NAME} ${ARG_FILES} )
        set_target_properties(${ARG_NAME} PROPERTIES FOLDER ${app_folder})
    elseif(${ARG_BUILDTYPE} MATCHES shared)
        add_library(${ARG_NAME} SHARED ${ARG_FILES} )
        set_target_properties(${ARG_NAME} PROPERTIES FOLDER ${lib_folder})
    elseif(${ARG_BUILDTYPE} MATCHES static)
        add_library(${ARG_NAME} STATIC ${ARG_FILES} )
        set_target_properties(${ARG_NAME} PROPERTIES FOLDER ${lib_folder})
    else()
        message(FATAL_ERROR "build_type=${ARG_BUILDTYPE} doesn't match executable, shared or static")
    endif()


    # Set the output directory for build artifacts
    set_target_properties(${ARG_NAME}
            PROPERTIES
            RUNTIME_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/bin"
            LIBRARY_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/lib"
            ARCHIVE_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/lib"
            PDB_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/bin")


    #includes
    target_include_directories(${ARG_NAME} PUBLIC ${CMAKE_CURRENT_SOURCE_DIR})
    target_include_directories(${ARG_NAME} PRIVATE ${CMAKE_BINARY_DIR})


    # link libraries
    status_lib("Link Depending public libraries: ${ARG_PUBLIC_LINK}")
    status_lib("Link Depending private libraries: ${ARG_PRIVATE_LINK}")
    if (ARG_PUBLIC_LINK)
        target_link_libraries(${ARG_NAME} PUBLIC ${ARG_PUBLIC_LINK})
    endif()
    if (ARG_PRIVATE_LINK)
        target_link_libraries(${ARG_NAME} PRIVATE ${ARG_PRIVATE_LINK})
    endif()

    # link spdlog
    target_link_libraries(${ARG_NAME} PRIVATE spdlog)

    status_lib("additional compiler flags CXX: ${COMPILER_FLAGS_CXX}")
    status_lib("additional compiler flags CXX DEBUG: ${COMPILER_FLAGS_CXX_DEBUG}")
    status_lib("additional compiler flags CXX RELEASE: ${COMPILER_FLAGS_CXX_RELEASE}")

    status_lib("compile definitions: ${COMPILER_DEFINITION}")
    status_lib("link options: ${LINK_OPTIONS}")

    # compiler flags
    foreach(flag IN LISTS COMPILER_FLAGS_CXX)
        target_compile_options(${ARG_NAME} PRIVATE "$<$<COMPILE_LANGUAGE:CXX>:${flag}>")
    endforeach()

    foreach(flag IN LISTS COMPILER_FLAGS_CXX_DEBUG)
        target_compile_options(${ARG_NAME} PRIVATE "$<$<AND:$<COMPILE_LANGUAGE:CXX>,$<CONFIG:DEBUG>>:${flag}>")
    endforeach()

    foreach(flag IN LISTS COMPILER_FLAGS_CXX_RELEASE)
        target_compile_options(${ARG_NAME} PRIVATE "$<$<AND:$<COMPILE_LANGUAGE:CXX>,$<CONFIG:RELEASE>>:${flag}>")
    endforeach()

    # compile definitions
    foreach(flag IN LISTS COMPILER_DEFINITION)
        target_compile_definitions(${ARG_NAME} PRIVATE ${flag})
    endforeach()

    # link options
    foreach(flag IN LISTS LINK_OPTIONS)
        target_link_options(${ARG_NAME} PRIVATE ${flag})
    endforeach()

    # export header
    if (${ARG_BUILDTYPE} MATCHES shared OR ${ARG_BUILDTYPE} MATCHES static)
        generateExportHeader (${ARG_NAME})
    endif()



    # cppcheck
    if(CPPSTART_ENABLE_CPPCHECK)
        find_program(CPPCHECK_PROGRAM NAMES cppcheck)

        if(NOT CPPCHECK_PROGRAM)
            message(FATAL_ERROR "cppcheck was requested but not found on the system. Consider running cmake with -DBUILD_USE_CPPCHECK=OFF")
        endif()

        set_target_properties(${ARG_NAME}
                PROPERTIES
                CXX_CPPCHECK "${CPPCHECK_PROGRAM};--enable=all")

        status("cppcheck enabled")
    endif()

    # include-what-you-use
    if(CPPSTART_ENABLE_INCLUDE_WHAT_YOU_USE)
        find_program(IWYU_PROGRAM NAMES include-what-you-use iwyu)

        if(NOT IWYU_PROGRAM)
            message(FATAL_ERROR "Could not find the program include-what-you-use")
        endif()

        set_target_properties(${library_name}
                PROPERTIES
                CXX_INCLUDE_WHAT_YOU_USE ${IWYU_PROGRAM})

        status("include-what-you-use enabled")
    endif()


    status("..done.")

endfunction()
