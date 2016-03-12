#!/bin/bash

cleanUp() {
  # Remove dangling images left-over from build
  if [[ `docker images -q --filter "dangling=true"` ]]
  then
    echo
    echo "Deleting intermediate containers..."
    docker images -q --filter "dangling=true" | xargs docker rmi;
  fi
}
trap cleanUp EXIT

cp MachineAgent.zip Java-App/
cp MachineAgent.zip PHP-App/
cp MachineAgent.zip Node-App/
cp MachineAgent.zip Python-App/

cp JavaAgent.zip Java-App/
cp PHPAgent.zip PHP-App/
cp webserver_agent.tar.gz WebServer/

echo; echo "Building MixApp containers"

echo; echo "Building Python App..."
(cd Python-App && docker build -t appdynamics/python-app .)

echo; echo "Building PHP App..."
(cd PHP-App && docker build -t appdynamics/php-app .)

echo; echo "Building Node App..."
(cd Node-App && docker build -t appdynamics/nodejs-app .)

echo; echo "Building the Java App..."
(cd Java-App && docker build -t appdynamics/java-app .)

echo; echo "Building the WebServer..."
(cd WebServer && docker build -t appdynamics/webserver .)

echo; echo "Building the Load Gen Container..."
(cd Load-Gen && docker build -t appdynamics/mixapp-load .)

HOSTNAME=`hostname`

sed -i.bk "s/ HOST_NAME/ ${HOSTNAME}/" docker-compose.yml

rm -f docker-compose.yml.bk
