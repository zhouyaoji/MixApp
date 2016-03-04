#!/bin/bash

source /env.sh

cd /tomcat/bin
echo "Starting tomcat"

java -Xdebug -Xrunjdwp:transport=dt_socket,server=y,suspend=n,address=8370 -Dappdynamics.socket.collection.bci.enable=true -javaagent:${CATALINA_HOME}/appagent/javaagent.jar ${APP_AGENT_JAVA_OPTS} ${JMX_OPTS} -cp ${CATALINA_HOME}/bin/bootstrap.jar:${CATALINA_HOME}/bin/tomcat-juli.jar org.apache.catalina.startup.Bootstrap > appserver-agent-startup.out 2>&1
