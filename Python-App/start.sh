#!/bin/bash

# This is a script to start the Python demo app
cd /appd/Python-App && nohup env/bin/pyagent run -c appdynamics.cfg - env/bin/gunicorn -w 4 -b 0.0.0.0:9000 demo.app:app &