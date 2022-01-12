#!/bin/bash
# Initialization script to do a manual install of the minimum development tools.
#

set -e

#
# Help message
help() {
  echo "$0 <options>"
  echo "    -h | --help    Prints this help message"
  echo "    --ansible      Installs Ansible"
}

#
# Find the Linux distribution
init() {
  egrep '^NAME' /etc/os-release | cut -d '=' -f2
}

#
# Installs Ansible on Ubuntu system
ubuntu_ansible() {
  apt install software-properties-common
  add-apt-repository --yes --update ppa:ansible/ansible
  apt install -y ansible
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
  --ansible|--vagrant)
    __linux=$(init | tr -d '"')
    __software=`echo $1 | cut -d '-' -f3`" ${__software}"
    ;;

  *)
    echo "Error: Invalid argument $1"
    help
    exit 2
    ;;
  esac
  shift
done

for item in ${__software}; do
  case "$item" in
  ansible)
    if [ "${__linux}" == "Ubuntu" ]; then
      ubuntu_ansible
    fi
    ;;

  esac
done