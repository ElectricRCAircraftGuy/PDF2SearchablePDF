#!/bin/bash

test() {
    echo -e ">>> Running 'pdf2searchablepdf \"$1\"' <<<"
    pdf2searchablepdf "$1"
    echo -e "\n\n\n"
}

# First, ensure the user has installed `pdf2searchablepdf`
if [ ! -f ~/bin/pdf2searchablepdf ]; then
    echo "Installing pdf2searchablepdf"
    ./install.sh
fi

test tests/imgs
test tests/pdfs/test1.pdf
test tests/pdfs/test1_edited_w_foxit.pdf
# test tests/pdfs/Wikipedia_pdf_screenshot.png
test tests/pdfs/Wikipedia_pdf_screenshot.pdf


