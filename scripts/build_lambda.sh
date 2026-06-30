#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."
rm -rf .lambda_build terraform/lambda_package.zip
mkdir -p .lambda_build
PYTHON=${PYTHON:-/home/admuser/venv/bin/python}
if [ ! -x "$PYTHON" ]; then
  echo "Python interpreter not found: $PYTHON" >&2
  exit 1
fi
"$PYTHON" -m pip install --quiet --target .lambda_build -r lambda/requirements.txt
cp lambda/handler.py .lambda_build/
"$PYTHON" scripts/build_lambda.py
