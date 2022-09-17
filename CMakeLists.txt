cmake_minimum_required(VERSION 3.14)

project(win-grpc-bench)

# import winext
message(STATUS "feching win-grpc")
include(FetchContent)
FetchContent_Declare(win_grpc
  GIT_REPOSITORY https://github.com/youyuanwu/win-grpc.git
  GIT_TAG 720de763a0fd73026ab6a747ee6c9196d10f0e2d)
FetchContent_GetProperties(win_grpc)
if(NOT win_grpc_POPULATED)
  FetchContent_Populate(win_grpc)
  add_subdirectory(${win_grpc_SOURCE_DIR} ${win_grpc_BINARY_DIR} EXCLUDE_FROM_ALL)
endif()

add_subdirectory(helloworld_proto)
add_subdirectory(win_grpc)

