# "Install" this script by symbolically linking from here to your "~/bin" dir! 
# - NB: don't delete your files here or it will break the "install", since it's simply symbolically linking to 
#   the executable here!
# - Note: this script does NOT add the "~/bin" dir to your PATH. Run `echo $PATH` and ensure you see an entry like 
#   this: `/home/my_username/bin:`. If you don't, you'll need to manually add your "~/bin" directory to your path
#   for this program to be visible.

mkdir -p ~/bin
ln -s 