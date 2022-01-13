#!/bin/bash
# Initialization script to do a manual install of the minimum development tools.
#

set -e

#
# Help message
help() {
  echo "$0 <options>"
  echo "    -h | --help          Prints this help message"
  echo "    ansible              Installs Ansible"
  echo "    virtualbox-ext-pack  Installs virtualbox-ext-pack (virtualbox must be installed)"
}

#
# Find the Linux distribution
init() {
  egrep '^ID=' /etc/os-release | cut -d '=' -f2 | tr -d '"'
}

#
# Installs Ansible on an Ubuntu system
ubuntu_ansible() {
  __results=$(apt-cache search --names-only "^ansible$")
  if [ -z "${__results}" ]; then
    apt install software-properties-common
    add-apt-repository --yes --update ppa:ansible/ansible
  else
    echo "Ansible found in existing repository"
  fi
  apt install -y ansible
}

#
# Installs virtualbox-ext-pack on an Ubuntu system
ubuntu_virtualbox-ext-pack() {
  set +e
  vbox-img --version
  if [ $? -eq 0 ]; then
    set -e
    apt install -y virtualbox-ext-pack
  else
    set -e
    echo "Please install virtualbox"
  fi
}

#
# Installs Ansible on a CentOS system
centos_ansible() {
  set +e
  yum search ansible
  if [ $? -ne 0 ]; then
    set -e
    apt install software-properties-common
    add-apt-repository --yes --update ppa:ansible/ansible
  else
    set -e
    echo "Ansible found in existing repository"
  fi
  yum install -y ansible
}

#
# Main
#

if [ $# -eq 0 -o "$1" == "-h" -o "$1" == "--help" -o "$1" == "help" ]; then
  help
  exit 0
fi

if [ $UID -ne 0  ]; then
  echo "Please execute this script as root"
  exit 1
fi

while [ "$1" != "" ]; do
  case "$1" in
  ansible|virtualbox-ext-pack)
    __linux=$(egrep '^ID=' /etc/os-release | cut -d '=' -f2 | tr -d '"')
    __linuxversion=$(egrep '^VERSION_ID=' /etc/os-release | cut -d '=' -f2 | tr -d '"')
    __software="${1} ${__software}"
    ;;

  *)
    echo "Error: Invalid argument $1"
    help
    exit 2
    ;;
  esac
  shift
done

# centos-specific
if [ "${__linux}" == "centos" ]; then
  yum -y install epel-release
  if [ "${__linuxversion}" == "7" ]; then
    yum -y install "https://packages.endpoint.com/rhel/${__linuxversion}/os/x86_64/endpoint-repo-1.9-1.x86_64.rpm"
  elif [ "${__linuxversion}" == "6" ]; then
    yum -y install "https://packages.endpoint.com/rhel/${__linuxversion}/os/x86_64/endpoint-repo-1.6-2.x86_64.rpm "
  fi
fi

for item in ${__software}; do
  case "$item" in
  ansible)
    if [ "${__linux}" == "ubuntu" ]; then
      ubuntu_ansible
    elif [ "${__linux}" == "centos" ]; then
      centos_ansible
    fi
    ;;

  virtualbox-ext-pack)
    if [ "${__linux}" == "ubuntu" ]; then
      ubuntu_virtualbox-ext-pack
    fi
    ;;
  esac
done