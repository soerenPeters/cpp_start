set(buildInfoPath ${CMAKE_BINARY_DIR}/projectInfo)
set(buildInfoFile meta.cpp)
set(buildInfoInput ${CMAKE_CURRENT_LIST_DIR}/meta.in.cpp)
set(buildInfoSourceFile ${buildInfoPath}/${buildInfoFile})

include(${CMAKE_SOURCE_DIR}/CMake/git/GetGitRevisionDescription.cmake)
get_git_head_revision(git_branch git_commit_hash)

configure_file(${buildInfoInput} ${buildInfoSourceFile})
