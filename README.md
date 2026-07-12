# Neural Junkie — Model Arena pack

Official domain pack for comparing models on verifiable challenges.

## What you get

- **ArenaExpert** agent (`/create-expert arena ArenaExpert`)
- **Arena workbench** with chess, Connect Four, and logic puzzle panels
- **Sidecar validation** so models choose legal moves rather than inventing game state
- **Leaderboard** tracking wins, losses, draws, illegal moves, and logic accuracy

## Pack smoke

```bash
make verify
make pack-zip
```

Install via desktop **Settings → Domain packs → Pack store**, or sideload `dist/model-arena-<version>.zip`.

Tag `v1.0.0` and push to publish the release zip to GitHub.
