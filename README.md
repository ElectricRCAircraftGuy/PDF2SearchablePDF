# Status
It works! See Changelog below.

# PDF2SearchablePDF

**Usage:**  
`pdf2searchablepdf <input.pdf | dir_of_imgs> [lang]` = if the 1st argument is
to an input pdf, then convert input.pdf to input_searchable.pdf using language
"lang" for OCR. Otherwise, if the 1st argument is a path to a directory containing
a bunch of images, convert the whole directory of images into a single PDF, using
language "lang" for OCR!

**See help menu for full details & more examples:**  
`pdf2searchablepdf -h`

Examples: 

1. `pdf2searchablepdf input.pdf` = voila! "input_searchable.pdf" has now been created and has searchable text!
1. `pdf2searchablepdf input.pdf deu` = same as above except perform Optical Character Recognition (OCR) for German text instead of using the default of English. 
1. `pdf2searchablepdf my_dir_of_images` = convert all images inside directory "my_dir_of_images" into a single, searchable PDF!

# Description:
`tesseract` has the ability to do OCR (Optical Character Recognition) on image files, but unfortunately NOT on PDF files as inputs. This is unfortunate, as it means it's a pain to try to convert a PDF to a searchable PDF, so this program scripts the process using existing tools in order to make it stupid-simple for ANYONE to use!

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
This has been tested on Ubuntu 18. It requires the following programs:

## You Must Install these:

    sudo apt update 
    sudo apt install tesseract-ocr

See: https://github.com/tesseract-ocr/tesseract/wiki

## It also relies on these, but they come pre-installed on Ubuntu 18:

1. `pdftoppm`

# PDF2SearchablePDF Installation:
Simply run the "install.sh" script to create a symbolic link to `pdf2searchablepdf` in your "~/bin" directory:

	./install.sh

In short, just follow the "Install" instructions above under the "Quick Start" section.

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

# Changelog
- Newest on top
- Follows Semantic Versioning; see: https://semver.org/
- 6 most common recommended types of changes (see here: https://keepachangelog.com/en/1.0.0/): Added, Changed, Deprecated, Removed, Fixed, Security

In short:  
Given a version number MAJOR.MINOR.PATCH, increment the:  

MAJOR version when you make incompatible API changes,  
MINOR version when you add functionality in a backwards compatible manner, and  
PATCH version when you make backwards compatible bug fixes.  

## v0.2.0 - 2019-12-29
- Improved help menu, which is accessible via: `pdf2searchablepdf -h` or `pdf2searchablepdf -?` or `pdf2searchablepdf`
- Added ability to set the OCR language; new usage: `pdf2searchablepdf <input.pdf> [lang]`

## v0.1.0 - 2019-11-10
- Initial release. It works! 
- Can only convert a pdf to a searchable pdf in English, which is tesseract's default setting.
- Usage: `pdf2searchablepdf <input.pdf>`


# KEYWORDS 
(to make this repo more "Googlable"): 

pdf 2 searchable pdf, pdftosearchablepdf, pdf to searchable pdf, make pdf searchable, perform ocr on pdf to make it searchable, extract text from pdf, pdf to text, how to make a PDF document searchable, how to make an unsearchable PDF document searchable, how to perform OCR (Optical Character Recognition) on a PDF image

