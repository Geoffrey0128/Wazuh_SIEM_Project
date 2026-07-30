# Déploiement

Notes et artefacts liés au déploiement de l'infrastructure.

- Procédure détaillée : [`../docs/installation.md`](../docs/installation.md)
- Script d'enrôlement agent Linux : [`../scripts/deploy-agent-linux.sh`](../scripts/deploy-agent-linux.sh)

## Pistes d'automatisation (évolution)

- **Ansible** : un playbook pour enrôler les agents en masse et pousser les configs
- **Docker Compose** : alternative all-in-one si tu veux un déploiement plus rapide que les VMs (moins réaliste pour un parc, mais pratique pour itérer sur les règles)

Documenter ici les fichiers correspondants s'ils sont ajoutés.
