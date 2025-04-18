#!/usr/bin/env bash
## coding=utf-8
##==================================----------==================================
## FILE: s2_install_sealos_cloud_ldg.sh
## MYPG: abldg, https://github.com/abldg
## LSCT: 2025-04-18 00:12:51
## VERS: 0.1
##==================================----------==================================
{
  [ X0 = X$(id -u) ] && SP= || SP='sudo '
  TEE="${SP}tee" SED="${SP}sed"
  XTAR="${SP}tar --no-same-owner"
  GHPROXY=https://ghfast.top
  # MYCACHE=$HOME/.cache/${PWD##*/}
  # mkdir -p $MYCACHE
} 2>/dev/null

mt_locate_thzfunc() {
  {
    local wf=${FUNCNAME[1]}
    [ $# -ge 1 ] && wf=$1
    shopt -s extdebug
    set -- $(declare -F ${wf})
    shopt -u extdebug
    realpath $3
  } 2>/dev/null
}
mt_tipstep() {
  {
    [ X0 = X${SHV_DEBUGTHZ:-0} ] && return
    # [ X1 != X${SHV_CALLBYMK} ] && exit 1
    local ci=($(caller 0))
    local msg="[${CBLU}${ci[2]}$CEND,${CGRN}${ci[1]}$CEND,${CYLW}${ci[0]}$CEND]"
    printf "====>${msg}${1:+ [${CYAN}$1${CEND}]}<====\n"
  } 2>/dev/null
}
dfn_ubt_sealosx() {
  set -- $(mt_locate_thzfunc)
  cd ${1%/*}
  MYSHFILES=(
    $(command ls $PWD/a*-*.sh 2>/dev/null)
    /etc/os-release
  )
  for x in ${MYSHFILES[@]}; do . $x; done 2>/dev/null
  # Configurations
  echo ${ID}
  echo ${ID_LIKE}
  echo ${UBUNTU_CODENAME}
  echo ${victoria_metrics_k8s_stack_version}
  ZL=en mt_getprompt installing_cloud
}

# set -xe
dfn_ubt_sealosx
# set +x
