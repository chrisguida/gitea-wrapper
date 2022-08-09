#!/bin/sh

TOR_ADDRESS=$(yq e '.tor-address' /data/start9/config.yaml)
LAN_ADDRESS=$(echo "$TOR_ADDRESS" | sed -r 's/(.+)\.onion/\1.local/g')
export GITEA__server__DOMAIN=$TOR_ADDRESS
export GITEA__server__ROOT_URL="http://$TOR_ADDRESS/"
export GITEA__server__SSH_DOMAIN=$TOR_ADDRESS

exec tini /usr/bin/entrypoint -- /bin/s6-svscan /etc/s6
