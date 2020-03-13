#!/bin/sh
#
# TEST-EXEC.SH --Test various invocations of the skeleton program.
# 
# Remarks:
# These tests check the behaviour of the skeleton program as a whole
# (i.e. they're not unit tests), and in particular check the
# option processing, sample outputs, and exit status.
#
. midden
require tap

plan 3

skeleton_result=$(../$archdir/skeleton --velocity=100km/h 2>/dev/null | grep velocity)
ok_eq "$skeleton_result" "velocity: 27.778m/s" \
    "computes skeleton-icity for 100km/h"

todo 'when I get some time '
ok 0 "return failure status for unrecognised option"
ok 1 "more boundary condition tests..."
todo
exit 0
