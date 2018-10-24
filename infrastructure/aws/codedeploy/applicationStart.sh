#!/bin/bash
echo "#CSYE6225: start application pwd and change directory to nodeapp-express"
pwd
cd /var/webapp/webapp/nodeapp-express
echo "PWD AND FILES"
pwd
pm2 stop app
ls -lrt
pm2 start app.js
