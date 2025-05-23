#!/bin/sh
# skel-shar: a shell archiver
#
# Contents:
# readlink()         --Define readlink(1) as needed...
# argv_or_stdin()    --output arguments (if specified) or lines from stdin.
# is_binary()        --Test if a file's content is "binary".
# is_missing_nl()    --Test if a file is missing a newline at end of file.
# archive_prologue() --Emit shar prologue.
# archive_symlink()  --Emit archive code for a symlink.
# archive_file()     --Emit archive code for a plain file.
# main()             --Archive a list of files into a shell self-extracting archive
#
# Options:
# -h  --follow symlinks
# -m  --encode binary files with base64 encoding (default is uuencode's default)
# -q  --avoid echo log messages (to stderr).
# -v  --echo log messages (to stderr).
# arg1...argn	--files to be archived
#
# Remarks:
# skel-shar provides a simple, portable machanism for archiving text
# files intended for distribution. The archive is printed to <stdout>,
# and may be redirected as required. All diagnostics are printed to
# <stderr>.
#
# The archive created by shar may be unpacked by running it as a
# Bourne shell script.
#
# @todo: preserve file permissions (use sed to construct arithmetic)
# @fixme: unpacking a directory error message
#
version=
options=hmvq_
usage="Usage: shar -$options files... >archive"
follow_symlink=1
uu_opts=
quiet=
verbose=
debug=

log_message()	{ printf "$@"; printf "\n"; } >&2
notice()	{ if [ ! "$quiet" ]; then log_message "$@"; fi; }
info()		{ if [ "$verbose" ]; then log_message "$@"; fi; }
debug()		{ if [ "$debug" ]; then log_message "$@"; fi; }
log_cmd()	{ debug "exec: %s" "$*"; "$@"; } >&2
log_quit()	{ notice "$@"; exit 1 ; }

#
# readlink() --Define readlink(1) as needed...
#
# Remarks:
# readlink(1) is common but not guranteed on all systems.
#
if ! type readlink >/dev/null 2>&1; then
    debug 'emulating readlink(1)'
    readlink()
    {
        local file="$1"

        if [ -h "$1" ]; then
            ls -l "$1" | sed -e 's/.* -> //'
            true
        else
            false
        fi
    }
fi


#
# argv_or_stdin() --output arguments (if specified) or lines from stdin.
#
# Remarks:
# This is an implementation of perl's behaviour wrt command arg.s
# and stdio.
#
argv_or_stdin()
{
    local arg

    if [ "$#" != "0" ]; then
        for arg; do
            echo "$arg";
        done
    else
        while read arg; do
            debug 'read arg: "%s"' "$arg"
            echo "$arg"
        done
    fi
}


#
# is_binary() --Test if a file's content is "binary".
#
# Remarks:
# This is a simple test: does the file contain any non-printable ASCII?
#
# The non-printable characters allowed are:
# * \0	   --utf16 MSB bytes (?)
# * \033   --colour formatting in log files etc.
# * \t\n.. --all the usual printf escapes
#
# Note that this does not handle UTF-8.
#
is_binary()
{
    local file="$1"

    n=$(tr -d '\000\033\a\b\t\r\n\f\v !-~' <"$file" | wc -c)
    if [ "$n" -ne 0 ]; then
        debug '%s: contains %d unprintable characters' "$file" "$n"
        true
    else
        false
    fi
}


#
# is_missing_nl() --Test if a file is missing a newline at end of file.
#
is_missing_nl()
{
    local file="$1"

    test "$(tail -c1 "$file")" != ""
}


#
# archive_prologue() --Emit shar prologue.
#
archive_prologue()
{
    cat <<- EOF
	#!/bin/sh
	# shell archive created on $(date)
	# by $USER@$(hostname)
	# from directory $PWD
	#
	# Contents:
	EOF
    for file; do
        echo "# $file"
    done
    echo "#"
    cat <<- 'EOF'
	force=
	eol=
	tmpfile="shar-$$.tmp"
	trap "rm -f $tmpfile*" 0

	while getopts "fw?" option
	do
	    case "$option" in
	    f)	force=1;;
	    w)	eol='s/$/\r/';;
	    \?)
	        echo "Usage: <file>.sh [-f] [-w] [files...]"  >&2
		exit 2;;
	    esac
	done
	shift $(($OPTIND - 1))

	match() { case "$1" in ($2) true;; (*) false;; esac; }

	is_selected()
	{
	    local target="$1"; shift

	    if [ $# -ne 0 ]; then
	        for candidate; do
	            match "$target" "$candidate" && return 0
	        done
	        false
	    else
	        true
	    fi
	}

	select_extract()
	{
	    local target="$1"; shift

	    if is_selected "$target" "$@"; then
	        if [ ! -e "$target" -o "$force" ]; then
	            mkdir -p $(dirname "$target")
	            mv "$tmpfile" "$target"
	        else
	            file_type="file exists, not overwritten"
	        fi
	        printf 'x %s\t%s\n' "$target" "$file_type"
	    fi
	}
	EOF
}


#
# archive_symlink() --Emit archive code for a symlink.
#
# Remarks:
# The symlink target is not checked; it might be utterly broken
# (although hopefully not when unpacked).
#
archive_symlink()
{
    local file="$1" target="$(readlink "$file")"

    notice "r %s\tsymlink" "$file"
    cat <<- EOF
	file_type="symlink to $target"
	ln -sf "$target" "\$tmpfile"
	EOF
}


#
# archive_file() --Emit archive code for a plain file.
#
# Remarks:
# There a several special cases here:
# * a "text" file
# * a "binary" file
# * a symlink
# * an empty file
# * a text file with a missing newline at end-of-file
#
archive_file()
{
    local file="$1"
    local eof_mark="[EOF@$file]"

    if [ -s "$file" ]; then
        if is_binary "$file"; then
            notice 'r %s\tbinary' "$file"
            echo 'file_type="binary"'
            echo "cat > \"\$tmpfile.uu\" << '$eof_mark'"
            uuencode $uu_opts "$file" < "$file"
            echo "$eof_mark"
            echo 'uudecode -o "$tmpfile" "$tmpfile.uu" && rm "$tmpfile.uu"'
        elif is_missing_nl "$file"  ; then
            notice 'r %s\tmissing-newline' "$file"
            echo 'file_type="missing newline"'
            echo "sed -e \"s/^X//;\$eol\" > \"\$tmpfile.nl\" << '$eof_mark'"
            sed -e "s/^/X/" "$file"
            echo ""		# add compensating newline
            echo "$eof_mark"	# ...so eof mark is on a new line.
            cat <<- EOF		# emit code to remove compensating newline
		file_size=\$(wc -c < "\$tmpfile.nl")
		dd ibs=1 count=\$((file_size-1)) < "\$tmpfile.nl" > "\$tmpfile" 2>/dev/null
		rm "\$tmpfile.nl"
		EOF
        else
            notice 'r %s\ttext' "$file"
            echo 'file_type="text"'
            echo "sed -e \"s/^X//;\$eol\" > \$tmpfile << '$eof_mark'"
            sed -e "s/^/X/" "$file"
            echo "$eof_mark"
        fi
    else
        notice 'r %s\tempty' "$file"
        echo 'file_type="empty"'
        echo "touch \"\$tmpfile\""
    fi
}


#
# main() --Archive a list of files into a shell self-extracting archive.
#
main()
{
    local status=0

    archive_prologue "$@"
    argv_or_stdin "$@" |
        {
            while read file; do
        	status=0
        	if [ -d "$file" ] ; then
                    notice "%s:\tdirectory	(not archived)" "$dir"
                    status=1
        	elif [ -h "$file" -a "$follow_symlink" ]; then
                    archive_symlink "$file"
        	elif [ -f "$file" ]; then	# note: matches symlinks too
        	    archive_file "$file" || status=1
        	elif [ ! -e "$file" ]; then
        	    notice 'r %s\tno such file (not archived)' "$file"
        	    status=1
        	else
        	    notice 'r %s\tunsupported file type (not archived)' "$file"
        	    status=1
        	fi
        	if [ "$status" -eq 0 ]; then
        	    cat <<- EOF
			select_extract "$file" "\$@"
			EOF
        	fi
            done
            exit "$status"
        }
    status=$?			# collect exit status from while loop
    return "$status"
}


while getopts "$options" opt
do
    case "$opt" in
    h)	follow_symlink=;;
    m)  uu_opts='-m';;
    v)	quiet= verbose=1 debug=;;
    q)	quiet=1 verbose= debug=;;
    _)	quiet= verbose=1 debug=1;;
    \?)
        printf 'skel-shar version %s\n' "VERSION" >&2
        echo $usage >&2
        exit 2;;
    esac
done
shift $(($OPTIND - 1))

main "$@"
