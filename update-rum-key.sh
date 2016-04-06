#!/bin/bash

if  [ $# -eq 0 ]
then
  read -e -p "Enter Rum Key: " RUM_KEY
  read -e -p "Enter EUM Cloud Destination: " EUM_CLOUD
  read -e -p "Enter EUM extension url (leave empty if using default extention url): " EXT_URL
else
	RUM_KEY=$1
	EUM_CLOUD=$2
	EXT_URL=$3
fi

echo "Updating RUM key and eum cloud to: "
echo "RUM_KEY: " $RUM_KEY
echo "EUM Cloud: " $EUM_CLOUD
echo "EUM extension url: " $EXT_URL
docker exec angular_app ./update-rum-key.sh $RUM_KEY $EUM_CLOUD $EXT_URL
echo "Done"
