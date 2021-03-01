#!/bin/bash

# pdf2searchablepdf
# Gabriel Staples
# Started: 9 Nov. 2019
# - Source code: https://github.com/ElectricRCAircraftGuy/PDF2SearchablePDF

# Test runs:
# See "run_tests.sh"

start=$SECONDS

EXIT_SUCCESS=0
EXIT_ERROR=1

VERSION="0.4.0"
AUTHOR="Gabriel Staples"

# Force this script and the `printf` usage below to work for non-US locales.
# See: https://stackoverflow.com/questions/12845638/how-do-i-change-the-decimal-separator-in-the-printf-command-in-bash/12845640#12845640.
export LC_NUMERIC="en_US.UTF-8"


SCRIPT_NAME="$(basename "$0")"
VERSION_SHORT_STR="pdf2searchablepdf (run as '$SCRIPT_NAME') version $VERSION"
VERSION_LONG_STR="\
$VERSION_SHORT_STR
Author = $AUTHOR
See '$SCRIPT_NAME -h' for more info.
"

# Note that the ISO 639-2 language code requirement is mentioned in the man pages here:
# https://github.com/tesseract-ocr/tesseract/blob/master/doc/tesseract.1.asc
HELP_STR="\
$VERSION_SHORT_STR

Purpose: convert \"input.pdf\" to a searchable PDF named \"input_searchable.pdf\"
by using tesseract to perform OCR (Optical Character Recognition) on the PDF.

Usage:

    $SCRIPT_NAME <input.pdf|dir_of_imgs> [lang]
            If the 1st argument is to an input pdf, then convert input.pdf to input_searchable.pdf
            using language \"lang\" for OCR. Otherwise, if the 1st argument is a path to a directory
            containing a bunch of images, convert the whole directory of images into a single PDF,
            using language \"lang\" for OCR!
    $SCRIPT_NAME
            print help menu
    $SCRIPT_NAME -h
            print help menu
    $SCRIPT_NAME -?
            print help menu
    $SCRIPT_NAME -v
            print author & version

Examples:

    $SCRIPT_NAME mypdf.pdf deu
            convert mypdf.pdf to a searchable PDF, using German text OCR, or
    $SCRIPT_NAME mypdf.pdf
            for English text OCR (the default).
    $SCRIPT_NAME dir_of_imgs
            convert all images in this directory, \"dir_of_imgs\", to a single, searchable PDF.
    $SCRIPT_NAME .
            Convert all images in the present directory, indicated by '.', to a single, searchable
            PDF.

[lang]
    The optional [lang] argument allows you to perform OCR in your language of choice.
    This parameter will be passed on to tesseract. You must use ISO 639-2 3-letter language
    codes. Ex: \"deu\" for German, \"dan\" for Danish, \"eng\" for English, etc.
    See the \"LANGUAGES\" section of the tesseract man pages ('man tesseract') for a
    complete list. If the [lang] parameter is not given, English will be used by default.
    If you don't have a desired language installed, it may be obtained from one of the
    following 3 repos (see tesseract man pages for details):
      - https://github.com/tesseract-ocr/tessdata_fast
      - https://github.com/tesseract-ocr/tessdata_best
      - https://github.com/tesseract-ocr/tessdata
    To install a new language, simply download the respective \"*.traineddata\" file from one of
    the 3 repos above and copy it to your tesseract installation's \"tessdata\" directory.
    See \"Post-Install Instructions\" here:
    https://github.com/tesseract-ocr/tessdoc/blob/master/Compiling-%E2%80%93-GitInstallation.md#post-install-instructions

Tesseract Wiki: https://github.com/tesseract-ocr/tesseract/wiki.

Source code: https://github.com/ElectricRCAircraftGuy/PDF2SearchablePDF
"

print_help() {
    echo "$HELP_STR" | less -RFX
}

print_version() {
    echo "$VERSION_LONG_STR"
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

        echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
        echo "1st parmeter is a directory, so we are assuming it contains a bunch of images"
        echo "you'd like converted to a PDF. PLEASE ENSURE THIS DIRECTORY CONTAINS ONLY IMAGES!"
        echo "Converting all files (images) inside directory \"$dir_of_imgs\""
        echo "into a searchable PDF."
        echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"

        # Create a text file containing a list of all of the files in this dir
        # - Use "version sort", or `sort -V` to enforce proper sorting between numbers which are multiple digits vs
        #   1 digit--ex: "pg-1.tiff" and "pg-10.tiff", for instance. See here: https://unix.stackexchange.com/a/41659/114401
        file_list_path="${dir_of_imgs}/file_list.txt"
        # Don't include *.txt files, including the "file_list.txt" file itself in case it was left
        # around in a previous run, in the file list.
        find "$dir_of_imgs" -maxdepth 1 -mindepth 1 -not -type d -not -name '*.txt' | \
            sort --version-sort > "$file_list_path"

        pdf_out="${dir_of_imgs}_searchable"

        echo "Running tesseract OCR on all files (better be images) in the directory you provided."
    else
        # Convert a single input pdf into a searchable pdf

        pdf_in="$1"

        echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
        echo "Converting input PDF ($pdf_in) into a searchable PDF"
        echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"

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

        # 3. Create a text file containing a list of all of the generated tif files - Use
        # `--version-sort`, or `sort -V` to enforce proper sorting between numbers which are
        # multiple digits vs 1 digit--ex: "pg-1.tiff" and "pg-10.tiff", for instance. See here:
        # https://unix.stackexchange.com/a/41659/114401
        file_list_path="${temp_dir}/file_list.txt"
        find "$temp_dir" -maxdepth 1 -mindepth 1 -not -type d -not -name '*.txt' | \
            sort --version-sort > "$file_list_path"

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


