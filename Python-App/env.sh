#!/bin/bash

if [ -z "${CONTROLLER}" ]; then
        export CONTROLLER="controller";
fi

if [ -z "${APPD_PORT}" ]; then
        export APPD_PORT=8090;
fi

if [ -z "${EVENT_ENDPOINT}" ]; then
        export EVENT_ENDPOINT="localhost";
fi

if [ -z "${SSL}" ]; then
        export SSL="off";
fi

if [ -z "${APP_NAME}" ]; then
        export APP_NAME="Python-App";
fi

if [ -z "${TIER_NAME}" ]; then
        export TIER_NAME="Python-Tier";
fi

if [ -z "${NODE_NAME}" ]; then
        export NODE_NAME="Python-Node";
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

# Required to start Machine Agent
export MACHINE_AGENT_HOME=/machine-agent
export JAVA_OPTS="-Xmx512m -XX:MaxPermSize=256m"

#Removed Tier and Node name to avoid the known bug - Machine Agent overtaking App Agent
export APPD_JAVA_OPTS="-Dappdynamics.controller.hostName=${CONTROLLER} -Dappdynamics.controller.port=${APPD_PORT} -Dappdynamics.agent.applicationName=${APP_NAME} -Dappdynamics.agent.accountName=${ACCOUNT_NAME} -Dappdynamics.agent.accountAccessKey=${ACCESS_KEY}";

export MACHINE_AGENT_JAVA_OPTS="-Dappdynamics.sim.enabled=true ${JAVA_OPTS} ${APPD_JAVA_OPTS}"
