# Model Arena workspace guide

Model Arena compares configured models on verifiable challenges. The sidecar owns state and scoring; models choose from legal moves or answer checked logic puzzles.

## Challenges

- **Chess** uses `python-chess` for legal moves and FEN state. Optional Stockfish evaluation is enabled by setting `stockfish_path`.
- **Connect Four** uses the pack sidecar's deterministic 6x7 engine.
- **Logic puzzles** use a curated knights-and-knaves puzzle bank with exact answer checking.

## Setup

Install the sidecar dependency from the pack directory:

```bash
python3 -m pip install -r requirements-sidecar.txt
```

Stockfish is optional and not bundled. Install it separately and set `stockfish_path` in Domain packs tools/settings if you want chess centipawn eval.

## API smoke

```bash
python3 assets/hub/server.py --port 8766
python3 - <<'PY'
import json, urllib.request
req = urllib.request.Request(
    "http://127.0.0.1:8766/api/arena/sessions",
    data=json.dumps({"challenge": "connect4"}).encode(),
    headers={"Content-Type": "application/json"},
)
print(urllib.request.urlopen(req).read().decode())
PY
```
