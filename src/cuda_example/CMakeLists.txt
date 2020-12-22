project(cuda_example LANGUAGES CUDA CXX)

set(TARGET_NAME
        cuda_example)

set(FIND_FILES_AUTOMATICALLY ON)

set(SOURCE_FILES)

set(TEST_FILES)

set(PUBLIC_LINK)

set(PRIVATE_LINK)

add_target()

# Optionally set the separable compilation on. Default is off.
#set_target_properties(cuda_example PROPERTIES
#                            CUDA_SEPARABLE_COMPILATION OFF)