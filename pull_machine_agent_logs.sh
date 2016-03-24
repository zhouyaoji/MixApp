#!/bin/bash
mkdir machine_agent_logs && cd $_

# Get Machine Agent Logs
docker cp python_app:/machine-agent/logs . && mv logs machine_agent_logs_python && zip -rm machine_agent_logs_python.zip ./machine_agent_logs_python
docker cp php_app:/machine-agent/logs . && mv logs machine_agent_logs_php && zip -rm machine_agent_logs_php.zip ./machine_agent_logs_php
docker cp nodejs_app:/machine-agent/logs . && mv logs machine_agent_logs_php && zip -rm machine_agent_logs_nodejs.zip ./machine_agent_logs_php
docker cp java_app:/machine-agent/logs . && mv logs machine_agent_logs_java && zip -rm machine_agent_logs_java.zip ./machine_agent_logs_java
docker cp webserver:/machine-agent/logs . && mv logs machine_agent_logs_webserver && zip -rm machine_agent_logs_webserver.zip ./machine_agent_logs_webserver
docker cp cpp_app:/machine-agent/logs . && mv logs machine_agent_logs_cpp && zip -rm machine_agent_logs_cpp.zip ./machine_agent_logs_cpp