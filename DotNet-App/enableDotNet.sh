#!/bin/bash

echo "Updating the NodeJs container..."
docker exec nodejs_app sed -i "s/DOTNET_IP/${DOTNET_IP}/g" /node-todo/app/crossdotnet.js
docker exec nodejs_app sed -i "s/DOTNET_PORT/${DOTNET_PORT}/g" /node-todo/app/crossdotnet.js

echo "Updating the PHP container..."
docker exec php_app sed -i "s/DOTNET_IP/${DOTNET_IP}/g" /var/www/html/callDotNetApp.php
docker exec php_app sed -i "s/DOTNET_PORT/${DOTNET_PORT}/g" /var/www/html/callDotNetApp.php

echo "Updating the Python container..."
docker exec python_app sed -i "s/DOTNET_IP/${DOTNET_IP}/g" /appd/Python-App/demo/app.py
docker exec python_app sed -i "s/DOTNET_PORT/${DOTNET_PORT}/g" /appd/Python-App/demo/app.py
docker stop python_app
docker start python_app

echo "Updating the CPP container..."
docker exec cpp_app sed -i '$ a cp cpp_app.cpp cpp_call_dotnet.cpp' /opt/appdynamics-sdk-native/build.sh
docker exec cpp_app sed -i '$ a cp cpp_app.gyp cpp_call_dotnet.gyp' /opt/appdynamics-sdk-native/build.sh
docker exec cpp_app sed -i '$ a sed -i "s/<backend_host>/DOTNET_IP/g" $NATIVE_HOME/app/cpp_call_dotnet.cpp' /opt/appdynamics-sdk-native/build.sh
docker exec cpp_app sed -i '$ a sed -i "s/<backend_port>/DOTNET_PORT/g" $NATIVE_HOME/app/cpp_call_dotnet.cpp' /opt/appdynamics-sdk-native/build.sh
docker exec cpp_app sed -i '$ a sed -i "s/<cpp_file_name>/cpp_call_dotnet/g" $NATIVE_HOME/app/cpp_call_dotnet.cpp' /opt/appdynamics-sdk-native/build.sh
docker exec cpp_app sed -i '$ a sed -i "s/<cpp_file_name>/cpp_call_dotnet/g" $NATIVE_HOME/app/cpp_call_dotnet.gyp' /opt/appdynamics-sdk-native/build.sh
docker exec cpp_app sed -i '$ a gyp --depth=./ -f make $NATIVE_HOME/app/cpp_call_dotnet.gyp' /opt/appdynamics-sdk-native/build.sh
docker exec cpp_app sed -i '$ a make' /opt/appdynamics-sdk-native/build.sh
docker exec cpp_app sed -i "s/DOTNET_IP/${DOTNET_IP}/g" /opt/appdynamics-sdk-native/build.sh
docker exec cpp_app sed -i "s/DOTNET_PORT/${DOTNET_PORT}/g" /opt/appdynamics-sdk-native/build.sh
docker exec cpp_app sed -i "/build.sh/ a nohup app/out/Default/cpp_call_dotnet ${DOTNET_IP}:${DOTNET_PORT}/ > dotnet.out 2>&1 &" /startup.sh
docker stop cpp_app
docker start cpp_app

echo "Updating the Load container..."
docker exec mixapp_load sed -i "$ a http://java_app:8080/TechStack/dotnet.httpbackendservlet?address=http://${DOTNET_IP}:${DOTNET_PORT}" /load-generator/MixAppLoadGenURLs.txt
docker exec mixapp_load sed -i "$ a http://php_app/callDotNetApp.php" /load-generator/MixAppLoadGenURLs.txt
docker exec mixapp_load sed -i "$ a http://python_app:9000/crossdotnet" /load-generator/MixAppLoadGenURLs.txt
docker exec mixapp_load sed -i "$ a http://nodejs_app:3000/crossdotnet" /load-generator/MixAppLoadGenURLs.txt
docker exec mixapp_load sed -i "$ a http://${DOTNET_IP}:${DOTNET_PORT}/?url=http://${HOST_IP}:${NODEJS_EX_PORT}" /load-generator/MixAppLoadGenURLs.txt
docker exec mixapp_load sed -i "$ a http://${DOTNET_IP}:${DOTNET_PORT}/?url=http://${HOST_IP}:${PYTHON_EX_PORT}/wave/abc" /load-generator/MixAppLoadGenURLs.txt
docker exec mixapp_load sed -i "$ a http://${DOTNET_IP}:${DOTNET_PORT}/?url=http://${HOST_IP}:${PHP_EX_PORT}/info.php" /load-generator/MixAppLoadGenURLs.txt
docker exec mixapp_load sed -i "$ a http://${DOTNET_IP}:${DOTNET_PORT}/?url=http://${HOST_IP}:${JAVA_EX_PORT}/TechStack/order.jsp" /load-generator/MixAppLoadGenURLs.txt
docker stop mixapp_load
docker start mixapp_load
