#
# Makefile --Build rules for SKEL, the skeleton file processor.
#
language = sh nroff

SH_SRC = skel-shar.sh skel.sh
SED_SRC = keyword.sed
MAN1_SRC = skel-shar.1 skel.1

export VERSION = $(shell git describe --dirty)

include makeshift.mk

install: install-sh
uninstall: uninstall-sh
