# WILL REMOVE SUDO RUN AT YOUR OWN RISK
sudo pacman -S opendoas
sudo pacman -R sudo
sudo chown -c root:root /etc/doas.conf
sudo chmod -c 0400 /etc/doas.conf

# Replace sudo with doas
ln -s $(which doas) /usr/bin/sudo

#!/bin/bash
if [ "$(id -u)" != 0 ]; then
        doas /root/script/vidoas
else
        /root/script/vidoas
fi
