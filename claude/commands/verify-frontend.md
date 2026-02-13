# Verify Frontend

Run all frontend verification checks.

## Commands to run

```bash
cd frontend
npm run build
```

Note: This repo currently does not define separate `lint` or `typecheck` scripts in `frontend/package.json`. The build command includes type checking.

## Expected output

Report:
1. Build status (pass/fail)
2. Any TypeScript errors
3. Any issues that need fixing
