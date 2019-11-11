#!/bin/bash

# pdf2searchablepdf
# Gabriel Staples
# Started: 9 Nov. 2019 
# - Source code: https://github.com/ElectricRCAircraftGuy/PDF2SearchablePDF

# Test run: `pdf2searchablepdf ./test_pdfs/test1.pdf`

start=$SECONDS

EXIT_SUCCESS=0
EXIT_ERROR=1

print_help() {
	echo "Purpose: convert \"input.pdf\" to a searchable PDF named \"input_searchable.pdf\""
	echo "by using tesseract to perform OCR (Optical Character Recognition) on the PDF."
	echo 'Usage: `pdf2searchablepdf <input.pdf>`'
}

if [ $# -eq 0 ]; then
	echo "No arguments supplied"
	print_help
	exit $EXIT_ERROR
fi

if [ "$1" == "-h" ]; then
	print_help
	exit $EXIT_SUCCESS
fi

pdf_in=$1
echo "================================================================================="
echo "Converting input PDF ($pdf_in) into a searchable PDF"
echo "================================================================================="

# First, create temporary directory to place all intermediate files
# - name it "pdf2searchablepdf_temp_yyyymmdd-hhmmss.ns"

timestamp=$(date '+%Y%m%d-%H%M%S.%N')
# echo "timestamp = $timestamp"
temp_dir="pdf2searchablepdf_temp_${timestamp}"
# echo "temp_dir = $temp_dir"
echo "Creating temporary working directory: \"$temp_dir\""
mkdir -p $temp_dir
rm -rf $temp_dir/* # ensure it is empty

# Convert the input pdf to a bunch of TIF files inside this directory
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
# pdftoppm -tiff -r 300 $pdf_in $temp_dir/pg

# FOR DEVELOPMENT TO SPEED THIS UP:
cp pdf2searchablepdf_temp_20191110-231200.594322352/ $temp_dir

echo "All TIF files created."

end=$SECONDS
duration_sec=$(( end - start ))
echo -e "\nTotal script run-time: $duration_sec sec"

echo "END"



# pdfimages -v
# pdfimages -list 10pgs.pdf 

# pdfimages -tiff 10pgs.pdf imgs

# mkdir imgs
# pdfimages -tiff 10pgs.pdf imgs/out

# sudo apt update
# sudo apt install tesseract-ocr

# sudo apt install exactimage
# hocr2pdf 