[TOC]

[1]: https://mirrors.ustc.edu.cn/ubuntu
[1]: README.md

# 操作系统配置初始化

osci : **O**perating **S**ystem **C**onfiguration **I**nitialization

----

- 前提条件: 目标机器网络可达 [mirrors.ustc.edu.cn][1]
- 点击跳转到 [English][2] 版本



## 一键下载代码并执行

```bash
#STS_BGN
mydoinst() {
  { [ ! -e /etc/os-release ] && return || . /etc/os-release; } 2>/dev/null
  #####
  local DPKGS="curl git make jq bash-completion"
  #####
  if [ X${ID_LIKE}Y${ID}Z == XdebianYubuntuZ ]; then ## Ubuntu
    ##~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    local mary=(
      https://mirrors.tuna.tsinghua.edu.cn/ubuntu
      https://mirrors.ustc.edu.cn/ubuntu
      https://mirrors.aliyun.com/ubuntu
    )
    ##~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    set -- /etc/apt/sources.list /etc/apt/sources.list.d/ubuntu.sources
    sed -i -r 's@//(archive|security)@//cn.archive@' $1 2>/dev/null
    sed -i -r "^/URIs:/s|.*|URIs: ${mary[${MRIDX:-0}]}|" $2 2>/dev/null
    ##~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    apt update -y && apt install -y ${DPKGS}
  else ## OpenEuler
    ##~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    yum update -y && yum install -y ${DPKGS}
  fi
  #####
  echo nameserver 114.114.114.114 >/etc/resolv.conf
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
