#! /bin/bash

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
        PKG_UPDATE="apt update"
        PKG_INSTALL="apt install -y"
        PKG_EXT="deb"
        INSTALL_LOCAL="apt install"
        ;;
    fedora|rhel|centos|rocky|almalinux)
        PKG_UPDATE="dnf check-update || true"
        PKG_INSTALL="dnf install -y"
        PKG_EXT="rpm"
        INSTALL_LOCAL="dnf install"
        ;;
    *)
        echo "Unsupported OS: $OS"
        echo "This script supports: Ubuntu, Debian, Fedora, RHEL, CentOS, Rocky, AlmaLinux"
        exit 1
        ;;
esac

echo "Detected OS: $OS, using package format: .$PKG_EXT"

#gum spin --title=update... --spinner=dot -- sudo $PKG_UPDATE >/dev/null
sudo $PKG_UPDATE >/dev/null
#2>&1
sudo $PKG_INSTALL gron xsel fzf
curl -sL "https://api.github.com/repos/$1/$2/releases/latest" | gron | grep browser_download_url | grep $PKG_EXT | sed "s/.*browser_download_url = //" | sed "s/^\"//" | sed "s/\";$//" | grep -v arm >res
RES="$(cat res | sed 's/.*download//'| fzf)"
if [[ $(echo $RES | wc -l) != 0 ]]; then
cat res | grep "$RES" | xsel -b
URL=$(cat res | grep "$RES")
else
curl -sL "https://api.github.com/repos/FiloSottile/age/releases/latest" | jq . | gron | grep "browser_download_url" >res
#cat res | grep "$RES" | xsel -b
URL=$(cat res | grep "$RES")
#wget $(cat res | grep "$RES")
sudo $PKG_INSTALL "$RES"
fi
echo $URL
wget $URL
sudo $PKG_UPDATE
sudo $INSTALL_LOCAL ./$(basename $URL) -y
[[ $? = 0 ]] && rm $(basename $URL)
rm res
