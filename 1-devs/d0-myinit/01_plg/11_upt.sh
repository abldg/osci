#!/usr/bin/env bash
# coding=utf-8
#==============================================================================
# COPYSTR: Copyright (c) 2024 By LanjianJunxin, All Rights Reserved.
# FLENAME: 11_upt.sh
# CONTACT: developer@ljjx.com
# CREATED: 2024-12-12 00:17:35
# LTSVERN: 0.1
# LTSUPDT: 2024-12-12 00:19:21
#==============================================================================
sfu.tiny_path() {
  export PATH=$(echo "${MI_EXTRA_PATH} ${PATH//:/ }" | xargs -n1 |
    awk '!/games/' | awk '!a[$0]++' | xargs | sed 's, ,:,g')
}
#-------------------------------------------------------------------------------
sfu.clr_knownhosts() {
  >~/.ssh/known_hosts
  rm -f ~/.ssh/known_hosts.old 2>/dev/null
}
#-------------------------------------------------------------------------------
sfu.etcprofile() {
  local f=0
  [ $f -eq 0 ] && [ X1 = X$(pidof docker-init) ] && f=1
  [ $f -eq 0 ] && [ X0 != X$(env | awk '/^VSCODE_/' | wc -l) ] && f=1
  [ $f -eq 1 ] && { . /etc/profile; } >/dev/null
}
#-------------------------------------------------------------------------------
sfu.load_plnxenv() {
  local kf=$(ls -d /home/ldg/.swbase/plnx* 2>/dev/null)
  [ -e $kf/settings.sh ] && {
    . $kf/settings.sh $kf
  }
}
#-------------------------------------------------------------------------------
sfu.fix_maxwatchers() {
  sudo sed -i '/max_user_watches=/d' /etc/sysctl.conf
  echo fs.inotify.max_user_watches=524288 | sudo tee -a /etc/sysctl.conf
  sudo sysctl -p
}
#-------------------------------------------------------------------------------
tsize.sh() {
  local orgbak=$(stty -g)
  {
    stty cbreak -echo min 0 time 8
    printf '\033[18t' >/dev/tty
    IFS='[;t' read _ ch2 rn cn </dev/tty
  } &>/dev/null
  stty "$orgbak"
  if [ "$ch2" == "8" ]; then
    # local rn=${1-50} cn=${2-180}
    echo "[TIP] set terminal size: $rn x $cn"
    stty rows $rn cols $cn
  fi
}
#-------------------------------------------------------------------------------
sfu.drop_caches() {
  case $1 in
  1 | 2) echo $1 ;;
  *) echo 3 ;;
  esac | sudo tee /proc/sys/vm/drop_caches
}
#-------------------------------------------------------------------------------
sfu.chgtz_cst8() {
  timedatectl set-timezone Asia/Shanghai
}
#-------------------------------------------------------------------------------
