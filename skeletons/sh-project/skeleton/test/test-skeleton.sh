#!/bin/sh
#
# TEST-SKELETON.SH --Test various invocations of the skeleton program.
#
# Remarks:
# These tests check the behaviour of the skeleton program as a whole
# (i.e. they're not really unit tests), and in particular check the
# option processing, sample outputs, and exit status.
#
# TODO: Write some real tests for skeleton.
#
. midden
require tap

plan 2

#
# Test processing of the velocity option...
#
skeleton_output=$(../skeleton "hello, world")
skeleton_status=$?
ok_eq "$skeleton_output" "hello, world" \
    "echoes arguments to stdout"

todo 'Planned updates'
ok 0 "TODO: more tests..."
todo
exit 0
