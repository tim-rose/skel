#
# Makefile --Build rules to install bash completion.
#
language = sh
subdir = bash-completion/completions
SHL_SRC = skel-complete.shl

include makeshift.mk

install: $(datadir)/skel

$(datadir)/skel: $(SHL_SRC)
	$(INSTALL_DATA) $? $@
