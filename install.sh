# "Install" this script by symbolically linking from here to your "~/bin" dir! 
# - NB: don't delete your files here or it will break the "install", since it's simply symbolically linking to 
#   the executable here! 
# - Therefore, if you move these files, simply re-run this install script and it will automatically update the 
#   symbolic link in ~/bin and all will be well again! 
# - Note: this script does NOT add the "~/bin" dir to your PATH. Run `echo $PATH` and ensure you see an entry like 
#   this: `/home/my_username/bin:`. If you don't, you'll need to manually add your "~/bin" directory to your path
#   for this program to be visible.

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
