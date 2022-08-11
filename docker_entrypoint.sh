#!/bin/sh

touch /data/start9/stats.yaml

TOR_ADDRESS=$(yq e '.tor-address' /data/start9/config.yaml)
LAN_ADDRESS=$(echo "$TOR_ADDRESS" | sed -r 's/(.+)\.onion/\1.local/g')
if [ "$(yq ".local-mode" /data/start9/config.yaml)" = "true" ]; then
    DOMAIN=$LAN_ADDRESS
    PROTOCOL=https
else
    DOMAIN=$TOR_ADDRESS
    PROTOCOL=http
fi
export GITEA__server__DOMAIN=$DOMAIN
export GITEA__server__ROOT_URL="$PROTOCOL://$DOMAIN/"
export GITEA__server__SSH_DOMAIN=$DOMAIN

exec tini /usr/bin/entrypoint -- /bin/s6-svscan /etc/s6
