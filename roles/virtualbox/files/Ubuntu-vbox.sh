#!/bin/bash

__results=$(apt-cache search --names-only "^virtualbox$")
if [ -z "${__results}" ]; then
  wget -q https://www.virtualbox.org/download/oracle_vbox_2016.asc -O- | sudo apt-key add -
  sudo apt-add-repository "deb [arch=amd64] https://download.virtualbox.org/virtualbox/debian $(lsb_release -cs) contrib"
else
  echo "Virtualbox found in existing repository"
fi

# Not doing the install because Ansible will take care of it via 'package'
#sudo apt-get update -y && sudo apt-get install -y virtualbox