#
# ENSCRIPT default options
# Other ones to consider: -2 -- prints two pages per sheet
#                         -M Tabloid -- prints on 11 x 17 paper
#                                       (but you need to have the following
#                                        entry in your ~/.enscriptrc file:
# Media:	Tabloid		792	1224	18	36	774	1188
#
export ENSCRIPT="-E -M Letter -f DejaVuSansMono8 -F DejaVuSansMono-Bold8 -DDuplex:true -j -v --lines-per-page=120 '--header=\$D{%a %b %d %H:%M:%S %Y}|\$n|Page \$V\$% of \$='"

##
## This converts a textfile to PDF. You must have enscript and ghostscript
## installed in your Cygwin environment.
##
## Examples of syntax:
##
## 1. On a single file: pdf myfile.c <other enscript arguments>
## 2. On standard output: grep this that.c | pdf --output=search.pdf
##
pdf()
{
	if [ $# = 0 ] ; then
		## assert -- No arguments were supplied
		echo "usage: pdf <file> [-keep]"
		echo "(by specifying '-keep' the PDF will be saved and the PDF will not be displayed on screen)."
		return
	fi
	
	if ! which enscript 2> /dev/null; then
		echo "Enscript is required, but it is not installed. Please install it."
		return
	fi

	if ! which gs 2> /dev/null; then
		echo "Ghostscript is required, but it is not installed. Please install it."
		return
	fi

	local file="$1"
	
	shift
	
	if which cygpath >& /dev/null; then
        # Running in Cygwin. Convert path to Unix, else the title in the PDF might overly-long
        file=$(cygpath -a -u "$file")
    fi
    
	postscript_file="$file-$RANDOM.ps"
	pdf_file="$file-$RANDOM.pdf"

	enscript --output="$postscript_file" --color "$file" "$@"
	gs -sDEVICE=pdfwrite -dNOPAUSE -dQUIET -dBATCH -sOutputFile="$pdf_file" "$postscript_file"

	echo "created $pdf_file"
	rm "$postscript_file"
	
	if which cygstart >& /dev/null; then
		# The wait actually doesn't work with this command. To get the wait to work, the Acrobat
		# Reader executable would need to be called directly.
		cygstart --wait "$pdf_file"
	elif which xdg-open >& /dev/null; then
		xdg-open "$pdf_file"
	else
		echo -e "Generated PDF: $pdf_file"
		return
	fi

	(sleep 10 && while [ true ]; do if rm "$pdf_file"; then break; else sleep 5; fi; done;) &
}
