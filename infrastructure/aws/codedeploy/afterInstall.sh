#!/bin/bash

# update the permission and ownership of nodeapp in the var directory

echo "#CSYE6225: doing after install"
cd /var
pwd
ls -lrt
echo "#CSYE6225: doing after install: remove webapp if already exist"
sudo rm -rf webapp
ls -lrt
echo "#CSYE6225: doing after install: unzip nodeapp"
sudo unzip csye6225-fall2018.zip
echo "#CSYE6225: doing after install: remove zip from webapp folder"
sudo rm -rf csye6225-fall2018.zip
echo "#CSYE6225: doing after install: end"
pwd
ls -lrt
sudo cp .env webapp/nodeapp-express
cd webapp/nodeapp-express
sudo chmod 666 .env
pwd
ls -lrt
cd ../..
pwd
ls -lrt
