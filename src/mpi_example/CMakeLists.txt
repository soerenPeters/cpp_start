project(MPI_example CXX)

set(TARGET_NAME
        MPI_example)

set(SOURCE_FILES
        MPI_example.cpp)

set(TEST_FILES
        test_MPI_example.cpp)

set(PUBLIC_LINK)

set(PRIVATE_LINK)

if(MPI_FOUND)
    list(APPEND PRIVATE_LINK
            MPI::MPI_CXX)
endif()

add_target()

if(MPI_FOUND)
    target_compile_definitions(MPI_example PRIVATE _MPI)
endif()