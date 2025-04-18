#!/usr/bin/env bash
## coding=utf-8
##==================================----------==================================
## FILE: a1-dinst.sh
## MYPG: abldg, https://github.com/abldg
## LSCT: 2025-04-17 00:43:25
## VERS: 1.3
##==================================----------==================================
dfn_cfgs4incus() {
  {
    local tpl='
      #TDL### tips-about-incus-settings ##
      #TDL#[TIP]. incus-admini-init-for-run-as-cluster-mode
      #TDL#Would you like to use clustering? (yes/no) [default=no]: yes  <<---
      #TDL#What IP address or DNS name should be used to reach this server? [default=192.168.X.Y]:
      #TDL#Are you joining an existing cluster? (yes/no) [default=no]:
      #TDL#What member name should be used to identify this server in the cluster? [default=192-168-X-Y]:
      #TDL#Do you want to configure a new local storage pool? (yes/no) [default=yes]: no  <<---
      #TDL#Do you want to configure a new remote storage pool? (yes/no) [default=no]:
      #TDL#Would you like to use an existing bridge or host interface? (yes/no) [default=no]: yes  <<---
      #TDL#Name of the existing bridge or host interface: br0   <<---
      #TDL#Would you like stale cached images to be updated automatically? (yes/no) [default=yes]:
      #TDL#Would you like a YAML "init" preseed to be printed? (yes/no) [default=no]:
      #TDL#
      #TDL#[TIP]. create-zfs-pool-[disks:/dev/RV_LASTDISK]
      #TDL#incus storage create disks zfs source=/dev/RV_LASTDISK
      #TDL#incus profile device add default root disk path=/ pool=disks
      #TDL#
      #TDL#[TIP]. incus-add-certificate
      #TDL#incus config trust add-certificate RV_UICRT
      #TDL#
      #TDL#[TIP]. change the mirror of remote images: RV_RMTIMGURL
      #TDL#incus remote remove images
      #TDL#incus remote add images RV_RMTIMGURL --protocol=simplestreams --public
      #TDL#
      #TDL#[TIP]. update profile of default
      #TDL#incus profile set default limits.cpu 4
      #TDL#incus profile set default limits.memory 4GiB
      #TDL#incus profile set default security.nesting true
      #TDL#incus profile set default security.privileged true
      #TDL#
      #TDL#[TIP]. some-useful-commands-for-incus(--vm run-as-a-vm)
      #TDL#incus launch images:ubuntu/24.04    ud2404devct
      #TDL#incus launch images:openeuler/24.03 oe2403devct
      #TDL#'
    set -- https://mirrors.nju.edu.cn/lxc-images $(mt_thzshflocation)
    echo "$tpl" | sed -r -e "s@\s+#TDL#@@g" \
      -e "s@RV_RMTIMGURL@${1}@g;s@RV_UICRT@${2%/*}/incus-ui.crt@g" \
      -e "s@RV_LASTDISK@$(lsblk | awk '/^[nsv]/{print $1}' | tail -1)@g"
  } 2>/dev/null
}
###~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
dfn_ubt_incus() {
  ##
  mt_tipstep
  local oscode=${VERSION_CODENAME}
  if [[ $oscode != @(noble|jammy|focal|bullseye|bookworm) ]]; then
    _red "[FATAL] only support ubuntu20.04+ or debian 11/12"
  fi
  if [[ $(systemd-detect-virt) != @(none|kvm) ]]; then
    _red "[FATAL] incus need kvm-based-virt-server or a bare-metal-server"
  fi
  if [[ X0 != X$(id -u) ]]; then
    _red "[FATAL] only support root run this tools"
  fi
  ##
  set -- /usr/share/keyrings/zabbly.asc https://pkgs.zabbly.com/key.asc
  [ ! -e $1 ] && mt_wrapdlder -fsSLo $1 $2
  ##
  set -- $1 /etc/apt/sources.list.d/zabbly-incus.sources
  [ ! -e $2 ] && {
    local tpl='Types: deb
    #TDL#URIs: https://mirrors.ustc.edu.cn/incus/stable
    #TDL#Suites: '${oscode}'
    #TDL#Components: main
    #TDL#Signed-By: '$1'
    #TDL#'
    echo "$tpl" | sed -r 's@\s+#TDL#@@g' >$2
  } 2>/dev/null
  ##
  mt_ispkgexist zfsutils-linux,zfs
  mt_ispkgexist qemu-system,qemu-img
  # mt_ispkgexist ubuntu-drivers-common,ubuntu-drivers
  set -- incus incus-client incus-ui-canonical
  apt update -y && apt install -y $@ && systemctl enable incus --now
  ##
  dfn_cfgs4incus
  ##
  incus remote remove images
  set -- https://mirrors.nju.edu.cn/lxc-images/
  incus remote add images $1 --protocol=simplestreams --public
  ##
  set -- $(dirname $(mt_thzshflocation))/incus-ui.crt
  [ -e $1 ] && incus config trust add-certificate $1
  ##
  incus profile set default limits.cpu 4
  incus profile set default limits.memory 4GiB
  incus profile set default security.nesting true
  incus profile set default security.privileged true
}
# ##
# (
#   if [ X = X${SHV_CALLBYMK} ]; then
#     mt_ispkgexist() { :; }
#     mt_wrapdlder() { /usr/bin/curl $@; }
#     mt_tipstep() {
#       echo ${FUNCNAME[1]}
#       . /etc/os-release 2>/dev/null
#     }
#     dfn_incus_ubt
#   fi
# )
