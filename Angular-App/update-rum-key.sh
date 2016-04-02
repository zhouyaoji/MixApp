#!/bin/bash

sed -i "s/APP_KEY_NOT_SET/${1}/g" /mixapp-angular/client/js/adrum.js
sed -i "s/col.eum-appdynamics.com/${2}/g" /mixapp-angular/client/js/adrum.js