#
# Makefile --Build rules for skeleton.
#
export VERSION ?= $(shell git describe --dirty 2>/dev/null)

language = c conf nroff

C_SRC = skeleton.c
C_MAIN_SRC = skeleton.c
LOCAL.C_CPPFLAGS = -I libskeleton/include

CONF_SRC = skeleton.conf
MAN1_SRC = skeleton.1

include makeshift.mk doxygen.mk

$(C_MAIN): libskeleton/$(archdir)/lib.a -lxtd

install: install-all
uninstall: uninstall-all
