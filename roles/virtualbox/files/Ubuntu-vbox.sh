#!/bin/bash

apt search --names-only "^virtualbox$"
if [ $? -ne 0 ]; then
  wget -q https://www.virtualbox.org/download/oracle_vbox_2016.asc -O- | sudo apt-key add -
  sudo apt-add-repository "deb [arch=amd64] https://download.virtualbox.org/virtualbox/debian $(lsb_release -cs) contrib"
fi

# Not doing the install because Ansible will take care of it via 'package'
#sudo apt-get update -y && sudo apt-get install -y virtualbox