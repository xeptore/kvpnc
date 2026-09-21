#!/bin/bash
set -euo pipefail

# Kerio's postinst uses debconf (not raw stdin). Since debconf 1.5.91
# (Ubuntu 25.10+), the Teletype frontend requires a real TTY, so piping
# answers into `dpkg -i` falls back to Noninteractive with empty defaults
# and the config script loops forever on "Domain name must be set!".
# Preseed answers instead, then install noninteractively.
export DEBIAN_FRONTEND=noninteractive

debconf-set-selections <<'EOF'
kerio-control-vpnclient kerio-kvc/server string domain.com
kerio-control-vpnclient kerio-kvc/autodetect_fingerprint boolean false
kerio-control-vpnclient kerio-kvc/fingerprint string AA:BB:CC:DD:EE:FF
kerio-control-vpnclient kerio-kvc/username string dummy
kerio-control-vpnclient kerio-kvc/password password pass
EOF

dpkg -i /tmp/kerio.deb
