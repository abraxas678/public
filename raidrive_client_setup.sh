#!/bin/bash
echo
set -e # Exit immediately if a command exits with a non-zero status

# Function to print formatted messages
print_step() {
    echo "--> $1"
}

print_sub_step() {
    echo "    - $1"
}

echo "=============================================="
echo " Starting RaiDrive Client Setup Script "
echo "=============================================="
echo

print_step "Setting up temporary directory..."
mkdir -p $HOME/tmp
cd $HOME/tmp
print_sub_step "Working directory: $(pwd)"

MYME=$(basename "$0")
MYPATH=$(dirname "$(readlink -f "$0")")
# echo "MYME: $MYME" # Optional: Keep if needed for debugging
# echo "MYPATH: $MYPATH" # Optional: Keep if needed for debugging

echo
print_step "Determining sudo requirement..."
if [[ $(whoami) = "root" ]]; then
  MYSUDO=""
  print_sub_step "Running as root, sudo not required."
else
  MYSUDO="sudo"
  print_sub_step "Running as non-root, 'sudo' will be used."
fi

echo
echo "----------------------------------------------"
print_step "System Preparation"
echo "----------------------------------------------"

print_step "Checking internet connectivity..."
if ! ping -c 1 google.com &>/dev/null; then
    print_sub_step "No internet connection detected. Attempting to set DNS..."
    echo "nameserver 1.1.1.1" | $MYSUDO tee -a /etc/resolv.conf >>/dev/null
    print_sub_step "DNS server set to 1.1.1.1."
else
    print_sub_step "Internet connection verified."
fi

print_step "Updating package list..."
$MYSUDO apt update
print_step "Installing base packages (curl, wget, sudo, nano)..."
$MYSUDO apt install -y curl wget sudo nano

echo
echo "----------------------------------------------"
print_step "User 'abrax' Management"
echo "----------------------------------------------"

print_step "Checking if user 'abrax' exists..."
if ! id "abrax" &>/dev/null; then
    print_sub_step "User 'abrax' not found. Creating user..."
    useradd -m abrax
    echo "    ! Please set a password for user 'abrax':"
    passwd abrax
    print_sub_step "Adding user 'abrax' to sudo group..."
    usermod -aG sudo abrax
    print_sub_step "Switching to user 'abrax'..."
    su abrax
else
    print_sub_step "User 'abrax' already exists."
fi

print_step "Ensuring current user is 'abrax'..."
if [[ $(whoami) != "abrax" ]]; then
    print_sub_step "Not running as 'abrax'. Switching user..."
    su abrax
else
     print_sub_step "Currently running as 'abrax'."
fi


echo
echo "----------------------------------------------"
print_step "RaiDrive Installation"
echo "----------------------------------------------"

print_step "Checking if RaiDrive CLI is installed..."
if ! command -v raidrivecli &> /dev/null; then
    print_sub_step "RaiDrive CLI not found. Installing..."
    print_sub_step "Downloading RaiDrive CLI package..."
    wget https://app.raidrive.com/deb/pool/main/r/raidrive/raidrive_2024.9.27.6-linux_amd64.deb -q --show-progress
    print_sub_step "Updating package list before installing RaiDrive..."
    sudo apt update
    print_sub_step "Installing RaiDrive CLI..."
    sudo apt install -y ./raidrive_2024.9.27.6-linux_amd64.deb
else
    print_sub_step "RaiDrive CLI is already installed."
fi

echo
echo "----------------------------------------------"
#print_step "Tailscale Installation & Setup"
echo "----------------------------------------------"

#print_step "Checking if Tailscale is installed..."
#if ! command -v tailscale &> /dev/null; then
#    print_sub_step "Tailscale not found. Installing..."
#    curl -fsSL https://tailscale.com/install.sh | sudo sh
#else
#    print_sub_step "Tailscale is already installed."
#fi

#print_step "Bringing Tailscale up..."
#$MYSUDO tailscale up --ssh --accept-routes --accept-risk=lose-ssh

echo
echo "----------------------------------------------"
print_step "RaiDrive Connection Setup"
echo "----------------------------------------------"

print_step "Adding RaiDrive WebDAV connection (tdrive)..."
raidrivecli add webdav webdav://100.100.100.100:8080 -l tdrive -m /mnt/tdrive -u anonymous

echo
echo "=============================================="
echo " Script Finished Successfully "
echo "=============================================="
echo
