#!/bin/bash

set -e
__directory="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

#
# Help message
help() {
  echo "$0 --configuration <cfg> [--hosts <hosts.yml>] [-v|--check] [--user "full name"] [--email <email>]"
  echo "    -h | --help  Prints this help message"
  echo "    --hosts      Full path to host file"
  echo "    -v           Verbose"
  echo "    --check      Perform in check mode"
  echo "    --user       User full name enclosed by double quotes (default ${USER})"
  echo "    --email      User email addressed (default ${USER}@email.com)"
  echo "    Configuration Options"
  echo "        common        Base configurations"
  echo "        vbox-vagrant  Virtualbox and Vagrant configurations"
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
__username=${USER}
__useremail="${USER}@email.com"

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

  --user)
    shift
    __username="${1}"
    ;;

  --email)
    shift
    __useremail="${1}"
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
echo "Username: ${__username}"
echo "Email: ${__useremail}"
read -p "Hit ENTER to continue or CTRL-C to exit"

source ${__directory}/ansible.env
ansible-playbook -i ${__hosts} \
  --user ${USER} \
  --extra-vars "user_name=${__username} user_email=${__useremail}" \
  -k -K ${__playbook} ${__args}
