#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "${ROOT}"
fail() { echo "verify-pack: $*" >&2; exit 1; }

[[ -f pack.yaml ]] || fail "missing pack.yaml"
[[ -f requirements-sidecar.txt ]] || fail "missing requirements-sidecar.txt"
[[ -f assets/hub/server.py ]] || fail "missing assets/hub/server.py"
[[ -f assets/hub/routes/arena.py ]] || fail "missing assets/hub/routes/arena.py"
[[ -f assets/puzzles/knights_knaves.yaml ]] || fail "missing puzzle bank"
[[ -f scenarios/collab/arena-connect4-smoke.json ]] || fail "missing arena smoke scenario"
grep -q 'model-arena-workbench' pack.yaml || fail "pack.yaml missing model-arena-workbench capability"
python3 -m py_compile assets/hub/server.py assets/hub/routes/arena.py

python3 - <<'PY'
import importlib.util
import pathlib

path = pathlib.Path("assets/hub/routes/arena.py").resolve()
spec = importlib.util.spec_from_file_location("arena", path)
arena = importlib.util.module_from_spec(spec)
spec.loader.exec_module(arena)
board = arena._empty_connect4()
for col in [3, 2, 3, 2, 3, 2, 3]:
    token = "R" if len([m for row in board for m in row if m]) % 2 == 0 else "Y"
    board, _ = arena._connect4_drop(board, col, token)
status, result = arena._connect4_status(board)
assert status == "finished", (status, result, board)
assert result == "red", (status, result, board)
PY

"${ROOT}/scripts/build-pack-zip.sh" >/dev/null
id="$(awk '/^id:/ {print $2; exit}' pack.yaml)"
ver="$(awk -F'"' '/^version:/ {print $2; exit}' pack.yaml)"
echo "OK pack ${id} ${ver}"
