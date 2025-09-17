# syntax=docker/dockerfile:1
FROM docker.io/ubuntu:25.04
ARG XRAY_TAG
COPY ./entrypoint.sh ./install.sh /
ADD https://cdn.kerio.com/dwn/kerio-control-vpnclient-linux-amd64.deb /tmp/kerio.deb
ADD https://github.com/XTLS/Xray-core/releases/download/${XRAY_TAG}/Xray-linux-64.zip /root/xray/
RUN <<EOT
#!/usr/bin/bash
set -Eeuo pipefail

# Add httpie repository
curl -SsL https://packages.httpie.io/deb/KEY.gpg | sudo gpg --dearmor -o /usr/share/keyrings/httpie.gpg
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/httpie.gpg] https://packages.httpie.io/deb ./" | sudo tee /etc/apt/sources.list.d/httpie.list > /dev/null

apt-get update
apt-get install -y iproute2 libcurl4t64 openssl libuuid1 procps cifs-utils smbclient wget unzip vim jq curl httpie
apt-get clean
rm -rf /var/lib/apt/lists/*
bash /install.sh
chmod +x /entrypoint.sh
unzip -d /root/xray /root/xray/Xray-linux-64.zip
rm /root/xray/{README.md,LICENSE,Xray-linux-64.zip}
EOT
ENTRYPOINT ["/entrypoint.sh"]
