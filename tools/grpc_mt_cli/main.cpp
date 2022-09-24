/*
 *
 * Copyright 2015 gRPC authors.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 *
 */

#include <iostream>
#include <memory>
#include <string>

#include <boost/program_options.hpp>
#include <grpcpp/grpcpp.h>

#include "helloworld.grpc.pb.h"
#include "certificate.hpp"

using grpc::Channel;
using grpc::ClientContext;
using grpc::Status;
using helloworld::Greeter;
using helloworld::HelloReply;
using helloworld::HelloRequest;

namespace po = boost::program_options;

class GreeterClient {
 public:
  GreeterClient(std::shared_ptr<Channel> channel)
      : stub_(Greeter::NewStub(channel)) {}

  // Assembles the client's payload, sends it and presents the response back
  // from the server.
  std::string SayHello(const std::string& user) {
    // Data we are sending to the server.
    HelloRequest request;
    request.set_name(user);

    // Container for the data we expect from the server.
    HelloReply reply;

    // Context for the client. It could be used to convey extra information to
    // the server and/or tweak certain RPC behaviors.
    ClientContext context;

    // The actual RPC.
    Status status = stub_->SayHello(&context, request, &reply);

    // Act upon its status.
    if (status.ok()) {
      return reply.message();
    } else {
      std::cout << status.error_code() << ": " << status.error_message()
                << std::endl;
      return "RPC failed";
    }
  }

 private:
  std::unique_ptr<Greeter::Stub> stub_;
};

int main(int argc, char** argv) {

    std::string target_str;
    std::string user_str;
    po::options_description desc("Allowed options");
    desc.add_options()
        ("help", "produce help message")
        ("target", po::value(&target_str)->default_value("localhost:50051"), "host:port target")
        ("user", po::value(&user_str)->default_value("world"), "name to send to hello world endpoint")
    ;

    po::variables_map vm;
    po::store(po::parse_command_line(argc, argv, desc), vm);
    po::notify(vm);    

    if (vm.count("help")) {
        std::cout << desc << "\n";
        return 1;
    }

   //std::string cacert = read_keycert("server.crt");
    grpc::SslCredentialsOptions ssl_opts;
   // ssl_opts.pem_root_certs=cacert;
   ssl_opts.pem_root_certs = test_certificate;
    auto ssl_creds = grpc::SslCredentials(ssl_opts);
  GreeterClient greeter(
      grpc::CreateChannel(target_str, ssl_creds));

  std::string reply = greeter.SayHello(user_str);
  std::cout << "Greeter received: " << reply << std::endl;

  return 0;
}