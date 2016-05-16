#!/bin/bash

# cd "${0%/*}"
docker build -f Dockerfile.cpp -t appdynamics/mixapp-base:cpp .
docker build -f Dockerfile.java -t appdynamics/mixapp-base:java .
docker build -f Dockerfile.node -t appdynamics/mixapp-base:node .
docker build -f Dockerfile.python -t appdynamics/mixapp-base:python .
docker build -f Dockerfile.php -t appdynamics/mixapp-base:php .
docker build -f Dockerfile.webserver -t appdynamics/mixapp-base:webserver .
