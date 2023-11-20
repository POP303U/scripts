# # # # # # # # # # # # # # #
# FONT INSTALLATION SCRIPT  #
# # # # # # # # # # # # # # #
# Move your fonts into a directory called 'fonts'
# and run this script (support for .otf and .ttf)

echo 'Enter your username (wont work without it correctly): '
read user_name

source_dir="fonts"
destination_dir="/home/$user_name/.local/share/fonts"

printf "Fonts to be installed: \n"

find . -name "*.ttf" -exec printf {}"\n" \;
find . -name "*.otf" -exec printf {}"\n" \;

echo "Continue (y/n)?"
read user_input
if [ "$user_input" == "y" ] || [ "$user_input" == "Y" ]; then
    echo "Executing"
else 
    echo "Exiting the script."
    exit 0
fi

mkdir -p "$destination_dir"
find . -name "*.ttf" -exec cp -v {} $destination_dir \;
find . -name "*.otf" -exec cp -v {} $destination_dir \;
fc-cache -fv
echo "Successfully installed fonts!"

echo "Do you want to install system-wide fonts (recommended)(y/n)?"
read user_input
if [ "$user_input" == "y" ] || [ "$user_input" == "Y" ]; then
    echo "Executing"
else 
    echo "Exiting the script."
    exit 0
fi

pacman -Sy noto-fonts ttf-dejavu ttf-liberation ttf-linux-libertine ttf-inconsolata --noconfirm

ln -s /etc/fonts/conf.avail/70-no-bitmaps.conf /etc/fonts/conf.d
ln -s /etc/fonts/conf.avail/10-sub-pixel-rgb.conf /etc/fonts/conf.d
ln -s /etc/fonts/conf.avail/11-lcdfilter-default.conf /etc/fonts/conf.d

rm /etc/profile.d/freetype2.sh
touch /etc/profile.d/freetype2.sh

printf '
# Subpixel hinting mode can be chosen by setting the right TrueType interpreter
# version. The available settings are:
#
#     truetype:interpreter-version=35  # Classic mode (default in 2.6)
#     truetype:interpreter-version=40  # Minimal mode (default in 2.7)
#
# There are more properties that can be set, separated by whitespace. Please
# refer to the FreeType documentation for details.

# Uncomment and configure below
export FREETYPE_PROPERTIES="truetype:interpreter-version=40"
' >> /etc/profile.d/freetype2.sh

rm /etc/fonts/local.conf
touch /etc/fonts/local.conf
printf '<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE fontconfig SYSTEM "fonts.dtd">
<fontconfig>
   <match>
      <edit mode="prepend" name="family">
         <string>Noto Sans</string>
      </edit>
   </match>
   <match target="pattern">
      <test qual="any" name="family">
         <string>serif</string>
      </test>
      <edit name="family" mode="assign" binding="same">
         <string>Noto Serif</string>
      </edit>
   </match>
   <match target="pattern">
      <test qual="any" name="family">
         <string>sans-serif</string>
      </test>
      <edit name="family" mode="assign" binding="same">
         <string>Noto Sans</string>
      </edit>
   </match>
   <match target="pattern">
      <test qual="any" name="family">
         <string>monospace</string>
      </test>
      <edit name="family" mode="assign" binding="same">
         <string>Noto Mono</string>
      </edit>
   </match>
</fontconfig>
' >> /etc/fonts/local.conf

fc-cache -fv
