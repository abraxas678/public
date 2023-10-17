#!/bin/bash

# Check if the system is WSL or not
if grep -qE "(Microsoft|WSL)" /proc/version; then
    echo "This system is running under WSL."
else
    echo "This system is not running under WSL."
    # exit 1
fi

# Check and display the current hostname
current_hostname=$(hostname)
echo "Current hostname: $current_hostname"

# Ask user if the hostname is okay
read -p "Is the hostname OK? (y/n): " user_response
if [[ "$user_response" == "y" ]]; then
    echo "No changes will be made to the hostname."
    exit 0
else
    # Get the new hostname from the user
    read -p "Please enter the new hostname: " new_hostname
    
    # Change the hostname
    sudo hostnamectl set-hostname "$new_hostname"
    
    # Update /etc/hosts
    sudo sed -i "s/$current_hostname/$new_hostname/g" /etc/hosts
    
    # Display the updated hostname
    echo "Hostname changed successfully. New hostname: $(hostname)"
fi
