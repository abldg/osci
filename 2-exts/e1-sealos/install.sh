#!/usr/bin/env bash
## coding=utf-8
##==================================----------==================================
## FILE: install.sh
## MYPG: abldg, https://github.com/abldg
## LSCT: 2025-04-12 09:42:28
## VERS: 1.2
##==================================----------==================================
# set -x
ds_create_vm() {
  ##
  set -- $(echo $HOME/*wksp/devstack 2>/dev/null)
  [ ! -d $1 ] && return 1
  cd $1
  ##
  set -- demo
  { . openrc $1 $1; } 2>/dev/null
  ##
  set -- id_rsa_demo
  [ ! -e $1 ] && {
    openstack keypair create demo >$1
    chmod 600 $1
  }
  ##
  set -- demo ubuntu ${VMNAME}
  local ceopts=
  ceopts=(
    openstack
    server create
    --nic net-id=$(openstack network show private -c id -f value)
    --flavor $(openstack flavor show m1.nano -c id -f value)
    --image $(openstack image show $2 -c ID -f value)
    --key-name ${1} ${3:-test1}
  ) 2>/dev/null
  ${ceopts[@]}
}
[ X1 != X${SHV_CALLBYMK} ] && ds_create_vm
