#
# Starts Notepad++.
#
# Note that to call this function for xargs, do the following:
#
# find -maxdepth 1 -type f | xargs zsh -lic "(){$functions[ne];}"' "$@"' zsh "$@" \;
#
ne() {
	NOTEPAD_PLUS_PLUS=${NOTEPAD_PLUS_PLUS-"/cygdrive/c/Progra~2/Notepad++/notepad++.exe"}
	if [ ! -f "${NOTEPAD_PLUS_PLUS}" ]; then
		echo Unable to find Notepad++ at ${NOTEPAD_PLUS_PLUS}. Please set the environment \
		variable NOTEPAD_PLUS_PLUS equal to the path of the Notepad++ executable on your system.
        return 1
	fi
	
	files=
	while [ $# -ne 0 ]
	do
		file=$1

		if [ ! -f "${file}" ]; then
			# The file does not exist, so create it. Create it with a newline so it starts out with
			# Unix-style newlines.
			>"${file}"
			echo >> "${file}"
		fi
		
		winfile=`cygpath -a -w "${file}"`
		if echo ${file} | grep "\s" > /dev/null ; then
			# The file has a space in it
			winfile=`cygpath -a -ws "${file}"`
		fi

		files="${files} ${winfile}"

		shift
	done

	cygstart "${NOTEPAD_PLUS_PLUS}" "${files}"
}
