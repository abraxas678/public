#! /bin/bash
gum spin --title=update... --spinner=dot -- sudo apt update >/dev/null 
#2>&1
sudo apt install -y gron xsel fzf -y
curl -sL "https://api.github.com/repos/$1/$2/releases/latest" | gron | grep browser_download_url | grep deb | sed "s/.*browser_download_url = //" | sed "s/^\"//" | sed "s/\";$//" | grep -v arm >res
RES="$(cat res | sed 's/.*download//'| fzf)"
if [[ $(echo $RES | wc -l) != 0 ]]; then
cat res | grep "$RES" | xsel -b
URL=$(cat res | grep "$RES")
else
curl -sL "https://api.github.com/repos/FiloSottile/age/releases/latest" | jq . | gron | grep "browser_download_url" >res
#cat res | grep "$RES" | xsel -b
URL=$(cat res | grep "$RES")
fi
wget $(cat res | grep "$RES")
sudo apt update
echo
sudo apt install -y "./$(basename $RES)"
echo
echo URL $URL
echo RES $RES

