#include "boost/winasio/http/http.hpp"
#include "boost/winasio/http/temp.hpp"

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
                                   logging::trivial::info);
}

int main() {
  log_init();

  // init http module
  winnet::http::http_initializer init;
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
  winnet::http::basic_http_handle<net::io_context::executor_type> queue(
      io_context);
  queue.assign(winnet::http::open_raw_http_queue());
  winnet::http::http_simple_url simple_url(queue, url);

  auto handler = std::bind(grpc::default_handler, middl, std::placeholders::_1,
                           std::placeholders::_2);

  std::make_shared<http_connection<net::io_context::executor_type>>(queue,
                                                                    handler)
      ->start();

  BOOST_LOG_TRIVIAL(info) << "server start listening at: " << url;
  io_context.run();
  BOOST_LOG_TRIVIAL(info) << "server stopped.";
}