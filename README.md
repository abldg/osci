[TOC]

# <u>O</u>perating <u>S</u>ystem <u>C</u>onfiguration <u>I</u>nitialization
----

- the target machine network-reachable to *[ftp.gnu.org](https://ftp.gnu.org/gnu)*
- if you live in China Mainland, use mirror-repo: <https://gitee.com/abldg/osci.git>
- click into [简体中文](README_zh.md)

## <u>D</u>ownload & <u>E</u>xecute

```bash
#STS_BGN
mydoinst() {
  { [ ! -e /etc/os-release ] && return || . /etc/os-release; } 2>/dev/null
  #####
  local DPKGS="curl git make jq bash-completion" NEWIP=$1
  #####
  if [ X${ID_LIKE}Y${ID}Z == XdebianYubuntuZ ]; then
    ## Ubuntu
    ##[optional-bgn]------------------------------------------------------------
    if [ X0 = X${SW_SKIP_OPT:-1} ]; then
      echo nameserver 114.114.114.114 >/etc/resolv.conf
      ##
      local mirurl=https://mirrors.ustc.edu.cn/ubuntu
      set -- /etc/apt/sources.list /etc/apt/sources.list.d/ubuntu.sources
      sed -i -r 's@//(archive|security)@//cn.archive@' $1 2>/dev/null
      sed -i -r '^/URIs:/s@.*@URIs: '${mirurl}'/@' $2 2>/dev/null
    fi
    ##[optional-end]------------------------------------------------------------
    apt update -y && apt install -y ${DPKGS}
  else #if [ X${ID_LIKE}Y${ID}Z == XdebianYubuntuZ ]; then
    ## OpenEuler
    yum update -y && yum install -y ${DPKGS}
  fi
  #####
  set -- $HOME/osci https://github.com/abldg/osci
  (
    [ ! -d $1 ] && git clone $2 $1
    cd $1 && make IP=${NEWIP}
  )
}
mydoinst $@
#STS_END
```

## All Content Above Save Into a Shell

```bash
sed -n "/^#STS_BGN$/,/^#STS_END$/{p}" README.md | tee anx.sh
```
