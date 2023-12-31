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

# <- GPT SIGNATURE ->
echo "Creating GPT signature on $DRIVE..."
parted -s $DRIVE mklabel gpt

# <- EFI ->
echo "Creating a 1G partition on $DRIVE..."
parted -s $DRIVE mkpart primary 0GB 1GiB
EFI_PART="${DRIVE}1"

# <- SWAP ->
echo "Creating a 4G partition on $DRIVE..."
parted -s $DRIVE mkpart primary 1GiB 5GiB
SWAP_PART="${DRIVE}2"

# <- ROOT ->
echo "Creating a partition with the rest of the disk on $DRIVE..."
parted -s $DRIVE mkpart primary 5GiB 100%
ROOT_PART="${DRIVE}3"

# Display partition table
echo "Partition table for $DRIVE:"
parted $DRIVE print

echo ""
echo "############################"
echo "# Setting up Filesystem... #"
echo "############################"
echo "Choose filesystem for Drive:
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
        mkfs.ext4 -f "${ROOT_PART}"
        ;;
    3)
        mkfs.f2fs -f "${ROOT_PART}"
        ;;
    4)
        mkfs.btrfs -f "${ROOT_PART}"
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

MOUNT_DIR_ROOT="/mnt/arch"
MOUNT_DIR_EFI="/mnt/arch/boot/efi"

if [ ! -d "$MOUNT_DIR_ROOT" ]; then
    mkdir -p "$MOUNT_DIR_ROOT"
fi

if [ ! -d "$MOUNT_DIR_EFI" ]; then
    mkdir -p "$MOUNT_DIR_EFI"
fi

# Mount the drive
mount "$ROOT_PART" "$MOUNT_DIR_ROOT"
mount "$EFI_PART" "$MOUNT_DIR_EFI"

# Check if the mount was successful
if [ $? -eq 0 ]; then
    echo "Drive mounted successfully"
else
    echo "Failed to mount the drive"
fi

echo "#--------------------------------------------#"
echo "~- Installing Arch Linux base on Main Drive -~"
echo "#--------------------------------------------#"

pacstrap "${MOUNT_DIR_ROOT}" base base-devel linux linux-firmware --noconfirm --needed

#DEBUG
#echo "EFI_PART: ${EFI_PART}"
#echo "SWAP_PART: ${SWAP_PART}"
#echo "ROOT_PART: ${ROOT_PART}"
#echo "DRIVE_FS: ${DRIVE_FS}"
#echo "ROOT_PASSWD: ${ROOT_PASSWD}"
#echo "USERNAME: ${USERNAME}"
#echo "USER_PASSWD: ${USER_PASSWD}"

#sudo pacman -Sy p7zip unrar tar rsync github-cli git neofetch htop exfat-utils fuse-exfat ntfs-3g flac jasper aria2 curl wget jp2a less --noconfirm
while true;
do
    sleep 1
done
