## Full-Stack Deployment Guide: MedusaJS 2.x + Next.js 15 on Dokploy (Hetzner)

This guide explains, end-to-end, how to deploy the MedusaJS 2.x backend and a Next.js 15 App Router storefront to a Dokploy instance hosted on Hetzner, including SSL, domains, environment variables, CORS, build/runtime settings, and how to sync your local PostgreSQL to a cloud PostgreSQL (one-time migration and optional ongoing replication).

The guide follows this project’s conventions:

- Backend lives in `nick-a-deal-shop/` (MedusaJS 2.11.1+)
- Storefront lives in `nick-a-deal-shop-storefront/` (Next.js 15, React 19)
- Use Yarn (backend v4, storefront v3) as in the repo
- Use brand variables and `NEXT_PUBLIC_*` envs for frontend config

### Prerequisites

- Hetzner server (Ubuntu 22.04+ recommended) with Docker installed (Dokploy installer can bootstrap)
- Domain(s) you control, DNS able to point to your Hetzner server’s public IP
- Dokploy installed and reachable via its dashboard
- Postgres available in Dokploy (managed by Dokploy) or external cloud Postgres
- Local development working for both apps
- Node.js 20+ on build images

If using Dokploy-managed databases, create a PostgreSQL service in your Dokploy project (instructions below). Otherwise, prepare external Postgres credentials.

---

## 1) High-Level Architecture

- `MedusaJS backend` (Node.js/TS) on port 9000
- `Next.js storefront` (Node.js) on port 8000 (or any chosen port)
- `PostgreSQL` database (Dokploy service or external cloud DB)
- Traefik (behind Dokploy) provides routing, HTTPS via Let’s Encrypt

Traffic flow: `User → HTTPS (Traefik) → Storefront` and `Storefront → Backend API` (HTTPS). Admin/API requests flow similarly to the backend.

---

## 2) Prepare DNS and Domains

For each app, decide a host:

- Backend: e.g., `api.example.com`
- Storefront: e.g., `shop.example.com`

Create DNS A records pointing each host to your Hetzner server’s public IP. Leave TTL low (e.g., 300 seconds) during setup. Dokploy/Traefik will provision Let’s Encrypt certs once domains resolve.

---

## 3) Install/Access Dokploy

If Dokploy is not installed yet on the Hetzner server, install with the official script. Verify the web UI is accessible and that the server shows as healthy in Dokploy.

---

## 4) Create a Dokploy Project and PostgreSQL

1. In Dokploy, create a new Project: e.g., `nick-a-deal`.
2. Add a PostgreSQL service (if you want Dokploy-managed Postgres):
   - Choose image (e.g., `postgres:15`)
   - Set `databaseName`, `databaseUser`, `databasePassword` and optionally expose an external port only if needed (prefer private-only access from the same network)
   - Save and Deploy. Wait until status is `running`.
3. Note the internal connection details (service name/host within the Dokploy network, default port 5432) and credentials for app env vars.

If using external Postgres, collect the connection URL and ensure the Hetzner server is allowed to connect (firewall/ACL).

---

## 5) Configure MedusaJS Backend for Production

Project path: `nick-a-deal-shop/`

Key environment variables (example):

```
NODE_ENV=production
PORT=9000
DATABASE_URL=postgres://<USER>:<PASSWORD>@<HOST>:5432/<DB>

# CORS
STORE_CORS=https://shop.example.com
ADMIN_CORS=https://admin.example.com

# App URL for modules/webhooks if needed
MEDUSA_BACKEND_URL=https://api.example.com

# Optional
REDIS_URL=redis://<user>:<pass>@<host>:6379/0
JWT_SECRET=<secure-random>
COOKIE_SECRET=<secure-random>
```

Notes:

- `STORE_CORS` must include your storefront’s public URL.
- If you use admin UI separately, `ADMIN_CORS` should include that domain.
- Ensure `medusa-config.ts` aligns with your modules, database driver set to Postgres, and any Redis configuration if used.

Build/Run expectations for Dokploy:

- Build: `yarn install` then `yarn build` (or your repo script)
- Start: `yarn start` (ensure this runs the built server on `PORT`)

---

## 6) Configure Next.js 15 Storefront for Production

Project path: `nick-a-deal-shop-storefront/`

Key environment variables (example):

```
NODE_ENV=production
PORT=8000

# Public API URL of Medusa backend
NEXT_PUBLIC_MEDUSA_BACKEND_URL=https://api.example.com

# Useful for canonical URLs, OpenGraph, etc.
NEXT_PUBLIC_SITE_URL=https://shop.example.com

# ISR/On-Demand Revalidation secret (if used)
REVALIDATE_SECRET=<secure-random>
```

Next.js production considerations:

- Next 15 App Router supports standalone output. Ensure scripts build properly (e.g., `yarn build`).
- If using Images, configure domains in `next.config.js` as needed.
- Avoid server-only secrets in `NEXT_PUBLIC_*` variables.

Build/Run expectations for Dokploy:

- Build: `yarn install` then `yarn build`
- Start: `yarn start` (or `node ./.next/standalone/server.js` if using standalone; confirm your scripts)

---

## 7) Create Dokploy Applications (Backend and Storefront)

Repeat steps for both apps, adjusting ports/envs accordingly.

1. In your Dokploy project, create a new Application: `nick-a-deal-backend`
   - Source: Git provider (GitHub/GitLab/Bitbucket/Gitea) or Docker image
   - Build Type: pick your preferred (Dockerfile recommended for consistency). Nixpacks/Paketo can work too if your repo supports it.
   - If Dockerfile:
     - Set Docker context to the app folder, e.g., `nick-a-deal-shop/`
     - Provide build args if needed
   - Set `PORT` to `9000` in environment
   - Add all env vars listed above for the backend
   - Configure health checks if supported (HTTP on `/health` if exposed)
   - Deploy once to confirm it starts

2. Create the Storefront application: `nick-a-deal-storefront`
   - Source: Git provider (or Docker image)
   - Build Type: Dockerfile (or Nixpacks/Paketo)
   - Docker context to `nick-a-deal-shop-storefront/`
   - Set `PORT` to `8000`
   - Add all env vars listed above for the storefront
   - Deploy once to confirm it starts

Tips:

- Use separate applications for backend and storefront in the same Dokploy project.
- Prefer Dockerfile for deterministic builds (pin Node version, yarn versions).

---

## 8) Configure Domains and HTTPS in Dokploy

For each Application in Dokploy:

1. Add a Domain: e.g., `api.example.com` for backend, `shop.example.com` for storefront
2. Enable HTTPS = true, Certificate = Let’s Encrypt
3. Set the Service Port to the app’s `PORT` (9000 for backend, 8000 for storefront)
4. Save and Deploy/Reload

Once DNS resolves, Traefik will issue certs. Verify both hosts are reachable over HTTPS.

---

## 9) CORS, Images, and Cross-App Configuration

- Ensure `STORE_CORS` (and `ADMIN_CORS` if used) on backend includes your storefront/admin URLs
- Ensure the storefront points to the correct backend URL via `NEXT_PUBLIC_MEDUSA_BACKEND_URL`
- If using Next Image Optimization, whitelist image domains in `next.config.js`

After any env changes, redeploy or restart the applications.

---

## 10) Logs, Health, Scaling, and Rollouts

- View app logs in Dokploy to troubleshoot
- Configure resources (CPU/memory) in the app settings as needed
- Scale replicas from Dokploy if the app is stateless (storefront typically is; backend may require sticky sessions if using in-memory state; prefer Redis/session store)
- Use rolling or blue/green updates if your workflow requires zero-downtime

---

## 11) One-Time Sync: Local PostgreSQL → Cloud PostgreSQL

Use a dump/restore flow to migrate your local database contents to your cloud Postgres. Examples below assume PostgreSQL 15+ tools installed.

### A) Windows PowerShell (Local → Dump)

```powershell
# Replace values accordingly
$env:PGPASSWORD = "<LOCAL_PASSWORD>"
pg_dump --dbname=postgres://<LOCAL_USER>@localhost:5432/<LOCAL_DB> `
        --format=custom --verbose --file local.backup
Remove-Item Env:PGPASSWORD
```

Transfer the file to the Hetzner server (from Windows):

```powershell
scp .\local.backup <user>@<hetzner_ip>:~/local.backup
```

### B) Restore on Cloud

SSH to the server and restore:

```bash
export PGPASSWORD="<CLOUD_PASSWORD>"
pg_restore --dbname=postgres://<CLOUD_USER>@<CLOUD_HOST>:5432/<CLOUD_DB> \
          --clean --if-exists --create --verbose ~/local.backup
unset PGPASSWORD
```

Notes:

- If you do not want `--create`, ensure the target DB exists and omit `--create`.
- Ensure roles exist; otherwise restore into a role with sufficient privileges.
- Schedule a short maintenance window so apps are not writing during migration.

After restore completes, update the backend `DATABASE_URL` to point to the cloud DB and redeploy the backend.

---

## 12) Optional Ongoing Sync (Logical Replication)

If you need continuous sync (e.g., from local to cloud temporarily), logical replication can stream changes. High-level steps:

1. Ensure `wal_level = logical` in cloud Postgres config (and appropriate `max_replication_slots`)
2. From the cloud (subscriber), create a subscription to local (publisher) — or vice versa, depending on direction. Typically, you publish from source and subscribe at destination.
3. Open required network access between nodes (firewalls, pg_hba.conf)

Example (conceptual; adapt to your setup):

On source (local) create publication:

```sql
CREATE PUBLICATION app_pub FOR ALL TABLES;
```

On destination (cloud) create subscription:

```sql
CREATE SUBSCRIPTION app_sub
CONNECTION 'host=<LOCAL_PUBLIC_IP> port=5432 dbname=<LOCAL_DB> user=<REPL_USER> password=<REPL_PASS>'
PUBLICATION app_pub;
```

Caveats:

- Requires stable network access from cloud to local or vice versa
- You likely want a dedicated replication user with minimal privileges
- Conflicts must be handled; initial data sync should be clean (consider seeding via dump/restore first, then enable replication)

If continuous sync is not needed after cutover, drop the subscription and publication to stop replication.

---

## 13) Backups and Disaster Recovery

- Configure regular automated backups on the cloud Postgres (e.g., nightly `pg_dump` in custom format + retention)
- Test restores periodically in a staging database
- For application rollback, keep previous images/tags and revert via Dokploy

---

## 14) Environment Variable Reference (Quick)

Backend (`nick-a-deal-shop/`):

```
NODE_ENV=production
PORT=9000
DATABASE_URL=postgres://<user>:<pass>@<host>:5432/<db>
STORE_CORS=https://shop.example.com
ADMIN_CORS=https://admin.example.com
MEDUSA_BACKEND_URL=https://api.example.com
JWT_SECRET=<secure>
COOKIE_SECRET=<secure>
REDIS_URL=redis://<user>:<pass>@<host>:6379/0
```

Storefront (`nick-a-deal-shop-storefront/`):

```
NODE_ENV=production
PORT=8000
NEXT_PUBLIC_MEDUSA_BACKEND_URL=https://api.example.com
NEXT_PUBLIC_SITE_URL=https://shop.example.com
REVALIDATE_SECRET=<secure>
```

---

## 15) Verification Checklist

- Domains resolve (A records → Hetzner IP)
- Dokploy apps `running` with healthy logs
- HTTPS certs issued (Let’s Encrypt) and valid
- Storefront can fetch from backend (no CORS errors)
- DB connections stable; migrations applied
- Admin flows (if used) working

---

## 16) Notes and Best Practices

- Prefer Dockerfile builds pinned to a Node LTS and Yarn versions used in this repo
- Keep secrets in Dokploy env management; never commit to Git
- Enable rate limits and web app firewalling where appropriate (Traefik middlewares)
- Use monitoring and alerts on the Hetzner node for CPU, memory, disk, TLS renewals

---

## Appendix: Useful Commands

### PowerShell (Windows)

```powershell
# Find process by port
netstat -ano | Select-String ":8000"

# Kill Node if safe
Get-Process node -ErrorAction SilentlyContinue | Stop-Process -Force
```

### Linux/Bash

```bash
# Port in use
lsof -i :9000

# Kill by PID
kill -9 <PID>
```

---

If anything in Dokploy UI differs from your version, prioritize its on-screen field names. The values above map to typical fields: build type (Dockerfile/Nixpacks), build context/path, environment variables, service port, domains/HTTPS, and deploy controls.


