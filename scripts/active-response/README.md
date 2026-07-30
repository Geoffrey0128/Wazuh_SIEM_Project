# Active Response

Wazuh intègre nativement le script **`firewall-drop`**, qui bannit une IP via le pare-feu local (iptables/nftables sous Linux, netsh sous Windows). C'est celui utilisé dans ce projet — inutile de réécrire un script custom.

## Configuration (côté manager, `ossec.conf`)

Voir [`config/manager/ossec.conf.example`](../../config/manager/ossec.conf.example) :

```xml
<active-response>
  <command>firewall-drop</command>
  <location>local</location>
  <rules_id>100001</rules_id>
  <timeout>600</timeout>
</active-response>
```

- `location=local` : l'action s'exécute sur l'agent qui a généré l'alerte
- `rules_id=100001` : notre règle de brute force SSH custom
- `timeout=600` : l'IP est débloquée automatiquement après 10 minutes

## Vérifier qu'une IP a bien été bloquée

Sur l'agent concerné :

```bash
sudo iptables -L -n | grep <IP_ATTAQUANTE>
```

Et dans les logs d'active response du manager :

```bash
sudo tail -f /var/ossec/logs/active-responses.log
```

## Écrire un script custom (pour aller plus loin)

Si tu veux une réponse sur mesure (ex. envoyer une notification, appeler une API), place un script exécutable dans `/var/ossec/active-response/bin/` sur l'agent, déclare-le comme `<command>` dans `ossec.conf`, puis référence-le dans un bloc `<active-response>`. Documenter ici le script correspondant le cas échéant.
