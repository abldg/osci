#!/usr/bin/env bash
## coding=utf-8
##==================================----------==================================
## FILE: m00-mylibs.sh
## MYPG: abldg, https://github.com/abldg
## LSCT: 2025-04-18 08:57:31
## VERS: 0.3
##==================================----------==================================

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
mt_load_envs() {
  {
    ##
    # xf_assign() {
    local p= x=
    for x in ${SLC_GLBVARS[@]}; do
      set -- ${x//,/ }
      if [ $# -eq 1 ]; then
        eval "export $1="
        # printf '%s=\n' $1
      else
        eval "export $1=\"$2\"" #${!$1}
        # printf '%s=${%s:-"%s"}\n' $1 $1 $2
      fi
    done
    # }
    ##
    # set -- $1 $(mt_locate_thzfunc)
    # [ $# -eq 2 ] && [ $1 -ot $2 ] && rm -f $1
    # [ -e $1 ] || xf_assign >$1
    # [ -e $1 ] && . $1
  } 2>/dev/null
}
###~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
mt_setlang() {
  ZLG=en
  mt_getprompt "choose_language"
  printf "  en. English\n  zh. 中文\n"
  SW_NEWLINE=0 mt_getprompt "enter_choice"
  read -p "" lang_choice
  [[ ${lang_choice}X != @(en|EN|e|E)X ]] && ZLG="cn"
  ##
  # if [ ${#1} -eq 0 ]; then
  #   set -- zxxxxx_loc_env.sh
  # else
  #   sed -i '/^ZLG/d' $1
  # fi
  # echo 'ZLG=${ZLG:-'"$ZLG"'}' >>$1
  export ZLG
}
###~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
mt_getprompt() {
  local cc= bk="${*}" zl="${ZLG:-cn}"
  case ${CLR} in
  cred | CRED | [rR] | red) cc="${CRED}" && red_exit=1 ;;
  cblu | CBLU | [bB] | blue) cc="${CBLU}" ;;
  cyan | CYAN | [cC] | cyan) cc="${CYAN}" ;;
  cgrn | CGRN | [gG] | green) cc="${CGRN}" ;;
  cplp | CPLP | [pP] | purple) cc="${CPLP}" ;;
  cylw | CYLW | [yY] | yellow) cc="${CYLW}" ;;
  *) cc="${CEND}" ;;
  esac
  ##
  {
    if [[ "X${bk//[a-z0-9_]/}" = "X" ]]; then
      [[ ${bk}X == @(cn|en|jp|fr|ru|de)_*X ]] && bk="${bk#*_}"
      set -- "${SLC_PROMPTS[${zl}_${bk}]}"
      [ ${#1} -ge 1 ] && bk="${*}"
    fi
    printf -- "${cc}${bk}${CEND}" | sed -r 's@^\s+#TDL#@@g'
    ##
    [ X${SW_NEWLINE:-1} = X1 ] && printf "\n"
  } 2>/dev/null
}
###~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
{
  ###
  declare -gA SLC_PROMPTS=()
  declare -gA SLC_GLBVARS=()
  ###
  [ X0 = X$(id -u) ] && SP= || SP='sudo '
  TEE="${SP}tee" SED="${SP}sed"
  XTAR="${SP}tar --no-same-owner"
  GHPROXY=https://ghfast.top
  ## [COLORS] ##~dddd~~
  mcary=(RED:"31;1" GRN:32 YLW:33 BLU:34 PLP:35 YAN:36 END:0)
  for x in ${mcary[@]}; do
    p=(${x//:/ }) && eval "export C${p[0]}='\e[${p[1]}m'"
  done
  for x in red blue cyan green purple yellow; do
    if [ X1 = X${SHV_DEBUGTHZ:-0} ]; then
      eval "_${x}(){ CLR=${x} xf_tiprint \$@; }"
    else
      eval "_${x}(){ { CLR=${x} xf_tiprint \$@; } 2>/dev/null; }"
    fi
  done
  unset -v x p mcary
  ###
} 2>/dev/null
###~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
