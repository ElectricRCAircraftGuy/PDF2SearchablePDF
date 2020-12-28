#!/bin/bash

test_pdf2searchablepdf() {
    echo -e ">>> Running 'pdf2searchablepdf $@' <<<"
    pdf2searchablepdf "$@"
    echo -e "\n\n\n"
}

# First, ensure the user has installed `pdf2searchablepdf`
if [ ! -f ~/bin/pdf2searchablepdf ]; then
    echo "Installing pdf2searchablepdf"
    ./install.sh
fi

# ===========
# Tests
# ===========

# Print help menu
test_pdf2searchablepdf -h
test_pdf2searchablepdf -?

# Print version
test_pdf2searchablepdf -v

# # Convert some PDFs into searchable PDFs
# test_pdf2searchablepdf tests/pdfs/test1.pdf
# test_pdf2searchablepdf tests/pdfs/test1_edited_w_foxit.pdf
# test_pdf2searchablepdf tests/pdfs/Wikipedia_pdf_screenshot.pdf

# # Convert a whole directory of images into a single, searchable pdf:
# test_pdf2searchablepdf tests/imgs

# # Convert a single image (NOT IMPLEMENTED YET)
# # test_pdf2searchablepdf tests/pdfs/Wikipedia_pdf_screenshot.png



