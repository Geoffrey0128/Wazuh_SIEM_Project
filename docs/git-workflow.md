# Mettre le projet sur GitHub

## 1. Créer le dépôt distant

Sur GitHub : **New repository** → nom `wazuh-siem-project` → **Private** (recommandé si lié à une vraie infra) → sans README (on a déjà le nôtre).

## 2. Initialiser en local

Depuis le dossier du projet :

```bash
git init
git add .
git commit -m "Initial commit : structure du projet SIEM Wazuh"
git branch -M main
git remote add origin git@github.com:<TON_USER>/wazuh-siem-project.git
git push -u origin main
```

## 3. Vérifier qu'aucun secret ne part

**Avant chaque push**, contrôler :

```bash
git status              # rien de sensible dans les fichiers suivis ?
git ls-files | grep -iE "pass|secret|\.key|\.pem"   # doit ne rien renvoyer
```

Le [`.gitignore`](../.gitignore) exclut déjà certificats, `.env`, logs et images de VM.

## 4. Convention de commits

Messages courts et parlants, en français ou en anglais mais de façon cohérente :

- `docs: ajout du playbook brute force`
- `rules: règle custom modification /etc/sudoers`
- `config: activation FIM realtime sur /etc`
- `feat: script de déploiement agent Linux`

## 5. Suivi de l'avancement (GitHub Issues / Projects)

Créer une Issue par cas d'usage (voir `docs/use-cases.md`) et les regrouper dans un **Project** (board Kanban : À faire / En cours / Fait). Ça matérialise ta progression et fait très bonne impression en entretien.

Exemple d'issues à créer :
- [ ] Installer et valider le serveur Wazuh all-in-one
- [ ] Enrôler l'agent Linux
- [ ] Enrôler l'agent Windows + Sysmon
- [ ] Cas 1 : brute force SSH + active response
- [ ] Cas 2 : FIM sur /etc
- [ ] Cas 3 : détection de vulnérabilités
- [ ] Cas 4 : événements Windows Sysmon
- [ ] Cas 5 : audit SCA / CIS

## 6. Bonnes pratiques

- Commits **réguliers et atomiques** plutôt qu'un gros commit final : ça raconte l'histoire du projet
- Un `git commit` après chaque étape franchie dans le lab
- Si tu ajoutes des captures d'écran, **floute les infos sensibles** (IP publiques, mots de passe visibles)
