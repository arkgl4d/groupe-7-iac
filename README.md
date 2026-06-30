# Groupe 7 IAC Projet

Ce dépôt contient l'infrastructure Terraform et le playbook Ansible pour le projet AWS :

- Deux buckets S3 isolés (source + destination)
- Une fonction Lambda déclenchée par un upload S3
- Conversion d'images en PDF
- Tags : `Project=ynov-iac-2025` et `groupe=groupe-7`

## Structure

- `terraform/` : code Terraform principal
- `terraform/modules/` : modules réutilisables
- `terraform/lambda/` : code source Lambda
- `ansible/` : playbook pour mettre à jour le code Lambda
- `scripts/` : packaging et déploiement

## Usage rapide

1. Activer le venv : `source /home/admuser/venv/bin/activate`
2. Construire le paquet Lambda : `./scripts/build_lambda.sh`
3. Initialiser Terraform : `cd terraform && terraform init`
4. Configurer vos identifiants AWS : `aws configure`, utiliser un profil AWS via `terraform/terraform.tfvars`, ou définir les variables d'environnement et exécuter `./scripts/configure_aws_creds.sh`.
5. Vérifier : `terraform plan`
6. Déployer : `terraform apply`

## Mise à jour du handler Lambda

Le playbook Ansible permet de reconditionner et mettre à jour le code handler :

```bash
cd /home/admuser/groupe-7-iac
source /home/admuser/venv/bin/activate
ansible-playbook ansible/playbook.yml
```

## Bonnes pratiques DevOps / DevSecOps

- chiffrement S3 activé
- blocage public S3 activé
- journalisation CloudWatch pour Lambda
- tags système appliqués automatiquement
- packaging reproductible du handler

## CI/CD GitHub Actions

Le dépôt contient désormais deux workflows GitHub Actions :
- un workflow de validation sur les PR et pushes vers main/master
- un workflow de déploiement Terraform vers AWS lorsque les secrets GitHub AWS sont configurés
# groupe-7-iac
# groupe-7-iac
# groupe-7-iac
