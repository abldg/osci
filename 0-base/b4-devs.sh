#!/usr/bin/env bash
## coding=utf-8
##==================================----------==================================
## FILE: b4-devs.sh
## MYPG: abldg, https://github.com/abldg
## LSCT: 2025-04-12 21:32:17
## VERS: 1.3
##==================================----------==================================

###~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
dfn_checkpkgs() {
  mt_tipstep
  local lpkgs= && {
    lpkgs+=(
      bash-completion,compgen
      bridge-utils,brctl
      bzip2
      curl
      dos2unix
      file
      fping
      git
      tig
      ipcalc
      lrzsz,rz
      make
      net-tools,netstat
      openssh-server,sshd
      pciutils,lspci
      screen
      sshfs
      sudo
      tmux
      tree
      uidmap,newuidmap
      unzip
      usbutils,lsusb
      wget
      xz-utils,xz
      zip
    )
    if [ "X${ID}Y${NAME}Z" = "XubuntuYUbuntuZ" ]; then
      lpkgs+=(
        lsb_release
        isc-dhcp-client,dhclient
        software-properties-common,add-apt-repository
      )
    fi
    ${SP}${PCMDUPT} &>/dev/null && set +x
    for x in ${lpkgs[@]}; do mt_ispkgexist $x; done
  } #>/dev/null
}
###~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

dfn_devel_cmake() {
  xf_cmake() {
    set -- ${1//,/ } 2>/dev/null
    ##arg1: owner/repo,     like mvdan/sh
    ##arg2: version_string, like 1.7.7
    ##arg3: filename-ends,  like linux-x64.tgz
    local dlfsh="${MYCACHE}/linux-x64-cmake-${2}.sh"
    mt_tipstep $dlfsh
    [ ! -e $dlfsh ] && {
      set -- $(mt_fetch_ghdlurls $1 $2) $3
      [ -s $1 ] && mt_wrapdlder -#SL4o $dlfsh $(awk '/'$2'$/' $1)
      rm -f $1 2>/dev/null
    }
    [ -s ${dlfsh} ] && (
      local xgs=(--prefix=/usr --exclude-subdir --skip-license)
      ${SP}bash ${dlfsh} ${xgs[@]} | head -1
    )
  }
  xf_cmake Kitware/CMake,3.31.6,linux-x86_64.sh
}

###~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
dfn_devel_bunjs() {
  xf_bun() {
    set -- ${1//,/ } 2>/dev/null
    ##arg1: owner/repo,     like mvdan/sh
    ##arg2: version_string, like 1.7.7
    ##arg3: filename-ends,  like linux-x64.tgz
    local dlzip="${MYCACHE}/linux-x64-bun-${2}.zip"
    mt_tipstep $dlzip
    [ ! -e ${dlzip} ] && {
      set -- $(mt_fetch_ghdlurls $1 $2) $3
      [ -s $1 ] && mt_wrapdlder -#SL4o $dlzip $(awk '/'$2'$/' $1)
      rm -f $1 2>/dev/null
    }
    [ -s ${dlzip} ] && (
      set -- $HOME/.bunjs $HOME/.config/mydev_bunjs
      rm -rf $1 2>/dev/null
      mkdir -p $1 && unzip -oqd $1 $dlzip
      (cd $1 && mv bun-* bin && cd bin && chmod a+x bun && ln -sf bun bunx)
      ##update-envfile
      {
        printf 'export BUN_INSTALL="%s"\n' ${1}
        printf 'export PATH="%s/bin:$PATH"\n' ${1}
      } >$2
      sync && [ X = X$BUN_INSTALL ] && . $2
    )
  }
  xf_bun oven-sh/bun,1.2.5,linux-x64.zip
}

###~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
dfn_devel_nodejs() {
  xf_get_xxlts() {
    command curl -fsSL4 https://api.github.com/repos/nodejs/node/releases |
      jq '.[]|.name' | grep ', Version '${1:-}'.*(LTS),' |
      awk '{print $3}' | sort -r | head -n1
  }
  xf_dl_tarxz() {
    set -- ${1}/node-${1}-linux-x64.tar.xz ${MYCACHE}/linux-x64-node-${1}.tar.xz
    if [ ! -e $2 ]; then
      local xmurl=https://mirrors.tuna.tsinghua.edu.cn
      mt_wrapdlder -#4fSLo $2 "${xmurl}/nodejs-release/$1"
    fi
    echo $2
  }
  set -- "v$(xf_get_xxlts ${SHV_NODEJS_VER:-22})" $HOME/.local/npm-global
  {
    echo 'registry=https://registry.npmmirror.com'
    echo "prefix=$2"
  } >$HOME/.npmrc && mkdir -p $2 2>/dev/null
  ${XTAR} -C /usr -xf $(xf_dl_tarxz $1)
  hash -r && npm config ls
}

###~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
dfn_devel_golang() {
  xf_get_latest_release() {
    set -- https://golang.google.cn "download downloadBox"
    mt_wrapdlder -fsSL4 $1/dl | awk -F'"' \
      '/ class="'"$2"'" /&& /linux-amd64/{print $(NF-1);}'
  }
  xf_dl_targz() {
    set -- https://golang.google.cn${1} ${MYCACHE}/${1#/dl/}
    [ -e $2 ] || eval "mt_wrapdlder -fsSLo $2 $1"
    echo $2
  }
  set -- $HOME/godev $HOME/.config/mydev_golang
  {
    echo 'export PATH='$1'/go/bin:$PATH'
    echo 'export GOROOT='$1'/go'
  } >$2
  [ X = X$GOROOT ] && . $2
  mkdir -p $1 2>/dev/null
  set -- $(xf_get_latest_release 2>/dev/null) $1
  tar -C $2 -xf $(xf_dl_targz $1) && hash -r
  go version
  go env -w GOSUMDB=off
  # go env -w GOPATH=/opt/ljjxgo
  go env -w GO111MODULE=on
  go env -w GOMODCACHE=$HOME/.cache/golang
  go env -w GOCACHE=/tmp/gobldcache
  go env -w GOPROXY=https://goproxy.io,https://goproxy.cn,direct
  go env -w GOPRIVATE=gitee.com/abldg,gitlab.com
  # go env -w GOINSECURE=192.168.166.7/*
}

###~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
xf_ghbin() {
  set -- ${1//,/ }
  ##arg1: owner/repo,     like mvdan/sh
  ##arg2: version_string, like 1.7.7
  ##arg3: filename-ends,  like linux-x64.tgz
  ##arg4: bin-name
  local fdst="/usr/bin/$4"
  local fcah="${MYCACHE}/ghbin-${4}-${2}-linux-x64"
  mt_tipstep $fcah
  [ ! -e $fcah ] && {
    set -- $(mt_fetch_ghdlurls $1 $2) $3
    [ -s $1 ] && {
      mt_wrapdlder -#SL4o $fcah $(awk '/'$2'$/' $1) 2>/dev/null
    }
    rm -f $1
  }
  [ -e $fcah ] && sudo install -m 755 $fcah $fdst
}
dfn_ttyd() { xf_ghbin tsl0922/ttyd,1.7.7,ttyd.x86_64,ttyd; }
dfn_shfmt() { xf_ghbin mvdan/sh,3.11.0,_linux_amd64,shfmt; }
dfn_jqlang() { xf_ghbin jqlang/jq,1.7.1,linux-amd64,jq; }
dfn_ghbins() {
  mt_tipstep
  dfn_ttyd
  dfn_shfmt
  dfn_jqlang
}
###~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
