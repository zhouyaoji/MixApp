#!/bin/bash

source /appd/Python-App/env.sh

cd /machine-agent

nohup java ${MACHINE_AGENT_JAVA_OPTS} -jar machineagent.jar > machine-agent.out 2>&1 &
