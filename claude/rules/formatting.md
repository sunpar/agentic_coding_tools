---
description: Auto-formatting standards — Prettier for TypeScript/JavaScript, Ruff for Python
alwaysApply: true
---

# Formatting Rules

Every file that Claude touches must be left formatted. No exceptions.

## TypeScript / JavaScript

- **Formatter**: Prettier
- After editing any `.ts`, `.tsx`, `.js`, or `.jsx` file, run Prettier on that file before considering the task complete.
- Respect the project's existing Prettier configuration (`.prettierrc`, `prettier.config.*`, or `package.json` settings). Do not override or weaken project settings.
- If no Prettier config exists, use these defaults:
  - Single quotes
  - Trailing commas: `all`
  - Semi-colons: enabled
  - Print width: 100
  - Tab width: 2 (spaces)
- Command: `npx prettier --write <file>`

## Python

- **Formatter**: Ruff
- After editing any `.py` file, run both Ruff format and Ruff check with auto-fix on that file before considering the task complete.
- Respect the project's existing Ruff configuration (`pyproject.toml`, `ruff.toml`, or `.ruff.toml`). Do not override project settings.
- If no Ruff config exists, use these defaults:
  - Line length: 100
  - Target Python version: py311
  - isort-compatible import sorting enabled
- Commands:
  - `ruff format <file>`
  - `ruff check --fix <file>`

## General Principles

- **Format on touch**: If you read a file, make changes, and write it back, format it. If you create a new file, format it.
- **Never commit unformatted code**. Formatting is the last step before any commit.
- **Do not mix formatting changes with logic changes** in explanations — but the file itself must always be formatted when written.
- If a formatter is not installed in the project, notify the user rather than skipping formatting.
