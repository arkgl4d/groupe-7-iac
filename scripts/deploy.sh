#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."
source /home/admuser/venv/bin/activate
./scripts/build_lambda.sh
cd terraform
terraform init -input=false
terraform plan -out=tfplan
terraform apply -input=false tfplan
