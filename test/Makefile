#
# Makefile --build rules for Skel's test directory
#

SH_SRC = test-shar.sh
language = sh

include makeshift.mk test/tap.mk

test-tap: $(SH_TRG)

distclean clean: clean-local
clean-local:; $(RM) -r unpack-data
