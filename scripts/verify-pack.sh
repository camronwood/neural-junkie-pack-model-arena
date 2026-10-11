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
[[ -f assets/eval/arena.yaml ]] || fail "missing assets/eval/arena.yaml benchmark suites"
[[ -f scenarios/collab/arena-connect4-smoke.json ]] || fail "missing arena smoke scenario"
grep -q 'model-arena-workbench' pack.yaml || fail "pack.yaml missing model-arena-workbench capability"
grep -q 'eval_probes:' pack.yaml || fail "pack.yaml missing assets.eval_probes"
grep -q 'default_suite:' assets/eval/arena.yaml || fail "arena.yaml missing default_suite"
grep -q 'logic-set' assets/eval/arena.yaml || fail "arena.yaml missing logic-set challenge"
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

root = str(pathlib.Path(".").resolve())
suites = arena._list_suites(root)
assert suites.get("default_suite") == "quick", suites
ids = {s["id"] for s in suites.get("suites") or []}
assert "quick" in ids and "logic-only" in ids, ids
agg = arena._aggregate_scores(
    {
        "models": [
            {"model": "b", "logic_correct": 1, "logic_total": 2, "connect4_completed": False, "pass_rate": 0.25},
            {"model": "a", "logic_correct": 2, "logic_total": 2, "connect4_completed": True, "pass_rate": 1.0},
        ]
    }
)
assert agg["ranking"][0]["model"] == "a" and agg["ranking"][0]["rank"] == 1, agg
PY

"${ROOT}/scripts/build-pack-zip.sh" >/dev/null
id="$(awk '/^id:/ {print $2; exit}' pack.yaml)"
ver="$(awk -F'"' '/^version:/ {print $2; exit}' pack.yaml)"
echo "OK pack ${id} ${ver}"
