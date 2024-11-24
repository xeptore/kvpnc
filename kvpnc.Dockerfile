# syntax=docker/dockerfile:1
FROM docker.io/ubuntu:24.10
COPY ./entrypoint.sh ./install.sh /
ADD https://cdn.kerio.com/dwn/kerio-control-vpnclient-linux-amd64.deb /tmp/kerio.deb
RUN <<EOT
#!/usr/bin/bash
set -Eeuo pipefail
apt-get update
apt-get install -y iproute2 libcurl4t64 openssl libuuid1 procps cifs-utils smbclient
apt-get clean
rm -rf /var/lib/apt/lists/*
bash /install.sh
chmod +x /entrypoint.sh
EOT
ENTRYPOINT ["/entrypoint.sh"]
