# "Install" this script by symbolically linking from here to your "~/bin" dir!
# - NB: don't delete your files here or it will break the "install", since it's simply symbolically linking to
#   the executable here!
# - Therefore, if you move these files, simply re-run this install script and it will automatically update the
#   symbolic link in ~/bin and all will be well again!
# - Note: this script does NOT add the "~/bin" dir to your PATH. Run `echo $PATH` and ensure you see an entry like
#   this: `/home/my_username/bin:`. If you don't, you'll need to manually add your "~/bin" directory to your path
#   for this program to be visible.

# See my answer: https://stackoverflow.com/a/60157372/4561887
FULL_PATH_TO_SCRIPT="$(realpath "${BASH_SOURCE[-1]}")"
SCRIPT_DIRECTORY="$(dirname "$FULL_PATH_TO_SCRIPT")"
SCRIPT_FILENAME="$(basename "$FULL_PATH_TO_SCRIPT")"

mkdir -p ~/bin

path2exec="${SCRIPT_DIRECTORY}/pdf2searchablepdf.sh" # path to the executable bash script
# echo "path2exec = \"$path2exec\""

ln -sf "$path2exec" ~/bin/pdf2searchablepdf

# Install dependencies
distro_name="$(lsb_release -is)"
if [ "$distro_name" = "Ubuntu" ]; then
     echo "Installing Ubuntu dependencies using 'sudo apt'..."
     sudo apt update
     sudo DEBIAN_FRONTEND=noninteractive apt install -y \
          tesseract-ocr \
          ghostscript \
          poppler-utils \
          bc
fi

echo ""
echo ""
echo "=================== FINAL 'pdf2searchablepdf' INSTALLATION INSTRUCTIONS ====================="

if [ "$distro_name" != "Ubuntu" ]; then
     echo "You are not running Ubuntu, so you'll need to install dependencies manually yourself."
     echo "See here for a list of them:"\
          "https://github.com/ElectricRCAircraftGuy/PDF2SearchablePDF#install"
fi

echo ""
echo "Done: a symbolic link should have been placed in \"~/bin/pdf2searchablepdf\"."
echo ""
echo "\
Run '. ~/.profile' now to re-source your \"~/.profile\" file, which sources
your \"~/.bashrc\" file, to ensure the new \"~/bin\" dir is in your PATH.

If you are not running Ubuntu, or if you do not have Ubuntu's default
'~/.profile' file, you may need to manually add '~/bin' to your path instead. In
this case, add the following to the bottom of your '~/.bashrc' file:
"'
     # From Ubuntu'"'"'s default "~/.profile" file at /etc/skel/.profile:
     # set PATH so it includes user'"'"'s private bin if it exists
     if [ -d "$HOME/bin" ] ; then
         PATH="$HOME/bin:$PATH"
     fi

Then, re-source your ~/.bashrc file with '"'. ~/.bashrc'

To understand more about 'source' vs 'export', see my answer here:
https://stackoverflow.com/a/62626515/4561887
"


# end
