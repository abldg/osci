#!/usr/bin/env bash
## coding=utf-8
##==================================----------==================================
## FILE: b1-ntwk.sh
## MYPG: abldg, https://github.com/abldg
## LSCT: 2025-04-12 20:18:29
## VERS: 1.3
##==================================----------==================================

dfn_cfgs4ntwk() {
  ###///////////////////////////////////////////////////////////////////////////
  xf_get_br_first_child() {
    set -- $1 /sys/class/net/$1/brif
    if [ -e $2 ]; then ##is-a-bridge
      local tbr=/sys/devices/virtual/net/${1} xif= rst=
      for xif in $(ls -d1 /sys/class/net/[^lvb]*); do
        if [ "$tbr" == "$(realpath $xif/master)" ]; then
          rst="${rst} ${xif##*/}"
        fi
      done 2>/dev/null
      set -- $(echo ${rst} | xargs -n1 | sort | grep -v 'tap' | head -1)
    fi
    echo $1
  }
  ###///////////////////////////////////////////////////////////////////////////
  xf_get_ifn_ip_brd_prefix() {
    local xt_i4pa='.[]|.addr_info[0]|.local,.broadcast,.prefixlen'
    set -- $(ip -4 -j addr show $1 | jq "${xt_i4pa}" | xargs)
    local cip=$1 brd=$2 pfx=$3
    ##SHV_RESET_IP-not-empty-then-merge-it-into-cip
    { local t= && set -- ${SHV_RESET_IP//./ }; } 2>/dev/null
    case $# in
    4) t= ;;
    0) t=${cip} ;;
    1) t=${cip%.*}. ;;
    2) t=${cip%.*.*}. ;;
    3) t=${cip%%.*}. ;;
    *) t=$1.$2.$3.$4 && SHV_RESET_IP= ;;
    esac
    cip=${t}$SHV_RESET_IP
    echo ${cip} ${pfx} ${cip##*.}
  }
  ###///////////////////////////////////////////////////////////////////////////
  xf_upt_hostname_and_hosts() {
    [ X = X${SHV_RESET_HN} ] && return
    ##arg1: ipv4address
    mt_tipstep
    set -- $ADRINFO ${ADRINFO//./-} ${SHV_RESET_HN} /etc/hosts
    local newhn=${2}
    [ X1 != X$3 ] && newhn=$3
    sudo hostnamectl set-hostname $newhn
    sed -i -r '/^#NEWAPD#$/,${d}' $4
    echo -e "#NEWAPD#\n$1 $newhn" | sudo tee -a $4
  }
  ###///////////////////////////////////////////////////////////////////////////
  xf_upt_npyaml() {
    ##via-outter-vars: (ADRINFO),GWIFN,GWIP
    {
      local tmp_saved=/tmp/x2x
      local tpl_npyml='network:
      #TDL#  version: 2
      #TDL#  ethernets:
      #TDL#    #eth1: { dhcp4: no, dhcp6: no, addresses: [ RV_CIDR_SPL ] }
      #TDL#    RV_TKN:
      #TDL#      dhcp4: no
      #TDL#      dhcp6: no
      #TDL#      addresses:
      #TDL#      - RV_CIDR_USE
      #TDL#      routes:
      #TDL#      - { metric: 100, to: 0.0.0.0/0, via: RV_GWIP }
      #TDL#      nameservers:
      #TDL#        addresses: [ 223.5.5.5,114.114.114.114,8.8.8.8 ]'
      set -- ${ADRINFO[@]}
      set -- ${GWIFN} ${GWIP} $1/$2 192.168.166.$3/$2
      echo "${tpl_npyml}" | sed -r \
        -e "s@RV_TKN@${1}@g" \
        -e "s@RV_GWIP@${2}@" \
        -e "s@RV_CIDR_USE@${3}@g" \
        -e "s@RV_CIDR_SPL@${4}@g" \
        -e 's@\s+#TDL#@@g' >$tmp_saved
    } 2>/dev/null
    set -- /etc/netplan/00-static.yaml
    sudo rm -f $1 2>/dev/null
    sudo install -m 0600 $tmp_saved $1
  }
  ###///////////////////////////////////////////////////////////////////////////
  xf_upt_oescrt() {
    echo $@
  }
  ###///////////////////////////////////////////////////////////////////////////
  mt_tipstep
  ##save-ntwkinfo-into-a-file (ubuntu：/etc/netplan/00-static, oe: ifcfg-xxx)
  ## GLV::SHV_RESET_IP change-into-a-newipv4
  ## GLV::SHV_RESET_HN change-hostname(SHV_RESET_HN=1,newhn=${ip4//./-})
  ##get-gateway-ipv4-address-and-via-interface
  set -- $(ip -4 -j route show default | jq '.[0]|.gateway,.dev' | xargs)
  local ADRINFO= GWIFN= GWIP=$1
  ##get-real-ifn-begins-with-eXXX
  GWIFN=$(xf_get_br_first_child $2)
  ##get-the-ipv4-on-gateway-via-interface
  ADRINFO=($(xf_get_ifn_ip_brd_prefix $2))
  # echo ${ADRINFO[@]}
  ##
  xf_upt_hostname_and_hosts
  ##
  set -- /usr/sbin/netplan /etc/sysconfig/network-scripts
  if [ -x $1 ]; then
    (xf_upt_npyaml)
    return
  fi
  if [ -d $2 ]; then
    (xf_upt_oescrt $2/ifcfg-${tifn})
  fi
}
###~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
