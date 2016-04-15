#
# Functions for writing the Windows-style or Unix-style path to the clipboard
#
wdir() {
	filepath=${1-.}
	cygpath -wa "$filepath" | tr -d '\n' > /dev/clipboard
}

udir() {
	filepath=${1-.}
	cygpath -ua "$filepath" | tr -d '\n' > /dev/clipboard
}
