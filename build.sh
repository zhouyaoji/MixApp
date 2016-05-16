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

checkBase(){
  if [[ ! -z $(docker images -q appdynamics/mixapp-base:java) 
    && ! -z $(docker images -q appdynamics/mixapp-base:python) 
    && ! -z $(docker images -q appdynamics/mixapp-base:node) 
    && ! -z $(docker images -q appdynamics/mixapp-base:php) 
    && ! -z $(docker images -q appdynamics/mixapp-base:cpp) 
    && ! -z $(docker images -q appdynamics/mixapp-base:webserver) ]]; then
    echo "You have all the base images. Awesome! "
    echo "************************************"
  else
    echo "Missing base image, building now..."
    cd Base-Image; ./buildBase.sh
    cd ..
  fi
}

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

findAgents(){
  #AGENT_DIR=$(pwd)/Agents
  # Confirm the Agents directory exists.
  if [ -z "$AGENT_DIR" ]; then
    echo "The Agents directory doesn't exist. We'll prompt you for the agents."
    return 0 
  fi
  # It exists, so let's find the agents and save their location.
  for f in $(ls $AGENT_DIR); do
    case $f in
      [Mm]achine*[Aa]gent*.zip)
        MACHINE_AGENT_PATH=$AGENT_DIR/$f   
        ;;
      [Aa]pp*[Ss]erver*[Aa]gent*.zip)                             
        APP_SERVER_AGENT_PATH=$AGENT_DIR/$f 
        ;;
      appdynamics-php-agent*.bz2)                 
        PHP_AGENT_PATH=$AGENT_DIR/$f    
        ;;
      appdynamics-sdk-native-nativeWebServer*.gz) 
        WEBSERVER_AGENT_PATH=$AGENT_DIR/$f 
        ;;
      apache-tomcat*.gz)                          
        TOMCAT_PATH=$AGENT_DIR/$f 
        ;;
      appdynamics-sdk-native*.gz)                 
        CPP_AGENT_PATH=$AGENT_DIR/$f 
        ;;
      adrum*.js)                                   
        ADRUM_PATH=$AGENT_DIR/$f 
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
    echo "All app agents found"
    return 1 
  fi
}

checkAgents(){
  if [ ! -e ${APP_SERVER_AGENT_PATH} ]; then
    echo "App Server Agent not found."; exit 1
  fi
  if [ ! -e ${CPP_AGENT_PATH} ]; then
    echo "C++ Agent not found."; exit 1
  fi
  if [ ! -e ${MACHINE_AGENT_PATH} ]; then
    echo "Machine Agent not found."; exit 1
  fi
  if [ ! -e ${PHP_AGENT_PATH} ]; then
    echo "PHP Agent not found."; exit 1        
  fi
  if [ ! -e ${TOMCAT_PATH} ]; then
    echo "Tomcat not found.";
    read -p "Do you want to download Tomcat?" yn
    case $yn in
        [Yy]* ) wget http://download.nextag.com/apache/tomcat/tomcat-8/v8.0.33/bin/apache-tomcat-8.0.33.tar.gz; break;;
        [Nn]* ) exit;;
        * ) echo "Please answer y or n.";;
    esac      
  fi
  if [ ! -e ${WEBSERVER_AGENT_PATH} ]; then
    echo "WebServer Agent not found."; exit 1
  fi
  if [ ! -e ${ADRUM_PATH} ]; then
    echo "Adrum.js not found."; exit 1
  fi
}

copyAgents(){
  echo "Here is your Tomcat:
  Tomcat: 
    ${TOMCAT_PATH} "
  echo "Here are your AppDynamics Agents: 
  App Server Agent:
    ${APP_SERVER_AGENT_PATH} 
  Machine Agent:
    ${MACHINE_AGENT_PATH}
  PHP Agent  
    ${PHP_AGENT_PATH}
  Web Server Agent: 
    ${WEBSERVER_AGENT_PATH}
  C++ Agent: 
    ${CPP_AGENT_PATH}
  Adrum: 
    ${ADRUM_PATH}
  [Optional] Node.js Agent: 
    ${NODEJS_PATH}
  [Optional] Python Agent: 
    ${PYTHON_AGENT_PATH}"
  
  echo "************************************"
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

  echo "Adding Apache Tomcat to build" 
  cp ${TOMCAT_PATH} Java-App/${TOMCAT} 

  echo "Adding C++ Agent to build" 
  cp ${CPP_AGENT_PATH} Cpp-App/${CPP_AGENT} 

  echo "Adding adrum.js to build" 
  cp ${ADRUM_PATH} Angular-App/mixapp-angular/client/js/${ADRUM} 

  if [ ! -z ${NODEJS_PATH} ]; then
    echo "Adding Node.js agent to build" 
    cp ${NODEJS_PATH} Node-App/node-todo/${NODEJS_AGENT}
  fi

  if [ ! -z ${PYTHON_AGENT_PATH} ]; then
    echo "Adding Python agent to build" 
    mkdir Python-App/${PYTHON_AGENT}
    cp ${PYTHON_AGENT_PATH}/* Python-App/${PYTHON_AGENT}/
  fi
}

specifyAgents(){
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
        ;;
      y)
        PYTHON_AGENT_PATH=$OPTARG
        ;;
      \?)
        echo "Invalid option: -$OPTARG"
        ;;
    esac
  done
}

buildImages(){
  echo; echo "************************************"
  echo "Building MixApp Images"
  checkBase
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

  echo; echo "Building Java App..."
  (cd Java-App && docker build -t appdynamics/mixapp-java .) || exit $?

  echo; echo "Building C++ App..."
  (cd Cpp-App && docker build -t appdynamics/mixapp-cpp .) || exit $?

  echo; echo "Building WebServer..."
  (cd WebServer && docker build -t appdynamics/mixapp-webserver .) || exit $?

  echo; echo "Building Load Generator..."
  (cd Load-Gen && docker build -t appdynamics/mixapp-load .) || exit $?

  echo; echo "Building Angular.js Browser App..."
  (cd Angular-App && docker build -t appdynamics/mixapp-angular .) || exit $?
}

# Usage information
if [[ $1 == *--help* ]]
then
  echo "To specify agent locations, run 
  ./build.sh -a <Path to App Server Agent> -c <Path to C++ Agent> -m <Path to Machine Agent> -p <Path to Php Agent> -t <Path to Tomcat> -w <Path to Web Server Agent> -r <Path to Adrum Agent> -n [<Path to Node.js Agent>] (Optional) -y [<Path to Python Agent Directory>] (Optional, 2 .whl files required)"
  echo "To prompt for agent locations, run
  ./build.sh"
  echo "To specify agent directory, run 
  ./build.sh -d <absolute-path-to-agent-directory>"
  exit 0
fi

# If user specify their agents directory
if [[ $1 == *-d* ]]
then
  AGENT_DIR=$2
  findAgents;
fi

# Prompt command for user to specify each agent's path
if [ "$#" -eq 0 ]
  then 
  read -e -p "Where is your Agent directory? 
  (press [ENTER] if you want to provide agent paths one by one)
  Please provide absolute path: " AGENT_DIR
  findAgents
  if [ -z $AGENT_DIR ]; then
    promptForAgents
  fi
fi

# Specify agent path in one line
if [ "$#" -gt 6 ]
  then
  specifyAgents; 
fi

# Check if agents exist then copy agents into each directory
checkAgents
copyAgents
buildImages

HOSTNAME=`hostname`

sed -i.bk "s/ HOST_NAME/ ${HOSTNAME}/" docker-compose.yml

rm -f docker-compose.yml.bk
