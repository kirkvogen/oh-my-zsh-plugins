# if which cygpath >& /dev/null; then


# Starts the Atom editor. It assumes that Atom is in the path
#
# Note that to call this function for xargs, do the following:
#
# find -maxdepth 1 -type f | xargs zsh -lic "(){$functions[atom];}"' "$@"' zsh "$@" \;
#
atom() {

  if ! which cygpath >& /dev/null; then
    # Probably not running on Windows
    atom "$@"
    return
  fi

  cygpath -a -w "$@" | tr -s '\n' '\0' | xargs --null "$LOCALAPPDATA/atom/bin/atom"
}
