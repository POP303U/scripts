#!/usr/bin/env bash

echo ""
echo "#######################"
echo "# Setting up Drive... #"
echo "#######################"
echo ""
lsblk
printf "Enter the name of your Drive (example /dev/sda): "
read DRIVE

echo "Wiping the drive $DRIVE..."
dd if=/dev/zero of=$DRIVE bs=1M count=100

echo "Creating GPT signature on $DRIVE..."
parted -s $DRIVE mklabel gpt

echo "Creating a 1G partition on $DRIVE..."
parted -s $DRIVE mkpart primary 0GB 1GB

echo "Creating a 4G partition on $DRIVE..."
parted -s $DRIVE mkpart primary 1GB 5GB

echo "Creating a partition with the rest of the disk on $DRIVE..."
parted -s $DRIVE mkpart primary 5GB 100%

# Display partition table
echo "Partition table for $DRIVE:"
parted $DRIVE print
exit 0
#printf "Please enter EFI partition: (example /dev/sda1 or /dev/nvme0n1p1): "
#read EFI_PART
#printf "Please enter SWAP partition: (example /dev/sda2 or /dev/nvme0n1p2): "
#read SWAP_PART
#printf "Please enter Root(/) partition: (example /dev/sda3 or /dev/nvme0n1p3): "
read ROOT_PART
echo ""

echo ""
echo "############################"
echo "# Setting up Filesystem... #"
echo "############################"
echo "Choose filesystem for Drive: \

    1. xfs
    2. ext4
    3. f2fs
    4. btrfs
    "
printf "Select filesystem type (1..4): "
read DRIVE_FS

echo ""
echo "#######################"
echo "# Setting up Users... #"
echo "#######################"
echo ""
printf "Please enter the root password: "
read ROOT_PASSWD
printf "Please enter your username: "
read USERNAME
printf "Please enter your users password: "
read USER_PASSWD

#echo "EFI_PART: ${EFI_PART}"
#echo "SWAP_PART: ${SWAP_PART}"
#echo "ROOT_PART: ${ROOT_PART}"
#echo "DRIVE_FS: ${DRIVE_FS}"
#echo "ROOT_PASSWD: ${ROOT_PASSWD}"
#echo "USERNAME: ${USERNAME}"
#echo "USER_PASSWD: ${USER_PASSWD}"

echo "#######################"
echo "# Formatting Drive... #"
echo "#######################"
echo ""

mkfs.vfat -F32 "${EFI_PART}"
mkswap "${SWAP_PART}"
swapon "${SWAP_PART}"

case "$DRIVE_FS" in
    1)
        mkfs.xfs -f "${ROOT_PART}"
        ;;
    2)
        mkfs.ext4 "${ROOT_PART}"
        ;;
    3)
        mkfs.f2fs "${ROOT_PART}"
        ;;
    4)
        mkfs.btrfs "${ROOT_PART}"
        ;;
    *)
        echo "Invalid filesystem type selected! value: $DRIVE_FS"
        echo "Exiting safely..."
        exit 0
        ;;
esac

echo "##########################"
echo "# Mounting Partitions... #"
echo "##########################"
echo ""

#mkdir -p /mnt/boot/efi
#mount "${ROOT_PART}" /mnt
#mount "${EFI_PART}" /mnt/boot/efi

echo "#--------------------------------------------#"
echo "~- Installing Arch Linux base on Main Drive -~"
echo "#--------------------------------------------#"
#pacstrap /mnt base base-devel linux linux-firmware --noconfirm --needed

#sudo pacman -Sy p7zip unrar tar rsync github-cli git neofetch htop exfat-utils fuse-exfat ntfs-3g flac jasper aria2 curl wget jp2a less --noconfirm
