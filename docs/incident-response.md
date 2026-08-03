# Playbooks de réponse à incident

Procédures simplifiées inspirées du cycle NIST (Détection → Analyse → Confinement → Éradication → Récupération → Leçons apprises), adaptées au lab.

---

## Playbook 1 — Brute force SSH détecté

| Étape | Action |
|---|---|
| **Détection** | Alerte Wazuh niveau ≥ 10 sur échecs SSH répétés depuis une même IP |
| **Analyse** | Vérifier l'IP source, le compte visé, le nombre de tentatives, l'éventuelle réussite (règle `5715`) |
| **Confinement** | L'active response `firewall-drop` bloque l'IP. Vérifier que la règle iptables est bien active |
| **Éradication** | Si un accès a réussi : révoquer les sessions, changer le mot de passe, auditer les actions du compte |
| **Récupération** | Renforcer : désactiver l'auth par mot de passe (clés SSH), fail2ban, restreindre l'accès SSH par IP |
| **Leçons** | Documenter l'incident, ajuster le seuil de la règle si faux positifs |

---

## Playbook 2 — Modification non autorisée dans /etc (FIM)

| Étape | Action |
|---|---|
| **Détection** | Alerte « Integrity checksum changed » sur un fichier de `/etc` |
| **Analyse** | Identifier le fichier, l'utilisateur, le processus responsable. Modification légitime ou non ? |
| **Confinement** | Isoler l'hôte si compromission suspectée (snapshot VMware pour analyse forensique) |
| **Éradication** | Restaurer le fichier depuis une version saine, supprimer tout compte/backdoor ajouté |
| **Récupération** | Vérifier l'intégrité globale du système, remettre en service |
| **Leçons** | Étendre le périmètre FIM si nécessaire, tracer les changements légitimes |

---

## Playbook 3 — Exécution PowerShell suspecte (Windows)

| Étape | Action |
|---|---|
| **Détection** | Alerte Sysmon sur commande PowerShell encodée/obfusquée |
| **Analyse** | Décoder la commande, identifier le processus parent, le contexte utilisateur |
| **Confinement** | Isoler la VM du réseau (snapshot), tuer le processus malveillant |
| **Éradication** | Supprimer les artefacts (tâches planifiées, clés de registre de persistance) |
| **Récupération** | Restaurer depuis un snapshot sain si nécessaire |
| **Leçons** | Renforcer les règles de détection, envisager une politique AppLocker/WDAC |

---
