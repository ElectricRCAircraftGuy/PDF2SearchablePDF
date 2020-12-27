#!/bin/bash

# pdf2searchablepdf
# Gabriel Staples
# Started: 9 Nov. 2019
# - Source code: https://github.com/ElectricRCAircraftGuy/PDF2SearchablePDF

# Test runs:
#   Convert test pdfs:
#     pdf2searchablepdf ./test_pdfs/test1.pdf
#     pdf2searchablepdf ./test_pdfs/Wikipedia_pdf_screenshot.pdf
#   Convert a whole directory of images into a single, searchable pdf:
#     pdf2searchablepdf test_imgs/
#   Print help menu
#     pdf2searchablepdf -h
#     pdf2searchablepdf -?
#   Print version
#     pdf2searchablepdf -v

start=$SECONDS

EXIT_SUCCESS=0
EXIT_ERROR=1

VERSION="0.4.0"
AUTHOR="Gabriel Staples"

print_help() {
    echo 'Purpose: convert "input.pdf" to a searchable PDF named "input_searchable.pdf"'
    echo 'by using tesseract to perform OCR (Optical Character Recognition) on the PDF.'
    echo 'Usage:    `pdf2searchablepdf <input.pdf | dir_of_imgs> [lang]` = if the 1st argument is'
    echo '            to an input pdf, then convert input.pdf to input_searchable.pdf using language'
    echo '            "lang" for OCR. Otherwise, if the 1st argument is a path to a directory containing'
    echo '            a bunch of images, convert the whole directory of images into a single PDF, using'
    echo '            language "lang" for OCR!'
    echo '          `pdf2searchablepdf`    = print help menu'
    echo '          `pdf2searchablepdf -h` = print help menu'
    echo '          `pdf2searchablepdf -?` = print help menu'
    echo '          `pdf2searchablepdf -v` = print author & version'
    echo 'Examples: `pdf2searchablepdf mypdf.pdf deu` = convert mypdf.pdf to a searchable PDF, using'
    echo '            German text OCR, or'
    echo '          `pdf2searchablepdf mypdf.pdf` for English text OCR (the default).'
    echo '          `pdf2searchablepdf dir_of_imgs` = convert all images in this directory, "dir_of_imgs",'
    echo '            to a single, searchable PDF.'
    echo '  The optional [lang] argument allows you to perform OCR in your language of choice.'
    echo '  This parameter will be passed on to tesseract. You must use ISO 639-2 3-letter language'
    # Note that the ISO 639-2 language code requirement is mentioned in the man pages here:
    # https://github.com/tesseract-ocr/tesseract/blob/master/doc/tesseract.1.asc
    echo '  codes. Ex: "deu" for German, "dan" for Danish, "eng" for English, etc.'
    echo '  See the "LANGUAGES" section of the tesseract man pages (`man tesseract`) for a'
    echo '  complete list. If the [lang] parameter is not given, English will be used by default.'
    echo '  If you don'"'"'t have a desired language installed, it may be obtained from one of the'
    echo '  following 3 repos (see tesseract man pages for details):'
    echo '    - https://github.com/tesseract-ocr/tessdata_fast'
    echo '    - https://github.com/tesseract-ocr/tessdata_best'
    echo '    - https://github.com/tesseract-ocr/tessdata'
    echo '  To install a new langauge, simply download the respective "*.traineddata" file from one of'
    echo '  the 3 repos above and copy it to your tesseract installation'"'"'s "tessdata" directory.'
    echo '  See "Post-Install Instructions" here:'
    echo '  https://github.com/tesseract-ocr/tesseract/wiki/Compiling-%E2%80%93-GitInstallation.'
    echo 'Source code: https://github.com/ElectricRCAircraftGuy/PDF2SearchablePDF'
}

print_version() {
    echo "pdf2searchablepdf version $VERSION"
    echo "Author = $AUTHOR"
    echo 'See `pdf2searchablepdf -h` for more info.'
}

parse_args() {
    if [ $# -eq 0 ]; then
        echo "No arguments supplied"
        print_help
        exit $EXIT_ERROR
    fi

    # Help menu
    if [ "$1" == "-h" ] || [ "$1" == "-?" ]; then
        print_help
        exit $EXIT_SUCCESS
    fi

    # Version
    if [ "$1" == "-v" ]; then
        print_version
        exit $EXIT_SUCCESS
    fi
}

main() {
    print_version
    lang=${2:-eng}
    echo "Language = $lang"

    # Determine if the 1st argument is a directory (of images) or a file (input PDF)
    # - See: https://stackoverflow.com/questions/59838/check-if-a-directory-exists-in-a-shell-script
    if [ -d "$1" ]; then
        # Convert a directory of images into a searchable pdf

        # Remove trailing slash if there is one
        # - see: https://unix.stackexchange.com/questions/198045/how-to-strip-the-last-slash-of-the-directory-path/198049#198049
        dir_of_imgs="${1%/}"
        # echo "dir_of_imgs = \"$dir_of_imgs\"" # debugging
        temp_dir=""

        echo "================================================================================="
        echo "1st parmeter is a directory, so we are assuming it contains a bunch of images"
        echo "you'd like converted to a PDF. PLEASE ENSURE THIS DIRECTORY CONTAINS ONLY IMAGES!"
        echo "Converting all files (images) inside directory \"$dir_of_imgs\""
        echo "into a searchable PDF."
        echo "================================================================================="

        # Create a text file containing a list of all of the files in this dir
        # - Use "version sort", or `sort -V` to enforce proper sorting between numbers which are multiple digits vs
        #   1 digit--ex: "pg-1.tiff" and "pg-10.tiff", for instance. See here: https://unix.stackexchange.com/a/41659/114401
        file_list_path="${dir_of_imgs}/file_list.txt"
        # Ensure file_list_path doesn't yet exist, so that this filename won't get included inside this file itself as
        # part of the list (useful in case this file was left around from a previous run)
        rm -f "$file_list_path"
        find "$dir_of_imgs"/* | sort -V > "$file_list_path"

        pdf_out="${dir_of_imgs}_searchable"

        echo "Running tesseract OCR on all files (better be images) in the directory you provided."
    else
        # Convert a single input pdf into a searchable pdf

        pdf_in="$1"

        echo "================================================================================="
        echo "Converting input PDF ($pdf_in) into a searchable PDF"
        echo "================================================================================="

        # Strip file extension; see: https://stackoverflow.com/a/32584935/4561887
        pdf_in_no_ext="$(echo "$pdf_in" | rev | cut -f 2- -d '.' | rev)"
        pdf_out="${pdf_in_no_ext}_searchable"

        # 1. First, create temporary directory to place all intermediate files
        # - name it "pdf2searchablepdf_temp_yyyymmdd-hhmmss.ns"

        timestamp="$(date '+%Y%m%d-%H%M%S.%N')"
        # echo "timestamp = \"$timestamp\""
        temp_dir="pdf2searchablepdf_temp_${timestamp}"
        # echo "temp_dir = \"$temp_dir\""
        echo "Creating temporary working directory: \"$temp_dir\""
        mkdir -p "$temp_dir"
        rm -rf "$temp_dir"/* # ensure it is empty

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
        pdftoppm -tiff -r 300 "$pdf_in" "$temp_dir/pg"

        # FOR DEVELOPMENT TO SPEED THIS UP BY USING PREVIOUSLY-GENERATED FILES INSTEAD
        # (comment out the above command, & uncomment the below command):
        # cp "pdf2searchablepdf_temp_20191110-231200.594322352"/* "$temp_dir"

        echo "All TIF files created."

        # 3. Create a text file containing a list of all of the generated tif files
        # - Use "version sort", or `sort -V` to enforce proper sorting between numbers which are multiple digits vs
        #   1 digit--ex: "pg-1.tiff" and "pg-10.tiff", for instance. See here: https://unix.stackexchange.com/a/41659/114401
        file_list_path="${temp_dir}/file_list.txt"
        find "$temp_dir"/* | sort -V > "$file_list_path"

        echo "Running tesseract OCR on all generated TIF images in the temporary working directory."
    fi

    # Run tesseract OCR on all images.
    # See: https://github.com/tesseract-ocr/tesseract/wiki/FAQ
    echo "This could take some time."
    echo "Searchable PDF will be generated at \"${pdf_out}.pdf\"."
    tesseract -l "$lang" "$file_list_path" "$pdf_out" pdf
    echo "Done! Searchable PDF generated at \"${pdf_out}.pdf\"."

    # 5. Delete temp dir
    if [ "$temp_dir" != "" ]; then
        echo "Removing temporary working directory at \"$temp_dir\"."
        rm -rf "$temp_dir"
        echo "Done!"
    fi

    end="$SECONDS"
    duration_sec="$(( end - start ))"
    # Get duration in min too; see my ans here:
    # https://stackoverflow.com/questions/12722095/how-do-i-use-floating-point-division-in-bash/58479867#58479867
    duration_min="$(printf %.3f $(echo "$duration_sec/60" | bc -l))"
    echo -e "\nTotal script run-time: $duration_sec sec ($duration_min min)."
}

# ----------------------------------------------------------------------------------------------------------------------
# Program entry point
# ----------------------------------------------------------------------------------------------------------------------

parse_args "$@"
time main "$@"
echo "END OF pdf2searchablepdf."


