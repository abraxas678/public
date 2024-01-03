#!/bin/bash

# Solution Script to Resolve NFS Mount Error

# Function to check if rpc.statd is running
check_rpc_statd() {
    if pgrep -x "rpc.statd" > /dev/null; then
        echo "rpc.statd is running."
        return 1
    else
        echo "rpc.statd is not running."
        return 0
    fi
}

# Function to start rpc.statd
start_rpc_statd() {
    echo "Starting rpc.statd..."
    sudo systemctl start rpc-statd
    echo "rpc.statd started."
}

# Function to mount NFS with nolock
mount_nfs_nolock() {
    echo "Mounting NFS without network locking..."
#    sudo mount -o nolock <NFS_Server>:<NFS_Share> <Mount_Point>
    sudo mount -o nolock $SNAS_IP:/volume2/setup /home/mnt/snas/setup
    echo "NFS mounted with nolock."
}

# Main Execution
check_rpc_statd
result=$?

# Uncomment one of the following blocks based on your requirement

 Start rpc.statd if not running
if [ $result -eq 0 ]; then
    start_rpc_statd
fi

 Mount with nolock
if [ $result -eq 0 ]; then
    mount_nfs_nolock
fi


