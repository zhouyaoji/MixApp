#!/bin/bash

# Version-independent agent names used by Dockerfiles 
MACHINE_AGENT=MachineAgent.zip
APP_SERVER_AGENT=JavaAgent.zip
PHP_AGENT=PHPAgent.tar.bz2
WEBSERVER_AGENT=webserver_agent.tar.gz
CPP_AGENT=appdynamics-sdk-native.tar.gz
TOMCAT=apache-tomcat.tar.gz
ADRUM=adrum.js
NODEJS_AGENT=appdynamics-nodejs-standalone-npm.tgz
PYTHON_AGENT=appdynamics-python-agent

#MACHINE_AGENT=Agents/MachineAgent-4.2.1.8.zip
#APP_SERVER_AGENT=Agents/AppServerAgent-ibm-4.2.1.8.zip
#PHP_AGENT=Agents/appdynamics-php-agent-x64-linux-4.2.1.8.tar.bz2
#WEBSERVER_AGENT=Agents/appdynamics-sdk-native-nativeWebServer-64bit-linux-4.2.1.8.tar.gz
#CPP_AGENT=Agents/appdynamics-sdk-native-64bit-linux-4.2.1.8.tar.gz
#TOMCAT=Agents/apache-tomcat-8.0.33.tar.gz

#MACHINE_AGENT=Agents/MachineAgent-4.2.1.8.zip
#APP_SERVER_AGENT=Agents/AppServerAgent-ibm-4.2.1.8.zip
#PHP_AGENT=Agents/appdynamics-php-agent-x64-linux-4.2.1.8.tar.bz2
#WEBSERVER_AGENT=Agents/appdynamics-sdk-native-nativeWebServer-64bit-linux-4.2.1.8.tar.gz
#CPP_AGENT=Agents/appdynamics-sdk-native-64bit-linux-4.2.1.8.tar.gz
#TOMCAT=Agents/apache-tomcat-8.0.33.tar.gz

cleanUp(){
  # Delete agent distros from docker build dirs
  (cd Java-App && rm -f ${APP_SERVER_AGENT} ${MACHINE_AGENT} ${TOMCAT})
  (cd PHP-App && rm -f ${PHP_AGENT} ${MACHINE_AGENT})
  (cd Node-App && rm -f ${MACHINE_AGENT})
  (cd Python-App && rm -f ${MACHINE_AGENT})
  (cd WebServer && rm -f ${MACHINE_AGENT} ${WEBSERVER_AGENT})
  (cd Cpp-App && rm -f ${CPP_AGENT} ${MACHINE_AGENT})
  (cd Angular-App/mixapp-angular/client/js && rm -f ${ADRUM})
  (cd Node-App/node-todo && rm -f ${NODEJS_AGENT})
  (cd Python-App && rm -rf ${PYTHON_AGENT})

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
  read -e -p "Enter path to App Server Agent (AppServerAgent-<ver>.zip): " APP_SERVER_AGENT_PATH
  read -e -p "Enter path to Machine Agent (64bit-linux-<ver>.zip): " MACHINE_AGENT_PATH
  read -e -p "Enter path to PHP Agent (x64-linux-<ver>.tar.bz): " PHP_AGENT_PATH
  read -e -p "Enter path to WebServer Agent (nativeWebServer-64bit-linux-<ver>.tar.gz): " WEBSERVER_AGENT_PATH
  read -e -p "Enter path of Tomcat (.tar.gz): " TOMCAT_PATH
  read -e -p "Enter path of C++ Native SDK (nativeSDK-64bit-linux-<ver>.tar.gz): " CPP_AGENT_PATH
  read -e -p "Enter path of EUM Agent - Adrum (adrum-<ver>.js): " ADRUM_PATH
  echo "OPTIONAL Press Enter to install default"
  read -e -p "Enter path of Node.js Agent (appdynamics-nodejs-standalone-npm-<ver>.tgz): " NODEJS_PATH
  read -e -p "Enter path of Python Agent Directory (appdynamics-python-agent/): " PYTHON_AGENT_PATH
}
# Searches for the agents in the 'Agents' directory
# and assigns the path to variables for later use.
findAgents(){
  agentDir=$(pwd)/Agents
  # Confirm the Agents directory exists.
  if [ ! -d "$agentDir" ]; then
    echo "The Agents directory doesn't exist. We'll prompt you for the agents."
    return 0 
  fi
  # It exists, so let's find the agents and save their location.
  for f in $(ls $agentDir); do
    case $f in
      MachineAgent*.zip)                          
        MACHINE_AGENT_PATH=$agentDir/$f   
        ;;
      AppServer*.zip)                             
        APP_SERVER_AGENT_PATH=$agentDir/$f 
        ;;
      appdynamics-php-agent*.bz2)                 
        PHP_AGENT_PATH=$agentDir/$f    
        ;;
      appdynamics-sdk-native-nativeWebServer*.gz) 
        WEBSERVER_AGENT_PATH=$agentDir/$f 
        ;;
      apache-tomcat*.gz)                          
        TOMCAT_PATH=$agentDir/$f 
        ;;
      appdynamics-sdk-native*.gz)                 
        CPP_AGENT_PATH=$agentDir/$f 
        ;;
      adrum.js)                                   
        ADRUM_PATH=$agentDir/$f 
        ;;
      *)           
        ;;
    esac
  done
  if [[ -z "${APP_SERVER_AGENT_PATH}" || -z "${PHP_AGENT_PATH}" || -z "${WEBSERVER_AGENT_PATH}" || -z "${TOMCAT_PATH}" || -z "${CPP_AGENT_PATH}" || -z "${ADRUM_PATH}" || -z "${MACHINE_AGENT_PATH}" ]];
    then
    echo "You were missing one of the agents in the 'Agents' directory. We're going to have to ask you to manually provide the path to each agent."
    return 0 
  else
    return 1 
  fi
}

# Searches for the agents in the 'Agents' directory
# and assigns the path to variables for later use.
findAgents(){
  agentDir=$(pwd)/Agents
  # Confirm the Agents directory exists.
  if [ ! -d "$agentDir" ]; then
    echo "The Agents directory doesn't exist. We'll prompt you for the agents."
    return 0 
  fi
  # It exists, so let's find the agents and save their location.
  for f in $(ls $agentDir); do
    case $f in
      MachineAgent*.zip)                          
        MACHINE_AGENT_PATH=$agentDir/$f   
        ;;
      AppServer*.zip)                             
        APP_SERVER_AGENT_PATH=$agentDir/$f 
        ;;
      appdynamics-php-agent*.bz2)                 
        PHP_AGENT_PATH=$agentDir/$f    
        ;;
      appdynamics-sdk-native-nativeWebServer*.gz) 
        WEBSERVER_AGENT_PATH=$agentDir/$f 
        ;;
      apache-tomcat*.gz)                          
        TOMCAT_PATH=$agentDir/$f 
        ;;
      appdynamics-sdk-native*.gz)                 
        CPP_AGENT_PATH=$agentDir/$f 
        ;;
      adrum.js)                                   
        ADRUM_PATH=$agentDir/$f 
        ;;
      *)           
        ;;
    esac
  done
  if [[ -z "${APP_SERVER_AGENT_PATH}" || -z "${PHP_AGENT_PATH}" || -z "${WEBSERVER_AGENT_PATH}" || -z "${TOMCAT_PATH}" || -z "${CPP_AGENT_PATH}" || -z "${ADRUM_PATH}" || -z "${MACHINE_AGENT_PATH}" ]];
    then
    echo "You were missing one of the agents in the 'Agents' directory. We're going to have to ask you to manually provide the path to each agent."
    return 0 
  else
    return 1 
  fi
}

copyAgents(){
  echo "Adding AppDynamics Agents: 
  App Server Agent: ${APP_SERVER_AGENT_PATH} 
  Machine Agent:  ${MACHINE_AGENT_PATH}
  Tomcat: ${TOMCAT_PATH} 
  Php Agent  ${PHP_AGENT_PATH}
  Web Server Agent: ${WEBSERVER_AGENT_PATH}
  C++ Agent: ${CPP_AGENT_PATH}
  Adrum: ${ADRUM_PATH}
  [Optional] Node.js: ${NODEJS_PATH}
  [Optional, 2 .whl files required] Python: ${PYTHON_AGENT_PATH}"
    
  echo "Adding Machine Agent to build"
  cp ${MACHINE_AGENT_PATH} Java-App/${MACHINE_AGENT}
  cp ${MACHINE_AGENT_PATH} PHP-App/${MACHINE_AGENT}
  cp ${MACHINE_AGENT_PATH} Node-App/${MACHINE_AGENT}
  cp ${MACHINE_AGENT_PATH} Python-App/${MACHINE_AGENT}
  cp ${MACHINE_AGENT_PATH} WebServer/${MACHINE_AGENT}
  cp ${MACHINE_AGENT_PATH} Cpp-App/${MACHINE_AGENT}

  echo ${APP_SERVER_AGENT_PATH}
  echo "Whoa, dude!"
  echo "Adding App Server Agent to build"
  cp ${APP_SERVER_AGENT_PATH} Java-App/${APP_SERVER_AGENT}

  echo ${PHP_AGENT_PATH}
  echo "Whoa, dude again!"
  echo "Adding PHP Agent to build"
  cp ${PHP_AGENT_PATH} PHP-App/${PHP_AGENT}

  echo "Adding WebServer Agent to build"
  cp ${WEBSERVER_AGENT_PATH} WebServer/${WEBSERVER_AGENT}

  echo "Adding tomcat path to build" 
  cp ${TOMCAT_PATH} Java-App/${TOMCAT} 

  echo "Adding C++ Native SDK path to build" 
  cp ${CPP_AGENT_PATH} Cpp-App/${CPP_AGENT} 

  echo "Adding adrum.js to Angular App" 
  cp ${ADRUM_PATH} Angular-App/mixapp-angular/client/js/${ADRUM} 

  if [ ! -z ${NODEJS_PATH} ]; then
    echo "Adding Node.js agent to Node.js App" 
    cp ${NODEJS_PATH} Node-App/node-todo/${NODEJS_AGENT}
  fi

  if [ ! -z ${PYTHON_AGENT_PATH} ]; then
    echo "Adding Python agent to Python App" 
    mkdir Python-App/${PYTHON_AGENT}
    cp ${PYTHON_AGENT_PATH}/* Python-App/${PYTHON_AGENT}/
  fi
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
          -w <Path to Web Server Agent>
          -r <Path to Adrum Agent>
          -n [<Path to Node.js Agent>] (Optional)
          -y [<Path to Python Agent Directory>] (Optional, 2 .whl files required)"
  echo "Prompt for agent locations: build.sh"
  exit 0
fi
if  findAgents;
then
  promptForAgents
else
  # Allow user to specify locations of Agent installers
  while getopts "a:c:m:p:t:w:r:n:e:y:" opt; do
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
        MACHINE_AGENT_PATH=$OPTARG
        if [ ! -e ${MACHINE_AGENT_PATH} ]; then
          echo "Not found: ${MACHINE_AGENT_PATH}"; exit 1
        fi
        ;;
      p)
        PHP_AGENT_PATH=$OPTARG 
	      if [ ! -e ${PHP_AGENT_PATH} ]; then
          echo "Not found: ${PHP_AGENT_PATH}"; exit 1        
        fi
        ;;
      t)
        TOMCAT_PATH=$OPTARG 
	      if [ ! -e ${TOMCAT_PATH} ]; then
          echo "Not found: ${TOMCAT_PATH}"; exit 1        
        fi
        ;;
      w)
        WEBSERVER_AGENT_PATH=$OPTARG
        if [ ! -e ${WEBSERVER_AGENT_PATH} ]; then
          echo "Not found: ${WEBSERVER_AGENT_PATH}"; exit 1
        fi
        ;;
      r)
        ADRUM_PATH=$OPTARG
        if [ ! -e ${ADRUM_PATH} ]; then
          echo "Not found: ${ADRUM_PATH}"; exit 1
        fi
        ;;
      n)
        NODEJS_PATH=$OPTARG
          echo "Building with: ${NODE_PATH}";
        ;;
      y)
        PYTHON_AGENT_PATH=$OPTARG
          echo "Building with: ${PYTHON_AGENT_PATH}";
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
  if [ ! -z ${PYTHON_AGENT_PATH} ]; then
    echo "Build with agent: ${PYTHON_AGENT_PATH}"
    (cd Python-App && docker build -f Dockerfile.test -t appdynamics/mixapp-python .) || exit $?
  else
    (cd Python-App && docker build -t appdynamics/mixapp-python .) || exit $?
  fi

echo; echo "Building PHP App..."
(cd PHP-App && docker build -t appdynamics/mixapp-php .) || exit $?

echo; echo "Building Node App..."
  if [ ! -z ${NODEJS_PATH} ]; then
    echo "Build with agent: ${NODEJS_PATH}" 
    (cd Node-App && docker build -f Dockerfile.test -t appdynamics/mixapp-nodejs .) || exit $?
  else
    (cd Node-App && docker build -t appdynamics/mixapp-nodejs .) || exit $?
  fi

echo; echo "Building the Java App..."
(cd Java-App && docker build -t appdynamics/mixapp-java .) || exit $?

echo; echo "Building the C++ Container..."
(cd Cpp-App && docker build -t appdynamics/mixapp-cpp .) || exit $?

echo; echo "Building the WebServer..."
(cd WebServer && docker build -t appdynamics/mixapp-webserver .) || exit $?

echo; echo "Building the Load Gen Container..."
(cd Load-Gen && docker build -t appdynamics/mixapp-load .) || exit $?

echo; echo "Building the Angular.js Container..."
(cd Angular-App && docker build -t appdynamics/mixapp-angular .) || exit $?


HOSTNAME=`hostname`

sed -i.bk "s/ HOST_NAME/ ${HOSTNAME}/" docker-compose.yml

rm -f docker-compose.yml.bk
