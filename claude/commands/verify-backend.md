# Verify Backend

Run all backend verification checks.

## Commands to run

```bash
cd backend
source .venv/bin/activate
ruff check .
ruff format --check .
pytest -q
```

## If schema changed

Also run:
```bash
alembic upgrade head
```

## Expected output

Report:
1. Lint status (pass/fail with details)
2. Format status (pass/fail with details)
3. Test results (pass/fail with summary)
4. Any issues that need fixing
