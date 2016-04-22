//
// main.cpp
// ~~~~~~~~
//
// Copyright (c) 2003-2012 Christopher M. Kohlhoff (chris at kohlhoff dot com)
//
// Distributed under the Boost Software License, Version 1.0. (See accompanying
// file LICENSE_1_0.txt or copy at http://www.boost.org/LICENSE_1_0.txt)
//

#include <iostream>
#include <string>
#include <boost/asio.hpp>
#include <boost/bind.hpp>
#include "server.hpp"
#include "/opt/appdynamics-sdk-native/sdk_lib/appdynamics.h"

const char APP_NAME[] = "Boost";
const char TIER_NAME[] = "Boost";
const char NODE_NAME[] = "Boost";
const char CONTROLLER_HOST[] = "controller";
const int CONTROLLER_PORT = 8090;
const char CONTROLLER_ACCOUNT[] = "customer1";
const char CONTROLLER_ACCESS_KEY[] = "access_key";
const int CONTROLLER_USE_SSL = 0;
const int WAITTIMEFORCONFIG = 10000;

int main(int argc, char* argv[])
{

    appd_config cfg;
    appd_config_init(&cfg);
    cfg.app_name = (char*)APP_NAME;
    cfg.tier_name = (char*)TIER_NAME;
    cfg.node_name = (char*)NODE_NAME;
    cfg.controller.host = (char*)CONTROLLER_HOST;
    cfg.controller.port = CONTROLLER_PORT;
    cfg.controller.account = (char*)CONTROLLER_ACCOUNT;
    cfg.controller.access_key = (char*)CONTROLLER_ACCESS_KEY;
    cfg.controller.use_ssl = CONTROLLER_USE_SSL;
    cfg.init_timeout_ms = WAITTIMEFORCONFIG;

    printf("Calling appd_sdk_init. Waiting %d milliseconds for config\n", WAITTIMEFORCONFIG);

    // initialize the SDK
    int initRC = appd_sdk_init(&cfg);
    if (initRC)
        {
            std::cerr <<  "Error: sdk init: " << initRC << ". Check that proxy was manually started.";
            return -1;
        }

  try
  {
    // Check command line arguments.
    if (argc != 4)
    {
      std::cerr << "Usage: http_server <address> <port> <doc_root>\n";
      std::cerr << "  For IPv4, try:\n";
      std::cerr << "    receiver 0.0.0.0 80 .\n";
      std::cerr << "  For IPv6, try:\n";
      std::cerr << "    receiver 0::0 80 .\n";
      return 1;
    }

    // Initialise the server.
    http::server::server s(argv[1], argv[2], argv[3]);

    // Run the server until stopped.
    s.run();
  }
  catch (std::exception& e)
  {
    std::cerr << "exception: " << e.what() << "\n";
  }

  return 0;
}