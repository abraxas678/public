#! /bin/bash
curl -sL "https://api.github.com/repos/$1/$2/releases/latest" | gron | grep browser_download_url | grep deb | sed "s/.*browser_download_url = //" | sed "s/^\"//" | sed "s/\";$//" | grep -v arm >res
COUNT=$(cat res | wc -l)
if [[ $COUNT != 0 ]]; then
 echo -n ""
else
curl -sL "https://api.github.com/repos/$1/$2/releases/latest" | gron | grep browser_download_url | sed "s/.*browser_download_url = //" | sed "s/^\"//" | sed "s/\";$//" | grep -v arm >res
COUNT=$(cat res | wc -l)
fi
RES="$(cat res | sed 's/.*download//'| fzf)"
if [[ $COUNT != 0 ]]; then
  cat res | grep "$RES" | xsel -b
  cat res | grep "$RES"
else
  cat res
  echo no
fi
