#!/usr/bin/env bash
## coding=utf-8
##==================================----------==================================
## FILE: 00_dinst.sh
## MYPG: abldg, https://github.com/abldg
## LSCT: 2025-04-12 13:02:43
## VERS: 0.2
##==================================----------==================================
dfn_sshkey() {
  mt_tipstep
  set -- $(mt_thzshflocation)
  [ $# -eq 1 ] || return
  (
    cd ${1%/*} &&
      tar -xf bak.skey.tgz -C $HOME/
    set -- $HOME/.ssh
    chmod 700 $1 && chmod 600 $1/id_* $1/authorized_keys
  )
}
