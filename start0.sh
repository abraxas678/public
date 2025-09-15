#!/bin/bash
if [ "$(id -u)" = 0 ]; then
    MYROOT=""
else
    MYROOT="sudo"
fi

# Install prerequisites only if missing
missing_packages=()
for pkg in wget curl coreutils nfs-common; do
    dpkg -s "$pkg" >/dev/null 2>&1 || missing_packages+=("$pkg")
done
if [ ${#missing_packages[@]} -gt 0 ]; then
    $MYROOT apt-get update
    $MYROOT apt-get install -y "${missing_packages[@]}"
fi

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

$MYROOT systemctl daemon-reload
$MYROOT mount -a


# Ensure keepassxc-cli is installed
if ! command -v keepassxc-cli >/dev/null 2>&1; then
    echo "keepassxc-cli not found. Installing keepassxc..."
    $MYROOT apt-get update
    $MYROOT apt-get install -y keepassxc
else
    echo "keepassxc-cli already installed: $(keepassxc-cli --version | head -n1)"
fi

exit
mkdir ./start0tmp && mount -t tmpfs -o size=500m tmpfs ./start0tmp
cd start0tmp

wget https://s.xxxyzzz.xyz/start0.key.keyx.tar.age
wget https://s.xxxyzzz.xyz/start.age.key.kdbx

read -s -p "AGE PRIVATE KEY: > " me
echo $me >key.txt
#cat key.txt
unset me

age --decrypt -i key.txt -o start0.key.keyx.tar start0.key.keyx.tar.age
tar xf start0.key.keyx.tar
shred -uvn 10 start0.key.keyx.tar
shred -uvn 10 rm start0.key.keyx.tar.age
shred -uvn 10 rm key.txt

