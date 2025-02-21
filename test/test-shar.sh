#!/bin/sh
#
# TEST-SHAR.SH --Unit tests for the shell archiver.
#
PATH=..:$PATH
. midden
require tap
require test-more

# atexit "rm *.sha *.txt"
#atexit "rm -rf unpack-data"

mk_shar()
(   # in a sub-shell
    cd data; echo "$@" | ../../$archdir/skel-shar -q
)

unpack_shar()
{
    local dir="$1" shar="$PWD/$2"; shift 2

    rm -rf "$dir"
    mkdir "$dir" 
    ( cd "$dir" && sh "$shar" "$@"; )
}

test_unpack()
{
    local file="$1"
    local size=$(stat --format '%s' "data/$file")
    local sum=$(sum <"data/$file")

    mk_shar "$file" > data.sha
    unpack_shar unpack-data data.sha | diag
    
    test -e "unpack-data/$file"
    ok "$?" "unpack %s" "$file"
    ok_eq "$(stat --format '%s' unpack-data/$file)" "$size" "%s size (%d)" "$file" "$size"
    ok_eq "$(sum <unpack-data/$file)" "$sum" "%s sum (%s)" "$file" "$sum"

    unpack_shar unpack-data data.sha "$file"
    test -e "unpack-data/$file"
    ok_eq "$?" "0" "unpack %s if requested" "$file"

    unpack_shar unpack-data data.sha some-other-file
    test -e "unpack-data/$file"
    ok_eq "$?" "1" "don't unpack %s if not requested" "$file"

    local dir=$(dirname "$file")
    if [ "$dir" != '.' ]; then
        test -d "unpack-data/$dir"
        ok_eq "$?" "1" "don't unpack subdir component (%s)" "$dir"
    fi
}

main()
{
    plan 21

    test_unpack empty-file.txt
    test_unpack simple.txt
    test_unpack simple.bin
    test_unpack subdir/simple.txt
}

main "$@"
