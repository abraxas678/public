#!/bin/bash
MYPWD=$PWD
if [ "$(id -u)" = 0 ]; then
    MYROOT=""
else
    MYROOT="sudo"
fi

# Detect OS and set package manager
if [ -f /etc/os-release ]; then
    . /etc/os-release
    OS=$ID
else
    echo "Cannot detect OS. /etc/os-release not found."
    exit 1
fi

case "$OS" in
    ubuntu|debian|linuxmint|pop)
        PKG_MANAGER="apt"
        PKG_UPDATE="apt-get update"
        PKG_INSTALL="apt-get install -y"
        PKG_CHECK="dpkg -s"
        NFS_PKG="nfs-common"
        ;;
    fedora|rhel|centos|rocky|almalinux)
        PKG_MANAGER="dnf"
        PKG_UPDATE="dnf check-update || true"
        PKG_INSTALL="dnf install -y"
        PKG_CHECK="rpm -q"
        NFS_PKG="nfs-utils"
        ;;
    *)
        echo "Unsupported OS: $OS"
        echo "This script supports: Ubuntu, Debian, Fedora, RHEL, CentOS, Rocky, AlmaLinux"
        exit 1
        ;;
esac

echo "Detected OS: $OS"
echo "Using package manager: $PKG_MANAGER"
echo
sleep 3
#source $MYPWD/header.source

if [ "$OS" = "ubuntu" ]; then
    echo
    echo "sudo ubuntu-drivers install"
    echo "for the newest driver"
    echo
fi

echo
echo "sudo visudo"
echo
echo "abrax ALL=(ALL:ALL) NOPASSWD: ALL"
echo
read -p "--" -t 60 me

$MYPWD/github_latest_release_url_install.sh Eugeny tabby

# Install prerequisites only if missing
missing_packages=()
for pkg in wget curl coreutils $NFS_PKG; do
    $PKG_CHECK "$pkg" >/dev/null 2>&1 || missing_packages+=("$pkg")
done

if [ ${#missing_packages[@]} -gt 0 ]; then
    $MYROOT $PKG_UPDATE
    $MYROOT $PKG_INSTALL "${missing_packages[@]}"
fi

THORIUM="$(command -v thorium-browser || true)"
if [ -z "$THORIUM" ]; then
  ./github_latest_release_url_install.sh Alex313031 thorium
fi


mkdir -p $HOME/tmp
cd $HOME/tmp
mkdir ./starttmp -p;  mount -t tmpfs -o size=500m tmpfs ./starttmp
cd starttmp

$MYROOT $PKG_INSTALL restic rclone ansible xsel keepassxc git gh zsh curl wget unzip

#command -v espanso;
#[[ $? != 0 ]] && ./espanso_setup_x11.sh

rm start.sh
[[ ! -f start.sh ]] && wget https://s.xxxyzzz.xyz/start.sh
chmod +x start.sh
echo "starting sudo start.sh"
read -p B -t 10 me
sudo ./start.sh
