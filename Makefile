ifneq (Yx86_64X,Y$(shell arch)X)
ifneq (Yaarch64X,Y$(shell arch)X)
only_for_run_on_amd64_or_arm64_machine:
	@echo "[WARN_TIP]: this tool $@ !!!" | sed 's@_@ @g'; true
endif
endif
###------------------------------BGN--------------------------------------------
en?=1
#dbg?=1
##
VE:=$(if $(ve),$(ve),$(if $(en),en,cn))
VD:=$(if $(vd),$(vd),$(if $(dbg),1,0))
VX:=$(if $(vx),-x,)
VQ:=@
ifeq (-x,$(VX))
VQ:=
VD:=1
endif
##
V2S+=SHV_CALLBYMK=1
V2S+=SHV_DEBUGTHZ=$(VD)
V2S+=SHV_THIZLANG=$(VE)
V2S+=SHV_RESET_HN=$(if $(HN),$(HN),)
V2S+=SHV_RESET_IP=$(if $(IP),$(IP),)
V2S+=SHV_RESET_PW=$(if $(PW),$(PW),$(if $(pswd),$(pswd),))
V2S+=SHV_NPAPLNOW=$(if $(NA),$(NA),$(if $(npan),$(npan),0))
V2S+=SHV_SKPEXIST=$(if $(SK),$(SK),$(if $(skip),$(skip),1))
##
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-include helper.mk

##extmod/xxxx
lst_optional+=extmods/ubt_incus
lst_optional+=showtip/cfgs4incus

lst_optional+=extmods/ubt_sealos
# [required]///////////////////////////////
all_required: $(lst_required)
	@printf "====>[done-task-list]<==== $(lst_required)" | xargs -n1; true
# [aliases]////////////////////////////////
showtip/:showtip/cfgs4incus

# [summary]////////////////////////////////
$(lst_required) $(lst_optional):
	$(VQ)($(V2S) SHV_TSKID=$(@F) SHV_TSKTP=$(@D) ${egs_${@F}} bash $(VX) instentry); true

##phony-targets
.PHONY: all_required $(lst_total)
###------------------------------END--------------------------------------------
