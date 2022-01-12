#!/bin/bash

__results=$(apt-cache search --names-only "^vagrant$")
if [ -z "${__results}" ]; then
  curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
  sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
else
  echo "Vagrant found in existing repository"
fi

# Not doing the install because Ansible will take care of it via 'package'
#sudo apt-get update -y && sudo apt-get install vagrant