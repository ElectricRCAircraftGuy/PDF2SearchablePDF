#!/bin/bash

# pdf2searchablepdf
# Gabriel Staples
# Started: 9 Nov. 2019
# - Source code: https://github.com/ElectricRCAircraftGuy/PDF2SearchablePDF
#
# Note to self: see also my
# [git-blametool.sh](https://github.com/ElectricRCAircraftGuy/eRCaGuy_dotfiles/blob/master/useful_scripts/git-blametool.sh)
# script for help on bash syntax and examples of advanced option parsing in bash.
#
# Test runs:
# See "run_tests.sh"

start=$SECONDS

RETURN_CODE_SUCCESS=0
RETURN_CODE_ERROR=1

VERSION="0.4.0"
AUTHOR="Gabriel Staples"

DEBUG_PRINTS_ON="false" # true or false; can also be passed in as an option: `-d` or `--debug`

# Force this script and the `printf` usage below to work for non-US locales.
# See: https://stackoverflow.com/questions/12845638/how-do-i-change-the-decimal-separator-in-the-printf-command-in-bash/12845640#12845640.
export LC_NUMERIC="en_US.UTF-8"


SCRIPT_NAME="$(basename "$0")"
VERSION_SHORT_STR="pdf2searchablepdf ('$SCRIPT_NAME') version $VERSION"
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

    $SCRIPT_NAME [options] <input.pdf|dir_of_imgs> [lang]
            If the 1st positional argument (after options) is to an input pdf, then convert
            input.pdf to input_searchable.pdf using language \"lang\" for OCR. Otherwise, if the 1st
            argument is a path to a directory containing a bunch of images, convert the whole
            directory of images into a single PDF, using language \"lang\" for OCR!
    $SCRIPT_NAME
            print help menu, then exit

  Options:

    [-h|-?|--help]
            print help menu, then exit
    [-v|--version]
            print author & version, then exit
    [-d|--debug]
            Turn debug prints on while running the script
    [-upw <password>]
            Specify the user password to open and read the PDF file. This option is passed directly
            through to the 'pdftoppm' cmd used internally to convert the PDF to images for OCR.
    [--run_tests]
            Run unit tests for this program.

Examples:

    $SCRIPT_NAME mypdf.pdf deu
            Convert mypdf.pdf to a searchable PDF, using German text OCR, or
    $SCRIPT_NAME mypdf.pdf
            Convert mypdf.pdf to a searchable PDF, using English text OCR (the default).
    $SCRIPT_NAME mypdf.pdf --debug
            Same as above, except also print out the debug prints.
    $SCRIPT_NAME dir_of_imgs
            Convert all images in this directory, \"dir_of_imgs\", to a single, searchable PDF.
    $SCRIPT_NAME .
            Convert all images in the present directory, indicated by '.', to a single, searchable
            PDF.
    $SCRIPT_NAME -upw 1234 mypdf.pdf
            Convert mypdf.pdf to a searchable PDF, using English text OCR, while using the user
            password \"1234\" to open up and read the PDF.
    $SCRIPT_NAME mypdf.pdf -upw 1234
            Same as above.

Option Details:

    [lang]
        The optional [lang] argument allows you to perform OCR in your language of choice. This
        parameter will be passed on to tesseract. You must use ISO 639-2 3-letter language codes.
        Ex: \"deu\" for German, \"dan\" for Danish, \"eng\" for English, etc. See the \"LANGUAGES\"
        section of the tesseract man pages ('man tesseract') for a complete list. If the [lang]
        parameter is not given, English will be used by default. If you don't have a desired
        language installed, it may be obtained from one of the following 3 repos (see tesseract man
        pages for details):
          - https://github.com/tesseract-ocr/tessdata_fast
          - https://github.com/tesseract-ocr/tessdata_best
          - https://github.com/tesseract-ocr/tessdata
        To install a new language, simply download the respective \"*.traineddata\" file from one of
        the 3 repos above and copy it to your tesseract installation's \"tessdata\" directory.
        See \"Post-Install Instructions\" here:
        https://github.com/tesseract-ocr/tessdoc/blob/master/Compiling-%E2%80%93-GitInstallation.md#post-install-instructions

Tesseract Wiki:
https://github.com/tesseract-ocr/tesseract/wiki.

Source code:
https://github.com/ElectricRCAircraftGuy/PDF2SearchablePDF
"

# A "debug" version of `echo`, to only print when `DEBUG_PRINTS_ON` is `true`.
echo_debug() {
    if [ "$DEBUG_PRINTS_ON" == "true" ]; then
        printf "DEBUG: "
        echo $@
    fi
}

print_help() {
    echo "$HELP_STR" | less -RFX
}

print_version() {
    echo "$VERSION_LONG_STR"
}

# Sample test commands I can run
# This test code is not in a "complete" state by any means. It's more of a proof-of-concept at the
# moment. Cmd: `pdf2searchablepdf --run_tests`
run_tests() {
    echo -e "\nTEST 1:"
    $SCRIPT_NAME rr -upw 2221 -d 2 3 --debug
    echo ""

    echo -e "\nTEST 2:"
    $SCRIPT_NAME rr -upw 2221 2 3 --debug
    echo ""

    echo -e "\nTEST 3:"
    $SCRIPT_NAME rr -upw 2221 2 3 --debug
    echo ""
}

parse_args() {
    # For advanced argument parsing help and demo, see:
    # https://stackoverflow.com/a/14203146/4561887.

    if [ $# -eq 0 ]; then
        echo "No arguments supplied"
        print_help
        exit $RETURN_CODE_ERROR
    fi

    user_password=""
    lang="eng" # English

    POSITIONAL_ARGS_ARRAY=()
    while [[ $# -gt 0 ]]; do
        arg="$1"
        # first letter of `arg`; see: https://stackoverflow.com/a/10218528/4561887
        first_letter="${arg:0:1}"

        case $arg in
            # Help menu
            "-h"|"-?"|"--help")
                print_help
                exit $RETURN_CODE_SUCCESS
                ;;
            # Version
            "-v"|"--version")
                print_version
                exit $RETURN_CODE_SUCCESS
                ;;
            # Debug prints on
            "-d"|"--debug")
                DEBUG_PRINTS_ON="true"
                shift # past argument
                ;;
            # PDF user password
            "-upw")
                user_password="-upw $2"
                shift # past argument
                shift # past value
                ;;
            "--run_tests")
                run_tests
                exit $RETURN_CODE_SUCCESS
                ;;
            # Unknown option (ie: unmatched in the switch cases above)
            *)
                if [ "$first_letter" == "-" ]; then
                    echo "ERROR: Unknown option \"$arg\"."
                    exit $RETURN_CODE_ERROR
                fi

                POSITIONAL_ARGS_ARRAY+=("$1") # save it in an array for later
                shift # past argument
                ;;
        esac
    done

    array_len=${#POSITIONAL_ARGS_ARRAY[@]}

    echo_debug "Number of positional args = $array_len"
    echo_debug "POSITIONAL_ARGS_ARRAY contains: '${POSITIONAL_ARGS_ARRAY[*]}'."
    echo_debug "user_password = $user_password"

    if [ $array_len -ge 1 ]; then
        pdf_in_OR_dir_of_imgs="${POSITIONAL_ARGS_ARRAY[0]}"
        echo_debug "pdf_in_OR_dir_of_imgs = $pdf_in_OR_dir_of_imgs"
    fi

    if [ $array_len -ge 2 ]; then
        lang="${POSITIONAL_ARGS_ARRAY[1]}"
        echo_debug "lang = $lang"
    fi
}

# program cleanup
cleanup() {
    # Delete temp dir
    if [ "$temp_dir" != "" ]; then
        echo "Removing temporary working directory at \"$temp_dir\"."
        rm -rf "$temp_dir"
        echo "Done!"
    fi
}

main() {
    print_version
    echo "Language = $lang"

    # Determine if the 1st argument is a directory (of images) or a file (input PDF)
    # - See: https://stackoverflow.com/questions/59838/check-if-a-directory-exists-in-a-shell-script
    if [ -d "$pdf_in_OR_dir_of_imgs" ]; then
        # Convert a directory of images into a searchable pdf

        # Remove trailing slash if there is one
        # - see: https://unix.stackexchange.com/questions/198045/how-to-strip-the-last-slash-of-the-directory-path/198049#198049
        dir_of_imgs="${pdf_in_OR_dir_of_imgs%/}"
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

        pdf_in="$pdf_in_OR_dir_of_imgs"

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
        pdftoppm $user_password -tiff -r 300 "$pdf_in" "$temp_dir/pg"

        ret_code="$?"
        if [ "$ret_code" -ne "$RETURN_CODE_SUCCESS" ]; then
            echo "ERROR: 'pdftoppm' failed. ret_code = $ret_code"
            cleanup
            exit $ret_code
        fi

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

    cleanup

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
time main
echo "END OF pdf2searchablepdf."


