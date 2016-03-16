#!/bin/bash

# This script should not return or the container will exit
# The last command called should execute in the foreground
cd /load-generator
source env.sh

sed -i "s,<url_extension>,${EXT_URL},g" MixAppLoadGenURLs.txt

javac -cp .:/lib/* MixAppLoadGenerator.java
java -cp .:/lib/* MixAppLoadGenerator > /MixAppLoad.txt 2>&1
