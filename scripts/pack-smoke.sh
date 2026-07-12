#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
NJ_ROOT="${NJ_ROOT:-/Users/camronwood/development/projects/neural-junkie}"
python3 "${NJ_ROOT}/scripts/collab-scenarios.py" --pack-dir "${ROOT}" --scenario "${ROOT}/scenarios/collab/arena-connect4-smoke.json"
