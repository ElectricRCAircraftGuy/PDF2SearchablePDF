# Status
It works! v0.1.0 released 11 Nov. 2019!

# PDF2SearchablePDF
`pdf2searchablepdf <input.pdf>` = voila! "input_searchable.pdf" has now been created and has searchable text!

# Description:
`tesseract` has the ability to do OCR (Optical Character Recognition) on image files, but unfortunately NOT on PDF files as inputs. This is unfortunate, as it means it's a pain to try to convert a PDF to a searchable PDF, so this is an attempt at scripting the process using existing tools in order to make it stupid-simple for ANYONE to use!

# Quick Start:
See here: https://askubuntu.com/questions/473843/how-to-turn-a-pdf-into-a-text-searchable-pdf/1187881#1187881

Tested on Ubuntu 18.04 on 11 Nov 2019.

### Install:

	git clone https://github.com/ElectricRCAircraftGuy/PDF2SearchablePDF.git
	./PDF2SearchablePDF/install.sh
	sudo apt update
	sudo apt install tesseract-ocr

### Use:

	pdf2searchablepdf mypdf.pdf

You'll now have a pdf called **mypdf_searchable.pdf**, which contains searchable text!

Done. The wrapper has no python dependencies, as it's currently written entirely in bash.

# Dependencies:
This has been tested only on Ubuntu 18. It requires the following programs:

## You Must Install these:

    sudo apt update 
    sudo apt install tesseract-ocr

See: https://github.com/tesseract-ocr/tesseract/wiki

## It also relies on these, but they come pre-installed on Ubuntu 18:

1. `pdftoppm`

# Installation
Simply run the "install.sh" script to create a symbolic link to `pdf2searchablepdf` in your "~/bin" directory:

	./install.sh

# Sample run and output:

```
$ pdf2searchablepdf ./test_pdfs/test1.pdf 
pdf2searchablepdf version 0.1.0
=================================================================================
Converting input PDF (./test_pdfs/test1.pdf) into a searchable PDF
=================================================================================
Creating temporary working directory: "pdf2searchablepdf_temp_20191111-001431.509915114"
Converting input PDF to a bunch of output TIF images inside temporary working directory.
- THIS COULD TAKE A LONG TIME (up to 45 sec or so per page)! Manually watch the temporary
  working directory to see the pages created one-by-one to roughly monitor progress.
- NB: each TIF file created is ~25MB, so ensure you have enough disk space for this
  operation to complete successfully.
All TIF files created.
Running tesseract OCR on all generated TIF images in the temporary working directory.
This could take some time.
Searchable PDF will be generated at "./test_pdfs/test1_searchable.pdf".
Tesseract Open Source OCR Engine v4.0.0-beta.1 with Leptonica
Page 0 : pdf2searchablepdf_temp_20191111-001431.509915114/pg-1.tif
Page 1 : pdf2searchablepdf_temp_20191111-001431.509915114/pg-2.tif
Page 2 : pdf2searchablepdf_temp_20191111-001431.509915114/pg-3.tif
Done! Searchable PDF generated at "./test_pdfs/test1_searchable.pdf".
Removing temporary working directory at "pdf2searchablepdf_temp_20191111-001431.509915114".
Done!

Total script run-time: 136 sec
END OF pdf2searchablepdf.

```

KEYWORDS: pdf 2 searchable pdf, pdftosearchablepdf, pdf to searchable pdf, make pdf searchable, perform ocr on pdf to make it searchable, extract text from pdf, pdf to text, how to make a PDF document searchable, how to make an unsearchable PDF document searchable, how to perform OCR (Optical Character Recognition) on a PDF image

