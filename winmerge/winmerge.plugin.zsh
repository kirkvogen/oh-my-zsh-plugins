#
# Starts Winmerge. Note that to call this function for xargs, do the following:
#
wdiff() {
	WINMERGE=${WINMERGE-"/cygdrive/c/Progra~2/WinMerge/WinMergeU.exe"}
	if [ ! -f "${WINMERGE}" ]; then
		echo Unable to find WinMerge at ${WINMERGE}. Please set the environment \
		variable WINMERGE equal to the path of the WinMerge executable on your system.
        return 1
	fi
	
	if [ $# != 2 ] ; then
		## assert -- No arguments were supplied
		echo "usage: wdiff <file1|dir> <file2|dir>"
		return 2
	fi

	if [ -d "$1" ] && [ -d "$2" ]; then
		# Both argument are directories
		file1=`cygpath -a -w "$1"`
		file2=`cygpath -a -w "$2"`
		"${WINMERGE}" "$file1" "$file2" -r &
	elif [ -f "$1" ] && [ -f "$2" ]; then
		# Both argument are files
		file1=`cygpath -a -w "$1"`
		file2=`cygpath -a -w "$2"`
		"${WINMERGE}" "$file1" "$file2" &
	else
        if [ ! -f "$1" ] && [ ! -d "$1" ]; then
            echo "The following file or directory does not exist: $1"
        fi

        if [ ! -f "$2" ] && [ ! -d "$2" ]; then
            echo "The following file or directory does not exist: $2"
        fi
        
        if [ -f "$1" ] && [ -d "$2" ]; then
            echo "The arguments must either both be files or both be directories."
        fi
        
        if [ -d "$1" ] && [ -f "$2" ]; then
            echo "The arguments must either both be files or both be directories."
        fi
        
		return 3
	fi
}