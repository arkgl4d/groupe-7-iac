#!/usr/bin/env bash
set -euo pipefail

: "${AWS_ACCESS_KEY_ID:?AWS_ACCESS_KEY_ID must be set}"
: "${AWS_SECRET_ACCESS_KEY:?AWS_SECRET_ACCESS_KEY must be set}"
AWS_DEFAULT_REGION="${AWS_DEFAULT_REGION:-eu-west-3}"
AWS_SESSION_TOKEN="${AWS_SESSION_TOKEN:-}"
AWS_PROFILE_NAME="${AWS_PROFILE_NAME:-default}"
AWS_SHARED_CREDENTIALS_FILE="${AWS_SHARED_CREDENTIALS_FILE:-$HOME/.aws/credentials}"

cd "$(dirname "$0")"/..
source /home/admuser/venv/bin/activate

AWS_PROFILE_NAME="$AWS_PROFILE_NAME" \
AWS_SHARED_CREDENTIALS_FILE="$AWS_SHARED_CREDENTIALS_FILE" \
AWS_SESSION_TOKEN="$AWS_SESSION_TOKEN" \
./scripts/configure_aws_creds.sh

./scripts/build_lambda.sh
cd terraform
terraform init -input=false
terraform plan -out=tfplan
terraform apply -input=false tfplan
