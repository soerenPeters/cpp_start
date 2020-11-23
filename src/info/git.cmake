set(buildInfoPath ${CMAKE_BINARY_DIR}/buildInfo)
set(buildInfoFile git.cpp)
set(buildInfoInput ${CMAKE_CURRENT_LIST_DIR}/git.in.cpp)
set(buildInfoSourceFile ${buildInfoPath}/${buildInfoFile})

include(${CMAKE_SOURCE_DIR}/CMake/git/GetGitRevisionDescription.cmake)
get_git_head_revision(git_branch git_commit_hash)

configure_file(${buildInfoInput} ${buildInfoPath}/${buildInfoFile})
