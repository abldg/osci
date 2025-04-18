#!/usr/bin/env bash
## coding=utf-8
##==================================----------==================================
## FILE: b2-ubts.sh
## MYPG: abldg, https://github.com/abldg
## LSCT: 2025-04-12 20:24:51
## VERS: 1.3
##==================================----------==================================

dfn_fix_ubt2204_n5n() {
  mt_tipstep
  set -- ${NAME} ${ID} ${VERSION_CODENAME}
  [ "X${1}Y${2}Z${3}" != "XUbuntuYubuntuZjammy" ] && return
  set -- netplan $(mt_thzshflocation)
  set -- /usr/share/$1/$1/cli/commands/apply.py ${2%/*}/${FUNCNAME#dfn_}.tgz
  [ -e $2 ] && [ -e $1 ] && sudo tar --no-same-owner -C / -xf $2
}

###~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
dfn_fix_aptmirurl() {
  mt_tipstep
  if [[ $VERSION_CODENAME != @(noble|jammy|focal|bionic) ]]; then
    _yellow "deb822 only support 18.04+"
    return
  fi
  ##
  set -- /etc/apt/sources.list /etc/apt/sources.list.d/ubuntu.sources
  {
    ##~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    local mary=(tuna.tsinghua.edu.cn ustc.edu.cn aliyun.com)
    local murl=${mary[${SHV_MIRURL_IDX:-0}]}
    echo "# Ubuntu sources have moved to $2" | ${TEE} $1
    local tpl='Types: deb
        #TDL#URIs: https://mirrors.RV_MIRURL/ubuntu/
        #TDL#Suites: RV_CE RV_CE-updates RV_CE-backports RV_CE-security
        #TDL#Components: main restricted universe multiverse
        #TDL#Signed-By: /usr/share/keyrings/ubuntu-archive-keyring.gpg
        #TDL#'
    echo "$tpl" | sed -r \
      -e "s@RV_CE@${VERSION_CODENAME}@g" \
      -e "s@RV_MIRURL@${murl:-${mary}}@g" \
      -e 's@\s+#TDL#@@g' |
      ${TEE} $2
  } 2>/dev/null
}

###~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
dfn_fix_wait4ifsonline() {
  mt_tipstep
  set -- /etc/systemd/system/network-online.target.wants
  [ -d $1 ] || return
  (
    cd $1
    ${SED} -i '/^TimeoutStartSec=/d' *.service
    ${SED} -i '/^RemainAfterExit=yes/aTimeoutStartSec=2' *.service
  )
}
dfn_fix_resolvfile() {
  mt_tipstep
  set -- /etc/systemd/resolved.conf /etc/resolv.conf
  local ka=
  if [ -e $1 ]; then
    ka=(DNS=114.114.114.114 FallbackDNS=223.5.5.5)
    ${SED} -i -r -e '/^#?DNS=/s@.*@'${ka[0]}'@' \
      -e '/^#?FallbackDNS=/s@.*@'${ka[1]}'@' $1
  fi
  ${SP}rm -f $2 2>/dev/null
  ka=(114.114.114.114 223.5.5.5)
  printf 'nameserver %s\n' ${ka[@]} | ${TEE} $2
}
###~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
dfn_cfgs4ubt() {
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  mt_tipstep
  set -- ${NAME} ${ID}
  [ "X${1}Y${2}" != "XUbuntuYubuntu" ] && return
  ##
  (
    ##
    ${SP}rm -rf /lost+found /[bls]*.usr-is-merged /wget-log* 2>/dev/null
    ##
    set -- needrestart open-vm-tools
    ${SP}apt purge --auto-remove -y $@ 2>/dev/null
    ##
    set -- /usr/bin/nvidia-smi /etc/profile.d/z96-nvidia-smi-pm-1.sh
    echo "[ -x $1 ] && $1 -pm 1 &>/dev/null" | ${TEE} $2
    ##
    set -- /etc/modprobe.d/blacklist-nouveau.conf
    printf 'blacklist nouveau\noptions nouveau modeset=0\n' | ${TEE} $1
    ##
    set -- /etc/cloud/cloud.cfg.d
    set -- $1 $1/99-disable-network-config.cfg
    [ -d $1 ] && echo 'network: {config: disabled}' | ${TEE} $2
    ##
    set -- ctrl-alt-del.target multi-user.target
    ${SP}systemctl mask $1
    [ X1 = X${SHV_ENB_MLUS:-0} ] && ${SP}systemctl set-default $2
    ##
    dfn_fix_wait4ifsonline
    dfn_fix_resolvfile
    dfn_fix_aptmirurl
    ##
    dfn_checkpkgs
    dfn_cfgs4sshd
    dfn_cfgs4ntwk
    dfn_fix_ubt2204_n5n
    dfn_ghbins
    ##
    set -- /etc/.git supda supda@lclsvr.mgr
    [ ! -d $1 ] && {
      cd /etc && {
        local MG="${SP}git"
        ${MG} init && ${MG} add . -f
        ${MG} config user.name $2 && ${MG} config user.email $3
        ${MG} commit -m "lclsvr-mgr-init-$(date +%s)"
      } &>/dev/null
    }
    [ X0 != X${SHV_NPAPLNOW:-0} ] && ${SP}netplan apply
  )
}

###~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
