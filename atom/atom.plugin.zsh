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

  # Separate flags from file arguments
  while getopts ":?" opt; do
    case $opt in
      \?)
        if [ -z $flags ]; then
          local flags="-$OPTARG"
        else
          local flags="$flags -$OPTARG"
        fi
        ;;
    esac
  done

  shift $(($OPTIND - 1))

  cygpath -a -w "$@" | tr -s '\n' '\0' | xargs --null "$LOCALAPPDATA/atom/bin/atom" "$flags"
}
