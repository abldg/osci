#!/usr/bin/env bash
## coding=utf-8
##==================================----------==================================
## FILE: a1-libs.sh
## MYPG: abldg, https://github.com/abldg
## LSCT: 2025-04-17 00:22:28
## VERS: 1.5
##==================================----------==================================
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
    GPROMPTS+=(
      [cn_try_inst_pkg]="${PFX4SUB}尝试安装: [${CBLU}$1${CYLW}]"
      [en_try_inst_pkg]="${PFX4SUB}attempted to install: [${CBLU}$1${CYLW}]"
      [cn_pkg_instdone]="${PFX4SUB}已安装过: [${CGRN}$1${CYAN}]"
      [en_pkg_instdone]="${PFX4SUB}done installed: [${CGRN}$1${CYAN}]"
    )
    local vs=$(command -v ${2:-${1}} 2>/dev/null)
    if [ ${#vs} -eq 0 ]; then
      _yellow try_inst_pkg
      sudo ${PCMDIST} $1
      vs=$(command -v ${2:-${1}} 2>/dev/null)
    fi
    [ ${#vs} -ge 1 ] && _cyan pkg_instdone
  } #2>/dev/null
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
{
  ## [TIPBSE] ##
  xf_tiprint() {
    case ${CLR} in
    [rR] | red) printf "${CRED}" && red_exit=1 ;;
    [bB] | blue) printf "${CBLU}" ;;
    [cC] | cyan) printf "${CYAN}" ;;
    [gG] | green) printf "${CGRN}" ;;
    [pP] | purple) printf "${CPLP}" ;;
    [yY] | yellow) printf "${CYLW}" ;;
    esac
    ##
    if [[ "X${*//[a-z0-9_]/}" = "X" ]]; then
      local bk=$1
      set -- "${GPROMPTS[${SHV_THIZLANG:-cn}_$bk]}"
      [ ${#1} -ge 1 ] && printf "${1}" || printf "${bk}"
    else
      printf "${*}"
    fi
    printf "${CEND}"
    ##
    [ X${SW_NEWLINE:-1} = X1 ] && echo
    [ X1 = X${red_exit} ] && [[ X${0}Z != X*bashZ ]] && exit 1
  }
  ## [COLORS] ##
  mcary=(RED:"31;1" GRN:32 YLW:33 BLU:34 PLP:35 YAN:36 END:0)
  for x in ${mcary[@]}; do
    p=(${x//:/ }) && eval "export C${p[0]}='\e[${p[1]}m'"
  done
  for x in red blue cyan green purple yellow; do
    eval "_${x}(){ { CLR=${x} xf_tiprint \$@; } 2>/dev/null; }"
    # eval "_${x}(){ CLR=${x} xf_tiprint \$@; }"
  done
  unset -v x p mcary
  ##
  export PFX4SUB='@----> '
  declare -gA GPROMPTS=()
} 2>/dev/null
##TESTS##
# _green "just_a_test_message_for_invalid_keyword2"
# _red "just_a_test_message_for_invalid_keyword1"
# _blue "just_a_test_message_for_invalid_keyword2"

##~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
