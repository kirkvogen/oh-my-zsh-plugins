# Unalias open in case it is already defined. It seems that Babun may be defining the 'open' alias
# to the cygstart utility.
unalias open 2>/dev/null

#
# Opens a file or folder. Typically, the argument is a folder, so this function will be useful for
# opening the OS's file explorer.
#
# To run with find, follow this example:
#
# find src -mindepth 1 -maxdepth 1 -type d -exec zsh -c "(){$functions[open];}"' "$@"' zsh "{}" \;
#
open() {
	local arguments="$@"

	if [ $# -eq 0 ]; then
		arguments=.
	fi

	if which cygstart >& /dev/null; then
		cygstart "$arguments"
	elif which xdg-open >& /dev/null; then
		xdg-open "$arguments"
	else
		echo -e "An open utility, such as cygstart or xdg-open, does not appear to be installed."
        return 1
	fi
}