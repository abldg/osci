#!/usr/bin/env bash
## coding=utf-8
##==================================----------==================================
## FILE: install.sh
## MYPG: abldg, https://github.com/abldg
## LSCT: 2025-04-12 09:42:28
## VERS: 1.2
##==================================----------==================================

dfn_ubt_sealos() {
  xf_inst_latest_sealos_via_deb() {
    set -- labring/sealos $MYCACHE/linux-x64-sealos-latest.deb
    [ -e $2 ] || {
      local dlexp="command curl -#4fSLo $2 "
      curl -s4fSL https://api.github.com/repos/$1/releases |
        jq '.[0]|.assets[]|.browser_download_url' | xargs -n1 |
        awk -va="${GHPROXY}" -v b="${dlexp}" \
          '/linux_/&&/amd64.deb/{printf("%s %s/%s\n",b,a,$0)}' |
        bash -x
    }
    [ -e $2 ] && echo "sudo dpkg -i $2"
  }
  ##~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  ##~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

  ##~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # echo ${0}::${FUNCNAME}
  # mt_tipstep
  mt_thzshflocation

  [ X = X$(command -v sealos) ] && xf_inst_latest_sealos_via_deb
}
  bash /tmp/install.sh \
  --cloud-version=v5.0.1 \
  --image-registry=registry.cn-shanghai.aliyuncs.com --zh \
  --proxy-prefix=https://ghfast.top
##
(
  set -xe
  if [ X = X${SHV_CALLBYMK} ]; then
    mt_ispkgexist() { :; }
    mt_wrapdlder() { /usr/bin/curl $@; }
    mt_tipstep() {
      echo ${FUNCNAME[1]}
      . /etc/os-release 2>/dev/null
    }
    dfn_ubt_sealos $@
  fi
  set +x
)
