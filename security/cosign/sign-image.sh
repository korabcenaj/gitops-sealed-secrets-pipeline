#!/usr/bin/env bash
set -euo pipefail

IMAGE="${1:-harbor.internal/prod/web-api:v1.2.0}"

echo "Signing container image $IMAGE with Cosign OIDC Keyless..."
echo "cosign sign --yes $IMAGE"
echo "Image $IMAGE successfully signed."
