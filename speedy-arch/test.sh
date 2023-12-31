ROOT_PART="/dev/sdb3"
MOUNT_DIR="/mnt/arch"

# Check if the mount point exists, create it if not
if [ ! -d "$MOUNT_DIR" ]; then
    mkdir -p "$MOUNT_DIR"
fi

# Mount the drive
mount "$ROOT_PART" "$MOUNT_DIR"

# Check if the mount was successful
if [ $? -eq 0 ]; then
    echo "Drive mounted successfully"
else
    echo "Failed to mount the drive"
fi
