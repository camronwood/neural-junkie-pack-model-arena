#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
OUT="${ROOT}/dist"
mkdir -p "$OUT"
id="$(awk '/^id:/ {print $2; exit}' "${ROOT}/pack.yaml")"
ver="$(awk -F'"' '/^version:/ {print $2; exit}' "${ROOT}/pack.yaml")"
artifact="${OUT}/${id}-${ver}.zip"
rm -f "${artifact}"
(cd "${ROOT}" && zip -r "${artifact}" pack.yaml requirements-sidecar.txt -x '*.DS_Store')
[[ -d "${ROOT}/assets" ]] && (cd "${ROOT}" && zip -ur "${artifact}" assets -x '*.DS_Store' -x '*__pycache__*')
[[ -d "${ROOT}/scripts" ]] && (cd "${ROOT}" && zip -ur "${artifact}" scripts -x '*.DS_Store')
[[ -d "${ROOT}/scenarios" ]] && (cd "${ROOT}" && zip -ur "${artifact}" scenarios -x '*.DS_Store')
echo "Wrote ${artifact}"
