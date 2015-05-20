MOAR = $(shell which moar)

perms:
	sudo setcap "cap_dac_override+ep cap_sys_rawio+ep" $(MOAR)
