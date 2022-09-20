set (CMAKE_CXX_STANDARD 20)

add_executable(win_grpc_main main.cpp)

target_link_libraries(win_grpc_main PRIVATE wingrpc libprotobuf)

set(_proto_file_path ${CMAKE_CURRENT_BINARY_DIR}/../helloworld_proto/helloworld.proto)

# generate command is inside find module
include(FindProtobuf)
protobuf_generate_cpp(PROTO_SRCS PROTO_HDRS ${_proto_file_path}
#    PLUGIN "protoc-gen-grpc=$<TARGET_FILE:grpc_cpp_plugin>"
#    PLUGIN_OPTIONS --grpc_out ${CMAKE_CURRENT_BINARY_DIR}
)
protobuf_generate(LANGUAGE grpc
    PLUGIN "protoc-gen-grpc=$<TARGET_FILE:win_grpc_cpp_plugin>"
    #PLUGIN "protoc-gen-grpc=$<TARGET_FILE:grpc_cpp_plugin>"
    OUT_VAR GRPC_SRCS
    APPEND_PATH
    GENERATE_EXTENSIONS
        .win_grpc.pb.h
        .win_grpc.pb.cc
    PROTOS ${_proto_file_path}
)


target_sources(win_grpc_main PRIVATE ${PROTO_SRCS} ${PROTO_HDRS} ${GRPC_SRCS})

target_include_directories(win_grpc_main
    PRIVATE ${CMAKE_CURRENT_BINARY_DIR}
    PRIVATE ${CMAKE_CURRENT_SOURCE_DIR}
)