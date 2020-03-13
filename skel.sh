#!/bin/sh
#
# SKEL --Create files from a skeleton.
#
# Contents:
# main()           --Process cmd-line options etc.
# usage()          --echo this script's help message.
# list_skeletons() --List the skeletons in skel's include path.
# fill_skeleton()  --Expand a skeleton file, replacing template variables etc.
# skel_binary()    --Expand a binary skeleton file, assumed to be a zip.
#
# Remarks:
# This utility creates file(s) from supplied templates.  The templates
# are ".sha" shell archives; the template file undergoes keyword
# expansion before the archive is unpacked.  This allows both the name
# and the content to manipulated in a uniform way.
#
# TODO: implement bash expansion support?
# TODO: customised replacements via additional sed/conf file.
#

. midden
require log
require getopt
require conjugate

version=
build=

include=${SKELPATH:-/usr/local/share/skel}
name=
opts="f.force;I.include=$include;l.list;n.name=$name;?.help"
opts="$opts;$LOG_GETOPTS"

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
    log_getopts
    info 'skel version %s.%s' "$version" "$build"

    if [ "$list" ]; then
	list_skeletons
	exit 0
    fi

    if [ "$#" -eq 0 ]; then
	log_quit "no template specified"
    fi
    if [ "$name" ]; then
	name=$(snake_case "$name")
    else
	log_quit "no name specified"
    fi

    # REVISIT: read templates from stdin if no-args?
    for file; do
	local skel_path=$(resolve_path "$include" "$file")

	if [ -f "$file" ]; then
	    skel_path=$file
	fi

	if [ ! "$skel_path" ]; then
	    err 'no such skeleton: "%s"' "$file"
	    continue
	fi
	fill_skeleton "$skel_path"
    done
}

#
# usage() --echo this script's help message.
#
usage()
{
    getopt_usage "skel [options] -n name skeleton..." "$1"
    cat <<EOF
e.g.
skel -n my_new_project c-project"
EOF
}

#
# list_skeletons() --List the skeletons in skel's include path.
#
list_skeletons()
{
    local IFS=:
    for dir in "$include"; do
        if [ -d "$dir" ]; then
	    printf '%s:\n' "$dir"
            ls "$dir"
	fi
    done
}

#
# fill_skeleton() --Expand a skeleton file, replacing template variables etc.
#
# Remarks:
# The skeleton files are shell archives.
#
fill_skeleton()
{
    local status=
    local skel_file=$1 tmp_file=skel-$$.sh idx_file="skel-idx-$$.txt"
    local camel_name="$(camel_case $name)"
    local upper_name="$(echo $name | tr a-z A-Z)"
    local transform="s/skeleton/$name/g;s/Skeleton/$camel_name/g;s/SKELETON/$upper_name/g"

    info 'loading skeleton "%s"' "$skel_file"
    debug 'name: "%s", "%s", "%s"' "$name" "$camel_name" "$upper_name"

    sed -e "$transform"	<"$skel_file" >"$tmp_file"

    if [ "$force" ]; then
	sh "$tmp_file" -f
    else
	sh "$tmp_file"
    fi > "$idx_file"
    status="$?"

    if [ "$status" -eq 0 ]; then
	while read action file type; do
	    info "%s %s" "$file" "$type"
	    if [ "$type" = "binary" ]; then
		skel_binary "$file"
	    fi
	done <"$idx_file"
    fi

    rm "$tmp_file" "$idx_file"
    return "$status"
}

#
# skel_binary() --Expand a binary skeleton file, assumed to be a zip.
#
# Remarks:
# Several applications use a zip-compressed collection of XML files
# to store content.
#
# See Also:
# midden/moxie.shl
#
skel_binary()
{
    local file= zip_dir="zip-$$.d"
    for file; do
	mkdir "$zip_dir"
	(
	    cd "$zip_dir"
	    if unzip -q "../$file"; then
		info 'processing zip file %s' "$file"
		sed -i -e "$transform" $(find * -type f)
		zip -q "../$file" $(find * -type f)
	    fi
	)
	rm -rf "$zip_dir"
    done
}

main "$@"
