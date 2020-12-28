#!/bin/bash

test() {
    echo -e ">>> Running 'pdf2searchablepdf \"$1\"' <<<"
    pdf2searchablepdf "$1"
    echo -e "\n\n\n"
}

test test_imgs
test test_pdfs/test1.pdf
test test_pdfs/test1_edited_w_foxit.pdf
# test test_pdfs/Wikipedia_pdf_screenshot.png
test test_pdfs/Wikipedia_pdf_screenshot.pdf


