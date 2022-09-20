set (CMAKE_CXX_STANDARD 11)

set(Boost_USE_STATIC_LIBS ON)
find_package(Boost REQUIRED COMPONENTS program_options) 

set(_exe_name grpc_mt_cli_main)

add_executable(${_exe_name} main.cpp)

# link with the helloworld lib built with server
target_link_libraries(${_exe_name}
    PRIVATE grpc_mt_lib 
    PRIVATE Boost::program_options
)

# for certificate.hpp
target_include_directories(${_exe_name}
    PRIVATE ../../grpc_mt
)