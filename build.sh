#!/bin/bash

# Version-independent agent names used by Dockerfiles 
MACHINE_AGENT=MachineAgent.zip
APP_SERVER_AGENT=AppServerAgent.zip
PHP_AGENT=PhpAgent.zip


cleanUp() {
if [ -z ${PREPARE_ONLY} ]; then
 echo "Deleting Older Agents"
# Delete agent distros from docker build dirs
(cd Java-App && rm -f AppServerAgent.zip MachineAgent.zip apache-tomcat.tar.gz)
(cd PHP-App && rm -f PhpAgent.zip MachineAgent.zip)
(cd Node-App && rm -f MachineAgent.zip)
(cd Python-App && rm -f MachineAgent.zip)

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
  read -e -p "Enter path to PHP Agents: " PHP_AGENT
  read -e -p "Enter path of tomcat Jar: " TOMCAT


  echo "Adding AppDynamics Agents: 
    ${APP_SERVER_AGENT} 
    ${MACHINE_AGENT}
    ${TOMCAT} 
    ${PHP_AGENT}"  
    
    # Add Machine Agent to build
    
cp ${MACHINE_AGENT} Java-App/MachineAgent.zip
cp ${MACHINE_AGENT} PHP-App/MachineAgent.zip
cp ${MACHINE_AGENT} Node-App/MachineAgent.zip
cp ${MACHINE_AGENT} Python-App/MachineAgent.zip

   # Add App Server Agent to build
   
cp ${APP_SERVER_AGENT} Java-App/AppServerAgent.zip

   # Add PHP Agent to build
   
cp ${PHP_AGENT} PHP-App/PhpAgent.zip 

  echo "Add tomcat path to build" 
cp ${TOMCAT} Java-App/apache-tomcat.tar.gz  

}



if  [ $# -eq 0 ]
then
  promptForAgents
  fi

#cp MachineAgent.zip Java-App/
#cp MachineAgent.zip PHP-App/
#cp MachineAgent.zip Node-App/
#cp MachineAgent.zip Python-App/

#cp JavaAgent.zip Java-App/
#cp PHPAgent.zip PHP-App/

echo; echo "Building MixApp containers"

echo; echo "Building Python App..."
(cd Python-App && docker build -t appdynamics/python-app .)

echo; echo "Building PHP App..."
(cd PHP-App && docker build -t appdynamics/php-app .)

echo; echo "Building Node App..."
(cd Node-App && docker build -t appdynamics/nodejs-app .)

echo; echo "Building the Java App..."
(cd Java-App && docker build -t appdynamics/java-app .)

echo "Building the Load Gen Container..."
(cd Load-Gen && docker build -t appdynamics/mixapp-load .)

HOSTNAME=`hostname`

sed -i.bk "s/ HOST_NAME/ ${HOSTNAME}/" docker-compose.yml

rm -f docker-compose.yml.bk
