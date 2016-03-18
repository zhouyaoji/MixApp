#!/bin/bash

source /${NATIVE_HOME}/env.sh

echo "Configuring Machine Agent Analytics properties..."
/configAnalytics.sh

echo "Configuring Machine Agent:"
cd ${MACHINE_AGENT_HOME}
nohup java ${MACHINE_AGENT_JAVA_OPTS} -jar machineagent.jar > machine-agent.out 2>&1 &
