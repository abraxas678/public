#!/bin/bash
if [ "$(id -u)" = 0 ]; then
    MYROOT=""
else
    MYROOT="sudo"
fi

#source $MYPWD/header.source

echo
echo "sudo visudo"
echo
echo "abrax ALL=(ALL:ALL) NOPASSWD: ALL"
echo
read -p "--" -t 60 me

# Install prerequisites only if missing
missing_packages=()
for pkg in wget curl coreutils nfs-common; do
    dpkg -s "$pkg" >/dev/null 2>&1 || missing_packages+=("$pkg")
done

if [ ${#missing_packages[@]} -gt 0 ]; then
    $MYROOT apt-get update
    $MYROOT apt-get install -y "${missing_packages[@]}"
fi

THORIUM="$(command -v thorium-browser || true)"
if [ -z "$THORIUM" ]; then
  ./github_latest_release_url_install.sh Alex313031 thorium
fi


mkdir -p $HOME/tmp
cd $HOME/tmp
mkdir ./starttmp -p;  mount -t tmpfs -o size=500m tmpfs ./starttmp
cd starttmp

sudo apt install restic rclone ansible xsel keepassxc git gh curl wget unzip -y

rm start.sh
[[ ! -f start.sh ]] && wget https://s.xxxyzzz.xyz/start.sh
chmod +x start.sh
sudo ./start.sh
