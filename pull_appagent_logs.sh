#!/bin/bash
mkdir -p appagent_logs
cd appagent_logs

# Get Agent Logs
(docker exec java_app /get_logs.sh && docker cp java_app:/logs . && mv logs java_logs && zip -rm java_logs.zip ./java_logs)
(docker cp python_app:/tmp/appd/logs . && mv logs python_logs && zip -rm python_logs.zip ./python_logs)
(docker cp php_app:/var/www/appdynamics-php-agent/logs . && mv logs php_logs && zip -rm php_logs.zip ./php_logs)
(docker cp nodejs_app:/tmp/appd . && docker cp nodejs_app:/nohup-todo.txt ./appd && mv ./appd/nohup-todo.txt ./appd/agentlog.txt && mv appd nodejs_logs && zip -rm nodejs_logs.zip ./nodejs_logs)
(docker cp webserver:/opt/appdynamics-sdk-native/logs . && mv logs webserver_logs && zip -rm webserver_logs.zip ./webserver_logs)
(docker cp cpp_app:/opt/appdynamics-sdk-native/logs . && mv logs cpp_logs && zip -rm cpp_logs.zip cpp_logs)
