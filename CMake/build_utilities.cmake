#################################################################################
## helper
#################################################################################
function(status msg)
    message(STATUS "  msg: ${msg}")
endfunction()

function(status_lib msg)
    message(STATUS "    ${msg}")
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
    set( oneValueArgs )
    set( multiValueArgs NAME BUILDTYPE PUBLIC_LINK PRIVATE_LINK FILES FOLDER EXCLUDE)
    cmake_parse_arguments( ARG "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN} )

    # Create the target
    if(${ARG_BUILDTYPE} MATCHES binary)
        add_executable(${ARG_NAME} ${ARG_FILES} )
    elseif(${ARG_BUILDTYPE} MATCHES shared)
        add_library(${ARG_NAME} SHARED ${ARG_FILES} )
    elseif(${ARG_BUILDTYPE} MATCHES static)
        add_library(${ARG_NAME} STATIC ${ARG_FILES} )
    else()
        message(FATAL_ERROR "build_type=${ARG_BUILDTYPE} doesn't match BINARY, SHARED or STATIC")
    endif()

    # Set the output directory for build artifacts
    set_target_properties(${ARG_NAME}
            PROPERTIES
            RUNTIME_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/bin"
            LIBRARY_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/lib"
            ARCHIVE_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/lib"
            PDB_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/bin")


    # link libraries
    status_lib("Link Depending public libraries: ${ARG_PUBLIC_LINK}")
    status_lib("Link Depending private libraries: ${ARG_PRIVATE_LINK}")
    if (ARG_PUBLIC_LINK)
        target_link_libraries(${ARG_NAME} PUBLIC ${ARG_PUBLIC_LINK})
    endif()
    if (ARG_PRIVATE_LINK)
        target_link_libraries(${ARG_NAME} PRIVATE ${ARG_PRIVATE_LINK})
    endif()

    # clang-tidy
    if(BUILD_CLANG_TIDY)
        find_program(CLANG_TIDY_PROGRAM NAMES clang-tidy)

        if(NOT CLANG_TIDY_PROGRAM)
            message(FATAL_ERROR "Could not find the program clang-tidy.")
        endif()

        set_target_properties(${ARG_NAME}
                PROPERTIES
                CXX_CLANG_TIDY ${CLANG_TIDY_PROGRAM})

        status_lib("clang-tidy enabled")
    endif()

    # compiler flags
    message("additional compiler flags CXX: ${COMPILER_FLAG}")
    foreach(flag IN LISTS COMPILER_FLAG)
        target_compile_options(${ARG_NAME} PRIVATE "$<$<COMPILE_LANGUAGE:CXX>:${flag}>")
    endforeach()

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
function(util_add_test)

    set( options )
    set( oneValueArgs )
    set( multiValueArgs NAME PRIVATE_LINK FILES)
    cmake_parse_arguments( ARG "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN} )


    add_executable(${ARG_NAME} ${ARG_FILES})


    gtest_add_tests(TARGET ${ARG_NAME})


    # Set the output directory for build artifacts
    set_target_properties(${ARG_NAME}
            PROPERTIES
            RUNTIME_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/bin"
            LIBRARY_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/lib"
            ARCHIVE_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/lib"
            PDB_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/bin")


    # link libraries
    set(ARG_PUBLIC_LINK gmock_main)


    status_lib("Link Depending public libraries: ${ARG_PUBLIC_LINK}")
    status_lib("Link Depending private libraries: ${ARG_PRIVATE_LINK}")
    if (ARG_PUBLIC_LINK)
        target_link_libraries(${ARG_NAME} PUBLIC ${ARG_PUBLIC_LINK})
    endif()
    if (ARG_PRIVATE_LINK)
        target_link_libraries(${ARG_NAME} PRIVATE ${ARG_PRIVATE_LINK})
    endif()

    # clang-tidy
    if(BUILD_CLANG_TIDY)
        find_program(CLANG_TIDY_PROGRAM NAMES clang-tidy)

        if(NOT CLANG_TIDY_PROGRAM)
            message(FATAL_ERROR "Could not find the program clang-tidy.")
        endif()

        set_target_properties(${target_name}
                PROPERTIES
                CXX_CLANG_TIDY ${CLANG_TIDY_PROGRAM})

        status_lib("clang-tidy enabled")
    endif()

    # compiler flags
    message("additional compiler flags CXX: ${COMPILER_FLAG}")
    foreach(flag IN LISTS COMPILER_FLAG)
        target_compile_options(${ARG_NAME} PRIVATE "$<$<COMPILE_LANGUAGE:CXX>:${flag}>")
    endforeach()

endfunction()