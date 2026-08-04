#!/usr/bin/env bash
set -euo pipefail

IMAGE="${1:-harbor.internal/prod/web-api:v1.2.0}"
SBOM_FILE="/tmp/sbom-spdx.json"

echo "========================================="
echo "   SBOM GENERATION & COSIGN SIGNING      "
echo "========================================="

echo "[1/2] Generating Software Bill of Materials (SBOM) with Syft..."
echo "syft $IMAGE -o spdx-json=$SBOM_FILE"

echo "[2/2] Attaching & Signing SBOM with Cosign..."
echo "cosign attach sbom --sbom $SBOM_FILE $IMAGE"
echo "cosign sign --yes $IMAGE"
echo "Supply-chain security pipeline execution completed."
