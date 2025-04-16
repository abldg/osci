#!/usr/bin/env bash
## coding=utf-8
##==================================----------==================================
## FILE: b2-ubts.sh
## MYPG: abldg, https://github.com/abldg
## LSCT: 2025-04-12 20:24:51
## VERS: 1.3
##==================================----------==================================

dfn_fix_ubt2204n6n() {
  mt_tipstep
  set -- ${NAME} ${ID} ${VERSION_CODENAME}
  [ "X${1}Y${2}Z${3}" != "XUbuntuYubuntuZjammy" ] && return
  set -- netplan
  set -- ${SHV_PCHS_DIR}/*ubt2204*.tgz /usr/share/$1/$1/cli/commands/apply.py
  [ -e $1 ] && [ -e $2 ] && ${XTAR} -C / -xf $1
}

###~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
dfn_cfgs4ubt() {
  xf_upt_source() {
    mt_tipstep
    local oscode=${VERSION_CODENAME}
    if [[ $oscode != @(noble|jammy|focal|bionic) ]]; then
      _cylw "deb822 only support 18.04+"
      return
    fi
    ##
    set -- /etc/apt/sources.list
    echo "# Ubuntu sources have moved to $1.d/ubuntu.sources" | ${TEE} $1
    ##
    set -- ${1}.d/ubuntu.sources
    {
      local tpl_deb822='Types: deb
        #TDL#URIs: https://mirrors.ustc.edu.cn/ubuntu/
        #TDL#Suites: RV_CE RV_CE-updates RV_CE-backports RV_CE-security
        #TDL#Components: main restricted universe multiverse
        #TDL#Signed-By: /usr/share/keyrings/ubuntu-archive-keyring.gpg
        #TDL#'
      echo "$tpl_deb822" | sed -r -e 's@\s+#TDL#@@g' \
        -e "s@RV_CE@${oscode}@g" | ${TEE} $1
    } 2>/dev/null
  }
  xf_fix_wait_ifns_ol() {
    mt_tipstep
    set -- /etc/systemd/system/network-online.target.wants
    [ -d $1 ] || return
    (
      cd $1
      ${SED} -i '/^TimeoutStartSec=/d' *.service
      ${SED} -i '/^RemainAfterExit=yes/aTimeoutStartSec=2' *.service
    )
  }
  xf_fix_resolvcfg() {
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
    xf_fix_wait_ifns_ol
    xf_fix_resolvcfg
    xf_upt_source
    ##
    dfn_checkpkgs
    dfn_cfgs4sshd
    dfn_cfgs4ntwk
    dfn_fix_ubt2204n6n
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
