cmake_minimum_required(VERSION 3.14)

project(win-grpc-bench)

option(wingrpc_bench_LocalDevMode     "Use local winasio repo" OFF)

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

if(wingrpc_bench_LocalDevMode)
  # winasio repo must be located parallel to wingrpc
  message(STATUS "Using wingrpc bench LocalDevMode. This should not be used in CI.")
  set(win_grpc_SOURCE_DIR ${CMAKE_CURRENT_SOURCE_DIR}/../win-grpc)
  set(win_grpc_BINARY_DIR ${CMAKE_CURRENT_BINARY_DIR}/local/win-grpc)
else()
  # import winext
  message(STATUS "feching win-grpc")
  include(FetchContent)
  FetchContent_Declare(win_grpc
    GIT_REPOSITORY https://github.com/youyuanwu/win-grpc.git
    GIT_TAG f619ae3f3efcfbbe5095deb7533fd455efa3312d)
  FetchContent_GetProperties(win_grpc)
  if(NOT win_grpc_POPULATED)
    FetchContent_Populate(win_grpc)
  endif()
endif(wingrpc_bench_LocalDevMode)

add_subdirectory(${win_grpc_SOURCE_DIR} ${win_grpc_BINARY_DIR} EXCLUDE_FROM_ALL)

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