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
set_target_properties(cuda_example PROPERTIES CUDA_SEPARABLE_COMPILATION ON)

# according to linker error when building static libraries and separate compilation.
# https://stackoverflow.com/questions/50033435/cmake-cuda-separate-compilation-static-lib-link-error-on-windows-but-not-on-ubun
if (NOT BUILD_SHARED_LIBRARY)
    set_target_properties(cuda_example PROPERTIES CUDA_RESOLVE_DEVICE_SYMBOLS ON)
endif()
