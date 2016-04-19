#!/bin/bash

sed -i "0,/APP_KEY_NOT_SET/s//${1}/" /mixapp-angular/client/js/adrum.js
sed -i "s,col.eum-appdynamics.com,${2},g" /mixapp-angular/client/js/adrum.js
if [ -z "$3" ]
  then
    echo "No adrum extension argument supplied, usging default"
  else
  	sed -i "s:cdn.appdynamics.com:${3}:g" /mixapp-angular/client/js/adrum.js
fi
