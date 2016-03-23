#!/bin/bash

# Version-independent agent names used by Dockerfiles 
MACHINE_AGENT=MachineAgent.zip
APP_SERVER_AGENT=JavaAgent.zip
PHP_AGENT=PHPAgent.tar.bz2
WEBSERVER_AGENT=webserver_agent.tar.gz
CPP_AGENT=appdynamics-sdk-native.tar.gz
TOMCAT=apache-tomcat.tar.gz

cleanUp(){
  # Delete agent distros from docker build dirs
  (cd Java-App && rm -f ${APP_SERVER_AGENT} ${MACHINE_AGENT} ${TOMCAT})
  (cd PHP-App && rm -f ${PHP_AGENT} ${MACHINE_AGENT})
  (cd Node-App && rm -f ${MACHINE_AGENT})
  (cd Python-App && rm -f ${MACHINE_AGENT})
  (cd WebServer && rm -f ${MACHINE_AGENT} ${WEBSERVER_AGENT})
  (cd Cpp-App && rm -f ${CPP_AGENT} ${MACHINE_AGENT})

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
  read -e -p "Enter path to App Server Agent (.zip): " APP_SERVER_AGENT_PATH
  read -e -p "Enter path to Machine Agent (.zip): " MACHINE_AGENT_PATH
  read -e -p "Enter path to PHP Agent (.tar.bz2): " PHP_AGENT_PATH
  read -e -p "Enter path to WebServer Agent (.zip): " WEBSERVER_AGENT_PATH
  read -e -p "Enter path of Tomcat (.tar.gz): " TOMCAT_PATH
  read -e -p "Enter path of C++ Native SDK (.tar.gz): " CPP_AGENT_PATH
}

copyAgents(){
  echo "Adding AppDynamics Agents: 
  App Server Agent: ${APP_SERVER_AGENT_PATH} 
  Machine Agent:  ${MACHINE_AGENT_PATH}
  Tomcat: ${TOMCAT_PATH} 
  Php Agent  ${PHP_AGENT_PATH}
  Web Server Agent: ${WEBSERVER_AGENT_PATH}
  C++ Agent: ${CPP_AGENT_PATH}"  
    
  echo "Adding Machine Agent to build"
  cp ${MACHINE_AGENT_PATH} Java-App/${MACHINE_AGENT}
  cp ${MACHINE_AGENT_PATH} PHP-App/${MACHINE_AGENT}
  cp ${MACHINE_AGENT_PATH} Node-App/${MACHINE_AGENT}
  cp ${MACHINE_AGENT_PATH} Python-App/${MACHINE_AGENT}
  cp ${MACHINE_AGENT_PATH} WebServer/${MACHINE_AGENT}
  cp ${MACHINE_AGENT_PATH} Cpp-App/${MACHINE_AGENT}

  echo "Adding App Server Agent to build"
  cp ${APP_SERVER_AGENT_PATH} Java-App/${APP_SERVER_AGENT}

  echo "Adding PHP Agent to build"
  cp ${PHP_AGENT_PATH} PHP-App/${PHP_AGENT}

  echo "Adding WebServer Agent to build"
  cp ${WEBSERVER_AGENT_PATH} WebServer/${WEBSERVER_AGENT}

  echo "Adding tomcat path to build" 
  cp ${TOMCAT_PATH} Java-App/${TOMCAT} 

  echo "Adding C++ Native SDK path to build" 
  cp ${CPP_AGENT_PATH} Cpp-App/${CPP_AGENT} 
}

# Usage information
if [[ $1 == *--help* ]]
then
  echo "Specify agent locations: build.sh
          -a <Path to App Server Agent>
          -c <Path to C++ Agent>
          -m <Path to Machine Agent>
          -p <Path to Php Agent>
          -t <Path to Tomcat>
          -w <Path to Web Server Agent>"
  echo "Prompt for agent locations: build.sh"
  exit 0
fi

if  [ $# -eq 0 ]
then
  promptForAgents
else
  # Allow user to specify locations of Agent installers
  while getopts "a:c:m:p:t:w:" opt; do
    case $opt in
      a)
        APP_SERVER_AGENT_PATH=$OPTARG
        if [ ! -e ${APP_SERVER_AGENT_PATH} ]; then
          echo "Not found: ${APP_SERVER_AGENT_PATH}"; exit 1
        fi
        ;;
      c)
        CPP_AGENT_PATH=$OPTARG
        if [ ! -e ${CPP_AGENT_PATH} ]; then
          echo "Not found: ${CPP_AGENT_PATH}"; exit 1
        fi
        ;; 
      m)
        export MACHINE_AGENT_PATH=$OPTARG
        if [ ! -e ${MACHINE_AGENT_PATH} ]; then
          echo "Not found: ${MACHINE_AGENT_PATH}"; exit 1
        fi
        ;;
      p)
        export PHP_AGENT_PATH=$OPTARG 
	if [ ! -e ${PHP_AGENT_PATH} ]; then
          echo "Not found: ${PHP_AGENT_PATH}"; exit 1        
        fi
        ;;
      t)
        export TOMCAT_PATH=$OPTARG 
	if [ ! -e ${TOMCAT_PATH} ]; then
          echo "Not found: ${TOMCAT_PATH}"; exit 1        
        fi
        ;;
      w)
        export WEBSERVER_AGENT_PATH=$OPTARG
        if [ ! -e ${WEBSERVER_AGENT_PATH} ]; then
          echo "Not found: ${WEBSERVER_AGENT_PATH}"; exit 1
        fi
        ;;
      \?)
        echo "Invalid option: -$OPTARG"
        ;;
    esac
  done
fi

copyAgents

echo; echo "Building MixApp containers"

echo; echo "Building Python App..."
(cd Python-App && docker build -t appdynamics/python-app .) || exit $?

echo; echo "Building PHP App..."
(cd PHP-App && docker build -t appdynamics/php-app .) || exit $?

echo; echo "Building Node App..."
(cd Node-App && docker build -t appdynamics/nodejs-app .) || exit $?

echo; echo "Building the Java App..."
(cd Java-App && docker build -t appdynamics/java-app .) || exit $?

echo; echo "Building the C++ Container..."
(cd Cpp-App && docker build -t appdynamics/cpp-app .) || exit $?

echo; echo "Building the WebServer..."
(cd WebServer && docker build -t appdynamics/webserver .) || exit $?

echo; echo "Building the Load Gen Container..."
(cd Load-Gen && docker build -t appdynamics/mixapp-load .) || exit $?


HOSTNAME=`hostname`

sed -i.bk "s/ HOST_NAME/ ${HOSTNAME}/" docker-compose.yml

rm -f docker-compose.yml.bk
