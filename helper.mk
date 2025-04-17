#$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
pfx_cfg:=update

##
lst_dfs+=myinit
lst_dfs+=sshkey
lst_dfs+=nvim

lst_required+=$(lst_dfs:%=$(pfx_cfg)/%)
##
lst_required+=$(pfx_cfg)/cfgs4ubt

# lst_optional+=$(pfx_cfg)/mywrapper
lst_optional+=$(pfx_cfg)/cfgs4vsc
lst_optional+=$(pfx_cfg)/cfgs4sshd
lst_optional+=$(pfx_cfg)/fix_ubt2204_n5n
##
lst_optional+=$(pfx_cfg)/cfgs4ntwk
egs_cfgs4ntwk+=SHV_N5N_USE_BR=$(if $(UB),$(UB),)
##
lst_optional+=$(pfx_cfg)/fix_aptmirurl
egs_fix_aptmirurl+=SHV_MIRURL_IDX=$(if $(MI),$(MI),0)
#$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
pfx_dev:=devel

lst_dev+=cmake
lst_dev+=golang
lst_dev+=nodejs
lst_dev+=rustlang
lst_dev+=checkpkgs
# lst_dev+=exts4vsc
lst_dev+=bunjs

lst_optional+=$(lst_dev:%=$(pfx_dev)/%)

#$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
pfx_pit:=binfiles
lst_optional+=$(pfx_pit)/msedge
lst_optional+=$(pfx_pit)/vscode
lst_optional+=$(pfx_pit)/jqlang
lst_optional+=$(pfx_pit)/shfmt
lst_optional+=$(pfx_pit)/ttyd
