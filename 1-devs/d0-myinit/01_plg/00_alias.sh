#!/usr/bin/env bash
# coding=utf-8
#========================================================================
# COPYSTR: Copyright (c) 2024 By LanjianJunxin, All Rights Reserved.
# FLENAME: 00_alias.sh
# CONTACT: developer@ljjx.com
# CREATED: 2024-10-12 06:31:00
# LTSVERN: 0.1
# LTSUPDT: 2024-12-12 01:01:15
#========================================================================
_dodef() {
  # [ X != X$(command -v tsize.sh) ] && tsize.sh &>/dev/null
  [ X != X$(command -v shfmt) ] && alias ffs='shfmt -s -ln bash -i 2 -w'
  [ X != X$(command -v bat) ] && alias cat='bat -pp'
  #-----------------------------------------------------------------------------
  alias sc='screen -S'
  alias scl='screen -ls'
  # alias scd='screen -d'
  alias scr='screen -r'
  alias scw='screen -wipe'
  alias scd='screen -dmLS'
  #---
  alias td='tree --dirsfirst'
  alias td1='tree --dirsfirst -L 1'
  #---
  alias ffc='clang-format -i --style=file'
  #---
  alias pn='pnpm'
  alias pni='pnpm install -D'
  alias pnb='pnpm build'
  alias pnr='pnpm remove'
  #---
  alias yadd='yarn add -D'
  alias ydel='yarn remove'
  alias ygadd='yarn global add'
  alias ygdel='yarn global remove'
  #---
  alias cgb='cargo build'
  alias cgc='cargo check'
  alias cgn='cargo new'
  alias cgr='cargo run'
  #-----------------------------
  alias .l='ls -l'
  alias l.='ls -d .*'
  alias la='ls -la'
  alias lh='ls -lh'
  alias ll='ls -l'
  alias lt='ls -lrt'
  alias lld.='ls -l -d .*'
  alias sa='dha'
  ##ip route----------------------------------
  alias ipr='ip -4 route show'
  alias ipra='ip -4 route add'
  alias iprd='ip -4 route del'
  alias iprr='ip -4 route replace'
  ##systemctl---------------------------------
  alias stl.bgn='systemctl start'
  alias stl.rld='systemctl daemon-reload'
  alias stl.sts='systemctl status'
  alias stl.hlt='systemctl stop'
  alias stl.rst='systemctl restart'
  #-------------------------------------------
  if [ -x /usr/bin/dircolors ]; then
    local xxx="$HOME/.dircolors"
    [ -r $xxx ] || xxx=
    dircolors -b $xxx &>/dev/null
    alias ls='ls --color=auto'
    alias dir='dir --color=auto'
    alias vdir='vdir --color=auto'
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
  fi
  #-------------------------------------------
  alias .a='cd ${MYINITDIR:-$HOME/.myinit}'
  alias .b='cd -'
  alias .1='cd ../'
  alias .2='cd ../..'
  alias .3='cd ../../..'
  alias ..='cd ../'
  alias ...='cd ../..'
  #-------------------------------------------
  alias rld='source ~/.bashrc'
  alias c='clear'
  alias p='pwd'
  alias q='exit'
  alias tf='tail -f'
  alias sfa='alias'
  alias noc='command grep -Ev "^($|#)"'
  alias chg2cn='export LANG=zh_CN.UTF-8 LC_ALL=zh_CN.UTF-8'
  alias chg2en='export LANG=en_US.UTF-8 LC_ALL=en_US.UTF-8'
  alias chg2root='su - root'
  alias crr='complete -r'
  alias srm='sudo rm -rf'
  alias npa='[ X != X$(command -v netplan) ] && netplan apply'
}
_dodef && unset -f _dodef
###EXTRA###@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#export FORCE_UNSAFE_CONFIGURE=1
# Alias definitions.
# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
  dircolors -b &>/dev/null
  alias ls='ls --color=auto'
  alias grep='grep --color=auto'
  alias fgrep='fgrep --color=auto'
  alias egrep='egrep --color=auto'
fi

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
