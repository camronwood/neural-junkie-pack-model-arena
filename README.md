# Neural Junkie — Model Arena pack

Official domain pack for comparing models on verifiable challenges.

## What you get

- **ArenaExpert** agent (`/create-expert arena ArenaExpert`)
- **Arena workbench** with chess, Connect Four, and logic puzzle panels
- **Benchmark mode** — multi-select installed Ollama models, run a suite, see ranked scores
- **Sidecar validation** so models choose legal moves rather than inventing game state
- **Leaderboard** tracking wins, losses, draws, illegal moves, and logic accuracy

## Benchmark models from Arena

1. Install and enable this pack (Settings → Domain packs).
2. Open the **Arena** toolbar chip.
3. Switch to the **Benchmark** tab.
4. Select one or more installed Ollama models and a suite (`quick` = logic + Connect Four).
5. Run — watch progress, cancel if needed, then review the ranked scoreboard.

Suite definitions live in `assets/eval/arena.yaml`. Model prompting is orchestrated by the Neural Junkie hub match runner; the sidecar scores legal moves and puzzle answers.

## Pack smoke

```bash
make verify
make pack-zip
```

Install via desktop **Settings → Domain packs → Pack store**, or sideload `dist/model-arena-<version>.zip`.

Tag a release (for example `v1.1.0`) and push to publish the release zip to GitHub.
