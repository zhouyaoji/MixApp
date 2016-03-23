#!/bin/bash

# This is a startup script for the Python Demo app

# Set EC2 Region variable
source /appd/env.sh && sed -i "/^host/c\host = ${CONTROLLER}" /appd/Python-App/appdynamics.cfg
source /appd/env.sh && sed -i "/^port/c\port = ${APPD_PORT}" /appd/Python-App/appdynamics.cfg
source /appd/env.sh && sed -i "/^ssl/c\ssl = ${SSL}" /appd/Python-App/appdynamics.cfg
source /appd/env.sh && sed -i "/^account/c\account = ${ACCOUNT_NAME}" /appd/Python-App/appdynamics.cfg
source /appd/env.sh && sed -i "/^accesskey/c\accesskey = ${ACCESS_KEY}" /appd/Python-App/appdynamics.cfg
source /appd/env.sh && sed -i "/^app/c\app = ${APP_NAME}" /appd/Python-App/appdynamics.cfg
source /appd/env.sh && sed -i "/^tier/c\tier = ${TIER_NAME}" /appd/Python-App/appdynamics.cfg
source /appd/env.sh && sed -i "/^node/c\node = ${APP_NAME}-${NODE_NAME}" /appd/Python-App/appdynamics.cfg
source /appd/env.sh && sed -i "s/version/${PY_AGENT_VERSION}/g" /appd/Python-App/start.sh
sed -i 's/localhost/python_mysql/g' /appd/Python-App/demo/config.py
sed -i 's/127.0.0.1/python_postgres/g' /appd/Python-App/demo/config.py

# Start services
source /appd/Python-App/start.sh
