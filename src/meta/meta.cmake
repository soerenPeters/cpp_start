set(buildMetaPath ${CMAKE_BINARY_DIR}/buildMetaPath)
set(metaInput ${CMAKE_CURRENT_LIST_DIR}/meta.in.cpp)
set(metaSourceFile ${buildMetaPath}/meta.cpp)

include(${CMAKE_SOURCE_DIR}/CMake/git/GetGitRevisionDescription.cmake)
get_git_head_revision(git_branch git_commit_hash)

configure_file(${metaInput} ${metaSourceFile})
