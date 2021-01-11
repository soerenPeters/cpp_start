project(MPI_example CXX)

set(TARGET_NAME
        MPI_example)

set(SOURCE_FILES
        MPI_example.cpp)

set(TEST_FILES
        test_MPI_example.cpp)

set(PUBLIC_LINK)

set(PRIVATE_LINK)

linkMPI()

add_target()
