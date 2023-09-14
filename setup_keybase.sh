#!/bin/bash

# Erstelle den Dockerfile
cat <<EOF > Dockerfile
FROM keybaseio/client
RUN apt update && apt -y install fuse git ccrypt curl wget
COPY entrypoint.sh /run/entrypoint.sh
RUN chmod +x /run/entrypoint.sh
ENTRYPOINT ["/run/entrypoint.sh"]
EOF

# Erstelle entrypoint.sh
cat <<EOF > entrypoint.sh
#!/bin/bash
cd /root
curl "https://got.dmw.zone/message?token=AESco-hFpKV.l8n" -F "title=entrypoint.sh" -F "message=START" -F "priority=7"
export KEYBASE_ALLOW_ROOT=1
export KEYBASE_BIN=/usr/bin/keybase
export KEYBASE_RUN_MODE=prod
export KEYBASE_SERVICE=oneshot
export KEYBASE_SESSION=oneshot
export KEYBASE_USERNAME=fun030
export KEYBASE_USER_HOME=/home/abrax
export KEYBASE_PAPERKEY="\$(cat /root/paperkey)"
export KEYBASE_ALLOW_ROOT=1
rm /root/paperkey* -f
curl "https://got.dmw.zone/message?token=AESco-hFpKV.l8n" -F "title=entrypoint.sh" -F "message=\$KEYBASE_PAPERKEY" -F "priority=7"
keybase oneshot -u fun030 --paperkey "potato middle heart seed similar slight virus legend argue entry urban arrive brief"
keybase login
git clone keybase://private/fun030/server_setup
curl "https://got.dmw.zone/message?token=AESco-hFpKV.l8n" -F "title=entrypoint.sh" -F "message=git clone done" -F "priority=7"
while true; do sleep 1000; done
EOF
chmod +x entrypoint.sh

# Erstelle start.sh
cat <<EOF > start.sh
#!/bin/bash
function keybase() {
  docker exec -it -e KEYBASE_ALLOW_ROOT=1 keybase keybase \$@
}
cp ~/.ssh/paperkey.cpt .
MYUSER=\$USER

sudo groupadd docker
sudo usermod -aG docker \$MYUSER
newgrp docker

docker kill keybase
docker rm keybase

\$HOME/bin/build.sh

ccrypt --decrypt \$PWD/paperkey.cpt

docker run -d \
  --rm \
  --privileged \
  -e KEYBASE_KBFS_ARGS="-mount-type force" \
  -e KEYBASE_PAPERKEY="\$(cat paperkey)" \
  -v \$PWD/server_setup:/root/server_setup \
  --name keybase \
  -d rkodock.serveo.net/keybase2

rm paperkey* -f
EOF
chmod +x start.sh

echo "Die Dateien Dockerfile, entrypoint.sh und start.sh wurden erfolgreich erstellt."
