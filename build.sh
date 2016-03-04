#!/bin/bash

cleanUp() {
  rm -rf Python-App

  # Remove dangling images left-over from build
  if [[ `docker images -q --filter "dangling=true"` ]]
  then
    echo
    echo "Deleting intermediate containers..."
    docker images -q --filter "dangling=true" | xargs docker rmi;
  fi
}
trap cleanUp EXIT

cp runMachineAgent.sh Java-App/
cp runMachineAgent.sh PHP-App/
cp runMachineAgent.sh Node-App/
cp runMachineAgent.sh python-siege/

cp MachineAgent.zip Java-App/
cp MachineAgent.zip PHP-App/
cp MachineAgent.zip Node-App/
cp MachineAgent.zip python-siege/

cp JavaAgent.zip Java-App/
cp PHPAgent.zip PHP-App/

echo; echo "Building MixApp containers"

echo; echo "Building Python App..."
(git clone https://github.com/Appdynamics/Python-Demo-App.git Python-App)
(cp -rf python-siege Python-App/Docker/)
(cd Python-App/Docker/python-app && docker build -t appdynamics/python-app .)
(cd Python-App/Docker/python-siege && docker build -t appdynamics/python-siege .)

echo; echo "Building PHP App..."
(cd PHP-App && docker build -t appdynamics/php-app .)

echo; echo "Building Node App..."
(cd Node-App && docker build -t appdynamics/nodejs-app .)

echo; echo "Building the Java App..."
(cd Java-App && docker build -t appdynamics/java-app .)

echo "Building the Load Gen Container..."
(cd Load-Gen && docker build -t appdynamics/mixapp-load .)