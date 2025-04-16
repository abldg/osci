[TOC]

# 操作系统配置初始化

osci : **O**perating **S**ystem **C**onfiguration **I**nitialization

----

- 前提条件: 目标机器网络可达 [mirrors.ustc.edu.cn][ustc]
- 点击跳转到 [English](README.md) 版本


[ustc]: https://mirrors.ustc.edu.cn/ubuntu


## 一键下载代码并执行

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
    set -- /etc/resolv.conf
    echo nameserver 114.114.114.114 >$1
    ##
    local ustcurl=https://mirrors.ustc.edu.cn/ubuntu
    set -- /etc/apt/sources.list
    set -- $1 $1.d/ubuntu.sources
    sed -i -r 's@//(archive|security)@//cn.archive@' $1 2>/dev/null
    sed -i -r '^/URIs:/s@.*@URIs: '${ustcurl}'/@' $2 2>/dev/null
    ##
    apt update -y && apt install -y ${DPKGS}
    ##
    rm -rf /etc/netplan/*.yaml 2>/dev/null
  else #if [ X${ID_LIKE}Y${ID}Z == XdebianYubuntuZ ]; then
    ## OpenEuler
    yum update -y && yum install -y ${DPKGS}
  fi
  #####
  set -- $HOME/osci https://gitee.com/abldg/osci
  (
    [ ! -d $1 ] && git clone $2 $1
    cd $1 && make IP=${NEWIP}
  )
}
mydoinst $@
#STS_END
```

## 保存特定内容到文件

```bash
sed -n "/^#STS_BGN$/,/^#STS_END$/{p}" $HOME/osci/README.md | tee anx.sh
```
