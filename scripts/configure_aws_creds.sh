#!/usr/bin/env bash
set -euo pipefail

: "${AWS_ACCESS_KEY_ID:?AWS_ACCESS_KEY_ID must be set}"
: "${AWS_SECRET_ACCESS_KEY:?AWS_SECRET_ACCESS_KEY must be set}"
AWS_DEFAULT_REGION="${AWS_DEFAULT_REGION:-eu-west-3}"
AWS_SESSION_TOKEN="${AWS_SESSION_TOKEN:-}"
AWS_SHARED_CREDENTIALS_FILE="${AWS_SHARED_CREDENTIALS_FILE:-$HOME/.aws/credentials}"
AWS_PROFILE_NAME="${AWS_PROFILE_NAME:-default}"
AWS_ROLE_ARN="${AWS_ROLE_ARN:-}"
AWS_ROLE_EXTERNAL_ID="${AWS_ROLE_EXTERNAL_ID:-}"

mkdir -p "$(dirname "$AWS_SHARED_CREDENTIALS_FILE")"
cat > "$AWS_SHARED_CREDENTIALS_FILE" <<CRED
[${AWS_PROFILE_NAME}]
aws_access_key_id = ${AWS_ACCESS_KEY_ID}
aws_secret_access_key = ${AWS_SECRET_ACCESS_KEY}
region = ${AWS_DEFAULT_REGION}
CRED

if [ -n "$AWS_SESSION_TOKEN" ]; then
  cat >> "$AWS_SHARED_CREDENTIALS_FILE" <<CRED
aws_session_token = ${AWS_SESSION_TOKEN}
CRED
fi

if [ -n "$AWS_ROLE_ARN" ]; then
  echo "Assume role ARN configured: $AWS_ROLE_ARN"
fi

echo "AWS credentials written to $AWS_SHARED_CREDENTIALS_FILE under profile '$AWS_PROFILE_NAME'"
