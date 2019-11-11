#!/bin/bash

# pdf2searchablepdf
# Gabriel Staples
# Started: 9 Nov. 2019 
# - Source code: https://github.com/ElectricRCAircraftGuy/PDF2SearchablePDF

# Test run: `pdf2searchablepdf ./test_pdfs/test1.pdf`

start=$SECONDS

EXIT_SUCCESS=0
EXIT_ERROR=1

VERSION="0.1.0"
AUTHOR="Gabriel Staples"

print_help() {
	echo "Purpose: convert \"input.pdf\" to a searchable PDF named \"input_searchable.pdf\""
	echo "by using tesseract to perform OCR (Optical Character Recognition) on the PDF."
	echo 'Usage: `pdf2searchablepdf <input.pdf>`'
	echo "Source code: https://github.com/ElectricRCAircraftGuy/PDF2SearchablePDF"
}

print_version() {
	echo "pdf2searchablepdf version $VERSION"
}

if [ $# -eq 0 ]; then
	echo "No arguments supplied"
	print_help
	exit $EXIT_ERROR
fi

# Help menu
if [ "$1" == "-h" ]; then
	print_help
	exit $EXIT_SUCCESS
fi

# Version
if [ "$1" == "-v" ]; then
	print_version
	echo "Author = $AUTHOR"
	echo 'See `pdf2searchablepdf -h` for more info.'
	exit $EXIT_SUCCESS
fi

pdf_in=$1
# Strip file extension; see: https://stackoverflow.com/a/32584935/4561887
pdf_in_no_ext=$(echo $pdf_in | rev | cut -f 2- -d '.' | rev)
pdf_out="${pdf_in_no_ext}_searchable"

print_version
echo "================================================================================="
echo "Converting input PDF ($pdf_in) into a searchable PDF"
echo "================================================================================="

# 1. First, create temporary directory to place all intermediate files
# - name it "pdf2searchablepdf_temp_yyyymmdd-hhmmss.ns"

timestamp=$(date '+%Y%m%d-%H%M%S.%N')
# echo "timestamp = $timestamp"
temp_dir="pdf2searchablepdf_temp_${timestamp}"
# echo "temp_dir = $temp_dir"
echo "Creating temporary working directory: \"$temp_dir\""
mkdir -p $temp_dir
rm -rf $temp_dir/* # ensure it is empty

# 2. Convert the input pdf to a bunch of TIF files inside this directory
# - See my ans here: https://askubuntu.com/questions/150100/extracting-embedded-images-from-a-pdf/1187844#1187844
echo "Converting input PDF to a bunch of output TIF images inside temporary working directory."
echo "- THIS COULD TAKE A LONG TIME (up to 45 sec or so per page)! Manually watch the temporary"
echo "  working directory to see the pages created one-by-one to roughly monitor progress."
echo "- NB: each TIF file created is ~25MB, so ensure you have enough disk space for this"
echo "  operation to complete successfully."
# TODO: fix this in the future to print out a progress bar in the form of 1 dot every 10 sec, and a % complete
# every time another file is completed, based on how many total files there are in the pdf! Be sure to line wrap 
# ever 80 chars or so as well. This will require spinning off another process in the background that does a file
# check once per second or so to monitor progress. Once all files are created I can kill the background process
# which was doing that monitoring.
pdftoppm -tiff -r 300 $pdf_in $temp_dir/pg

# FOR DEVELOPMENT TO SPEED THIS UP BY USING PREVIOUSLY-GENERATED FILES INSTEAD 
# (comment out the above command, & uncomment the below command):
# cp pdf2searchablepdf_temp_20191110-231200.594322352/* $temp_dir

echo "All TIF files created."

# 3. Create a text file containing a list of all of the generated tif files
# - Use "version sort", or `sort -V` to enforce proper sorting between numbers which are multiple digits 
# vs 1 digit--ex: "pg-1.tiff" and "pg-10.tiff", for instance. See here: https://unix.stackexchange.com/a/41659/114401
find $temp_dir/* | sort -V > $temp_dir/file_list.txt

# 4. Run tesseract OCR on all generated TIF images.
# See: https://github.com/tesseract-ocr/tesseract/wiki/FAQ
echo "Running tesseract OCR on all generated TIF images in the temporary working directory."
echo "This could take some time."
echo "Searchable PDF will be generated at \"${pdf_out}.pdf\"."
tesseract $temp_dir/file_list.txt $pdf_out pdf
echo "Done! Searchable PDF generated at \"${pdf_out}.pdf\"."

# 5. Delete temp dir
echo "Removing temporary working directory at \"$temp_dir\"."
rm -rf $temp_dir
echo "Done!"


end=$SECONDS
duration_sec=$(( end - start ))
echo -e "\nTotal script run-time: $duration_sec sec"

echo "END OF pdf2searchablepdf."
