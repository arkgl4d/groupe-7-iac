# GitHub Actions

## Secrets requis

Ajouter ces secrets dans les paramètres du dépôt GitHub :

- AWS_ACCESS_KEY_ID
- AWS_SECRET_ACCESS_KEY

Le workflow de déploiement s’exécute uniquement si ces secrets sont présents.

## Branches

- Les PR vers main ou master déclenchent la validation CI.
- Un push sur main ou master déclenche la validation puis le déploiement si les secrets sont configurés.
