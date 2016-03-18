#!/bin/bash
cd $NATIVE_HOME
source env.sh

sed -i "s/<your_controller>/${CONTROLLER}/g" $NATIVE_HOME/app/cpp_app.cpp
sed -i "s/<your_controller_port>/${APPD_PORT}/g" $NATIVE_HOME/app/cpp_app.cpp
sed -i "s/<your_app_name>/${APP_NAME}/g" $NATIVE_HOME/app/cpp_app.cpp
sed -i "s/<your_tier_name>/${CPP_TIER_NAME}/g" $NATIVE_HOME/app/cpp_app.cpp
sed -i "s/<your_node_name>/${APP_NAME}-${CPP_NODE_NAME}/g" $NATIVE_HOME/app/cpp_app.cpp
sed -i "s/<your_account_name>/${ACCOUNT_NAME}/g" $NATIVE_HOME/app/cpp_app.cpp
sed -i "s/<your_access_key>/${ACCESS_KEY}/g" $NATIVE_HOME/app/cpp_app.cpp

cd app/

# Replace exitcall properties 
cp cpp_app.cpp cpp_call_java.cpp
cp cpp_app.gyp cpp_call_java.gyp
sed -i "s/<backend_host>/java_app/g" $NATIVE_HOME/app/cpp_call_java.cpp
sed -i "s/<backend_port>/8080/g" $NATIVE_HOME/app/cpp_call_java.cpp
sed -i "s/<cpp_file_name>/cpp_call_java/g" $NATIVE_HOME/app/cpp_call_java.cpp
sed -i "s/<cpp_file_name>/cpp_call_java/g" $NATIVE_HOME/app/cpp_call_java.gyp

gyp --depth=./ -f make $NATIVE_HOME/app/cpp_call_java.gyp
make

cp cpp_app.cpp cpp_call_nodejs.cpp
cp cpp_app.gyp cpp_call_nodejs.gyp
sed -i "s/<backend_host>/nodejs_app/g" $NATIVE_HOME/app/cpp_call_nodejs.cpp
sed -i "s/<backend_port>/3000/g" $NATIVE_HOME/app/cpp_call_nodejs.cpp
sed -i "s/<cpp_file_name>/cpp_call_nodejs/g" $NATIVE_HOME/app/cpp_call_nodejs.cpp
sed -i "s/<cpp_file_name>/cpp_call_nodejs/g" $NATIVE_HOME/app/cpp_call_nodejs.gyp

gyp --depth=./ -f make $NATIVE_HOME/app/cpp_call_nodejs.gyp
make

cp cpp_app.cpp cpp_call_python.cpp
cp cpp_app.gyp cpp_call_python.gyp
sed -i "s/<backend_host>/python_app/g" $NATIVE_HOME/app/cpp_call_python.cpp
sed -i "s/<backend_port>/9000/g" $NATIVE_HOME/app/cpp_call_python.cpp
sed -i "s/<cpp_file_name>/cpp_call_python/g" $NATIVE_HOME/app/cpp_call_python.cpp
sed -i "s/<cpp_file_name>/cpp_call_python/g" $NATIVE_HOME/app/cpp_call_python.gyp

gyp --depth=./ -f make $NATIVE_HOME/app/cpp_call_python.gyp
make

cp cpp_app.cpp cpp_call_php.cpp
cp cpp_app.gyp cpp_call_php.gyp
sed -i "s/<backend_host>/php_app/g" $NATIVE_HOME/app/cpp_call_php.cpp
sed -i "s/<backend_port>/80/g" $NATIVE_HOME/app/cpp_call_php.cpp
sed -i "s/<cpp_file_name>/cpp_call_php/g" $NATIVE_HOME/app/cpp_call_php.cpp
sed -i "s/<cpp_file_name>/cpp_call_php/g" $NATIVE_HOME/app/cpp_call_php.gyp

gyp --depth=./ -f make $NATIVE_HOME/app/cpp_call_php.gyp
make