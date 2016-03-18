#!/bin/bash

if [ -z "${CONTROLLER}" ]; then
	export CONTROLLER="controller";
fi

if [ -z "${APPD_PORT}" ]; then
	export APPD_PORT=8090;
fi

if [ -z "${APP_NAME}" ]; then
	export APP_NAME="C_plus_plus_app";
fi

if [ -z "${CPP_TIER_NAME}" ]; then
	export CPP_TIER_NAME="Cpp_tier";
fi

if [ -z "${CPP_NODE_NAME}" ]; then
	export CPP_NODE_NAME="Cpp_node";
fi

if [ -z "${EVENT_ENDPOINT}" ]; then
        export EVENT_ENDPOINT="localhost";
fi

if [ -z "${ACCOUNT_NAME}" ]; then
        export ACCOUNT_NAME="customer1";
fi

if [ -z "${GLOBAL_ACCOUNT_NAME}" ]; then
        export GLOBAL_ACCOUNT_NAME="customer1";
fi

if [ -z "${ACCESS_KEY}" ]; then
        export ACCESS_KEY="your-account-access-key";
fi
