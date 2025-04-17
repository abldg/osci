#!/usr/bin/env bash
## coding=utf-8
##==================================----------==================================
## FILE: 00_dinst.sh
## MYPG: abldg, https://github.com/abldg
## LSCT: 2025-04-12 14:18:52
## VERS: 0.1
##==================================----------==================================
###~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
_get_msdlurl() {
  set -- https://packages.microsoft.com/repos/$1 /tmp/tmp_msdebs.$(date +%N) $2
  command curl -4fsSL $1 | awk -F'"' '/<a href="/{print $2}' | tac >$2
  [ ! -s $2 ] && rm -f $2 && exit 0
  awk -vb=$1 -va=${3:-1} 'NR==a{printf("%s/%s",b,$0)}' $2 && rm -f $2
}
###~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
dfn_inst_msedge() {
  set -- microsoft-edge-stable
  set -- $1 /usr/bin/$1 $(command -v dpkg)
  [ -x $2 ] && {
    [ X1 = X${SHV_SKPEXIST:-1} ] && return
  }
  [ X = X$3 ] && return
  set -- ${MYCACHE}/linux-x64-msedge-latest.deb edge/pool/main/m/$1
  ##
  [ ! -e $1 ] && {
    mt_tipstep $1
    command curl -#4LSo $1 $(_get_msdlurl $2 3)
  }
  [ -e $1 ] && sudo dpkg -i $1
}
##test
# MYCACHE=$HOME/.cache/myiok xf_inst_msedge
###~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
dfn_inst_vscode() {
  if [ X1 = X${SHV_SNAP_INST:-1} ]; then
    set -- /snap/bin/code $(command -v snap) 2>/dev/null
    if [ X != X$2 ]; then
      [ ! -e $1 ] && {
        mt_tipstep $1
        sudo snap install code --classic #&>/dev/null
      }
      dfn_cfgs4vsc
      return
    fi
  fi
  set -- /usr/bin/code $(command -v dpkg) 2>/dev/null
  [ -x $1 ] && {
    [ X1 = X${SHV_SKPEXIST:-1} ] && return
  }
  [ X != X$2 ] && {
    set -- ${MYCACHE}/linux-x64-vscde-latest.deb
    set -- $1 vscode/pool/main/c/code
    [ ! -e $1 ] && {
      mt_tipstep $1
      command curl -#4LSo $1 $(_get_msdlurl $2 1)
    }
    [ -e $1 ] && sudo dpkg -i $1
  }
  dfn_cfgs4vsc
}
##test
# MYCACHE=$HOME/.cache/myiok dfn_inst_vscode
###~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
dfn_cfgs4vsc() {
  xf_instexts() {
    local exts= x=
    exts+=(
      geeebe.duplicate
      # johnpapa.winteriscoming
      editorconfig.editorconfig
      foxundermoon.shell-format
      # suryashanm.winter-pearl-theme
    )
    exts+=(
      # ms-vscode.hexeditor
      # ms-vscode.makefile-tools
      kennylong.kubernetes-yaml-formatter
    )
    ##
    rm -rf $1 2>/dev/null
    mkdir -p $1 #2>/dev/null
    cd $1 && for x in ${exts[@]}; do
      [ -d ${x}* ] || code --install-extension ${x}
    done
  }
  ##~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  xf_uptconfs() {
    set -- $1 $(mt_thzshflocation)
    [ $# -eq 2 ] && [ -e $2 ] && (
      local ddst=${1} dsrc=${2%/*}
      set -- settings.json keybindings.json
      mkdir -p $ddst 2>/dev/null
      cd ${dsrc} && cp -f $@ ${ddst}/
    )
  }
  ##~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  [ X1 = X$CBYCFGS ] && return
  local rmtver=
  set -- $(command -v code)
  case $1 in
  "") CBYCFGS=1 dfn_inst_vscode ;;
  */remote-cli/code) rmtver=1 ;;
  esac
  ##
  set -- $HOME/.vscode extensions
  if [ X1 = X${rmtver} ]; then
    set -- ${1}-server/$2 ${1}-server/data/Machine
  else
    set -- $1/$2 $HOME/.config/Code/User
  fi
  ##
  xf_uptconfs $2
  ##
  xf_instexts $1
}
