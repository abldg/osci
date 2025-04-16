#!/usr/bin/env bash
## coding=utf-8
##==================================----------==================================
## FILE: 00_dinst.sh
## MYPG: abldg, https://github.com/abldg
## LSCT: 2025-04-12 13:09:13
## VERS: 0.1
##==================================----------==================================

dfn_nvim() {
  trydl_nvim() {
    ##arg1: owner/repo,     like mvdan/sh
    ##arg2: version_string, like 1.7.7
    ##arg3: filename-ends,  like linux-x64.tgz
    local xbf=$(command -v nvim)
    [ X != X${xbf} ] && [ X1 = X${SHV_EXIST_SK:-1} ] && {
      (printf "ln -sf ${xbf} /usr/bin/%s\n" vim vi | sudo bash -x)
      return
    }
    set -- ${1//,/ }
    local dltgz="${MYCACHE}/linux-x64-nvim-${2}.tgz"
    mt_tipstep $dltgz
    [ ! -e ${dltgz} ] && {
      set -- $(mt_fetch_ghdlurls $1 $2) $3
      [ -s $1 ] && mt_wrapdlder -#SL4o $dltgz $(awk '/'$2'$/' $1)
      rm -f $1 2>/dev/null
    }
    [ -s ${dltgz} ] && (
      ${XTAR} -C /usr -xf ${dltgz}
      (printf "ln -sf /usr/bin/nvim /usr/bin/%s\n" vim vi | sudo bash -x)
    )
  }
  ##----------------------------------------------------------------------------
  mt_tipstep
  set -- $HOME/.config $(mt_thzshflocation)
  [ $# -eq 2 ] && [ -e $2 ] && {
    mkdir -p ${1} 2>/dev/null
    set -- ${1}/nvim ${2%/*}
    [ -d $2 ] && {
      rm -rf ${1} 2>/dev/null
      mkdir -p $1
      cd $2 && cp -rf autoload ldg t init.vim $1/ 2>/dev/null
    }
    ##mgr-by-git
    [ -d $1 ] && (
      cd $1 && git init && git add . -f && git commit -m 'reinit'
    ) &>/dev/null
  }
  trydl_nvim neovim/neovim-releases,0.10.3,linux64.tar.gz
}

###~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
