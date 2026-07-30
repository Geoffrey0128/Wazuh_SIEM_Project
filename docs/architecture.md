# Architecture du lab SIEM Wazuh

## 1. Vue d'ensemble

Le lab repose sur une architecture Wazuh **all-in-one** : le Manager, l'Indexer et le Dashboard sont installés sur une seule VM. Ce choix est adapté à un lab (< 10 agents) ; en production avec un volume important, ces composants seraient distribués sur plusieurs nœuds.

## 2. Composants

| Composant | Rôle |
|---|---|
| **Wazuh Manager** | Reçoit les événements des agents, applique les décodeurs et règles, génère les alertes, pilote l'active response |
| **Wazuh Indexer** | Moteur d'indexation et de recherche (fork d'OpenSearch) qui stocke alertes et événements |
| **Wazuh Dashboard** | Interface web de visualisation, requêtage et administration |
| **Agents Wazuh** | Installés sur les endpoints : collecte de logs, FIM, inventaire, détection de vulnérabilités, SCA |

## 3. Topologie réseau

- **Réseau Host-only VMware** : `192.168.100.0/24` — isole le lab d'Internet
- **Carte NAT secondaire** : activée ponctuellement pour les mises à jour de paquets

| Machine | IP statique | Rôle |
|---|---|---|
| wazuh-server | 192.168.100.10 | Manager + Indexer + Dashboard |
| agent-linux | 192.168.100.20 | Endpoint Linux |
| agent-windows | 192.168.100.30 | Endpoint Windows |
| Machine hôte | 192.168.100.1 | Accès au dashboard + machine "attaquante" pour les simulations |

## 4. Flux réseau

| Flux | Port / Protocole | Description |
|---|---|---|
| Agents → Manager | 1514/TCP | Envoi des événements (chiffré AES) |
| Agents → Manager | 1515/TCP | Enrôlement des agents |
| Hôte → Dashboard | 443/TCP | Accès à l'interface web |
| Dashboard → Indexer | 9200/TCP | Requêtes (interne à la VM serveur) |

## 5. Dimensionnement

Machine hôte : 16 Go de RAM.

| VM | RAM | vCPU | Disque | Justification |
|---|---|---|---|---|
| wazuh-server | 8 Go | 4 | 50 Go | L'indexer (JVM) est le composant le plus gourmand ; 6 Go suffisent pour 2-3 agents. Heap indexer limitée à 2 Go si besoin |
| agent-linux | 2 Go | 2 | 20 Go | Ubuntu desktop headless, charge légère |
| agent-windows | 4 Go | 2 | 40 Go | Windows 11 pro Desktop Experience, minimum confortable |

Total alloué : **12 Go** — laisse ~4 Go pour l'hôte.

## 6. Snapshots VMware

Stratégie de snapshots pour pouvoir simuler des attaques sans risque :

1. `01-clean-os` : OS fraîchement installé et à jour
2. `02-wazuh-ready` : Wazuh installé/enrôlé et fonctionnel
3. `03-usecases-ok` : après validation de chaque cas d'usage majeur

## 7. Limites connues et pistes d'évolution

- All-in-one : pas de haute disponibilité (acceptable en lab)
- Pistes : ajout d'un agent supplémentaire (serveur web DVWA pour générer des attaques applicatives), intégration Suricata (NIDS) en complément du HIDS, envoi d'alertes vers un canal (mail, Slack, TheHive)
