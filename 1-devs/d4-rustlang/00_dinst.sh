#!/usr/bin/env bash
## coding=utf-8
##==================================----------==================================
## FILE: 00_dinst.sh
## MYPG: abldg, https://github.com/abldg
## LSCT: 2025-04-12 22:04:58
## VERS: 0.1
##==================================----------==================================

dfn_devel_rustlang() {
  xf_upt_rs_cfgs() {
    set -- config.toml $(mt_thzshflocation)
    ##config.toml
    cd ${2%/*} && [ -e $1 ] && {
      set -- $1 $CARGO_HOME/$1
      sed "s@RV_RSCN@${RUSTUP_DIST_SERVER}@g" $1 >$2
    }
    ##completions
    set -- /etc/bash_completion.d $CARGO_HOME/bin/rustup /tmp/bc.cg /tmp/bc.rs
    [ -x $2 ] && {
      $2 completions bash cargo >$3
      $2 completions bash rustup >$4
      ${SP}install -m644 $3 $1/cargo
      ${SP}install -m644 $4 $1/rustup
    }
  }
  ##~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  xf_tryinst_cargo() {
    set -- $CARGO_HOME $RUSTUP_HOME
    if [ -d $1 -a -d $2 ]; then
      [ X1 = X${SHV_EXIST_SK:-1} ] && return
    fi
    ##
    mkdir -p $1 $2
    $rs_inster --no-modify-path -y
  }
  ##~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  local rs_inster="${MYCACHE}/rustup-init"
  local rs_dldurl="https://mirrors.tuna.tsinghua.edu.cn/"
  rs_dldurl+="rustup/rustup/dist/x86_64-unknown-linux-gnu/rustup-init"
  set -- $rs_inster
  [ ! -e $1 ] && mt_wrapdlder -#fSL4o $1 ${rs_dldurl} && chmod a+x $1
  ##regen-envfile
  ##~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  set -- $HOME
  set -- https://rsproxy.cn ${1}/.cargo ${1}/.rustup $1/.config/mydev_rustlang
  {
    printf 'export PATH="%s/bin:$PATH"\n' $2
    printf 'export CARGO_HOME="%s"\n' $2
    printf 'export RUSTUP_HOME="%s"\n' $3
    printf 'export RUSTUP_DIST_SERVER="%s"\n' $1
    printf 'export RUSTUP_UPDATE_ROOT="%s/rustup"\n' $1
  } >$4 && { sync && . ${4}; } 2>/dev/null
  xf_tryinst_cargo
  ##completions-and-config.toml
  hash -r && xf_upt_rs_cfgs
}
###~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
