#!/bin/bash

# exit script if return code != 0
set -e

apk add --no-cache \
    gawk \
    supervisor \
    tini \
    unrar \
    htop \
    jq \
    ts \
    curl \
    openssl \
    shadow

groupadd -g 99 media && \
useradd -u 99 -g 99 -d /home/media -s /bin/bash -m media && \

[[ -d /home/media ]] || mkdir -p /home/media

chown -R media:media '/home/media'
chmod -R 775 '/home/media'

rm -rf /tmp/*
