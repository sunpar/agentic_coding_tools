---
description: Auto-formatting — Prettier for TS/JS, Ruff for Python
alwaysApply: true
---

# Formatting

IMPORTANT: Every file you edit or create must be formatted before you stop working on it.

- **TypeScript/JavaScript**: `npx prettier --write <file>` — respect project `.prettierrc` if present
- **Python**: `ruff format <file>` then `ruff check --fix <file>` — respect project `ruff.toml`/`pyproject.toml` if present
- Never commit unformatted code
- If a formatter is not installed, tell the user — do not skip formatting
