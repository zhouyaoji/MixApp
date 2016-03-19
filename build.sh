#!/bin/bash

# Version-independent agent names used by Dockerfiles 
MACHINE_AGENT=MachineAgent.zip
APP_SERVER_AGENT=JavaAgent.zip
PHP_AGENT=PHPAgent.zip
WEBSERVER_AGENT=webserver_agent.tar.gz
CPP_AGENT=appdynamics-sdk-native.tar.gz

cleanUp() {
if [ -z ${PREPARE_ONLY} ]; then
 echo "Deleting Older Agents"
# Delete agent distros from docker build dirs
(cd Java-App && rm -f AppServerAgent.zip MachineAgent.zip apache-tomcat.tar.gz)
(cd PHP-App && rm -f PhpAgent.zip MachineAgent.zip)
(cd Node-App && rm -f MachineAgent.zip)
(cd Python-App && rm -f MachineAgent.zip)
(cd WebServer && rm -f MachineAgent.zip webserver_agent.tar.gz)
(cd Cpp-App && rm -f appdynamics-sdk-native.tar.gz MachineAgent.zip)

fi
  # Remove dangling images left-over from build
  if [[ `docker images -q --filter "dangling=true"` ]]
  then
    echo
    echo "Deleting intermediate containers..."
    docker images -q --filter "dangling=true" | xargs docker rmi;
  fi
}
trap cleanUp EXIT

promptForAgents(){
  read -e -p "Enter path to App Server Agent: " APP_SERVER_AGENT
  read -e -p "Enter path to Machine Agent (zip): " MACHINE_AGENT
  read -e -p "Enter path to PHP Agent: " PHP_AGENT
  read -e -p "Enter path to WebServer Agent: " WEBSERVER_AGENT
  read -e -p "Enter path of tomcat Jar: " TOMCAT
  read -e -p "Enter path of C++ Native SDK: " CPP_AGENT

  echo "Adding AppDynamics Agents: 
    ${APP_SERVER_AGENT} 
    ${MACHINE_AGENT}
    ${TOMCAT} 
    ${PHP_AGENT}
    ${WEBSERVER_AGENT}
    ${CPP_AGENT}"  
    
  echo "Add Machine Agent to build"
  cp ${MACHINE_AGENT} Java-App/MachineAgent.zip
  cp ${MACHINE_AGENT} PHP-App/MachineAgent.zip
  cp ${MACHINE_AGENT} Node-App/MachineAgent.zip
  cp ${MACHINE_AGENT} Python-App/MachineAgent.zip
  cp ${MACHINE_AGENT} WebServer/MachineAgent.zip
  cp ${MACHINE_AGENT} Cpp-App/MachineAgent.zip

  echo "Add App Server Agent to build"
  cp ${APP_SERVER_AGENT} Java-App/JavaAgent.zip

  echo "Add PHP Agent to build"
  cp ${PHP_AGENT} PHP-App/PHPAgent.zip 

  echo "Add WebServer Agent to build"
  cp ${WEBSERVER_AGENT} WebServer/webserver_agent.tar.gz

  echo "Add tomcat path to build" 
  cp ${TOMCAT} Java-App/apache-tomcat.tar.gz 

  echo "Add C++ Native SDK path to build" 
  cp ${CPP_AGENT} Cpp-App/appdynamics-sdk-native.tar.gz 

}

if  [ $# -eq 0 ]
then
  promptForAgents
fi

echo; echo "Building MixApp containers"

echo; echo "Building Python App..."
(cd Python-App && docker build -t appdynamics/python-app .)

echo; echo "Building PHP App..."
(cd PHP-App && docker build -t appdynamics/php-app .)

echo; echo "Building Node App..."
(cd Node-App && docker build -t appdynamics/nodejs-app .)

echo; echo "Building the Java App..."
(cd Java-App && docker build -t appdynamics/java-app .)

echo; echo "Building the C++ Container..."
(cd Cpp-App && docker build -t appdynamics/cpp-app .)

echo; echo "Building the WebServer..."
(cd WebServer && docker build -t appdynamics/webserver .)

echo; echo "Building the Load Gen Container..."
(cd Load-Gen && docker build -t appdynamics/mixapp-load .)


HOSTNAME=`hostname`

sed -i.bk "s/ HOST_NAME/ ${HOSTNAME}/" docker-compose.yml

rm -f docker-compose.yml.bk
