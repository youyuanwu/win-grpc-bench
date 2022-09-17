# maybe this is needed.
#add_dependencies(helloworldserver protobuf::protoc)

#download the proto from grpc example
set(_proto_file_path ${CMAKE_CURRENT_BINARY_DIR}/helloworld.proto)
if(NOT EXISTS ${_proto_file_path})
    message(STATUS "downloading helloworld proto")
    file(DOWNLOAD
        https://raw.githubusercontent.com/grpc/grpc/master/examples/protos/helloworld.proto
        ${_proto_file_path}
    )
endif()