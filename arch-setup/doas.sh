# WILL REMOVE SUDO RUN AT YOUR OWN RISK
sudo pacman -S opendoas
doas pacman -R sudo
doas chown -c root:root /etc/doas.conf
doas chmod -c 0400 /etc/doas.conf

# Replace sudo with doas
ln -s $(which doas) /usr/bin/sudo

#!/bin/bash
if [ "$(id -u)" != 0 ]; then
        doas /root/script/vidoas
else
        /root/script/vidoas
fi
