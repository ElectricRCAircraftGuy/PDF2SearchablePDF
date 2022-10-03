#!/bin/bash

brew install poppler tesseract

dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

path2exec="${dir}/pdf2searchablepdf.sh" # path to the executable bash script
# echo "path2exec = \"$path2exec\""

echo alias\ pdf2searchablepdf="$path2exec" >> ~/.bash_profile
echo "Done: alias inserted in ~/.bash_profile"




mkdir -p ~/bin

# Obtain full path to this install.sh file:
full_path="$(readlink -f $0)"
# echo "full_path = \"$full_path\""

# Get just the directory path now, by stripping off the filename part; see: https://stackoverflow.com/a/6121114/4561887
dir="$(dirname "${full_path}")"
# echo "dir = \"$dir\""

path2exec="${dir}/pdf2searchablepdf.sh" # path to the executable bash script
# echo "path2exec = \"$path2exec\""

ln -sf "$path2exec" ~/bin/pdf2searchablepdf

echo "Done: symbolic link should have been placed in \"~/bin/pdf2searchablepdf\"."
