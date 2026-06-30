#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."
rm -rf .lambda_build terraform/lambda_package.zip
mkdir -p .lambda_build

if [ -n "${PYTHON:-}" ]; then
  PYTHON_BIN="$PYTHON"
elif [ -x /home/admuser/venv/bin/python ]; then
  PYTHON_BIN="/home/admuser/venv/bin/python"
elif command -v python3 >/dev/null 2>&1; then
  PYTHON_BIN="$(command -v python3)"
elif command -v python >/dev/null 2>&1; then
  PYTHON_BIN="$(command -v python)"
else
  echo "No Python interpreter found" >&2
  exit 1
fi

if ! "$PYTHON_BIN" -m pip --version >/dev/null 2>&1; then
  echo "pip is not available for $PYTHON_BIN; installing it if possible" >&2
  if command -v apt-get >/dev/null 2>&1; then
    sudo apt-get update >/dev/null 2>&1 && sudo apt-get install -y python3-pip >/dev/null 2>&1 || true
  fi
fi

if ! "$PYTHON_BIN" -m pip --version >/dev/null 2>&1; then
  echo "pip still unavailable after fallback; cannot build Lambda package" >&2
  exit 1
fi

"$PYTHON_BIN" -m pip install --quiet --target .lambda_build -r lambda/requirements.txt
cp lambda/handler.py .lambda_build/
"$PYTHON_BIN" scripts/build_lambda.py
