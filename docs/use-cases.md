# Cas d'usage de détection

Chaque cas suit la même trame : **objectif → mise en place → simulation → résultat attendu → preuve**. Insérer les captures d'alertes dans un dossier `docs/img/` (non versionné s'il contient des données sensibles).

---

## Cas 1 — Brute force SSH + blocage automatique

**Objectif :** détecter une attaque par force brute SSH sur `agent-linux` et bloquer automatiquement l'IP source.

**Mise en place :**
- Règles Wazuh natives : `5710`, `5712` (échecs SSH répétés)
- Active response `firewall-drop` (voir `scripts/active-response/`)

**Simulation** (depuis la machine hôte) :
```bash
hydra -l root -P wordlist.txt ssh://192.168.100.20
```

**Résultat attendu :** alerte de niveau ≥ 10 « sshd: Multiple authentication failures », puis déclenchement de l'active response et blocage de l'IP attaquante.

**Technique MITRE ATT&CK :** T1110 (Brute Force)

📸 *Preuve : capture de l'alerte + règle iptables ajoutée sur l'agent.*

---

## Cas 2 — Surveillance d'intégrité de fichiers (FIM)

**Objectif :** être alerté de toute modification dans `/etc` sur `agent-linux`.

**Mise en place :** module `syscheck` configuré en `realtime` sur `/etc` (voir `config/agents/agent.conf`).

**Simulation :**
```bash
sudo echo "test" >> /etc/hosts
sudo useradd pirate
```

**Résultat attendu :** alertes « Integrity checksum changed » (règle `550`) et détection du nouvel utilisateur.

**Technique MITRE ATT&CK :** T1136 (Create Account), T1565 (Data Manipulation)

📸 *Preuve : détail de l'alerte FIM avec diff avant/après.*

---

## Cas 3 — Détection de vulnérabilités (CVE)

**Objectif :** identifier les paquets vulnérables installés sur les agents.

**Mise en place :** activer le module `vulnerability-detection` dans `ossec.conf`.

**Résultat attendu :** liste des CVE dans le module « Vulnerability Detection » du dashboard, avec criticité et paquet concerné.

📸 *Preuve : tableau des CVE détectées sur agent-linux.*

---

## Cas 4 — Événements Windows suspects (Sysmon)

**Objectif :** détecter des comportements suspects sur `agent-windows` (ex. exécution de PowerShell encodé, création de processus anormale).

**Mise en place :** Sysmon + collecte du canal `Microsoft-Windows-Sysmon/Operational`.

**Simulation :**
```powershell
powershell.exe -EncodedCommand <payload_base64_benin>
```

**Résultat attendu :** événement Sysmon EventID 1 (Process Create) corrélé, alerte sur ligne de commande suspecte.

**Technique MITRE ATT&CK :** T1059.001 (PowerShell)

📸 *Preuve : alerte avec la ligne de commande décodée.*

---

## Cas 5 — Audit de conformité (SCA / CIS)

**Objectif :** évaluer la conformité de `agent-linux` au CIS Benchmark.

**Mise en place :** module SCA (Security Configuration Assessment) activé par défaut.

**Résultat attendu :** score de conformité et liste des contrôles échoués dans le module « Configuration Assessment ».

📸 *Preuve : rapport SCA avec score et recommandations.*

---

## Récapitulatif MITRE ATT&CK couvert

| Tactique | Technique | Cas |
|---|---|---|
| Credential Access | T1110 Brute Force | 1 |
| Persistence | T1136 Create Account | 2 |
| Execution | T1059.001 PowerShell | 4 |
