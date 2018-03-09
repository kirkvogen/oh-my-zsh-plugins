#
# ENSCRIPT default options
# Other ones to consider: -2 -- prints two pages per sheet
#                         -M Tabloid -- prints on 11 x 17 paper
#                                       (but you need to have the following
#                                        entry in your ~/.enscriptrc file:
# Media:	Tabloid		792	1224	18	36	774	1188
#
export ENSCRIPT="-E -M Letter -f DejaVuSansMono8 -F DejaVuSansMono-Bold8 -DDuplex:true -j -v \
--lines-per-page=120 '--header=\$D{%a %b %d %H:%M:%S %Y}|\$n|Page \$V\$% of \$='"

##
## Pretty prints a file to a PostScript file. You must have enscript installed.
##
## e.g.: _generate_postscript input.c output.ps <other enscript arguments>
##
_generate_postscript()
{
	local input_file="$1"
	local output_file="$2"

	shift 2

	if ! which enscript 2> /dev/null; then
		echo "Enscript is required, but it is not installed. Please install it."
		return
	fi

	if which cygpath >& /dev/null; then
        # Running in Cygwin. Convert path to Unix, else the title in the PDF might overly-long
        input_file=$(cygpath -a -u "$input_file")
    fi
    
	enscript --output="$output_file" --color "$input_file" "$@"
}

##
## Pretty prints a file to a PDF file. You must have enscript and ghostscript installed.
##
## e.g.: pdf input.c <other enscript arguments>
##
pdf()
{
	if [ $# = 0 ] ; then
		## assert -- No arguments were supplied
		echo "usage: pdf <file>"
		return
	fi

	if ! which gs 2> /dev/null; then
		echo "Ghostscript is required, but it is not installed. Please install it."
		return
	fi
	
	local input_file="$1"
	shift

	local postscript_file="$(mktemp --suffix .ps)"

	_generate_postscript "$input_file" "$postscript_file" "$@"

	local pdf_file="$(mktemp --suffix .pdf)"
	gs -sDEVICE=pdfwrite -dNOPAUSE -dQUIET -dBATCH -sOutputFile="$pdf_file" "$postscript_file"

	echo "created $pdf_file"
	rm "$postscript_file"
	
	if which cygstart >& /dev/null; then
		win_pdf_file=$(cygpath -a -w "$pdf_file")
		chmod u+x "$pdf_file"
		cmd /c "$win_pdf_file"
	elif which xdg-open >& /dev/null; then
		xdg-open "$pdf_file"
	else
		echo -e "Generated PDF: $pdf_file"
		return
	fi

	(sleep 10 && while [ true ]; do if rm "$pdf_file"; then break; else sleep 5; fi; done;) &
}

##
## Pretty prints a file to a printer. You must have enscript and lpr installed and the PRINTER
## variable defined.
##
## e.g.: pretty input.c <other enscript arguments>
##
pretty()
{
	if [ $# = 0 ] ; then
		## assert -- No arguments were supplied
		echo "usage: pretty <file>"
		return
	fi

	if [ -z "$PRINTER" ]; then
    	echo "The PRINTER variable must be defined e.g. //server/printer"
		return
	fi

	if ! which lpr 2> /dev/null; then
		echo "The lpr utility is required, but it is not installed. Please install it."
		return
	fi

	local input_file="$1"
	shift

	local postscript_file="$(mktemp --suffix .ps)"

	_generate_postscript "$input_file" "$postscript_file" "$@"

	lpr -d "$PRINTER" "$postscript_file"

	rm "$postscript_file"
}

#
# Instructions for installing fonts
#
# 1. Download the fonts
#
#    mkdir -p ~/.fonts
#    cd ~/.fonts
#    curl -L -O http://mirrors.ctan.org/fonts/dejavu/type1/DejaVuSansMono.pfb
#    curl -L -O http://mirrors.ctan.org/fonts/dejavu/type1/DejaVuSansMono.pfm
#    curl -L -O http://mirrors.ctan.org/fonts/dejavu/type1/DejaVuSansMono-Oblique.pfb
#    curl -L -O http://mirrors.ctan.org/fonts/dejavu/type1/DejaVuSansMono-Oblique.pfm
#    curl -L -O http://mirrors.ctan.org/fonts/dejavu/type1/DejaVuSansMono-BoldOblique.pfb
#    curl -L -O http://mirrors.ctan.org/fonts/dejavu/type1/DejaVuSansMono-BoldOblique.pfm
#    curl -L -O http://mirrors.ctan.org/fonts/dejavu/type1/DejaVuSansMono-Bold.pfb
#    curl -L -O http://mirrors.ctan.org/fonts/dejavu/type1/DejaVuSansMono-Bold.pfm
#    curl -L -O http://mirrors.ctan.org/fonts/dejavu/afm/DejaVuSansMono.afm
#    curl -L -O http://mirrors.ctan.org/fonts/dejavu/afm/DejaVuSansMono-Oblique.afm
#    curl -L -O http://mirrors.ctan.org/fonts/dejavu/afm/DejaVuSansMono-BoldOblique.afm
#    curl -L -O http://mirrors.ctan.org/fonts/dejavu/afm/DejaVuSansMono-Bold.afm
#
# 2. Run: mkafmmap *.afm
#
#    Note that if you are using Cygwin and don't have mkafmmap, install the tetex-bin package. It
#    should come as a dependency of that package.
#
# 3. Create ~/.enscriptrc with the following (replacing the final path containing the .fonts with a
#    folder the corresponding path on your environment; ~/.fonts doesn’t appear to work).
#
#    AFMPath: /usr/share/enscript/afm:/usr/share/ghostscript/fonts:FULL_PATH_TO_YOUR_DOT_FONTS_FOLDER:
#
#    DownloadFont: DejaVuSansMono
#    DownloadFont: DejaVuSansMono-Bold
#    DownloadFont: DejaVuSansMono-BoldOblique
#    DownloadFont: DejaVuSansMono-Oblique
#