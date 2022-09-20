set (CMAKE_CXX_STANDARD 17)

add_executable(grpc_mt_main main.cpp)

set(_proto_file_path ${CMAKE_CURRENT_BINARY_DIR}/../helloworld_proto/helloworld.proto)

# generate command is inside find module
include(FindProtobuf)
protobuf_generate_cpp(PROTO_SRCS PROTO_HDRS ${_proto_file_path}
#    PLUGIN "protoc-gen-grpc=$<TARGET_FILE:grpc_cpp_plugin>"
#    PLUGIN_OPTIONS --grpc_out ${CMAKE_CURRENT_BINARY_DIR}
)
protobuf_generate(LANGUAGE grpc
    PLUGIN "protoc-gen-grpc=$<TARGET_FILE:grpc_cpp_plugin>"
    OUT_VAR GRPC_SRCS
    APPEND_PATH
    GENERATE_EXTENSIONS
        .grpc.pb.h
        .grpc.pb.cc
    PROTOS ${_proto_file_path}
)

# lib contains generated code only
add_library(grpc_mt_lib STATIC ${PROTO_SRCS} ${PROTO_HDRS} ${GRPC_SRCS})

# target_sources(grpc_mt_main PRIVATE ${PROTO_SRCS} ${PROTO_HDRS} ${GRPC_SRCS})

target_include_directories(grpc_mt_lib
    PUBLIC ${CMAKE_CURRENT_BINARY_DIR}
)

target_compile_options(grpc_mt_lib 
  PUBLIC /wd4267 # grpc size_t convert warning
)

target_link_libraries(grpc_mt_lib
    PUBLIC wingrpc grpc++
)

target_link_libraries(grpc_mt_main 
    PRIVATE grpc_mt_lib
)