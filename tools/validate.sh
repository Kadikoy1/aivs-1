#!/usr/bin/env bash
# Validate every example against the AIVS-1 schemas.
# Requires: npm install -g ajv-cli ajv-formats
set -euo pipefail
cd "$(dirname "$0")/.."

fail=0

echo "── Inference Value Record ──"
for f in examples/ivr-*.json; do
  if ajv validate --spec=draft2020 -c ajv-formats \
       -s schemas/aivs-1-ivr.schema.json -d "$f" 2>&1; then
    echo "  ok   $f"
  else
    echo "  FAIL $f"; fail=1
  fi
done

echo "── Outcome Record (draft) ──"
for f in examples/outcome-*.json; do
  if ajv validate --spec=draft2020 -c ajv-formats \
       -s schemas/aivs-1-outcome.schema.json -d "$f" 2>&1; then
    echo "  ok   $f"
  else
    echo "  FAIL $f"; fail=1
  fi
done

if [ "$fail" -ne 0 ]; then
  echo "validation failed"; exit 1
fi
echo "all records valid"
