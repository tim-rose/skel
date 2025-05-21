#!/bin/sh
#
# TEST-SHAR.SH --Unit tests for the shell archiver.
#
# Contents:
# mk_shar()          --Make a shell archive from the specified files.
# unpack_shar()      --Unpack a shell archive into a subdirectory.
# test_unpack_file() --Test that a file is unpacked correctly from an archive.
#
. midden
require tap
require test-more

# atexit "rm *.sha *.txt"
#atexit "rm -rf unpack-data"

#
# mk_shar() --Make a shell archive from the specified files.
#
mk_shar()
(   # in a sub-shell
    cd data; echo "$@" | ../../$archdir/skel-shar -q
)

#
# unpack_shar() --Unpack a shell archive into a subdirectory.
#
unpack_shar()
{
    local dir="$1" shar="$PWD/$2"; shift 2

    rm -rf "$dir"
    mkdir "$dir"
    ( cd "$dir" && sh "$shar" "$@"; )
}

#
# test_unpack_file() --Test that a file is unpacked correctly from an archive.
#
test_unpack_file()
{
    local file="$1"
    local size=$(stat --format '%s' "data/$file")
    local sum=$(sum <"data/$file")

    mk_shar "$file" > data.sha
    unpack_shar unpack-data data.sha | diag

    test -f "unpack-data/$file"
    ok "$?" "unpack %s" "$file"
    ok_eq "$(stat --format '%s' unpack-data/$file)" "$size" "%s size (%d)" "$file" "$size"
    ok_eq "$(sum <unpack-data/$file)" "$sum" "%s sum (%s)" "$file" "$sum"

    unpack_shar unpack-data data.sha "$file"
    test -f "unpack-data/$file"
    ok_eq "$?" "0" "unpack %s if requested" "$file"

    unpack_shar unpack-data data.sha some-other-file
    test -f "unpack-data/$file"
    ok_eq "$?" "1" "don't unpack %s if not requested" "$file"

    local dir=$(dirname "$file")
    if [ "$dir" != '.' ]; then
        test -d "unpack-data/$dir"
        ok_eq "$?" "1" "don't unpack subdir component (%s)" "$dir"
    fi
}

test_unpack_dir()
{
    local dir="$1"

    mk_shar "$dir" > data.sha
    unpack_shar unpack-data data.sha 2>&1 | diag

    test -d "unpack-data/$dir"
    ok_eq "$?" 1 "dir is not unpacked alone (%s)" "$dir"
}

main()
{
    plan 23

    test_unpack_file empty-file.txt
    test_unpack_file simple.txt
    test_unpack_file simple.bin
    test_unpack_file subdir/simple.txt
    test_unpack_dir subdir
    test_unpack_dir empty-subdir
}

main "$@"
