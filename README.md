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

*Note that when converting an entire directory of images, if the images are large (ex: jpeg images at 3MB each) when you start, your searchable PDF at the end will be very large too! Simply sum the sizes of all the images to know how big the final PDF file will be!* To reduce its size, one quick-and-easy way is to compress the jpeg images using `jpegoptim` *before* you call `pdf2searchablepdf`. Read more about `jpegoptim` here: https://www.tecmint.com/optimize-and-compress-jpeg-or-png-batch-images-linux-commandline/.  

Here's an example demonstrating how to install `jpegoptim`, use it to compress an entire directory of jpeg images, then call `pdf2searchablepdf` to turn the whole directory of images into one single, searchable pdf. Assume your directory containing all the jpeg images is called "dir_of_imgs". *Be sure no spaces exist anywhere in its path!*

Install `jpegoptim`: 

    sudo apt update
    sudo apt install jpegoptim

Compress all the images, then convert all of them to a single, searchable PDF:

    jpegoptim --size=500k dir_of_imgs/*.jpg # compress the whole dir of images!
    pdf2searchablepdf dir_of_imgs           # now make 1 searchable pdf out of all of them!

For my particular case, with 7 jpeg images originally in the 2.5 to 3MB size range, the end result without jpegoptim was a 20 MB PDF, which is too large to email! By calling `jpegoptim --size=500k` as shown above, first, it shrunk the image size to approx. 500kB each, which meant the final PDF size was about 3.5MB instead of 20MB! Big improvement! Now I can email the file, and the images still look pretty good!

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
- Follows Semantic Versioning: MAJOR.MINOR.PATCH; see: https://semver.org/ for rules & FAQ.
- The 6 most common recommended types of changes are (see here: https://keepachangelog.com/en/1.0.0/): Added, Changed, Deprecated, Removed, Fixed, Security

INITIAL DEVELOPMENT PHASE:
- Use version numbers 0.MINOR.PATCH for the initial development phase; ex: 0.1.0, 0.2.0, etc.
- Increment just the MINOR version number for each new 0.y.z development phase enhancement, until the project is mature enough that you choose to move to a 1.0.0 release
- You may increment the PATCH number for bug fixes to your development code, or just increment the MINOR version number if there are also enhancements

MORE MATURE PHASE:
- As the project matures, release a 1.0.0 version
- Once you release a 1.0.0 version, do the following (copied from semver.org):
- Given a version number MAJOR.MINOR.PATCH, increment the:  
1. MAJOR version when you make incompatible API changes,  
2. MINOR version when you add functionality in a backwards compatible manner, and  
3. PATCH version when you make backwards compatible bug fixes.  

## [v0.4.0] - 2020-03-14
- Updated install.sh & pdf2searchablepdf.sh scripts to allow spaces in path names; fixes [issue #6](https://github.com/ElectricRCAircraftGuy/PDF2SearchablePDF/issues/6)
- Move argument parsing code into `parse_args()` function inside pdf2searchablepdf.sh
- Moved all main code into `main()` function inside pdf2searchablepdf.sh, and added `time` command to the call to `main` to time how long `main` takes to run

## [v0.3.0] - 2019-12-29
- Added a big new feature to allow the user to convert a whole directory containing a bunch of images into a single, searchable pdf! 
- New usage: `pdf2searchablepdf <input.pdf | dir_of_imgs> [lang]`
- Also added print of run duration at end in units of minutes too instead of just seconds.

## [v0.2.0] - 2019-12-29
- Improved help menu, which is accessible via: `pdf2searchablepdf -h` or `pdf2searchablepdf -?` or `pdf2searchablepdf`
- Added ability to set the OCR language; new usage: `pdf2searchablepdf <input.pdf> [lang]`

## [v0.1.0] - 2019-11-10
- Initial release. It works! 
- Can only convert a pdf to a searchable pdf in English, which is tesseract's default setting.
- Usage: `pdf2searchablepdf <input.pdf>`

# Alternative Software:
1. https://github.com/tesseract-ocr/tesseract/wiki/User-Projects-%E2%80%93-3rdParty#4-others-utilities-tools-command-line-interfaces-cli-etc
    1. https://github.com/jbarlow83/OCRmyPDF
    1. https://github.com/LeoFCardoso/pdf2pdfocr
- See my issue here: https://github.com/ElectricRCAircraftGuy/PDF2SearchablePDF/issues/5. Are these alternatives better than my project here? Do I offer something they don't? Should I continue this project or just switch to using one of the projects listed above? I need to investigate and find out more!

# KEYWORDS 
(to make this repo more "Googlable"): 

pdf 2 searchable pdf, pdftosearchablepdf, pdf to searchable pdf, make pdf searchable, perform ocr on pdf to make it searchable, extract text from pdf, pdf to text, how to make a PDF document searchable, how to make an unsearchable PDF document searchable, how to perform OCR (Optical Character Recognition) on a PDF image, linux convert directory of images into a single pdf, linux convert images to pdf, images to pdf, images2pdf, linux convert a folder of images into a single pdf, tif to pdf, tiff to pdf, png to pdf, bmp to pdf, jpg to pdf, jpeg to pdf, folder of pictures to pdf, ocr on pictures, ocr on images, pictures ocr to searchable pdf

