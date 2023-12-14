#!/usr/bin/env sh

pacman -S virt-manager virt-viewer qemu edk2-ovmf vde2 ebtables dnsmasq bridge-utils openbsd-netcat libguestfs

systemctl enable libvirtd.service
systemctl start libvirtd.service

rm -f br10.xml
echo "<network>
  <name>br10</name>
  <forward mode='nat'>
    <nat>
      <port start='1024' end='65535'/>
    </nat>
  </forward>
  <bridge name='br10' stp='on' delay='0'/>
  <ip address='192.168.30.1' netmask='255.255.255.0'>
    <dhcp>
      <range start='192.168.30.50' end='192.168.30.200'/>
    </dhcp>
  </ip>
</network>" >> br10.xml

virsh net-define br10.xml
virsh net-start br10
virsh net-autostart br10

rm -f /etc/libvirt/libvirtd.conf
echo 'unix_sock_group = "libvirt"
unix_sock_ro_perms = "0777"
unix_sock_rw_perms = "0770"' >> /etc/libvirt/libvirtd.conf

usermod -a -G kvm $(whoami)
usermod -a -G libvirt $(whoami)
gpasswd -a "$USER" libvirt
newgrp libvirt

modprobe -r kvm_intel
modprobe kvm_intel nested=1
echo "options kvm-intel nested=1" | tee /etc/modprobe.d/kvm-intel.conf

systool -m kvm_intel -v | grep nested
cat /sys/module/kvm_intel/parameters/nested
