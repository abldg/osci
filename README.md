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
  local NEWIP=$1
  local DPKGS="curl git make jq bash-completion"
  #####
  set -- /etc/os-release
  { [ -e $1 ] && . $1; } 2>/dev/null
  #####
  if [ X${ID_LIKE}Y${ID}Z == XdebianYubuntuZ ]; then
    ## Ubuntu
    ##[optional-bgn]------------------------------------------------------------
    if [ X0 = X${SW_SKIP_OPT:-1} ]; then
      set -- /etc/resolv.conf
      echo nameserver 114.114.114.114 >$1
      ##
      local ustcurl=https://mirrors.ustc.edu.cn/ubuntu
      set -- /etc/apt/sources.list
      set -- $1 $1.d/ubuntu.sources
      sed -i -r 's@//(archive|security)@//cn.archive@' $1 2>/dev/null
      sed -i -r '^/URIs:/s@.*@URIs: '${ustcurl}'/@' $2 2>/dev/null
    fi
    ##[optional-end]------------------------------------------------------------
    ##
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
sed -n "/^#STS_BGN$/,/^#STS_END$/{p}" $HOME/osci/README.md | tee anx.sh
```
