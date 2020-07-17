#
# Makefile --Rules for building skeleton's test suite.
#
language = c sh

C_SRC = test-skeleton.c
C_MAIN_SRC = test-skeleton.c
SH_SRC = test-exec.sh

BUILD_PATH = ../libskeleton

include makeshift.mk test/tap.mk

$(C_MAIN): -lskeleton -lxtd

test-tap: $(C_MAIN) $(SH_TRG)
