#!/usr/bin/env bash
## coding=utf-8
##==================================----------==================================
## FILE: a1-lib-prompt.sh
## MYPG: abldg, https://github.com/abldg
## LSCT: 2025-04-18 05:59:26
## VERS: 0.2
##==================================----------==================================
declare -gA SLC_PROMPTS=()
## [COLORS] ##~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
mcary=(RED:"31;1" GRN:32 YLW:33 BLU:34 PLP:35 YAN:36 END:0)
for x in ${mcary[@]}; do
  p=(${x//:/ }) && eval "export C${p[0]}='\e[${p[1]}m'"
done
for x in red blue cyan green purple yellow; do
  if [ X1 = X${SHV_DEBUGTHZ:-0} ]; then
    eval "_${x}(){ CLR=${x} xf_tiprint \$@; }"
  else
    eval "_${x}(){ { CLR=${x} xf_tiprint \$@; } 2>/dev/null; }"
  fi
done
unset -v x p mcary
###
mt_getprompt() {
  local cc= bk="${*}" zl="${ZLG:-cn}"
  case ${CLR} in
  cred | CRED | [rR] | red) cc="${CRED}" && red_exit=1 ;;
  cblu | CBLU | [bB] | blue) cc="${CBLU}" ;;
  cyan | CYAN | [cC] | cyan) cc="${CYAN}" ;;
  cgrn | CGRN | [gG] | green) cc="${CGRN}" ;;
  cplp | CPLP | [pP] | purple) cc="${CPLP}" ;;
  cylw | CYLW | [yY] | yellow) cc="${CYLW}" ;;
  *) cc="${CEND}" ;;
  esac
  ##
  {
    if [[ "X${bk//[a-z0-9_]/}" = "X" ]]; then
      [[ ${bk}X == @(cn|en|jp|fr|ru|de)_*X ]] && bk="${bk#*_}"
      set -- "${SLC_PROMPTS[${zl}_${bk}]}"
      [ ${#1} -ge 1 ] && bk="${*}"
    fi
    printf -- "${cc}${bk}${CEND}" | sed -r 's@^\s+#TDL#@@g'
    ##
    [ X${SW_NEWLINE:-1} = X1 ] && printf "\n"
  } 2>/dev/null
}
###
{
  SLC_PROMPTS+=(
    ###~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~###
    [en_pre_prompt]="Depends on iptables, please make sure iptables is installed, multiple nodes need to configure ssh password-free login or the same password, after installation with the self-signed certificate provided by Sealos, you need to trust the certificate yourself."
    [cn_pre_prompt]="依赖 iptables, 请确保 iptables 已经安装, 多节点需要配置 ssh 免密登录或密码一致, 使用 Sealos 提供的自签证书安装完成后需要自信任证书"
    ###~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~###
    [en_pull_image]="Pulling image: "
    [cn_pull_image]="正在拉取镜像: "
    ###~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~###
    [en_pull_image_success]="Image pulled successfully: "
    [cn_pull_image_success]="镜像拉取成功: "
    ###~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~###
    [en_pull_image_failed]="Image pulled failed: "
    [cn_pull_image_failed]="镜像拉取失败: "
    ###~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~###
    [en_install_sealos]="Sealos CLI is not installed, do you want to install it? (y/n): "
    [cn_install_sealos]="Sealos CLI 尚未安装, 是否安装? (y/n): "
    ###~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~###
    [en_input_master_ips]="Please enter Master IP (For single node installation, you can press enter to skip this step; separate multiple Master nodes with commas, e.g: 192.168.0.1,192.168.0.2,192.168.0.3): "
    [cn_input_master_ips]="请输入 Master IP (单节点安装可输入回车跳过该步骤; 多个 Master 节点使用逗号分隔, 例: 192.168.0.1,192.168.0.2,192.168.0.3): "
    ###~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~###
    [en_invalid_ips]="Invalid or incorrect IP format, please try again."
    [cn_invalid_ips]="IP无效或错误格式, 请再试一次."
    ###~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~###
    [en_invalid_master_ips]="The number of master IPs is even. Please provide an odd number of master IPs."
    [cn_invalid_master_ips]="Master IP的数量是偶数,请提供奇数个 Master IP"
    ###~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~###
    [en_input_node_ips]="Please enter Node IP (If there are no Node nodes, you can press enter to skip this step; separate multiple Node nodes with commas, e.g: 192.168.1.1,192.168.1.2,192.168.1.3): "
    [cn_input_node_ips]="请输入 Node IP (无 Node 节点可输入回车跳过该步骤; 多个 Node 节点使用逗号分隔, 例: 192.168.1.1,192.168.1.2,192.168.1.3): "
    ###~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~###
    [en_pod_subnet]="Please enter the Pod subnet (Press enter to use the default value: 100.64.0.0/10): "
    [cn_pod_subnet]="请输入 Pod 子网 (回车使用默认值: 100.64.0.0/10): "
    ###~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~###
    [en_service_subnet]="Please enter the Service subnet (Press enter to use the default value: 10.96.0.0/22): "
    [cn_service_subnet]="请输入 Service 子网 (回车使用默认值: 10.96.0.0/22): "
    ###~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~###
    [en_cloud_domain]="Please enter the cloud domain name (You can use the nip.io domain name if you need: [ip].nip.io, for more details, please refer to: http://nip.io, e.g: 127.0.0.1.nip.io): "
    [cn_cloud_domain]="请输入 Sealos Cloud 域名 (无自备域名可使用 nip.io 域名: [ip].nip.io, 详细参考: http://nip.io, 例:127.0.0.1.nip.io): "
    ###~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~###
    [en_cloud_port]="Please enter the cloud port (Press enter to use the default value: 443): "
    [cn_cloud_port]="请输入 Sealos Cloud 端口 (回车使用默认值: 443): "
    ###~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~###
    [en_certificate_path]="Please enter the certificate path (Press Enter to use ACME to automatically apply for certificates): "
    [cn_certificate_path]="请输入证书路径 (回车使用 ACME 自动申请证书): "
    ###~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~###
    [en_private_key_path]="Please enter the private key path: "
    [cn_private_key_path]="请输入私钥路径: "
    ###~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~###
    [en_choose_language]="Please choose a language: "
    [cn_choose_language]="请选择语言: "
    ###~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~###
    [en_enter_choice]="Please enter your choice (zh/en): "
    [cn_enter_choice]="请输入您的选择 (zh/en): "
    ###~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~###
    [en_k8s_installation]="Installing Kubernetes cluster."
    [cn_k8s_installation]="正在安装 Kubernetes 集群."
    ###~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~###
    [en_partner_installation]="Installing Higress and Kubeblocks."
    [cn_partner_installation]="正在安装 Higress 和 Kubeblocks."
    ###~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~###
    [en_installing_monitoring]="Installing kubernetes monitoring."
    [cn_installing_monitoring]="正在安装 kubernetes 监控."
    ###~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~###
    [en_installing_cloud]="Installing Sealos Cloud."
    [cn_installing_cloud]="正在安装 Sealos Cloud."
    ###~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~###
    [en_avx_not_supported]="CPU does not support AVX instruction set."
    [cn_avx_not_supported]="CPU 不支持 AVX 指令集."
    ###~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~###
    [en_ssh_private_key]="Please enter the ssh private key path (Press enter to use the default value: '$HOME/.ssh/id_rsa'): "
    [cn_ssh_private_key]="请输入 ssh 私钥路径 (回车使用默认值: '$HOME/.ssh/id_rsa'): "
    ###~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~###
    [en_ssh_password]="Please enter the ssh password (Press enter to use password-free login): "
    [cn_ssh_password]="请输入 ssh 密码 (回车使用免密登录): "
    ###~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~###
    [en_wait_cluster_ready]="Waiting for the cluster to be ready, if you want to skip this step, please enter 'y': "
    [cn_wait_cluster_ready]="正在等待集群就绪, 如果您想跳过此步骤, 请输入'y': "
    ###~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~###
    [en_optimizing_h2_buffer]="Optimizing the size of the H2 flow control buffer."
    [cn_optimizing_h2_buffer]="正在优化H2流控缓冲区大小."
    ###~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~###
    [en_mongo_avx_requirement]="MongoDB 6.0 version depends on a CPU that supports the AVX instruction set. The current environment does not support AVX, so it has been switched to MongoDB 4.4 version. For more information, see: https://www.mongodb.com/docs/v6.0/administration/production-notes/"
    [cn_mongo_avx_requirement]="MongoDB 6.0版本依赖支持 AVX 指令集的 CPU, 当前环境不支持 AVX, 已切换为 MongoDB 4.4版本, 更多信息查看: https://www.mongodb.com/docs/v6.0/administration/production-notes/"
    ###~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~###
    [en_enable_acme]="Do you want to enable ACME to automatically obtain certificates (Press n to use the self-signed certificate provided by Sealos)? (y/n): "
    [cn_enable_acme]="是否启用 ACME 自动获取证书（输入 n 使用 Sealos 提供的自签证书）? (y/n): "
    ###~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~###
    [en_acmedns_registration_failed]="ACME DNS registration failed. Please check if the acmedns-host: '${GREEN}%s${RESET}' is correct."
    [cn_acmedns_registration_failed]="注册 ACME DNS 失败, 请检查 acmedns-host: '${GREEN}%s${RESET}' 是否正确."
    ###~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~###
    [en_acme_cname_record]="Please create a CNAME record for '${GREEN}_acme-challenge.%s${RESET}'\npointing to '${GREEN}%s${RESET}'."
    [cn_acme_cname_record]="请为 '${GREEN}_acme-challenge.%s${RESET}' 创建一条 CNAME 记录\n指向 '${GREEN}%s${RESET}'."
    ###~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~###
    [en_i_have_confirmed]="I have confirmed (Enter to continue): "
    [cn_i_have_confirmed]="我已确认（回车继续）："
    ###~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~###
    ["en_cilium_requirement"]="Using Cilium as the network plugin, the host system must meet the following requirements:
                            #TDL#  1. Hosts with AMD64 or AArch64 architecture;
                            #TDL#  2. Linux kernel> = 4.19.57 or equivalent version (e.g., 4.18 on RHEL8)."
    ["cn_cilium_requirement"]="正在使用 Cilium 作为网络插件, 主机系统必须满足以下要求:
                            #TDL#  1.具有AMD64或AArch64架构的主机;
                            #TDL#  2.Linux内核> = 4.19.57或等效版本 (例如, 在RHEL8上为4.18)."
    ###~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~###
    [en_usage]="Usage: $0 [options]=[value] [options]=[value] ...
              #TDL#
              #TDL#Options:
              #TDL#  --image-registry                  # Image repository address (default: docker.io)
              #TDL#  --image-repository                # Image repository name (default: labring)
              #TDL#  --kubernetes-version              # Kubernetes version (default: 1.27.11)
              #TDL#  --cilium-version                  # Cilium version (default: 1.15.8)
              #TDL#  --cert-manager-version            # Cert Manager version (default: 1.14.6)
              #TDL#  --helm-version                    # Helm version (default: 3.14.1)
              #TDL#  --openebs-version                 # OpenEBS version (default: 3.10.0)
              #TDL#  --higress-version                 # Higress version (default: 2.0.1)
              #TDL#  --kubeblocks-version              # Kubeblocks version (default: 0.8.2)
              #TDL#  --metrics-server-version          # Metrics Server version (default: 0.6.4)
              #TDL#  --cloud-version                   # Sealos Cloud version (default: latest)
              #TDL#  --mongodb-version                 # MongoDB version (default: mongodb-6.0)
              #TDL#  --master-ips                      # Master node IP list, separated by commas (no need to fill in for single node and current execution node)
              #TDL#  --node-ips                        # Node node IP list, separated by commas
              #TDL#  --ssh-private-key                 # SSH private key path (default: $HOME/.ssh/id_rsa)
              #TDL#  --ssh-password                    # SSH password
              #TDL#  --pod-cidr                        # Pod subnet (default: 100.64.0.0/10)
              #TDL#  --service-cidr                    # Service subnet (default: 10.96.0.0/22)
              #TDL#  --cloud-domain                    # Cloud domain name
              #TDL#  --cloud-port                      # Cloud port (default: 443)
              #TDL#  --cert-path                       # Certificate path
              #TDL#  --key-path                        # Private key path
              #TDL#  --single                          # Whether to install on a single node (y/n)
              #TDL#  --acme                            # Enable ACME to automatically obtain certificates
              #TDL#  --acmedns-host                    # ACME DNS host (default: auth.acme-dns.io)
              #TDL#  --disable-acme                    # Disable ACME and use self-signed certificates
              #TDL#  --proxy-prefix                    # Sealos binary installation address proxy prefix
              #TDL#  --zh                              # Chinese prompt
              #TDL#  --en                              # English prompt
              #TDL#  --help                            # Help information"
    [cn_usage]="Usage: $0 [options]=[value] [options]=[value] ...
              #TDL#
              #TDL#Options:
              #TDL#  --image-registry                # 镜像仓库地址 (默认: docker.io)
              #TDL#  --image-repository              # 镜像仓库名称 (默认: labring)
              #TDL#  --kubernetes-version            # Kubernetes版本 (默认: 1.27.11)
              #TDL#  --cilium-version                # Cilium版本 (默认: 1.15.8)
              #TDL#  --cert-manager-version          # Cert Manager版本 (默认: 1.14.6)
              #TDL#  --helm-version                  # Helm版本 (默认: 3.14.1)
              #TDL#  --openebs-version               # OpenEBS版本 (默认: 3.10.0)
              #TDL#  --higress-version               # Higress版本 (默认: 2.0.1)
              #TDL#  --kubeblocks-version            # Kubeblocks版本 (默认: 0.8.2)
              #TDL#  --metrics-server-version        # Metrics Server版本 (默认: 0.6.4)
              #TDL#  --cloud-version                 # Sealos Cloud版本 (默认: latest)
              #TDL#  --mongodb-version               # MongoDB版本 (默认: mongodb-6.0)
              #TDL#  --master-ips                    # Master节点IP列表,使用英文逗号分割 (单节点且为当前执行节点可不填写)
              #TDL#  --node-ips                      # Node节点IP列表,使用英文逗号分割
              #TDL#  --ssh-private-key               # SSH私钥路径 (默认: $HOME/.ssh/id_rsa)
              #TDL#  --ssh-password                  # SSH密码
              #TDL#  --pod-cidr                      # Pod子网 (默认: 100.64.0.0/10)
              #TDL#  --service-cidr                  # Service子网 (默认: 10.96.0.0/22)
              #TDL#  --cloud-domain                  # 云域名
              #TDL#  --cloud-port                    # 云端口 (默认: 443)
              #TDL#  --cert-path                     # 证书路径
              #TDL#  --key-path                      # 私钥路径
              #TDL#  --single                        # 是否单节点安装 (y/n)
              #TDL#  --acme                          # 启用 ACME 自动获取证书
              #TDL#  --acmedns-host                  # ACME DNS host (默认: auth.acme-dns.io)
              #TDL#  --disable-acme                  # 禁用 ACME 并使用自签名证书
              #TDL#  --proxy-prefix                  # sealos二进制安装地址代理前缀
              #TDL#  --zh                            # 中文提示
              #TDL#  --en                            # 英文提示
              #TDL#  --help                          # 帮助信息"
  )
} 2>/dev/null
# ZLG=en mt_getprompt usage
# CLR=cyan mt_getprompt cn_i_have_confirmed
