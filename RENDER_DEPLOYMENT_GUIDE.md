# Deploying to Render: Step-by-Step Guide

This guide walks through hosting your application on [Render](https://render.com) using the **Blueprint (Infrastructure-as-Code)** method. It covers common stacks including the React + FastAPI + PostgreSQL architecture referenced in this repo's tooling.

---

## Table of Contents

1. [Prerequisites](#1-prerequisites)
2. [Prepare Your Application for Render](#2-prepare-your-application-for-render)
3. [Create the `render.yaml` Blueprint](#3-create-the-renderyaml-blueprint)
4. [Validate the Blueprint](#4-validate-the-blueprint)
5. [Push to a Git Remote](#5-push-to-a-git-remote)
6. [Deploy via the Render Dashboard](#6-deploy-via-the-render-dashboard)
7. [Fill in Secrets and Environment Variables](#7-fill-in-secrets-and-environment-variables)
8. [Verify the Deployment](#8-verify-the-deployment)
9. [Troubleshooting Common Issues](#9-troubleshooting-common-issues)
10. [Blueprint Examples for Other Stacks](#10-blueprint-examples-for-other-stacks)

---

## 1. Prerequisites

Before you begin, make sure you have:

- [ ] A [Render account](https://dashboard.render.com/register) (free tier is fine to start)
- [ ] Your code in a **Git repository** hosted on GitHub, GitLab, or Bitbucket
- [ ] Git installed locally and your repo pushed to a remote
- [ ] (Optional) The [Render CLI](https://render.com/docs/cli) for local Blueprint validation

**Install the Render CLI (optional but recommended):**

```bash
# macOS
brew install render

# Linux / macOS (alternative)
curl -fsSL https://raw.githubusercontent.com/render-oss/cli/main/bin/install.sh | sh
```

**Verify your Git remote is set up:**

```bash
git remote -v
# Should show your GitHub/GitLab/Bitbucket remote URL
```

If you don't have a remote yet, create a repo on your Git provider and add it:

```bash
git remote add origin https://github.com/your-username/your-repo.git
git push -u origin main
```

---

## 2. Prepare Your Application for Render

Render requires two things from your app:

### A. Port Binding

Your backend must bind to `0.0.0.0:$PORT`. Render sets the `PORT` environment variable automatically (default: `10000`). **Do not hardcode a port or bind to `localhost`.**

**FastAPI example:**

```python
# main.py
import os
import uvicorn
from fastapi import FastAPI

app = FastAPI()

@app.get("/health")
async def health():
    return {"status": "ok"}

if __name__ == "__main__":
    port = int(os.environ.get("PORT", 8000))
    uvicorn.run(app, host="0.0.0.0", port=port)
```

**Express.js example:**

```javascript
const PORT = process.env.PORT || 3000;
app.listen(PORT, '0.0.0.0', () => {
  console.log(`Server running on port ${PORT}`);
});
```

### B. Health Check Endpoint

Add a `/health` route that returns a `200` status. Render uses this to know your service is alive.

---

## 3. Create the `render.yaml` Blueprint

Create a `render.yaml` file in the **root** of your repository. This file tells Render what services, databases, and configuration your app needs.

### React (Vite) Frontend + FastAPI Backend + PostgreSQL

This is the architecture described in this repo's cursor rules. It deploys as three resources:

```yaml
# render.yaml

services:
  # --- React / Vite Frontend (Static Site) ---
  - type: web
    name: frontend
    runtime: static
    plan: free
    branch: main
    autoDeploy: true
    buildCommand: cd frontend && npm ci && npm run build
    staticPublishPath: ./frontend/dist
    routes:
      - type: rewrite
        source: /*
        destination: /index.html
    headers:
      - path: /assets/*
        name: Cache-Control
        value: public, max-age=31536000, immutable
      - path: /index.html
        name: Cache-Control
        value: no-cache, no-store, must-revalidate
    envVars:
      - key: VITE_API_URL
        value: https://backend-api.onrender.com

  # --- FastAPI Backend (Web Service) ---
  - type: web
    name: backend-api
    runtime: python
    plan: free
    region: oregon
    branch: main
    autoDeploy: true
    buildCommand: cd backend && pip install -r requirements.txt && alembic upgrade head
    startCommand: cd backend && uvicorn main:app --host 0.0.0.0 --port $PORT
    healthCheckPath: /health
    envVars:
      - key: PYTHON_VERSION
        value: "3.11"
      - key: DATABASE_URL
        fromDatabase:
          name: postgres
          property: connectionString
      - key: SECRET_KEY
        sync: false  # You fill this in on the Render Dashboard
      - key: ALLOWED_ORIGINS
        value: https://frontend.onrender.com

databases:
  # --- PostgreSQL Database ---
  - name: postgres
    databaseName: app_production
    plan: free
    postgresMajorVersion: "15"
    ipAllowList: []  # Internal access only
```

### What each section does

| Section | Purpose |
|---------|---------|
| `type: web` + `runtime: static` | Serves the Vite/React build output via Render's CDN |
| `type: web` + `runtime: python` | Runs the FastAPI server |
| `databases` | Provisions a managed PostgreSQL instance |
| `fromDatabase` | Auto-injects the database connection string as an env var |
| `sync: false` | Marks a secret that you fill in manually on the Dashboard |
| `routes: rewrite` | Sends all frontend routes to `index.html` (SPA client-side routing) |
| `healthCheckPath` | Tells Render where to ping to confirm the service is healthy |

---

## 4. Validate the Blueprint

If you installed the Render CLI, validate your config before deploying:

```bash
# Authenticate first
render login
# or
export RENDER_API_KEY="rnd_your_key_here"

# Validate the blueprint
render blueprints validate
```

Fix any errors it reports before proceeding. Common issues:

- Missing required fields (`name`, `type`, `runtime`)
- Invalid YAML syntax (indentation, missing colons)
- Incorrect `staticPublishPath` (must match your actual build output directory)

If you don't have the CLI, you can skip this step -- Render will validate when you deploy from the Dashboard.

---

## 5. Push to a Git Remote

The `render.yaml` file **must be committed and pushed** to your repository before Render can read it.

```bash
git add render.yaml
git commit -m "Add Render deployment configuration"
git push origin main
```

Verify it's visible on your Git provider (e.g., check GitHub to confirm the file appears in the repo root).

---

## 6. Deploy via the Render Dashboard

### Option A: Blueprint Deeplink (Fastest)

Construct your deeplink by replacing `<REPO_URL>` with your repository's HTTPS URL:

```
https://dashboard.render.com/blueprint/new?repo=<REPO_URL>
```

For example:

```
https://dashboard.render.com/blueprint/new?repo=https://github.com/your-username/your-repo
```

Open this URL in your browser to begin.

### Option B: Manual Dashboard Steps

1. Go to [dashboard.render.com](https://dashboard.render.com)
2. Click **New** > **Blueprint**
3. Connect your GitHub/GitLab/Bitbucket account if prompted
4. Select your repository
5. Render will auto-detect `render.yaml` and show the services it will create
6. Review the configuration
7. Click **Apply** to start the deployment

---

## 7. Fill in Secrets and Environment Variables

After clicking Apply, Render will prompt you for any env vars marked `sync: false`. These are your secrets (API keys, JWT secrets, etc.) that should not be stored in code.

1. In the Dashboard, navigate to each service
2. Go to **Environment** > **Environment Variables**
3. Fill in the values for any variables marked as needing input
4. Save and trigger a redeploy if needed

---

## 8. Verify the Deployment

Once Render finishes building and deploying, verify everything works:

### Step 1: Check deploy status

In the Render Dashboard, confirm each service shows status **"Live"** with a green indicator.

### Step 2: Test the backend health endpoint

```bash
curl https://backend-api.onrender.com/health
# Expected: {"status":"ok"}
```

### Step 3: Visit the frontend

Open `https://frontend.onrender.com` in your browser. Confirm the page loads and can communicate with the backend API.

### Step 4: Check logs for errors

In the Dashboard, click on each service and go to **Logs**. Look for:

- Build errors (dependency failures, missing files)
- Startup errors (port binding issues, missing env vars)
- Runtime errors (database connection failures, import errors)

---

## 9. Troubleshooting Common Issues

### Build fails: "Module not found" or missing dependencies

**Cause:** Build command runs in the wrong directory or dependencies aren't listed.

**Fix:** Ensure your `buildCommand` uses `cd` into the correct subdirectory for monorepos:

```yaml
buildCommand: cd backend && pip install -r requirements.txt
```

### Health check timeout

**Cause:** App isn't binding to `0.0.0.0:$PORT`.

**Fix:** Update your start command to explicitly bind:

```yaml
startCommand: cd backend && uvicorn main:app --host 0.0.0.0 --port $PORT
```

### Frontend returns 404 on page refresh

**Cause:** Missing SPA rewrite rule.

**Fix:** Add this to your static site config in `render.yaml`:

```yaml
routes:
  - type: rewrite
    source: /*
    destination: /index.html
```

### Database connection refused

**Cause:** Using an external URL instead of the internal one, or the database hasn't finished provisioning.

**Fix:** Use `fromDatabase` in your `render.yaml` (which provides internal URLs automatically). Wait a minute for the database to become available after initial deploy.

### Free tier spin-down (cold starts)

**Behavior:** Free-tier services spin down after 15 minutes of inactivity. The first request after spin-down takes ~30 seconds.

**Options:**
- Accept the cold start delay (fine for demos/personal projects)
- Upgrade to a paid plan for always-on services
- Use an external cron/ping service to keep it warm

### Out of memory (OOM) crash

**Cause:** Free tier has 512 MB RAM per service.

**Fix:**
- Reduce worker/thread count in your start command
- Optimize dependencies (remove unused packages)
- Upgrade to a paid plan for more RAM

---

## 10. Blueprint Examples for Other Stacks

### Node.js / Express API

```yaml
services:
  - type: web
    name: express-api
    runtime: node
    plan: free
    branch: main
    autoDeploy: true
    buildCommand: npm ci
    startCommand: npm start
    healthCheckPath: /health
    envVars:
      - key: NODE_ENV
        value: production
```

### Next.js with PostgreSQL

```yaml
services:
  - type: web
    name: nextjs-app
    runtime: node
    plan: free
    branch: main
    autoDeploy: true
    buildCommand: npm ci && npm run build
    startCommand: npm start
    healthCheckPath: /api/health
    envVars:
      - key: NODE_ENV
        value: production
      - key: DATABASE_URL
        fromDatabase:
          name: postgres
          property: connectionString

databases:
  - name: postgres
    databaseName: nextjs_production
    plan: free
    postgresMajorVersion: "15"
```

### Django with Celery Worker

```yaml
services:
  - type: web
    name: django-web
    runtime: python
    plan: free
    branch: main
    autoDeploy: true
    buildCommand: pip install -r requirements.txt && python manage.py collectstatic --no-input && python manage.py migrate
    startCommand: gunicorn config.wsgi:application --bind 0.0.0.0:$PORT --workers 2
    healthCheckPath: /health/
    envVars:
      - key: PYTHON_VERSION
        value: "3.11"
      - key: DJANGO_SECRET_KEY
        sync: false
      - key: DATABASE_URL
        fromDatabase:
          name: postgres
          property: connectionString

  - type: worker
    name: celery-worker
    runtime: python
    plan: free
    branch: main
    autoDeploy: true
    buildCommand: pip install -r requirements.txt
    startCommand: celery -A config.celery_app worker --loglevel=info --concurrency=2
    envVars:
      - key: DATABASE_URL
        fromDatabase:
          name: postgres
          property: connectionString

databases:
  - name: postgres
    databaseName: django_production
    plan: free
    postgresMajorVersion: "15"
```

### Docker-based Service

```yaml
services:
  - type: web
    name: docker-app
    runtime: docker
    plan: free
    branch: main
    autoDeploy: true
    dockerfilePath: ./Dockerfile
    dockerContext: .
    envVars:
      - key: PORT
        value: "10000"
```

---

## Quick Reference

| What | Command / Action |
|------|-----------------|
| Install Render CLI | `brew install render` or `curl -fsSL https://raw.githubusercontent.com/render-oss/cli/main/bin/install.sh \| sh` |
| Validate blueprint | `render blueprints validate` |
| Deploy via deeplink | `https://dashboard.render.com/blueprint/new?repo=<REPO_URL>` |
| Check service logs | Dashboard > Service > Logs |
| Render default port | `$PORT` (usually `10000`) |
| Required host binding | `0.0.0.0` (not `localhost`) |
| Free tier spin-down | 15 minutes of inactivity |
| Free tier RAM | 512 MB per service |
| Free tier DB storage | 1 GB PostgreSQL |

---

## Further Reading

- [Render Docs](https://render.com/docs)
- [Blueprint Specification](https://render.com/docs/blueprint-spec)
- [Render CLI Reference](https://render.com/docs/cli)
- This repo's deployment skill: [`codex/skills/render-deploy/SKILL.md`](codex/skills/render-deploy/SKILL.md)
