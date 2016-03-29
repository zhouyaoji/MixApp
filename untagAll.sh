#! /bin/bash

if [ "$#" -eq 1 ]; then
  export TAG_VERSION=$1
  export REGISTRY="appdynamics"
elif [ "$#" -eq 2 ]; then
  export TAG_VERSION=$1;
  export REGISTRY=$2;
else
  echo "Usage: untagAll.sh <tag> [<registry>]"
  exit
fi

docker rmi ${REGISTRY}/java-app:$TAG_VERSION
docker rmi ${REGISTRY}/python-app:$TAG_VERSION
docker rmi ${REGISTRY}/php-app:$TAG_VERSION
docker rmi ${REGISTRY}/nodejs-app:$TAG_VERSION
docker rmi ${REGISTRY}/cpp-app:$TAG_VERSION
docker rmi ${REGISTRY}/webserver:$TAG_VERSION

if [[ `docker images -q --filter "dangling=true"` ]]
then
  echo
  echo "Deleting intermediate containers..."
  docker images -q --filter "dangling=true" | xargs docker rmi;
fi