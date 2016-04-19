#!/bin/bash

if [ $# -eq 0 ]; then 
	echo "Building with pre version agent"
	sed -i "s:INSTALL_APPD:/appd/Python-App/env/bin/pip install --pre appdynamics:" /appd/startup.sh
else
	# Check if python whl file follows Whell Binary Package Format
	VERSION=$(echo /appd/Python-App/appdynamics-python-agent/appdynamics_bindeps* | cut -d '-' -f 5)
	if [ ! -f /appd/Python-App/appdynamics-python-agent/appdynamics-*-py2-none-any.whl ]; then
		echo "Renaming agent..."
		mv /appd/Python-App/appdynamics-python-agent/appdynamics-*.whl /appd/Python-App/appdynamics-python-agent/appdynamics-${VERSION}-py2-none-any.whl 
	fi
	echo "Building with agent version: ${VERSION}"
	sed -i "s:INSTALL_APPD:/appd/Python-App/env/bin/pip install appdynamics-proxysupport-linux-x64\\
	/appd/Python-App/env/bin/pip install /appd/Python-App/appdynamics-python-agent/appdynamics_bindeps*-cp27*.whl\\
	/appd/Python-App/env/bin/pip install /appd/Python-App/appdynamics-python-agent/appdynamics-*.whl:" /appd/startup.sh
fi