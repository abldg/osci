#!/usr/bin/env bash
## coding=utf-8
##==================================----------==================================
## FILE: 00_dinst.sh
## MYPG: abldg, https://github.com/abldg
## LSCT: 2025-04-12 13:02:07
## VERS: 0.3
##==================================----------==================================

# xf_upt_vsjson() {
#   set -- $HOME/.vscode-server/data/Machine
#   mkdir -p ${1} 2>/dev/null
#   install -m 644 ${SHV_TPLS_DIR}/*_vsccfg $1/settings.json
# }

dfn_myinit() {
  ##----------------------------------------------------------------------------
  xf_insteadof() {
    # git config --global url."<NEWURL>".insteadOf "<ORIGURL>"
    set -- ${1//,/ } 2>/dev/null
    git config --global url."${3:-$2}".insteadof "$1"
  }
  ##----------------------------------------------------------------------------
  xf_upt_gitcfg() {
    git config --global user.name "${SHV_UNAME:-abldg}"
    git config --global user.email "${SHV_EMAIL:-abodu@qq.com}"
    ###
    ##local-gitlab-server
    set -- ${SHV_LOCGITLAB:-192.168.166.7}
    xf_insteadof http://$1/,git@$1:
    ##gitee
    set -- gitee.com
    xf_insteadof https://$1/,git@$1:
    ##github-1
    set -- github.com
    xf_insteadof https://$1/,git@$1: #,https://ghfast.top/https://$1/
  }
  ##----------------------------------------------------------------------------
  mt_tipstep
  set -- $HOME/.myinit $(mt_thzshflocation)
  [ $# -eq 2 ] && [ -e $2 ] && {
    [ -d $1 ] && rm -rf $1
    mkdir -p $1 2>/dev/null
    ##copy-files
    (cd ${2%/*} && cp -rf 01_plg 02_tpl $1/ && date >$1/.reinit) 2>/dev/null
    ##mgr-by-git
    (cd $1 && git init && git add . -f && git commit -m 'reinit') &>/dev/null
    ##update-cfg
    (
      cd $HOME
      install -m 644 $1/02_tpl/*_bashrc .bashrc
      install -m 644 $1/02_tpl/*_edtcfg .editorconfig
      install -m 644 $1/02_tpl/*_gitcfg .gitconfig
      xf_upt_gitcfg
    )
  }
}
