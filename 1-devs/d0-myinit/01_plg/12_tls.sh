#!/usr/bin/env bash
#--- Coding: UTF-8 ---
#=====================================================================
# COPYSTR: Copyright (c) 2024 By LanjianJunxin, All Rights Reserved.
# FLENAME: 12_tls.sh
# CONTACT: developer@ljjx.com
# CREATED: 2019-09-04 14:01:10
# LTSVERN: 0.1
# LTSUPDT: 2024-12-12 00:31:37
#=====================================================================
_dosfn() {
  open() {
    local vcmd='vifm'
    [ X1 = X${FINST:-0} ] && sudo apt install -y $vcmd
    if [ X != X$(command -v $vcmd) ]; then
      $vcmd ${1-$PWD}
    else
      vim $@
    fi
  }
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  dha() {
    if [ $# -ge 1 ]; then
      [ -d $1 ] && (cd $1 && ls -A | xargs du -sh | sort -h)
      return
    fi
    ls -A | xargs du -sh | sort -h
  }
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  fj() {
    [ ${#1} -eq 0 ] && return
    [ X${1:0:1} = X- ] && return
    [ -d $1 ] || mkdir -p $1
    cd $1
  }
  # alias sft.fastjump='fj'
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  alias sfs='sf -s'
  sf() {
    local flgSave=0
    [ "X$1" = "X-s" ] && flgSave=1 && shift
    [ "X$1" = "X" ] && declare -F && return
    [ "X$(command -v $1)" = "X" ] && return
    [ "X$(declare -F $1)" = "X" ] && {
      alias $1
      return
    }
    local tf=/tmp/${1##.}.sh
    if [ X != X$(command -v shfmt) ]; then
      declare -f $1 | shfmt -i 2 -ln bash
    else
      declare -f $1 | sed -r 's@\t@    @;s@  @ @g'
    fi | tee $tf
    [ X$flgSave = X1 ] && {
      echo '#!/usr/bin/env bash'
      cat $tf
      echo "$1 "'$@'
    } >$1.sh
    rm -f $tf
  }
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  sfx() {
    (
      echo '+set -x'
      shopt -s expand_aliases
      set -x
      eval "$@"
      set +x #&& shopt -u expand_aliases
    )
  }
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  sft.kapid() {
    [ $# -ge 1 ] && {
      pidof $1 | xargs kill -9
    }
  }
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  sft.remove_duplines() {
    [ $# -ge 1 ] && awk '!a[$0]++' "$*"
  }
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  sft.gbk2utf8() {
    [ X != X$1 ] && (
      local afile= frm=
      while read afile; do
        frm=$(file -ib $afile | awk -F= '{printf $NF}')
        [ "Xutf-8" != "X$frm" ] && {
          mv $afile tmx
          [ "Xiso" = "X${frm%%-*}" ] && frm='GB18030'
          iconv -f "$frm" -t UTF-8 <tmx >$afile
          [ $? -ne 0 ] && mv tmx ${afile}
        }
      done <$1
      rm -f tmx
    )
  }
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  sft.groupString() {
    [ $# -ge 1 ] || return
    local x="$1" step=${2:-1} next=${3:-0}
    local vLen=${#x}
    while [ $next -le $vLen ]; do
      y=${x:next:step}
      [ "X$y" == "X" ] && break
      echo $y
      ((next += step))
    done
  }
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  sft.chk_pkgcmd() {
    set -- apt dnf yum
    local x=
    for x in $@; do
      if [ X != X$(command -v $x) ]; then
        export PKG_REMV="${x} remove -y"
        export PKG_UPDT="${x} update -y"
        export PKG_INST="${x} install -y"
        return
      fi
    done
  }
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  sfn.get_mypubip() {
    # dig @resolver1.opendns.com -t A -4 myip.opendns.com +short
    curl -f4sSL ifconfig.io
  }
  sfn.sync_datetime() {
    ntpdate ntp.aliyun.com
  }
  sfn.showIPv4s() {
    ip -4 a | awk '/inet /{sub("/.*","",$2);print $NF,$2}' |
      awk '/.*'$1'/' | column -t
  }
  sfn.shownicsdata() {
    tail +2 /proc/net/dev | awk '$2!=0' |
      sed 's@cast|bytes@cast Send:@;s@face\s|bytes@Ifnames Recv:@' | column -t
  }
  sfn.showlanips() {
    [ X = X$(command -v fping) ] && $PKG_INST fping
    [ X = X$(command -v fping) ] && return
    set -- $(ip -4 -j route | jq '.[]|.dev+"="+.dst' | grep -v default | xargs)
    local p= && echo "=====Detected-Using-Ipv4s=====" && for r in $@; do
      p=(${r//=/ })
      echo "via-[${p[0]}@${p[1]}]"
      fping -4 -a -I ${p[0]} -g ${p[1]}
    done 2>/dev/null
  }
  sfn.upthostname() {
    if [ $# -ne 0 ]; then
      hostnamectl set-hostname $1
      return
    fi
    ##
    [ X = X$(command -v jq) ] && $PKG_INST jq
    local jx_ifngw='.[0]|.dev,.gateway'
    set -- $(ip -4 -j route show default | jq "${jx_ifngw}" | xargs)
    local gp=${2%.*} nh=${SHV_NEW_HN} x=
    set -- $(ip -4 -j addr show dev $1 | jq '.[]|.addr_info[]|.local' | xargs)
    for x in $@; do [ X${x#$gp} != X${x} ] && break; done
    [ X != X${x} ] && {
      [ X$nh = X ] && nh=${x//./-}
      set -- $x $nh /etc/hosts
      hostnamectl set-hostname $2
      sed -i -r '/^##APDNEW##$/,${d}' $3
      echo -e "##APDNEW##\n$1 $2" >>$3
      sync && echo "verify-1: [/etc/hostname:$(hostname)]" &&
        echo "verify-2: [$3   :$(tail -1 $3)]"
    }
  }
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  ##工具函数:启动screen会话进入虚拟机microX
  [ X != X$(command -v incus) ] && {
    bss_vm_micro_x() {
      [ $# -eq 0 ] && screen -ls && return
      set -- ${1//[a-z]/} $1
      local rssn= x=
      for x in ssw$1 micro$1; do
        if screen -ls | grep -Eiq $x; then
          rssn=$x
          break
        fi
      done
      if [ X != X$rssn ]; then
        ##有找到screen窗口,直接恢复
        screen -r $rssn
      else
        ##未找到screen窗口,继续检查是否有对应的incus虚拟机
        set -- micro$1 ssw$1
        local msg="$(incus info $1)"
        if echo $msg | grep -q 'Error: Instance not found'; then
          echo "ERROR: instance $1 not found"
          return
        fi 2>/dev/null
        if echo $msg | grep -q 'Status: STOPPED'; then
          incus start $1
          echo "WARN: already start instance $1, please retry later."
          return
        fi 2>/dev/null
        screen -4mS $2 incus exec $1 -- bash
      fi
    }
  }
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
}
_dosfn && unset -f _dosfn
