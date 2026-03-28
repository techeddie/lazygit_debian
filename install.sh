#!/bin/bash
set -e

# Aktuelle Version von GitHub API holen
LATEST=$(curl -s https://api.github.com/repos/jesseduffield/lazygit/releases/latest \
  | grep '"tag_name"' \
  | cut -d'"' -f4 \
  | sed 's/v//')

# Architektur erkennen und auf Debian-Format mappen
ARCH=$(dpkg --print-architecture)
case "$ARCH" in
  amd64)   ARCH_NAME="x86_64" ;;
  i386)    ARCH_NAME="32-bit" ;;
  arm64)   ARCH_NAME="arm64" ;;
  armhf)   ARCH_NAME="armv6" ;;
  *) echo "Unbekannte Architektur: $ARCH"; exit 1 ;;
esac

FILE="lazygit_${LATEST}_Linux_${ARCH_NAME}.tar.gz"
URL="https://github.com/jesseduffield/lazygit/releases/download/v${LATEST}/${FILE}"

echo ">> Installiere lazygit v${LATEST} (${ARCH_NAME})..."
curl -sL "$URL" -o "/tmp/${FILE}"
tar xf "/tmp/${FILE}" -C /tmp lazygit
sudo mv /tmp/lazygit /usr/local/bin/lazygit
rm "/tmp/${FILE}"

echo ">> Fertig: $(lazygit --version)"
