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
. "midden"
require "log"
require "getopt"
require "wordy"

version=
include=${SKELPATH:-/usr/local/share/skel}
script=${SKEL_FILTER:-cat}
name=
opts="f.force;I.include=$include;l.list;n.name=$name;c.camel;s.script=$script;V.version;w.windows;?.help"
opts="$opts;$LOG_GETOPTS"
sh_opts=

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
	usage "$opts"
	exit 0
    fi
    if [ "$version" ]; then
        printf 'skel version %s\n' "VERSION"
        exit 0
    fi

    log_getopts
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
    if ! filter=$(which "$script"); then
	log_quit 'cannot execute file "%s"' "$script"
    fi

    # REVISIT: read templates from stdin if no-args?
    for file; do
	local skel_path=$(resolve_path "$include" "$file.sha")

	if [ -f "$file" ]; then
	    skel_path=$file
	fi

	if [ ! "$skel_path" ]; then
	    err 'no such skeleton: "%s"' "$file"
	    continue
	fi
	fill_skeleton "$skel_path"
	# TODO: apply and remove post-processing script
    done
}

#
# usage() --Echo this program's help message.
#
usage()
{
    printf 'skel version %s\n' "$version"
    getopt_usage "skel [options] -n name skeleton..." "$1"
    cat <<-EOF
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

    for dir in $include; do
        debug 'list %s' "$dir"
        if [ -d "$dir" ]; then
	    find "$dir" -name "*.sha" | sed -e "s|$dir/||;s/[.]sha//g"
	fi
    done | sort -u
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
    local pascal_name="$(pascal_case $name)"
    local upper_name="$(echo $name | tr a-z A-Z)"
    local plural_name=$(plural $name)
    local plural_pascal_name="$(pascal_case $plural_name)"
    local plural_upper_name="$(echo $plural_name | tr a-z A-Z)"

    if [ "$camel" ]; then
	name="$(camel_case $name)"
    fi
    local transform="s/skeletons/$plural_name/g;s/Skeletons/$plural_pascal_name/g;s/SKELETONS/$plural_upper_name/g"
    local transform="$transform;s/skeleton/$name/g;s/Skeleton/$pascal_name/g;s/SKELETON/$upper_name/g"

    info 'loading skeleton "%s"' "$skel_file"
    debug 'name: "%s", "%s", "%s"' "$name" "$pascal_name" "$upper_name"
    debug 'plural.name: "%s", "%s", "%s"' "$plural_name" "$plural_pascal_name" "$plural_upper_name"

    sed -e "$transform" <"$skel_file" | "$filter" >"$tmp_file"

    sh_opts="${force:+-f} ${windows:+-w}"
    sh "$tmp_file" $sh_opts > "$idx_file"
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
{				# TODO: set transform, dammit.
    local file= zip_dir="zip-$$.d"
    for file; do
	mkdir "$zip_dir"
	(
	    cd "$zip_dir"
	    if quietly unzip -q "../$file"; then
		info 'processing zip file %s' "$file"
		log_cmd sed -i -e "$transform" ${script:+-f $script} $(find * -type f)
		zip -q "../$file" $(find * -type f)
	    fi
	)
	rm -rf "$zip_dir"
    done
}

main "$@"
