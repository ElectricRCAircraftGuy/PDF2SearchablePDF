# "Install" this script by symbolically linking from here to your "~/bin" dir! 
# - NB: don't delete your files here or it will break the "install", since it's simply symbolically linking to 
#   the executable here! 
# - Therefore, if you move these files, simply re-run this install script and it will automatically update the 
#   symbolic link in ~/bin and all will be well again! 
# - Note: this script does NOT add the "~/bin" dir to your PATH. Run `echo $PATH` and ensure you see an entry like 
#   this: `/home/my_username/bin:`. If you don't, you'll need to manually add your "~/bin" directory to your path
#   for this program to be visible.

brew install poppler tesseract

dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

path2exec="${dir}/pdf2searchablepdf.sh" # path to the executable bash script
# echo "path2exec = \"$path2exec\""

echo alias\ pdf2searchablepdf="$path2exec" >> ~/.bash_profile
echo "Done: alias inserted in ~/.bash_profile"
