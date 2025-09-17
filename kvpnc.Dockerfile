# syntax=docker/dockerfile:1
FROM docker.io/ubuntu:25.04
ARG XRAY_TAG
COPY ./entrypoint.sh ./install.sh /
ADD https://cdn.kerio.com/dwn/kerio-control-vpnclient-linux-amd64.deb /tmp/kerio.deb
ADD https://github.com/XTLS/Xray-core/releases/download/${XRAY_TAG}/Xray-linux-64.zip /root/xray/
RUN <<EOT
#!/usr/bin/bash
set -Eeuo pipefail
apt-get update
apt-get install -y iproute2 libcurl4t64 openssl libuuid1 procps cifs-utils smbclient wget unzip vim jq
apt-get clean
rm -rf /var/lib/apt/lists/*
bash /install.sh
chmod +x /entrypoint.sh
unzip -d /root/xray /root/xray/Xray-linux-64.zip
rm /root/xray/{README.md,LICENSE,Xray-linux-64.zip}
EOT
ENTRYPOINT ["/entrypoint.sh"]
