#!/usr/bin/env bash
## coding=utf-8
##==================================----------==================================
## FILE: a2-load-envs.sh
## MYPG: abldg, https://github.com/abldg
## LSCT: 2025-04-18 05:59:32
## VERS: 0.2
##==================================----------==================================

mt_load_envs() {
  {
    local DFTVARS=(
      CLOUD_DIR,${HOME}/.sealos/cloud
      SEALOS_VERSION,v5.0.1
      cloud_version,latest
      ##~~~~~~~~~~~~~~~~~~~~~~~~~~~
      # mongodb_version,mongodb-6.0
      # master_ips
      # node_ips
      # ssh_private_key
      # ssh_password
      # pod_cidr
      # service_cidr
      # cloud_domain
      # cloud_port
      # input_cert
      # cert_path
      # key_path
      # single,y/n
      # acme,y/n
      ##~~~~~~~~~~~~~~~~~~~~~~~~~~~
      image_registry,docker.io
      image_repository,labring
      kubernetes_version,1.28.11
      cilium_version,1.15.8
      cert_manager_version,1.14.6
      helm_version,3.16.2
      openebs_version,3.10.0
      higress_version,2.0.1
      kubeblocks_version,0.8.2
      metrics_server_version,0.6.4
      victoria_metrics_k8s_stack_version,1.96.0
      acmedns_host,auth.acme-dns.io
    )
    ##
    xf_assign() {
      local p= x= #args=($@)
      for x in ${DFTVARS[@]}; do
        set -- ${x//,/ }
        if [ $# -eq 1 ]; then
          printf '%s=\n' $1
        else
          printf '%s=${%s:-"%s"}\n' $1 $1 $2
        fi
      done
    }
    ##
    set -- $1 $(mt_locate_thzfunc)
    [ $# -eq 2 ] && [ $1 -ot $2 ] && rm -f $1
    [ -e $1 ] || xf_assign >$1
    [ -e $1 ] && . $1
  } 2>/dev/null
}
mt_load_envs .env.sh
