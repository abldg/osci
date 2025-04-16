#!/usr/bin/env bash
# coding=utf-8
#========================================================================
# COPYSTR: Copyright (c) 2024 By LanjianJunxin, All Rights Reserved.
# FLENAME: 13_genfiles.sh
# CONTACT: developer@ljjx.com
# CREATED: 2024-10-12 06:41:58
# LTSVERN: 0.1
# LTSUPDT: 2024-12-12 00:32:42
#========================================================================
_dodefs() {
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  sft.gen_newmac() {
    _inm() {
      while [ $# -ge 1 ]; do
        shift && printf ':%s' "$(date +%s%N | md5sum | head -c 2)"
      done
    }
    case $1 in
    1 | FIX | fix) printf '00:25:7C' && _inm 1 2 3 ;;
    *) _inm 1 2 3 4 5 6 ;;
    esac | awk '{print toupper($0)}' | sed 's,^:,,'

    unset -f _inm
  }
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  sft.gen_password() {
    local usage="Usage: ${FUNCNAME} [-d,--digit-only] [PASSWD_LEN{=6}]"
    local cset='12345!@#$%qwertQWERTasdfgASDFGzxcvbZXCVB' crnd='/dev/urandom'
    local plen=6
    while :; do
      case $1 in
      '') break ;;
      -h | --help | help) echo $usage && return 0 ;;
      -d | --digit-only) cset='0-9' ;;
      *) [ X$1 != X ] && [ X${1//[0-9]/} = X ] && plen=$1 ;;
      esac
      shift
    done
    if [ ! -e $crnd ]; then
      echo '[FATAL] not find out '$crnd', skip !!!' && return 1
    fi
    tr <$crnd -dc $cset | head -c${plen} && echo
  }
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # sft.gen_editorconfig() {
  #   (
  #     local tplstr='root = true
  #     #TDL#
  #     #TDL#[*]
  #     #TDL## for all filetyes
  #     #TDL#charset = utf-8
  #     #TDL#indent_style = space
  #     #TDL#indent_size = 2
  #     #TDL#end_of_line = lf
  #     #TDL#trim_trailing_whitespace = true
  #     #TDL#insert_final_newline = true
  #     #TDL#
  #     #TDL#[*.md]
  #     #TDL## only for markdown
  #     #TDL#max_line_length = off
  #     #TDL#trim_trailing_whitespace = false
  #     #TDL#
  #     #TDL#[{*.mk,Makefile}]
  #     #TDL## only for makefile
  #     #TDL#indent_style=tab
  #     #TDL#'
  #     cd && [ ! -e .editorconfig ] &&
  #       echo "${tplstr}" | sed -r 's@^\s+#TDL#@@' >.editorconfig
  #   ) 2>/dev/null
  # }
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # sft.gen_webidefiles() {
  #   mkdir -p $HOME/.webide/.userdata
  #   {
  #     local xbse=/usr/lib/webide
  #     local xcfg=$HOME/.webide/webide.yaml
  #     local xsvc=/lib/systemd/system/webide.service
  #     ##gen-webide.yaml
  #     local tplstr1='auth: password
  #     #TDL#password: 1q2w3e
  #     #TDL#bind-addr: 0.0.0.0:ENVPORT
  #     #TDL#extensions-dir: ENVHOME/.webide/extensions
  #     #TDL#user-data-dir:  ENVHOME/.webide/.userdata
  #     #TDL#cert: false
  #     #TDL#force: true
  #     #TDL#disable-telemetry: true
  #     #TDL#disable-update-check: true
  #     #TDL#disable-workspace-trust: true
  #     #TDL#disable-getting-started-override: true
  #     #TDL#'
  #
  #     echo "${tplstr1}" | sed -r -e 's@^\s+#TDL#@@' \
  #       -e "s@ENVPORT@${WIPORT:-80}@" -e "s@ENVHOME@${HOME}@" | tee ${xcfg}
  #
  #     ##gen-webide.service
  #     local tplstr2='[Unit]
  #     #TDL#Description=WebIDE via code-server
  #     #TDL#After=network.target
  #     #TDL#
  #     #TDL#[Service]
  #     #TDL#ExecStart=ENVBSE/lib/node ENVBSE --config ENVCFG
  #     #TDL#ExecReload=/bin/kill -HUP $MAINPID
  #     #TDL#KillMode=process
  #     #TDL#Restart=on-failure
  #     #TDL#RestartPreventExitStatus=255
  #     #TDL#
  #     #TDL#[Install]
  #     #TDL#WantedBy=multi-user.target
  #     #TDL#'
  #
  #     echo "${tplstr2}" | sed -r -e 's@^\s+#TDL#@@' \
  #       -e "s@ENVBSE@${xbse}@g" -e "s@ENVCFG@${xcfg}@g" | tee ${xsvc}
  #     ##gen-/usr/bin/wo
  #     {
  #       echo '#!/usr/bin/env bash'
  #       printf '\n%s/lib/node %s --config %s "$@"\n' ${xbse} ${xbse} ${xcfg}
  #     } >wi && chmod a+x wi && mv wi /usr/bin/
  #   } 2>/dev/null
  # }
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # sft.gen_dhcpsvrfiles() {
  #   {
  #     rm -rf /etc/dnsmasq.conf /etc/dnsmasq.d
  #     mkdir -p /etc/dhcpsvr.d
  #     ##gen-/usr/sbin/dhcpsvr
  #     [ ! -x /usr/sbin/dhcpsvr ] && (cd /usr/sbin && ln -f dnsmasq dhcpsvr)
  #   }
  #   {
  #     local xifn=${ENVIFN:-eth0}
  #     local xcfg=/etc/dhcpsvr.d/dhcp-${xifn}.conf
  #     local tplstr1='port=0
  #     #TDL#interface=ENVIFN
  #     #TDL#dhcp-range=ENVIP4.10,ENVIP4.225,255.255.255.0,12h
  #     #TDL#dhcp-option=3,ENVIP4.1
  #     #TDL#dhcp-option=option:dns-server,223.5.5.5,223.6.6.6
  #     #TDL#dhcp-lease-max=255
  #     #TDL#dhcp-leasefile=/run/dhcpsvr.leases
  #     #TDL#dhcp-sequential-ip
  #     #TDL#log-dhcp
  #     #TDL#no-hosts
  #     #TDL##dhcp-host=SAMPLE_MAC,SAMPLE_IPV4
  #     #TDL#'
  #
  #     echo "${tplstr1}" | sed -r -e 's@^\s+#TDL#@@' -e "s@ENVIFN@${xifn}@g" \
  #       -e "s@ENVIP4@${ENVIP4:-192.168.100}@g" | tee ${xcfg}
  #   } 2>/dev/null
  #   {
  #     local _opts=(
  #       -k
  #       --local-service
  #       -x /run/dhcpsvr.pid
  #       -7 /etc/dhcpsvr.d
  #     )
  #     local xsvc=/lib/systemd/system/dhcpsvr.service
  #     ##gen-dhcpsvr.service
  #     local tplstr2='[Unit]
  #     #TDL#Description=A DHCP server via dnsmasq
  #     #TDL#Requires=network.target
  #     #TDL#After=network.target
  #     #TDL#
  #     #TDL#[Service]
  #     #TDL#ExecStart=/usr/sbin/dhcpsvr ENVOPTS
  #     #TDL#ExecReload=/bin/kill -HUP $MAINPID
  #     #TDL#
  #     #TDL#[Install]
  #     #TDL#WantedBy=multi-user.target
  #     #TDL#'
  #
  #     echo "${tplstr2}" | sed -r -e 's@^\s+#TDL#@@' \
  #       -e "s@ENVOPTS@${_opts[*]}@g" | tee ${xsvc}
  #   } 2>/dev/null
  # }
}
_dodefs
unset -f _dodefs
