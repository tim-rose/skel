#
# Makefile --Build rules to install bash completion.
#
language = sh
SH_SRC = skel-complete.sh
subdir = bash_completion.d

include makeshift.mk

install: $(SH_TRG:%=$(sysconfdir)/%)
