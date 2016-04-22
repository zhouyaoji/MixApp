#!/bin/bash
cd $BOOST_DEV/server/
nohup /opt/appdynamics-sdk-native/runSDKProxy.sh > nohup.out 2>&1 &
g++ *.cpp -o server -lboost_system -lboost_thread -lpthread -lappdynamics_native_sdk -L/opt/appdynamics-sdk-native/sdk_lib/lib
./server 0.0.0.0 8090 .