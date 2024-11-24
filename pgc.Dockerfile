# syntax=docker/dockerfile:1
FROM ghcr.io/xeptore/kvpnc:latest
RUN <<EOT
#!/usr/bin/bash
set -Eeuo pipefail
apt-get update
apt-get install -y postgresql-client-common postgresql-client-16
apt-get clean
rm -rf /var/lib/apt/lists/*
EOT
