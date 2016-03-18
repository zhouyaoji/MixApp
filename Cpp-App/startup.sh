#!/bin/bash
cd $NATIVE_HOME

if [ -z "${NO_AGENT}" ]; then 
  echo "Starting Proxy Agent"
  nohup ./runSDKProxy.sh &
else
  echo "AppDynamicsEnabled Off - Proxy Agent not started"
fi

# Wait for 5 mins for other apps to show up on the controller
sleep 5m; ./build.sh
nohup app/out/Default/cpp_call_java java_app:8080 > java.out 2>&1 &
nohup app/out/Default/cpp_call_nodejs nodejs_app:3000 > node.out 2>&1 &
nohup app/out/Default/cpp_call_python python_app:9000 > python.out 2>&1 &
nohup app/out/Default/cpp_call_php php_app:80 > php.out 2>&1 