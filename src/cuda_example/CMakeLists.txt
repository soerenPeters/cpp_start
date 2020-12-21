project(cuda_example LANGUAGES CUDA CXX)

set(TARGET_NAME
        cuda_example)

set(SOURCE_FILES
        Cuda_example.cpp
        kernel.cu)

set(TEST_FILES
        test_cuda_example.cpp)

set(PUBLIC_LINK)

set(PRIVATE_LINK)

add_target()

# Optionally set the separable compilation on. Default is off.
#set_target_properties(cuda_example PROPERTIES
#                            CUDA_SEPARABLE_COMPILATION OFF)