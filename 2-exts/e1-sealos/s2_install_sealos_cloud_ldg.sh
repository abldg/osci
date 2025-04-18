#!/usr/bin/env bash
## coding=utf-8
##==================================----------==================================
## FILE: s2_install_sealos_cloud_ldg.sh
## MYPG: abldg, https://github.com/abldg
## LSCT: 2025-04-18 00:12:51
## VERS: 0.1
##==================================----------==================================
dfn_ubt_sealosx() {
  {
    shopt -s extdebug
    set -- $(declare -F ${FUNCNAME})
    shopt -u extdebug
    cd $(dirname $(realpath $3))
    local MYSHFILES=(
      $(command ls $PWD/m*-*.sh 2>/dev/null)
      /etc/os-release
    )
  } 2>/dev/null
  for x in ${MYSHFILES[@]}; do . $x; done 2>/dev/null
  # Configurations
  mt_load_envs
  mt_setlang

  # mt_getprompt usage
  xf_set_mongo_version() {
    set +e
    grep avx /proc/cpuinfo >/dev/null 2>&1
    if [ $? -ne 0 ]; then
      mt_getprompt "mongo_avx_requirement"
      mongodb_version="mongodb-4.4"
    fi
    set -e
  }
  xf_set_mongo_version
  env
}

# set -xe
dfn_ubt_sealosx
# set +x
