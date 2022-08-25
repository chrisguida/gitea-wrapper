#!/bin/sh

set -e

if [ "$(yq e ".disable-registration" /data/start9/config.yaml)" = "true" ]; then
    exit 0
else
    echo "For security purposes, user account registration should be disabled when not in use. You can disable registration in Config settings." >&2
    exit 1
fi
