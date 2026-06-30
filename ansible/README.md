# Ansible deployment

Ce playbook permet de packager le code Lambda et de mettre à jour le déploiement via AWS CLI.

Utilisation :

```bash
cd /home/admuser/groupe-7-iac
source /home/admuser/venv/bin/activate
export AWS_ACCESS_KEY_ID="<votre-access-key>"
export AWS_SECRET_ACCESS_KEY="<votre-secret-key>"
ansible-playbook ansible/playbook.yml
```
