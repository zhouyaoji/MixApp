#!/bin/bash

CUSTOM_COMPOSE_FILE=docker-compose.custom.yml
CUSTOM_LOAD_URL=CustomLoadURLs.txt

# Clean up if custom yml file exists
rm -rf $CUSTOM_COMPOSE_FILE

HAVE_JAVA=''
HAVE_NODEJS=''
HAVE_PYTHON=''
HAVE_PHP=''
HAVE_CPP=''
HAVE_WEBSERVER=''
HAVE_ANGULAR=''
ARGS=$@

COMPOSE_HEADER="version: '2'
services:"

JAVA_CONTAINER_COMPOSE='java_app: 
    container_name: java_app
    hostname: HOST_NAME-java_app
    env_file:
      - ./env.sh
    image: appdynamics/mixapp-java
    ports:
      - "3003:8080"'

NODE_CONTAINER_COMPOSE='nodejs_app:
    container_name: nodejs_app
    hostname: HOST_NAME-nodejs_app
    image: appdynamics/mixapp-nodejs
    env_file: 
      - ./env.sh
    ports: 
      - "3000:3000"'

PYTHON_CONTAINER_COMPOSE='python_app:
    container_name: python_app
    hostname: HOST_NAME-python_app
    image: appdynamics/mixapp-python
    env_file: 
      - ./env.sh
    ports: 
      - "3001:9000"'

PHP_CONTAINER_COMPOSE='php_app:
    container_name: php_app
    hostname: HOST_NAME-php_app
    image: appdynamics/mixapp-php
    env_file: 
      - ./env.sh
    ports: 
      - "3002:80"'

WEBSERVER_CONTAINER_COMPOSE='webserver:
    container_name: webserver
    hostname: HOST_NAME-webserver
    env_file: 
      - ./env.sh
    image: appdynamics/mixapp-webserver
    ports:
      - "3004:80"'

ANGULAR_CONTAINER_COMPOSE='angular_app:
    container_name: angular_app
    hostname: HOST_NAME-angular_app
    image: appdynamics/mixapp-angular
    ports:
      - "3008:8000"'

CPP_CONTAINER_COMPOSE='cpp_app:
    container_name: cpp_app
    hostname: HOST_NAME-cpp_app
    env_file: 
      - ./env.sh
    image: appdynamics/mixapp-cpp'

LOAD_CONTAINER_COMPOSE='mixapp_load:
    container_name: mixapp_load
    hostname: HOST_NAME-mixapp_load
    env_file: 
      - ./env.sh
    image: appdynamics/mixapp-load'

promptForContainers(){
	echo "Which containers do you want to start?"
	read -e -p "Java (y or n): " HAVE_JAVA
	read -e -p "Node.js (y or n): " HAVE_NODEJS
	read -e -p "Python (y or n): " HAVE_PYTHON
	read -e -p "PHP (y or n): " HAVE_PHP
	read -e -p "Webserver (y or n): " HAVE_WEBSERVER
	read -e -p "C++ (y or n): " HAVE_CPP
	read -e -p "Angular Browswer (y or n): " HAVE_ANGULAR
}

specifyContaiers(){
	for opt in $ARGS; do
	case $opt in
      	java)
			echo "Adding Java"
	        HAVE_JAVA='y'
	        ;;
      	nodejs)
			echo "Adding Node.js"
	        HAVE_NODEJS='y'
	        ;;
      	python)
			echo "Adding Python"
			HAVE_PYTHON='y'
			;;
		php)
			echo "Adding PHP"
			HAVE_PHP='y'
			;;
		webserver)
			echo "Adding Webserver"
			HAVE_WEBSERVER='y'
			;;
		angular)
			echo "Adding Angular"
			HAVE_ANGULAR='y'
			;;
		cpp)
			echo "Adding C++"
			HAVE_CPP='y'
			;;
	     \?)
	        echo "Invalid option: -$OPTARG"
	        ;;
    esac
  done
}

buildComposeYml(){
 	echo -e "$COMPOSE_HEADER" >> $CUSTOM_COMPOSE_FILE
	if [[ "$HAVE_JAVA" == "y" ]];then
		echo -e "  $JAVA_CONTAINER_COMPOSE" >> $CUSTOM_COMPOSE_FILE
	fi
	if [[ "$HAVE_NODEJS" == "y" ]];then
		echo -e "  $NODE_CONTAINER_COMPOSE" >> $CUSTOM_COMPOSE_FILE
	fi
	if [[ "$HAVE_PYTHON" == "y" ]];then
		echo -e "  $PYTHON_CONTAINER_COMPOSE" >> $CUSTOM_COMPOSE_FILE
	fi
	if [[ "$HAVE_PHP" == "y" ]];then
		echo -e "  $PHP_CONTAINER_COMPOSE" >> $CUSTOM_COMPOSE_FILE
	fi
	if [[ "$HAVE_WEBSERVER" == "y" ]];then
		echo -e "  $WEBSERVER_CONTAINER_COMPOSE" >> $CUSTOM_COMPOSE_FILE
	fi
	if [[ "$HAVE_ANGULAR" == "y" ]];then
		echo -e "  $ANGULAR_CONTAINER_COMPOSE" >> $CUSTOM_COMPOSE_FILE
	fi
	if [[ "$HAVE_CPP" == "y" ]];then
		echo -e "  $CPP_CONTAINER_COMPOSE"  >> $CUSTOM_COMPOSE_FILE
	fi
	echo -e "  $LOAD_CONTAINER_COMPOSE" >> $CUSTOM_COMPOSE_FILE
	echo "docker-compose.custom.yml constructed."
}

# Usage information
if [[ $1 == *--help* ]]
then
  echo "To prompt and select which containers to start, run
  ./custom_start.sh"
  echo "To specify which containers to start, run with the containers you want to start
  ./custom_start.sh [java] [nodejs] [python] [php] [webserver] [angular] [cpp]"
  exit 0
fi

# Build yml file with specified containers, otherwise prompt to users to select
if [ $# -ne 0 ];then
	specifyContaiers
	buildComposeYml
else
	promptForContainers
	buildComposeYml
fi


HOSTNAME=`hostname`

sed -i.bk "s/ HOST_NAME/ ${HOSTNAME}/" docker-compose.custom.yml

rm -f docker-compose.custom.yml.bk

echo "Starting Docker container..."
docker-compose -f docker-compose.custom.yml up -d



