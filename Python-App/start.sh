#!/bin/bash

# Setup virtualenv
/usr/local/bin/virtualenv /appd/Python-App/env
source /appd/Python-App/env/bin/activate
/appd/Python-App/env/bin/pip install -U appdynamics==version
/appd/Python-App/env/bin/pip install -r /appd/Python-App/requirements.txt

# This is a script to start the Python demo app
cd /appd/Python-App && nohup env/bin/pyagent run -c appdynamics.cfg - env/bin/gunicorn -w 4 -b 0.0.0.0:9000 demo.app:app &