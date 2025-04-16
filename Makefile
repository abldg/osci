ifneq (Yx86_64X,Y$(shell arch)X)
only_for_run_on_x64_machine:
	@echo "[WARN_TIP]: this tool $@ !!!" | sed 's@_@ @g'; true
else
###------------------------------BGN--------------------------------------------
VX:=$(if $(VBSE),-x,$(if $(nx),,-x))
ifeq (,$(VX))
VQ:=@
else
VQ:=
endif
##
V2S+=SHV_CALLBYMK=1
V2S+=SHV_RESET_HN=$(if $(HN),$(HN),)
V2S+=SHV_RESET_IP=$(if $(IP),$(IP),)
V2S+=SHV_RESET_PW=$(if $(PW),$(PW),$(if $(pswd),$(pswd),))
V2S+=SHV_EXIST_SK=$(if $(SK),$(SK),$(if $(skip),$(skip),1))
V2S+=SHV_NPAPLNOW=$(if $(NP),$(NP),$(if $(npnn),$(npnn),0))
##
V2S+=SHV_PCHS_DIR=$(abspath $(wildcard */*pchs))
##
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-include helper.mk

##extmod/xxxx
lst_optional+=extmods/incus_ubt
lst_optional+=showtip/cfgs4incus

lst_optional+=extmods/devstack_ubt
# [required]///////////////////////////////
all_required: $(lst_required)
	@printf "====>[done-task-list]<==== $(lst_required)" | xargs -n1; true
# [aliases]////////////////////////////////
showtip/:showtip/cfgs4incus

# [summary]////////////////////////////////
$(lst_required) $(lst_optional):
	@(SHV_TSKID=$(@F) SHV_TSKTP=$(@D) $(V2S) bash $(VX) instentry); true

##phony-targets
.PHONY: all_required $(lst_total)
###------------------------------END--------------------------------------------
endif
