#!/bin/bash

__linuxversion=$(egrep '^VERSION_ID=' /etc/os-release | cut -d '=' -f2 | tr -d '"')
yum-config-manager --add-repo "https://yum.oracle.com/mirror/ol${__linuxversion}/x86_64/oraclelinux-developer-ol${__linuxversion}-x86_64.repo"
sed -i 's/gpgcheck=1/gpgcheck=0/g' /etc/yum.repos.d/oraclelinux-developer-ol${__linuxversion}-x86_64.repo
