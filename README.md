# Wazuh_SIEM_Project

# 🛡️ Projet SIEM — Déploiement et gestion de Wazuh

Déploiement, configuration et exploitation d'un SIEM **Wazuh** dans un lab virtualisé (VMware), avec des cas d'usage concrets de détection et de réponse à incident.

> 🎓 Projet réalisé dans un objectif d'apprentissage et de montée en compétences en cybersécurité défensive (Blue Team / SOC).

---

## 📋 Objectifs du projet

- Déployer une architecture SIEM complète avec Wazuh (Manager, Indexer, Dashboard)
- Superviser des endpoints Linux et Windows via les agents Wazuh
- Mettre en œuvre des cas d'usage de détection réalistes (brute force, FIM, vulnérabilités...)
- Écrire des règles de détection personnalisées
- Automatiser la réponse à incident (active response)
- Documenter l'ensemble de la démarche de façon professionnelle

## 🏗️ Architecture

```
                    ┌──────────────────────────────┐
                    │        wazuh-server           │
                    │   Ubuntu Server 24.04         │
                    │   192.168.154.154.153         │
                    │                               │
                    │  ┌─────────┐ ┌────────────┐  │
                    │  │ Manager │ │  Indexer   │  │
                    │  └─────────┘ └────────────┘  │
                    │        ┌───────────┐          │
                    │        │ Dashboard │ :443     │
                    │        └───────────┘          │
                    └───────────┬──────────────────┘
                        1514/TCP │ 1515/TCP
              ┌─────────────────┴─────────────────┐
              │                                   │
   ┌──────────┴──────────┐           ┌────────────┴────────┐
   │    agent-linux      │           │    agent-windows     │
   │  Ubuntu 24.04       │           │  Windows Server 2022 │
   │  192.168.154.154     │           │  192.168.154.155      │
   └─────────────────────┘           └──────────────────────┘
```

📖 Détails : [docs/architecture.md](docs/architecture.md)

## 🖥️ Environnement de lab

| VM | OS | RAM | vCPU | Disque | Rôle |
|---|---|---|---|---|---|
| wazuh-server | Ubuntu Server 22.04 | 8 Go | 4 | 50 Go | Manager + Indexer + Dashboard |
| agent-linux | Ubuntu 22.04 | 4 Go | 2 | 20 Go | Endpoint Linux supervisé |
| agent-windows | Windows Server 2022 | 4 Go | 2 | 40 Go | Endpoint Windows supervisé |

**Hyperviseur :** VMware Workstation — Réseau Host-only (`192.168.100.0/24`) + NAT pour les mises à jour.

## 🎯 Cas d'usage couverts

| # | Cas d'usage | Statut |
|---|---|---|
| 1 | Détection de brute force SSH (+ blocage auto de l'IP) | 🔲 À faire |
| 2 | Surveillance d'intégrité de fichiers (FIM) sur `/etc` | 🔲 À faire |
| 3 | Détection de vulnérabilités (CVE) sur les agents | 🔲 À faire |
| 4 | Détection d'événements Windows suspects (Sysmon) | 🔲 À faire |
| 5 | Audit de conformité CIS Benchmark | 🔲 À faire |

📖 Détails et preuves (captures d'alertes) : [docs/use-cases.md](docs/use-cases.md)

## 📁 Structure du dépôt

```
├── docs/                  # Documentation complète du projet
├── deployment/            # Scripts et notes de déploiement
├── config/
│   ├── manager/           # Configuration du manager (ossec.conf)
│   ├── agents/            # Configuration centralisée des agents
├── rules/                 # Règles de détection custom (local_rules.xml)
├── scripts/
│   └── active-response/   # Scripts de réponse automatique
└── dashboards/            # Dashboards exportés (.ndjson)
```

## 🚀 Démarrage rapide

1. Lire la [procédure d'installation](docs/installation.md)
2. Déployer le serveur Wazuh (all-in-one)
3. Enrôler les agents Linux et Windows
4. Appliquer les configurations du dossier `config/`
5. Charger les règles custom depuis `rules/`

## ⚠️ Sécurité du dépôt

Ce dépôt ne contient **aucun secret** : pas de mots de passe, clés, certificats ni logs réels. Les adresses IP sont celles d'un lab isolé (réseau host-only). Voir [.gitignore](.gitignore).

## 📚 Ressources

- [Documentation officielle Wazuh](https://documentation.wazuh.com/)
- [Règles Wazuh (référence)](https://documentation.wazuh.com/current/user-manual/ruleset/index.html)
- [MITRE ATT&CK](https://attack.mitre.org/)

---

*Projet en cours — voir les [issues](../../issues) pour le suivi de l'avancement.*
