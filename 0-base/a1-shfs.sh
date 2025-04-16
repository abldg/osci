#!/usr/bin/env bash
## coding=utf-8
##==================================----------==================================
## FILE: a1-shfs.sh
## MYPG: abldg, https://github.com/abldg
## LSCT: 2025-04-17 00:11:48
## VERS: 1.4
##==================================----------==================================

##COLORS
{
  export CRED='\e[31;1m' CGRN='\e[32;1m' CYLW='\e[33;1m'
  export CBLU='\e[34;1m' CYAN='\e[35;1m' CEND='\e[0m'
  for x in cyan cblu cgrn cylw; do
    eval _$x'(){ { printf "${'${x^^}'}${@}${CEND}\n"; } 2>/dev/null; }'
  done && unset -v x
  _cred() { { printf "${CRED}${@}${CEND}\n" && exit 1; } 2>/dev/null; }
  # ##RESET_PSWD
  # [ "${#SHV_RESET_PW}" -ge 1 ] && {
  #   echo "root:${SHV_RESET_PW}" | chgpasswd --
  # } #2>/dev/null
} 2>/dev/null

###~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
mt_tipstep() {
  {
    [ X0 = X${SHV_DEBUGTHZ:-0} ] && return
    # [ X1 != X${SHV_CALLBYMK} ] && exit 1
    local ci=($(caller 0))
    local msg="[${CBLU}${ci[2]}$CEND,${CGRN}${ci[1]}$CEND,${CYLW}${ci[0]}$CEND]"
    printf "====>${msg}${1:+ [${CYAN}$1${CEND}]}<====\n"
  } 2>/dev/null
}

###~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
mt_chkpkgcmd() {
  set -- apt dnf yum
  local x=
  for x in $@; do
    if [ X != X$(command -v $x) ]; then
      export PCMDRMV="${x} remove -y"
      export PCMDUPT="${x} update -y"
      export PCMDIST="${x} install -y"
      return
    fi
  done
}

###~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
mt_ispkgexist() {
  ##arg1: pkgname[,binfilename]
  {
    set -- ${1//,/ }
    if ! command -v ${2:-${1}} &>/dev/null; then
      _cylw " ----> attempted to install: [$1]"
      sudo ${PCMDIST} $1
    fi
    _cyan " ----> done installed: [$1]"
  } 2>/dev/null
}

###~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
mt_wrapdlder() {
  local args= url= vpp="${GHPROXY:-https://ghfast.top}"
  while [ $# -ge 1 ]; do
    if [[ "$1" != @(http|https)://* ]]; then
      args+=($1)
    else
      if [ X1 != X$(echo $1 | awk '/github/&&/\.com/{printf 1}') ]; then
        url=${1}
      else
        url=${vpp%/}/$1
      fi 2>/dev/null
    fi
    shift
  done
  ##
  if [ ${#url} -ne 0 ]; then
    [ ! -x /usr/bin/curl ] && ${PCMDIST} curl
    eval "/usr/bin/curl -L $url ${args[@]}"
  fi
}

###~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
mt_fetch_ghdlurls() {
  ##arg1: owner/repo,     like mvdan/sh
  ##arg2: version_string, like 1.7.7
  {
    local pt='.[]|.assets|.[]|.browser_download_url'
    local ga="https://api.github.com/repos/${1}/releases"
    set -- $2 "ghdlurl_$(date +%N)_${1%/*}.tmp"
    command curl -fsSL4 $ga | jq "$pt" |
      grep $1 | xargs -n1 >$2 && echo $2
  } 2>/dev/null
}
##test
# mt_fetch_ghdlurls neovim/neovim-releases 0.11.0

###~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
mt_thzshflocation() {
  {
    local wf=${FUNCNAME[1]}
    [ $# -ge 1 ] && wf=$1
    shopt -s extdebug
    set -- $(declare -F ${wf})
    shopt -u extdebug
    echo $3
  } 2>/dev/null
}

###~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
