# PDF2SearchablePDF
`pdf2searchablepdf <input.pdf>` = voila! "input_searchable.pdf" has now been created and has searchable text!

# Description:
`tesseract` has the ability to do OCR (Optical Character Recognition) on image files, but unfortunately NOT on PDF files as inputs. This is unfortunate, as it means it's a pain to try to convert a PDF to a searchable PDF, so this is an attempt at scripting the process using existing tools in order to make it stupid-simple for ANYONE to use!

# Dependencies:
This has been tested only on Ubuntu 18. It requires the following programs:

## You Must Install these:

   sudo apt update 
   sudo apt install tesseract-ocr

See: https://github.com/tesseract-ocr/tesseract/wiki

## It also relies on these, but they come pre-installed on Ubuntu 18:

1. pdftoppm

