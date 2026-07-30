#!/usr/bin/env bash
#
# Génère des échecs d'authentification SSH pour VALIDER la détection Wazuh.
# À lancer depuis la machine hôte (attaquant) contre l'agent-linux DU LAB.
#
# ⚠️  Usage strictement limité à VOTRE lab isolé. Ne jamais cibler
#     une machine dont vous n'êtes pas propriétaire.
#
# Usage : ./test-bruteforce-ssh.sh <IP_CIBLE>
#
set -euo pipefail

TARGET="${1:-}"
ATTEMPTS="${2:-10}"

if [[ -z "$TARGET" ]]; then
  echo "Usage : $0 <IP_CIBLE> [NB_TENTATIVES]" >&2
  exit 1
fi

echo "[*] Simulation de ${ATTEMPTS} échecs SSH contre ${TARGET}..."
echo "    (Résultat attendu : alerte règle 100001 côté Wazuh + blocage IP)"

for i in $(seq 1 "$ATTEMPTS"); do
  # Utilisateur inexistant + timeout court : échec garanti sans hydra
  sshpass -p "mauvais_mot_de_passe" \
    ssh -o StrictHostKeyChecking=no \
        -o ConnectTimeout=3 \
        -o PreferredAuthentications=password \
        "utilisateur_bidon@${TARGET}" 2>/dev/null || true
  echo "    tentative ${i}/${ATTEMPTS}"
done

echo "[+] Terminé. Vérifiez le dashboard Wazuh (Security Events)."
