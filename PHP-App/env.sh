#!/bin/bash
if [ -z "${APP_NAME}" ]; then
        export APP_NAME="PHP-App";
fi

if [ -z "${EVENT_ENDPOINT}" ]; then
        export EVENT_ENDPOINT="localhost";
fi

if [ -z "${PHP_TIER_NAME}" ]; then
        export PHP_TIER_NAME="PHP-Tier";
fi

if [ -z "${PHP_NODE_NAME}" ]; then
        export PHP_NODE_NAME="PHP-Node";
fi

if [ -z "${GLOBAL_ACCOUNT_NAME}" ]; then
        export GLOBAL_ACCOUNT_NAME="customer1";
fi

export MACHINE_AGENT_HOME=/machine-agent
export JAVA_OPTS="-Xmx512m -XX:MaxPermSize=256m"
export APPD_JAVA_OPTS="-Dappdynamics.controller.hostName=${CONTROLLER} -Dappdynamics.controller.port=${APPD_PORT} -Dappdynamics.agent.applicationName=${APP_NAME} -Dappdynamics.agent.tierName=${PHP_TIER_NAME} -Dappdynamics.agent.nodeName=${APP_NAME}-${PHP_NODE_NAME} -Dappdynamics.agent.accountName=${ACCOUNT_NAME} -Dappdynamics.agent.accountAccessKey=${ACCESS_KEY}";
export MACHINE_AGENT_JAVA_OPTS="-Dappdynamics.sim.enabled=true ${JAVA_OPTS} ${APPD_JAVA_OPTS}"
