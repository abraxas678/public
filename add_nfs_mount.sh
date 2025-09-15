#!/bin/bash

# Create mount directory
sudo mkdir -p /mnt/unas/sec
sudo chown abrax:abrax /mnt/unas/sec

# Check if NFS mount already exists in /etc/fstab
if grep -q "10.10.101.1:/volume1/sec" /etc/fstab; then
    echo "NFS mount already exists in /etc/fstab"
else
    # Add NFS mount to /etc/fstab
    echo "10.10.101.1:/volume1/sec /mnt/unas/sec nfs proto=tcp,hard,intr,timeo=600,retrans=2,rsize=1048576,wsize=1048576,nodev,nosuid,noexec 0 0" | sudo tee -a /etc/fstab
    echo "NFS mount added to /etc/fstab"
fi

echo "Directory /mnt/unas/sec created/verified"