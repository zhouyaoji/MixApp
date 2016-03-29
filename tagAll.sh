#! /bin/bash

if [ "$#" -eq 1 ]; then
  export TAG_VERSION=$1
  export REGISTRY="appdynamics"
elif [ "$#" -eq 2 ]; then
  export TAG_VERSION=$1;
  export REGISTRY=$2;
else
  echo "Usage: tagAll.sh <tag> [<registry>]"
  exit
fi

export JAVA_LATEST=`docker images | grep 'appdynamics/java-app' | grep 'latest' | awk '{print $3}'`
export PYTHON_LATEST=`docker images | grep 'appdynamics/python-app' | grep 'latest' | awk '{print $3}'`
export PHP_LATEST=`docker images | grep 'appdynamics/php-app' | grep 'latest' | awk '{print $3}'`
export NODEJS_LATEST=`docker images | grep 'appdynamics/nodejs-app' | grep 'latest' | awk '{print $3}'`
export CPP_LATEST=`docker images | grep 'appdynamics/cpp-app' | grep 'latest' | awk '{print $3}'`
export WEBSERVER_LATEST=`docker images | grep 'appdynamics/webserver' | grep 'latest' | awk '{print $3}'`

docker tag $JAVA_LATEST ${REGISTRY}/java-app:$TAG_VERSION
docker tag $PYTHON_LATEST ${REGISTRY}/python-app:$TAG_VERSION
docker tag $PHP_LATEST ${REGISTRY}/php-app:$TAG_VERSION
docker tag $NODEJS_LATEST ${REGISTRY}/nodejs-app:$TAG_VERSION
docker tag $CPP_LATEST ${REGISTRY}/cpp-app:$TAG_VERSION
docker tag $WEBSERVER_LATEST ${REGISTRY}/webserver:$TAG_VERSION

if [[ `docker images -q --filter "dangling=true"` ]]
then
  echo
  echo "Deleting intermediate containers..."
  docker images -q --filter "dangling=true" | xargs docker rmi;
fi