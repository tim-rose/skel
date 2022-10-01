#!/bin/sh
#
# SKELETON --An extended version of echo.
#
# Remarks:
# This script is useful for mocking up behaviour in testing.
# It uses midden for option parsing and logging.
#
# TODO: Add -f file option to load message from file.
#
. midden
require "log"
require "getopt"

version=
status=0

opts="d.delay=;e.stderr=;s.signal=;x.status"
opts="$opts;$LOG_GETOPTS"	# add standard logging options

#
# main() --Process cmd-line options etc.
#
main()
{
    if ! eval $(getopt_long_args -d "$opts" "$@"); then
	usage "$opts" >&2
	exit 2
    fi
    if [ "$help" ]; then
	usage "$opts" >&2
	exit 0
    fi

    if [ "$delay" ]; then
	info 'sleeping for %ds' "$delay"
	sleep $delay
    fi

    echo "$@"

    if [ "$signal" ]; then
	info 'sending %s signal to %s...' "$signal" "$$"
	kill -s $signal $$
    fi
    exit $status
}

#
# usage() --Echo this script's help message.
#
usage()
{
    printf 'skeleton version %s\n' "${version:-unknown}"
    getopt_usage "skeleton [options] -n name skeleton..." "$1"
    cat <<-EOF
	e.g.
	skeleton --stderr "error text" --delay 5 "some message"
	EOF
}

main "$@"
