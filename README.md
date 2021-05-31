[![Hits](https://hits.seeyoufarm.com/api/count/incr/badge.svg?url=https%3A%2F%2Fgithub.com%2FElectricRCAircraftGuy%2FPDF2SearchablePDF&count_bg=%2379C83D&title_bg=%23555555&icon=&icon_color=%23E7E7E7&title=views+%28today+%2F+total%29&edge_flat=false)](https://hits.seeyoufarm.com)

# PDF2SearchablePDF

# Status

It works! See Changelog below.

# Table of Contents

<details>
<summary><b>(click to expand)</b></summary>
<!-- MarkdownTOC -->

1. [Description:](#description)
   1. [Operating Systems:](#operating-systems)
   1. [Usage:](#usage)
   1. [Image size notes:](#image-size-notes)
   1. [Compress your post-processed PDF:](#compress-your-post-processed-pdf)
1. [Quick Start:](#quick-start)
   1. [Install:](#install)
   1. [Uninstall:](#uninstall)
   1. [Use:](#use)
1. [Dependencies:](#dependencies)
   1. [You Must Install these:](#you-must-install-these)
   1. [It also relies on these, but they come pre-installed on Ubuntu:](#it-also-relies-on-these-but-they-come-pre-installed-on-ubuntu)
1. [PDF2SearchablePDF Installation:](#pdf2searchablepdf-installation)
1. [Sample run and output:](#sample-run-and-output)
1. [Changelog](#changelog)
   1. [\[v0.5.0\] - 2021-03-02](#v050---2021-03-02)
   1. [\[v0.4.0\] - 2020-03-14](#v040---2020-03-14)
   1. [\[v0.3.0\] - 2019-12-29](#v030---2019-12-29)
   1. [\[v0.2.0\] - 2019-12-29](#v020---2019-12-29)
   1. [\[v0.1.0\] - 2019-11-10](#v010---2019-11-10)
1. [Alternative Software:](#alternative-software)
1. [KEYWORDS](#keywords)

<!-- /MarkdownTOC -->
</details>

<a id="description"></a>

# Description:

`tesseract` has the ability to do OCR (Optical Character Recognition) on image files, but unfortunately NOT on PDF files as inputs. This is unfortunate, as it means it's a pain to try to convert a PDF to a searchable PDF, so this program scripts the process using existing tools in order to make it stupid-simple for ANYONE to use!

<a id="operating-systems"></a>

## Operating Systems:

**Windows** (untested, but I think it would work), **Mac** (untested, but should work), and **Linux** (tested and works):

- Developed and tested primarily in **Linux** Ubuntu 16.04, 18.04, and 20.04, but should run on any of the 3 operating systems I think: Windows, Mac, and Linux.
- For **Windows**, I think you can get it to run inside the [Windows Subsystem for Linux (WSL)](https://docs.microsoft.com/en-us/windows/wsl/install-win10), [Cygwin](https://www.cygwin.com/), or in the terminal provided with [Git for Windows][git_for_windows] (usually my preference when using Windows).
  - Here are some options to install the [`tesseract`](https://github.com/tesseract-ocr/tesseract) OCR (Optical Character Recognition) program, which `pdf2searchablepdf` requires, in Windows. See also the official tesseract documentation on this [here](https://tesseract-ocr.github.io/tessdoc/Downloads.html) and [here](https://tesseract-ocr.github.io/tessdoc/Installation.html#windows).
    1. [Probably the easiest/best]: get Windows tesseract .exe binary files directly from UB-Mannheim here: https://github.com/UB-Mannheim/tesseract/wiki.
    1. Cygwin packages for tesseract: https://cygwin.com/cgi-bin2/package-grep.cgi?grep=tesseract&arch=x86_64.
  - Once you get tesseract installed from the .exe file provided by UB-Mannheim above, for instance, I'm pretty sure you can then just install [Git for Windows][git_for_windows], open the bash terminal it provides, and run `pdf2searchablepdf` from there. This assumes that the .exe installer places `tesseract` in the Windows PATH so that you can call `tesseract` from the command-line/MS-DOS-prompt in Windows.

<a id="usage"></a>

## Usage:

**See help menu for full details & more examples:**

```bash
pdf2searchablepdf -h
```

From the help menu:

> pdf2searchablepdf ('pdf2searchablepdf') version 0.5.0
>
> Purpose: convert "input.pdf" to a searchable PDF named "input_searchable.pdf"
> by using tesseract to perform OCR (Optical Character Recognition) on the PDF.
>
> Usage:
>
>     pdf2searchablepdf [options] <input.pdf|dir_of_imgs> [lang]
>             If the 1st positional argument (after options) is to an input pdf, then convert
>             input.pdf to input_searchable.pdf using language "lang" for OCR. Otherwise, if the 1st
>             argument is a path to a directory containing a bunch of images, convert the whole
>             directory of images into a single PDF, using language "lang" for OCR!
>     pdf2searchablepdf
>             print help menu, then exit
>
> Options:
>
>     [-h|-?|--help]
>             print help menu, then exit
>     [-v|--version]
>             print author & version, then exit
>     [-d|--debug]
>             Turn debug prints on while running the script
>     [-upw <password>]
>             Specify the user password to open and read the PDF file. This option is passed directly
>             through to the 'pdftoppm' cmd used internally to convert the PDF to images for OCR.
>     [--run_tests]
>             Run unit tests for this program.
>
> Examples:
>
>     pdf2searchablepdf mypdf.pdf deu
>             Convert mypdf.pdf to a searchable PDF, using German text OCR, or
>     pdf2searchablepdf mypdf.pdf
>             Convert mypdf.pdf to a searchable PDF, using English text OCR (the default).
>     pdf2searchablepdf mypdf.pdf --debug
>             Same as above, except also print out the debug prints.
>     pdf2searchablepdf dir_of_imgs
>             Convert all images in this directory, "dir_of_imgs", to a single, searchable PDF.
>     pdf2searchablepdf .
>             Convert all images in the present directory, indicated by '.', to a single, searchable
>             PDF.
>     pdf2searchablepdf -upw 1234 mypdf.pdf
>             Convert mypdf.pdf to a searchable PDF, using English text OCR, while using the user
>             password "1234" to open up and read the PDF.
>     pdf2searchablepdf mypdf.pdf -upw 1234
>             Same as above.
>
> Option Details:
>
>     [lang]
>         The optional [lang] argument allows you to perform OCR in your language of choice. This
>         parameter will be passed on to tesseract. You must use ISO 639-2 3-letter language codes.
>         Ex: "deu" for German, "dan" for Danish, "eng" for English, etc. See the "LANGUAGES"
>         section of the tesseract man pages ('man tesseract') for a complete list. If the [lang]
>         parameter is not given, English will be used by default. If you don't have a desired
>         language installed, it may be obtained from one of the following 3 repos (see tesseract man
>         pages for details):
>           - https://github.com/tesseract-ocr/tessdata_fast
>           - https://github.com/tesseract-ocr/tessdata_best
>           - https://github.com/tesseract-ocr/tessdata
>         To install a new language, simply download the respective "*.traineddata" file from one of
>         the 3 repos above and copy it to your tesseract installation's "tessdata" directory.
>         See "Post-Install Instructions" here:
>         https://github.com/tesseract-ocr/tessdoc/blob/master/Compiling-%E2%80%93-GitInstallation.md#post-install-instructions

<a id="image-size-notes"></a>

## Image size notes:

_Note that when converting an entire directory of images, if the images are large (ex: jpeg images at 3MB each) when you start, your searchable PDF at the end will be very large too! Simply sum the sizes of all the images to know how big the final PDF file will be!_ To reduce its size, one quick-and-easy way is to compress the jpeg images using `jpegoptim` _before_ you call `pdf2searchablepdf`. Read more about `jpegoptim` here: https://www.tecmint.com/optimize-and-compress-jpeg-or-png-batch-images-linux-commandline/.

Here's an example demonstrating how to install `jpegoptim`, use it to compress an entire directory of jpeg images, then call `pdf2searchablepdf` to turn the whole directory of images into one single, searchable pdf. Assume your directory containing all the jpeg images is called "dir*of_imgs". \_Be sure no spaces exist anywhere in its path!*

Install `jpegoptim`:

    sudo apt update
    sudo apt install jpegoptim

Compress all the images, then convert all of them to a single, searchable PDF:

    jpegoptim --size=500k dir_of_imgs/*.jpg # compress the whole dir of images!
    pdf2searchablepdf dir_of_imgs           # now make 1 searchable pdf out of all of them!

For my particular case, with 7 jpeg images originally in the 2.5 to 3MB size range, the end result without jpegoptim was a 20 MB PDF, which is too large to email! By calling `jpegoptim --size=500k` as shown above, first, it shrunk the image size to approx. 500kB each, which meant the final PDF size was about 3.5MB instead of 20MB! Big improvement! Now I can email the file, and the images still look pretty good!

<a id="compress-your-post-processed-pdf"></a>

## Compress your post-processed PDF:

For some PDF compression options, see my answer here: [AskUbuntu.com: How can I reduce the file size of a scanned PDF file?](https://askubuntu.com/questions/113544/how-can-i-reduce-the-file-size-of-a-scanned-pdf-file/1303196#1303196).

<a id="quick-start"></a>

# Quick Start:

See here: https://askubuntu.com/questions/473843/how-to-turn-a-pdf-into-a-text-searchable-pdf/1187881#1187881

Tested on Ubuntu 18.04 and 20.04.

<a id="install"></a>

## Install:

### Ubuntu install

1. Install dependencies
   ```bash
   sudo apt update
   sudo apt install tesseract-ocr
   ```
1. Download the repository, and run the install script:
   ```bash
   git clone https://github.com/ElectricRCAircraftGuy/PDF2SearchablePDF.git
   cd PDF2SearchablePDF
   ./install.sh
   ```
1. **Log out and log back in** if that script just created your `~/bin` dir (if `ls ~/bin` shows only the one `pdf2searchablepdf` symlink in that dir, and nothing else, then this is likely the case).

   Note about what this does: this step simply causes the `~/.profile` file in Ubuntu to add `~/bin` to your executable PATH, so long as the `~/bin` dir exists. If you need to manually add the `~/bin` dir to your PATH (because you're using a different Linux distribution, for instance, which does not use the `~/.profile` file like this) you can run this command to add it to your path just in the terminal you have open:

   ```bash
   PATH="$HOME/bin:$PATH"
   ```

   OR, you can add this to the bottom of your `~/.bashrc` file, then close and re-open your terminal. Note: this is copied from Ubuntu's default `~/.profile` file:

   ```bash
   # set PATH so it includes user's private bin if it exists
   if [ -d "$HOME/bin" ] ; then
       PATH="$HOME/bin:$PATH"
   fi
   ```

1. (Optional, but recommended) run tests.
   ```bash
   ./run_tests.sh
   # Then, manually visually scan the output messages and inspect the
   # output searchable PDF files to ensure everything looks like it worked
   # correctly.
   ```
1. Lastly, ensure you **do NOT delete the PDF2SearchablePDF repository you downloaded**, as the install script didn't copy the executable out of it, it created an executable symlink which points _to_ it.

### MacOS install

You'll need `brew` for this.

1. Download the repository, and run the install script. This will install the dependencies too:
   ```bash
   git clone https://github.com/ElectricRCAircraftGuy/PDF2SearchablePDF.git
   cd PDF2SearchablePDF
   ./mac_install.sh
   ```
1. (Optional, but recommended) run tests.
   ```bash
   ./run_tests.sh
   # Then, manually visually scan the output messages and inspect the
   # output searchable PDF files to ensure everything looks like it worked
   # correctly.
   ```
1. Lastly, ensure you **do NOT delete the PDF2SearchablePDF repository you downloaded**, as the install script didn't copy the executable out of it, it created an alias which points _to_ it.
   <a id="uninstall"></a>

## Uninstall:

Uninstallation is simple, if desired. You just need to run the commands below to delete a few things, or delete those things manually using your favorite file manager, such as nemo (see [my detailed installation instructions for nemo in Ubuntu here](https://askubuntu.com/a/1173861/327339)).

```bash
# 1. delete the symlink in ~/bin
rm ~/bin/pdf2searchablepdf

# 2. (Optional) delete the entire PDF2SearchablePDF repository directory, and all contents
# in it. WARNING! CHOOSING THE WRONG PATH HERE WILL erase everything in the folder you specify,
# so BE VERY CAUTIOUS!
rm -rf path/to/PDF2SearchablePDF

# 3. (Optional) remove dependencies
sudo apt remove tesseract-ocr
```

<a id="use"></a>

## Use:

    pdf2searchablepdf mypdf.pdf

You'll now have a pdf called **mypdf_searchable.pdf**, which contains searchable text! See `pdf2searchablepdf -h` for many more usage examples.

Done. The wrapper has no python dependencies, as it's currently written entirely in bash.

<a id="dependencies"></a>

# Dependencies:

This has been tested on Ubuntu 18.04 and 20.04. It requires the following programs:

<a id="you-must-install-these"></a>

## You Must Install these:

    sudo apt update
    sudo apt install tesseract-ocr

See: https://github.com/tesseract-ocr/tesseract/wiki

<a id="it-also-relies-on-these-but-they-come-pre-installed-on-ubuntu"></a>

## It also relies on these, but they come pre-installed on Ubuntu:

1. `pdftoppm`

<a id="pdf2searchablepdf-installation"></a>

# PDF2SearchablePDF Installation:

Simply run the "install.sh" script to create a symbolic link to `pdf2searchablepdf` in your "~/bin" directory:

    ./install.sh

In short, just follow the "Install" instructions above under the "Quick Start" section.

<a id="sample-run-and-output"></a>

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

<a id="changelog"></a>

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

<a id="v050---2021-03-02"></a>

## [v0.5.0] - 2021-03-02

- Massively improved the way argument parsing is done.
- Added additional parsing options for debug prints and converting user-password-protected PDFs. Use the `-upw <password>` option to pass in a PDF's user password to be able to open and convert it. This works great on my password-protected home mortgage documents scanned and sent to me from the title company!

<a id="v040---2020-03-14"></a>

## [v0.4.0] - 2020-03-14

- Updated install.sh & pdf2searchablepdf.sh scripts to allow spaces in path names; fixes [issue #6](https://github.com/ElectricRCAircraftGuy/PDF2SearchablePDF/issues/6)
- Move argument parsing code into `parse_args()` function inside pdf2searchablepdf.sh
- Moved all main code into `main()` function inside pdf2searchablepdf.sh, and added `time` command to the call to `main` to time how long `main` takes to run

<a id="v030---2019-12-29"></a>

## [v0.3.0] - 2019-12-29

- Added a big new feature to allow the user to convert a whole directory containing a bunch of images into a single, searchable pdf!
- New usage: `pdf2searchablepdf <input.pdf | dir_of_imgs> [lang]`
- Also added print of run duration at end in units of minutes too instead of just seconds.

<a id="v020---2019-12-29"></a>

## [v0.2.0] - 2019-12-29

- Improved help menu, which is accessible via: `pdf2searchablepdf -h` or `pdf2searchablepdf -?` or `pdf2searchablepdf`
- Added ability to set the OCR language; new usage: `pdf2searchablepdf <input.pdf> [lang]`

<a id="v010---2019-11-10"></a>

## [v0.1.0] - 2019-11-10

- Initial release. It works!
- Can only convert a pdf to a searchable pdf in English, which is tesseract's default setting.
- Usage: `pdf2searchablepdf <input.pdf>`

<a id="alternative-software"></a>

# Alternative Software:

1. https://github.com/tesseract-ocr/tesseract/wiki/User-Projects-%E2%80%93-3rdParty#4-others-utilities-tools-command-line-interfaces-cli-etc
   1. https://github.com/jbarlow83/OCRmyPDF
   1. https://github.com/LeoFCardoso/pdf2pdfocr

- See my issue here: https://github.com/ElectricRCAircraftGuy/PDF2SearchablePDF/issues/5. Are these alternatives better than my project here? Do I offer something they don't? Should I continue this project or just switch to using one of the projects listed above? I need to investigate and find out more!

<a id="keywords"></a>

# KEYWORDS

(to make this repo more "Googlable"):

pdf 2 searchable pdf, pdftosearchablepdf, pdf to searchable pdf, make pdf searchable, perform ocr on pdf to make it searchable, extract text from pdf, pdf to text, how to make a PDF document searchable, how to make an unsearchable PDF document searchable, how to perform OCR (Optical Character Recognition) on a PDF image, linux convert directory of images into a single pdf, linux convert images to pdf, images to pdf, images2pdf, linux convert a folder of images into a single pdf, tif to pdf, tiff to pdf, png to pdf, bmp to pdf, jpg to pdf, jpeg to pdf, folder of pictures to pdf, ocr on pictures, ocr on images, pictures ocr to searchable pdf

[git_for_windows]: https://git-scm.com/download/win
