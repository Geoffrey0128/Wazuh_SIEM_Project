#!/usr/bin/env bash
#
# Déploiement d'un agent Wazuh sur un endpoint Linux (Debian/Ubuntu).
# Usage : sudo ./deploy-agent-linux.sh <IP_MANAGER> <NOM_AGENT>
# Exemple : sudo ./deploy-agent-linux.sh 192.168.100.10 agent-linux
#
set -euo pipefail

MANAGER_IP="${1:-}"
AGENT_NAME="${2:-$(hostname)}"
WAZUH_VERSION="4.9.0-1"   # à adapter à la version courante

if [[ -z "$MANAGER_IP" ]]; then
  echo "Usage : sudo $0 <IP_MANAGER> [NOM_AGENT]" >&2
  exit 1
fi

if [[ $EUID -ne 0 ]]; then
  echo "Ce script doit être exécuté en root (sudo)." >&2
  exit 1
fi

echo "[*] Téléchargement de l'agent Wazuh ${WAZUH_VERSION}..."
PKG="wazuh-agent_${WAZUH_VERSION}_amd64.deb"
wget -q "https://packages.wazuh.com/4.x/apt/pool/main/w/wazuh-agent/${PKG}"

echo "[*] Installation (manager=${MANAGER_IP}, nom=${AGENT_NAME})..."
WAZUH_MANAGER="$MANAGER_IP" WAZUH_AGENT_NAME="$AGENT_NAME" dpkg -i "./${PKG}"

echo "[*] Activation du service..."
systemctl daemon-reload
systemctl enable --now wazuh-agent

rm -f "./${PKG}"

echo "[+] Agent installé. Vérifiez côté manager :"
echo "    sudo /var/ossec/bin/agent_control -l"
