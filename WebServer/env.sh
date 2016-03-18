#!/bin/bash

if [ -z "${CONTROLLER}" ]; then
	export CONTROLLER="controller";
fi

if [ -z "${APPD_PORT}" ]; then
	export APPD_PORT=8090;
fi

if [ -z "${APP_NAME}" ]; then
	export APP_NAME="WebServer";
fi

if [ -z "${WEB_TIER_NAME}" ]; then
	export WEB_TIER_NAME="WebTier";
fi

if [ -z "${WEB_NODE_NAME}" ]; then
	export WEB_NODE_NAME="Apache";
fi

if [ -z "${EVENT_ENDPOINT}" ]; then
        export EVENT_ENDPOINT="localhost";
fi

if [ -z "${ACCOUNT_NAME}" ]; then
        export ACCOUNT_NAME="customer1";
fi

if [ -z "${GLOBAL_ACCOUNT_NAME}" ]; then
        export GLOBAL_ACCOUNT_NAME="customer1";
fi

if [ -z "${ACCESS_KEY}" ]; then
        export ACCESS_KEY="your-account-access-key";
fi

if [ -z "${EXT_URL}" ]; then
        export EXT_URL="/calljavanode";
fi

if [ -z "${DEST_URL}" ]; then
        export DEST_URL="http://java_app:8080";
fi


export HTTPD_24=/opt/rh/httpd24/root/etc/httpd
export NATIVE_SDK_HOME=/opt/appdynamics-sdk-native
export JAVA_OPTS="-Xmx512m -XX:MaxPermSize=256m"

# Uncomment these lines to use system proeprties to override controller-info.xml settings
export MACHINE_AGENT_HOME=/machine-agent
export APPD_JAVA_OPTS="-Dappdynamics.controller.hostName=${CONTROLLER} -Dappdynamics.controller.port=${APPD_PORT} -Dappdynamics.agent.applicationName=${APP_NAME} -Dappdynamics.agent.accountName=${ACCOUNT_NAME} -Dappdynamics.agent.accountAccessKey=${ACCESS_KEY}";
export APPD_HOSTID_OPTS="-DuniqueHostId=${HOSTNAME}"
export APPD_SIM_OPTS="-Dappdynamics.sim.enabled=true"
export MACHINE_AGENT_JAVA_OPTS="-Dappdynamics.sim.enabled=true ${JAVA_OPTS} ${APPD_JAVA_OPTS}"
