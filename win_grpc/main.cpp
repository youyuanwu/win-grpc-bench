#include "boost/winasio/http/http.hpp"
#include "boost/winasio/http/temp.hpp"
#include "boost/winasio/http/basic_http_url.hpp"

#include "boost/wingrpc/wingrpc.hpp"

#include <boost/asio/signal_set.hpp>

#include <boost/log/core.hpp>
#include <boost/log/expressions.hpp>
#include <boost/log/trivial.hpp>

namespace net = boost::asio;
namespace winnet = boost::winasio;
namespace grpc = boost::wingrpc;



#include "helloworld.pb.h"
#include "helloworld.win_grpc.pb.h"

class server2 : public Greeter::Service {
public:
  void SayHello(boost::system::error_code &ec,
                const helloworld::HelloRequest *request,
                helloworld::HelloReply *reply) override {
    reply->set_message("hello " + request->name());
  }
};

void log_init() {
  namespace logging = boost::log;
  logging::core::get()->set_filter(logging::trivial::severity >=
                                   logging::trivial::debug);
}

int main() {
  log_init();

  // init http module
  winnet::http::http_initializer<winnet::http::HTTP_MAJOR_VERSION::http_ver_2> init;
  // add https then this becomes https server
  std::wstring url = L"https://localhost:12356/";

  boost::system::error_code ec;
  net::io_context io_context;
  net::signal_set signals(io_context, SIGINT, SIGTERM);
  signals.async_wait([&io_context](auto, auto) { io_context.stop(); });

  server2 svr;

  grpc::ServiceMiddleware middl;
  middl.add_service(svr);

  // open queue handle
  winnet::http::basic_http_queue_handle<net::io_context::executor_type> queue(
      io_context);
  queue.assign(init.create_http_queue(ec));
  BOOST_ASSERT(!ec.failed());

  winnet::http::basic_http_url<net::io_context::executor_type,
                              winnet::http::HTTP_MAJOR_VERSION::http_ver_2>
    simple_url(queue, url);

  auto handler = std::bind(grpc::default_handler, middl, std::placeholders::_1,
                           std::placeholders::_2);

  std::make_shared<http_connection<net::io_context::executor_type>>(queue,
                                                                    handler)
      ->start();

  BOOST_LOG_TRIVIAL(info) << "server start listening at: " << url;
  std::vector<std::thread> threads;
  int parallelism = std::thread::hardware_concurrency();
  BOOST_LOG_TRIVIAL(info) << "server using " << parallelism << " threads";
  threads.reserve(parallelism);
  for (int i = 0; i < parallelism; ++i) {
    threads.emplace_back([&io_context] {
      io_context.run();
    });
  }
  io_context.run();
  BOOST_LOG_TRIVIAL(info) << "server stopped.";
  for (auto &thread : threads) {
    thread.join();
  }
}