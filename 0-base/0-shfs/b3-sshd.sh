#!/usr/bin/env bash
## coding=utf-8
##==================================----------==================================
## FILE: b3-sshd.sh
## MYPG: abldg, https://github.com/abldg
## LSCT: 2025-04-12 21:04:16
## VERS: 1.3
##==================================----------==================================

dfn_cfgs4sshd() {
  declare -gA _aryoftips=()
  _tipopt() {
    set -- ${tlang:-CN} ${@}
    echo -en "## ${_aryoftips[${1}, ${2}]}"
    if [ $# -ge 3 ]; then
      shift 2 && echo -e "\n${@}\n"
    else
      [[ $2 == @(spt)_* ]] && echo -e " ##\n"
    fi
  }
  ##~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  xsc_bsr() {
    mt_tipstep
    local lisip=${SSHD_LISIP:-0.0.0.0}
    if [ X1 = X${SSHD_ONEIP:-0} ]; then
      lisip=$(hostname -I | xargs -n1 | awk '!/^127.0/' | head -1)
    fi
    {
      _aryoftips+=(
        [CN, spt_xx1]="======基础安全加固======"
        [CN, opt_dvo]="禁用SSHv1"
        [CN, opt_afs]="可用网络栈(any/inet/inet6)"
        [CN, opt_las]="限制监听IP(按需设置)"
        [CN, opt_lpn]="修改SSH端口(按需设置)"
      )
      _tipopt spt_xx1
      _tipopt opt_dvo "Protocol 2"
      _tipopt opt_afs "AddressFamily inet"
      _tipopt opt_las "ListenAddress ${lisip}"
      _tipopt opt_lpn "Port ${SSHD_PORT:-22}"
    } 2>/dev/null | ${TEE} $1
  }
  xsc_apc() {
    mt_tipstep
    {
      _aryoftips+=(
        [CN, spt_xx2]="======认证与权限控制======"
        [CN, opt_prl]="是否允许root登录"
        [CN, opt_pep]="禁止空密码"
        [CN, opt_pda]="强制密钥认证(禁用密码)"
        [CN, opt_pua]="启用公钥认证"
        [CN, opt_wlt]="白名单用户+IP限制(按需设置)"
        [CN, opt_wlg]="白名单用户组"
        [CN, opt_mat]="单次连接最大认证尝试次数"
        [CN, opt_lgt]="登录超时时间(快速断开未认证连接)"
        [CN, opt_pam]="启用PAM模块(配合Fail2Ban)"
      )
      _tipopt spt_xx2
      _tipopt opt_prl "PermitRootLogin ${SSHD_PRL:-yes}"
      _tipopt opt_pep "PermitEmptyPasswords no"
      _tipopt opt_pda "PasswordAuthentication yes"
      _tipopt opt_pua "PubkeyAuthentication yes"
      _tipopt opt_wlt "#AllowUsers ldg ljjx stack root@192.168.*.*"
      _tipopt opt_wlg "#AllowGroups ssh-users"
      _tipopt opt_mat "MaxAuthTries 2"
      _tipopt opt_lgt "LoginGraceTime 30s"
      _tipopt opt_pam "UsePAM yes"
    } 2>/dev/null | ${TEE} $1
  }
  xsc_eae() {
    {
      _xhlp() {
        printf '%s@openssh.com ' $@ | xargs | sed 's@ @,@g'
      }
      local lst_ciphers='chacha20-poly1305 aes256-gcm aes128-gcm'
      local lst_macs='hmac-sha2-512-etm hmac-sha2-256-etm'
      local lst_kxalgs='curve25519-sha256'
      lst_kxalgs+=',curve25519-sha256@libssh.org'
      lst_kxalgs+=',diffie-hellman-group-exchange-sha256'
      local lst_hkalgs='ssh-ed25519,ssh-ed25519-cert-v01 '
      lst_hkalgs+='rsa-sha2-512,rsa-sha2-512-cert-v01'
    } 2>/dev/null
    mt_tipstep
    {
      _aryoftips+=(
        [CN, spt_xx3]="======加密算法强化======"
        [CN, opt_dwa]="禁用弱算法,优先选择ChaCha20和AES-GCM\n## 优先使用Ed25519密钥"
        [CN, opt_rsa]="RSA密钥建议4096位以上"
      )
      _tipopt spt_xx3
      _tipopt opt_dwa "HostKey /etc/ssh/ssh_host_ed25519_key"
      _tipopt opt_rsa "HostKey /etc/ssh/ssh_host_rsa_key"
      echo "Ciphers $(_xhlp ${lst_ciphers})"
      echo "MACs $(_xhlp ${lst_macs})"
      echo "KexAlgorithms ${lst_kxalgs}"
      echo "HostKeyAlgorithms $(_xhlp ${lst_hkalgs})"
    } 2>/dev/null | ${TEE} $1
  }
  xsc_scl() {
    mt_tipstep
    {
      _aryoftips+=(
        [CN, spt_xx4]="======会话与连接限制======"
        [CN, opt_cai]="客户端无活动300秒发送保活包"
        [CN, opt_cac]="最多发送2次保活包后断开"
        [CN, opt_mst]="控制并发未认证连接(初始:概率拒绝:最大)"
        [CN, opt_mse]="单用户最大并发会话"
      )
      _tipopt spt_xx4
      _tipopt opt_cai "ClientAliveInterval 300"
      _tipopt opt_cac "ClientAliveCountMax 2"
      _tipopt opt_mst "MaxStartups 5:50:10"
      _tipopt opt_mse "MaxSessions 3"
    } 2>/dev/null | ${TEE} $1
  }
  xsc_ads() {
    mt_tipstep
    {
      _aryoftips+=(
        [CN, spt_xx5]="======高级防护======"
        [CN, opt_udn]="禁用DNS反向解析(加速+防SSH劫持)"
        [CN, opt_cpn]="禁用压缩(防御CRIME攻击)"
        [CN, opt_aaf]="禁用SSH代理转发(除非必要)"
        [CN, opt_atf]="禁用TCP端口转发(按需开启)"
        [CN, opt_x11]="禁用X11图形转发"
        [CN, opt_ptn]="禁用VPN隧道功能"
        [CN, opt_dbb]="隐藏SSH版本信息(防指纹识别)"
        [CN, opt_stm]="严格检查文件权限(如~/.ssh目录)"
        [CN, opt_tka]="TCP保活"
      )
      _tipopt spt_xx5
      _tipopt opt_udn "UseDNS no"
      _tipopt opt_cpn "Compression no"
      _tipopt opt_aaf "AllowAgentForwarding no"
      _tipopt opt_atf "AllowTcpForwarding ${SSHD_ATF:-yes}"
      _tipopt opt_x11 "X11Forwarding no"
      _tipopt opt_ptn "PermitTunnel no"
      _tipopt opt_dbb "DebianBanner no"
      _tipopt opt_stm "StrictModes yes"
      _tipopt opt_tka "TCPKeepAlive yes"
    } 2>/dev/null | ${TEE} $1
  }
  xsc_laa() {
    mt_tipstep
    {
      _aryoftips+=(
        [CN, spt_xx6]="======日志与审计======"
        [CN, opt_slf]="将日志发送到系统日志"
        [CN, opt_llv]="记录详细日志(可追踪攻击行为)"
        [CN, opt_sbs]="限制SFTP用户访问目录(需匹配用户/组)"
      )
      _tipopt spt_xx6
      _tipopt opt_slf "SyslogFacility AUTH"
      _tipopt opt_llv "LogLevel VERBOSE"
      _tipopt opt_sbs "Subsystem sftp internal-sftp -f AUTH -l INFO"
    } 2>/dev/null | ${TEE} $1
  }
  ##~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  (
    if [ X = X$(command -v sshd) ]; then
      ${SP}${PCMDIST} openssh-erver
    fi

    ##
    mt_tipstep
    set -- /etc/ssh/sshd_config
    set -- $1 $1.bak $1.d
    ##backup-and-invoke-subconfigs
    [ ! -e $2 ] && cp $1 $2
    printf "##loads-sshd_config.d/xxx.conf\nInclude ${3}/*.conf\n" | ${TEE} $1
    set -- $3
    ${SP}mkdir -p ${1} 2>/dev/null
    (cd $1 && ${SP}rm -rf *.conf) 2>/dev/null
    ##
    xsc_bsr $1/00-basic-security-reinforcement.conf
    xsc_apc $1/01-authentication-permission-control.conf
    xsc_eae $1/02-encryption-algorithm-enhancement.conf
    xsc_scl $1/03-session-connection-limits.conf
    xsc_ads $1/04-advanced-security-reinforcement.conf
    xsc_laa $1/05-log-and-auditement.conf
    (cd $1 && ${SP}chmod 644 *.conf) 2>/dev/null
    ${SP}systemctl enable ssh
    ${SP}systemctl restart ssh
  ) >/dev/null
  ##
}
