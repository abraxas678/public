#!/bin/bash

# Step 1: Install davfs2
sudo apt-get update
sudo apt-get install -y davfs2

# Step 2: Create mount point
sudo mkdir -p /home/mnt/nextcloud

# Optional: To allow non-root users to mount WebDAV resources,
# you can add your user to the davfs2 group (replace `youruser` with your username)
sudo usermod -aG davfs2 Admin

# Step 3: Configure davfs2 secrets
echo "https://next.dmw.zone/remote.php/dav/files/Admin Admin 2fNMbpdq4rw7hAewiWpXVXSP3XjU4VJ9i" | sudo tee -a /etc/davfs2/secrets

# Step 4: Mount the WebDAV resource
sudo mount -t davfs https://next.dmw.zone/remote.php/dav/files/Admin /home/mnt/nextcloud

# To ensure the mount persists across reboots, add it to /etc/fstab:
echo "https://next.dmw.zone/remote.php/dav/files/Admin /home/mnt/nextcloud davfs _netdev,users 0 0" | sudo tee -a /etc/fstab
