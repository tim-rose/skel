#
# Makefile --Build rules to install bash completion.
#
language = sh
subdir = bash-completion/completions
SHL_SRC = skel-complete.shl
LOCAL.SH_LINT_FLAGS = --shell=bash --exclude=SC2086,SC2207
include makeshift.mk

install: $(datadir)/skel

$(datadir)/skel: $(SHL_SRC)
	$(INSTALL_DATA) $? $@
