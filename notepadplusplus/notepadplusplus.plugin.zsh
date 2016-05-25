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

  cygpath -a -w "$@" | tr -s '\n' '\0' | xargs --null "${NOTEPAD_PLUS_PLUS}"
}
