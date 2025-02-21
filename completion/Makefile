#
# Makefile --Build rules to install bash completion.
#
language = sh
subdir = bash_completion.d
SHL_SRC = skel-complete.shl

include makeshift.mk

install: $(SHL_SRC:%=$(sysconfdir)/%)
