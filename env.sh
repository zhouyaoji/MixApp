#!/bin/bash

# Set variables
CONTROLLER=
APPD_PORT=8090

SSL=off
ACCOUNT_NAME=customer1
ACCESS_KEY=

# Set app variables
APP_NAME=MixApp
TIER_NAME=Python-Tier
NODE_NAME=Python-Node
PHP_TIER_NAME=PHP-Tier
PHP_NODE_NAME=PHP-Node
NODE_TIER_NAME=Nodejs-Tier
NODE_NODE_NAME=Nodejs-Node
JAVA_TIER_NAME=Java-Tier
JAVA_NODE_NAME=Java-Node
WEB_TIER_NAME=Web-Tier
WEB_NODE_NAME=Apache

# Set WebServer sub URL & Destination Node
EXT_URL=/crossjava
DEST_URL=http://java_app:8080
