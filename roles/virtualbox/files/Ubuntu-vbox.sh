#!/bin/bash

wget -q https://www.virtualbox.org/download/oracle_vbox_2016.asc -O- | sudo apt-key add -
sudo apt-add-repository "deb [arch=amd64] https://download.virtualbox.org/virtualbox/debian $(lsb_release -cs) contrib"

# Not doing the install because Ansible will take care of it via 'package'
#sudo apt-get update -y && sudo apt-get install -y virtualbox