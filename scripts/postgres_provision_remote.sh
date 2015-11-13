# Remote script to provision a Postgres box.
# No arguments

MOUNT_POINT=/mnt/ebs-a
STORAGE_DEVICE=/dev/xvdf

echo "Formatting $STORAGE_DEVICE..."
sudo mkfs -t ext4 $STORAGE_DEVICE

echo "Mounting $STORAGE_DEVICE at $MOUNT_POINT..."
sudo mkdir $MOUNT_POINT
sudo cp /etc/fstab /etc/fstab.orig
echo "$STORAGE_DEVICE   $MOUNT_POINT  ext4    defaults,nofail 0   0" | sudo tee -a /etc/fstab
sudo mount -a
sudo rm /etc/fstab.orig
echo "Done mounting $STORAGE_DEVICE at $MOUNT_POINT."

# In order to first stand up the database, you'll also need to seed it from a production Rails
# container.  See `scripts/rails_seed.sh`