#!/bin/bash

test_num=0

# See my ans: https://stackoverflow.com/a/60157372/4561887
FULL_PATH_TO_HERE="$(realpath "$0")"
DIRECTORY="$(dirname "$FULL_PATH_TO_HERE")"
starting_dir="$(pwd)"
cd "$DIRECTORY"

test_pdf2searchablepdf() {
    ((test_num++))
    echo -e "============================ START OF TEST $test_num ==============================="
    echo -e "=== Running 'pdf2searchablepdf $@' ==="
    echo -e "----------------------------------------------------------------------------"
    pdf2searchablepdf "$@"
    echo -e "=== END TEST $test_num ===\n"
}

# First, ensure the user has installed `pdf2searchablepdf`
if [ ! -f ~/bin/pdf2searchablepdf ]; then
    echo "Installing pdf2searchablepdf"
    ./install.sh
fi

# ===========
# Tests
# ===========

run_all_tests() {
    # Print help menu
    test_pdf2searchablepdf -h
    test_pdf2searchablepdf -?

    # Print version
    test_pdf2searchablepdf -v

    # Convert some PDFs into searchable PDFs
    test_pdf2searchablepdf "tests/pdfs/test1.pdf"
    test_pdf2searchablepdf "tests/pdfs/test1_edited_w_foxit.pdf"
    test_pdf2searchablepdf "tests/pdfs/Wikipedia_pdf_screenshot.pdf"

    # Convert a whole directory of images into a single, searchable pdf:
    test_pdf2searchablepdf "tests/imgs"

    # Convert a single image (NOT IMPLEMENTED YET)
    # test_pdf2searchablepdf tests/pdfs/Wikipedia_pdf_screenshot.png
}


time run_all_tests
# cd back to the starting dir in case this script is run as a part of a user's main process with
# a trailing `&`, rather than as a subprocess.
cd "$starting_dir"

