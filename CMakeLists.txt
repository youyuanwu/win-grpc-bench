cmake_minimum_required(VERSION 3.14)

project(win-grpc-bench)

# import grpc which will override win-grpc's dependency
# we will build grpc git submodules as well
include(FetchContent)
FetchContent_Declare(
  grpc
  GIT_REPOSITORY https://github.com/grpc/grpc
  GIT_TAG        v1.28.0
)
set(FETCHCONTENT_QUIET OFF)
FetchContent_MakeAvailable(grpc)

# import winext
message(STATUS "feching win-grpc")
include(FetchContent)
FetchContent_Declare(win_grpc
  GIT_REPOSITORY https://github.com/youyuanwu/win-grpc.git
  GIT_TAG d1c8d3ed35d2c14c869fda1a00c27fe05d080100)
FetchContent_GetProperties(win_grpc)
if(NOT win_grpc_POPULATED)
  FetchContent_Populate(win_grpc)
  add_subdirectory(${win_grpc_SOURCE_DIR} ${win_grpc_BINARY_DIR} EXCLUDE_FROM_ALL)
endif()

# TODO: format folder fix
#include(${winasio_SOURCE_DIR}/cmake/clang-format.cmake)

add_subdirectory(hgz)
add_subdirectory(helloworld_proto)
add_subdirectory(win_grpc)
add_subdirectory(grpc_mt)
add_subdirectory(tools/grpc_mt_cli)

# script tests
enable_testing()
add_subdirectory(scripts)