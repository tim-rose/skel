SED_SRC = project.sed
#
# Makefile --Build rules for SKEL, the skeleton file processor.
#
language = sh nroff

SH_SRC = skel.sh
MAN1_SRC = skel.1

include devkit.mk

install: install-sh
uninstall: uninstall-sh
