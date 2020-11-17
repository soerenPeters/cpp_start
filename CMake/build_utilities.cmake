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

#################################################################################
## Add a target, link the libraries and add the compiler flags to the target
##
## parameter:
## NAME      - Name of the target.
## BUILDTYPE - STATIC; SHARED; EXECUTABLE
## PUBLIC_LINK  - public libraries to link
## PRIVATE_LINK - private libraries to link
## FILES     - adds these files to the target
##
#################################################################################
function(add_target)

    set( options )
    set( oneValueArgs BUILDTYPE)
    set( multiValueArgs )
    cmake_parse_arguments( ARG "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN} )

    _add_target(
            NAME ${TARGET_NAME}
            BUILDTYPE ${ARG_BUILDTYPE}
            PUBLIC_LINK ${PUBLIC_LINK}
            PRIVATE_LINK ${PRIVATE_LINK}
            FILES ${SOURCE_FILES})

    _add_test()

    # clang-tidy
    if(BUILD_CLANG_TIDY)
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
            PUBLIC_LINK gmock_main
            PRIVATE_LINK ${TARGET_NAME}
            FILES ${TEST_FILES})

    gtest_add_tests(TARGET ${test_name})

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


    # Create the target
    if(${ARG_BUILDTYPE} MATCHES executable)
        add_executable(${ARG_NAME} ${ARG_FILES} )
    elseif(${ARG_BUILDTYPE} MATCHES shared)
        add_library(${ARG_NAME} SHARED ${ARG_FILES} )
    elseif(${ARG_BUILDTYPE} MATCHES static)
        add_library(${ARG_NAME} STATIC ${ARG_FILES} )
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
        target_compile_definitions(${library_name} PRIVATE ${flag})
    endforeach()

    # link options
    foreach(flag IN LISTS LINK_OPTIONS)
        target_link_options(${library_name} PRIVATE ${flag})
    endforeach()

    # export header
    #if (${ARG_BUILDTYPE} MATCHES shared)
    #    generateExportHeader (${ARG_NAME})
    #endif()


    status("..done.")

endfunction()



######################################################################################################################
## Load additional compiler flags                                                                                   ##
## the file needs to be named after one of the following compiler with file ending *.cmake:                         ##
## https://cmake.org/cmake/help/latest/variable/CMAKE_LANG_COMPILER_ID.html#variable:CMAKE_<LANG>_COMPILER_ID       ##
######################################################################################################################
if(EXISTS "${CMAKE_CURRENT_LIST_DIR}/compilerflags/${CMAKE_CXX_COMPILER_ID}.cmake")
    status("Load compiler file: ${CMAKE_CXX_COMPILER_ID}.cmake")
    include(${CMAKE_CURRENT_LIST_DIR}/compilerflags/${CMAKE_CXX_COMPILER_ID}.cmake)
else()
    status("${CMAKE_CXX_COMPILER_ID}.cmake file not found.")
endif()

