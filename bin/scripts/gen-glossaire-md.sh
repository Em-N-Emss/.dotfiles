#!/usr/bin/env bash

set -euo pipefail

# Check args

if [[ $# -ne 1 ]]; then
  echo "Usage: $0 TEMPLATE.md" >&2

  exit 1
fi
TEMPLATE="$1"

# Verify template exists
if [[ ! -f "$TEMPLATE" ]]; then
  echo "Error: template '$TEMPLATE' not found." >&2
  exit 2

fi

OUTDIR="$HOME/Second-Brain/Resources/Glossaire-Test"
mkdir -p "$OUTDIR"

# Read entire template into a variable
TPL_CONTENT=$(< "$TEMPLATE")  # faster than cat :contentReference[oaicite:4]{index=4}

# Loop A → Z
for LETTER in {A..Z}; do                         # brace‐expansion A..Z :contentReference[oaicite:5]{index=5}
  OUT_FILE="$OUTDIR/Glossaire-${LETTER}.md"
  # Replace all __LETTER__ globally and write
  echo "${TPL_CONTENT//__LETTER__/$LETTER}" > "$OUT_FILE"  # shell parameter expansion :contentReference[oaicite:6]{index=6}
done

echo "Glossaire_A.md … Glossaire_Z.md généré"
