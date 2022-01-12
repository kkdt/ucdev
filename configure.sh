#!/bin/bash

set -e
__directory="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

#
# Help message
help() {
  echo "$0 --configuration <cfg> [--hosts <hosts.yml>] [-v|--check]"
  echo "    -h | --help  Prints this help message"
  echo "    --hosts      Full path to host file"
  echo "    -v           Verbose"
  echo "    --check      Perform in check mode"
  echo "    Configuration Options"
  echo "        common   Base configurations"
}

if [ $# -eq 0 -o "$1" == "-h" -o "$1" == "--help" -o "$1" == "help" ]; then
  help
  exit 0
fi

if [ $UID -eq 0  ]; then
  echo "Please execute this script as yourself"
  exit 1
fi

# default host is localhost
__hosts=${__directory}/hosts/localhost.yml

while [ "$1" != "" ]; do
  case "$1" in
  --hosts)
    shift
    __hosts=${1}
    if [ ! -f "${__hosts}" ]; then
      echo "Please provide valid host inventory file"
      exit 3
    fi
    ;;

  --configuration)
    shift
    if [ -z "${1}" -o ! -f "${__directory}/playbooks/${1}.yml" ]; then
      echo "Please provide a valid configuration"
      exit 4
    fi
    __playbook="${__directory}/playbooks/${1}.yml"
    ;;

  -v|--check)
    __args="${1} ${__args}"
    ;;

  *)
    echo "Error: Invalid argument $1"
    help
    exit 2
    ;;
  esac
  shift
done

echo "All configurations will be applied using "
echo "playbook: ${__playbook}, hosts: ${__hosts}"
echo "Additional args: ${__args}"
read -p "Hit ENTER to continue or CTRL-C to exit"

source ${__directory}/ansible.env
ansible-playbook -i ${__hosts} \
  --user ${USER} \
  -k -K ${__playbook} ${__args}
