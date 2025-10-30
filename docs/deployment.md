### Summary
We’ll deploy your MedusaJS backend to Dokploy with two instances: one “server” (serves API + Admin) and one “worker” (background jobs). We’ll add a small set of config changes (worker mode, admin settings, Redis URL, predeploy script), then configure two Dokploy Applications (or a single Docker Compose app) that connect to your already-provisioned Postgres and Redis. I’ll outline both Nixpacks-based and Dockerfile-based builds for Dokploy.

### Approach Options (pros/cons)
- Nixpacks (Dokploy “Build Type”): 
  - Pros: Zero-Dockerfile setup, faster iteration, uses your `yarn.lock`.
  - Cons: Slightly opaque build steps; Yarn 4/corepack behavior can vary by base image; more care for multi-command start.
- Dockerfile (multi-stage):
  - Pros: Fully deterministic; you control Node version, corepack, install/build phases, and start scripts.
  - Cons: Slightly more work to maintain a Dockerfile.
- Docker Compose (2 services from same repo):
  - Pros: Clean separation of server/worker with shared env, easy to manage together.
  - Cons: Slightly more complex initial setup in Dokploy if you haven’t used Compose there.

### Selected Plan
- Minimal code edits in `nick-a-deal-shop` to add worker mode, admin toggles, Redis URL, and `predeploy` script.
- Prefer Dokploy Nixpacks first; if Yarn 4/corepack causes issues, switch to the provided Dockerfile.
- Create two Dokploy Applications from the same repo:
  - medusa-server: `MEDUSA_WORKER_MODE=server`, `DISABLE_MEDUSA_ADMIN=false`, serves on 9000 with health check `/health`.
  - medusa-worker: `MEDUSA_WORKER_MODE=worker`, `DISABLE_MEDUSA_ADMIN=true`, no public route needed.
- Acceptance criteria:
  - `/health` returns OK on server deployment.
  - Admin available at `<SERVER_URL>/app`.
  - Background jobs running (e.g., scheduled jobs/subscribers execute).
  - No build/runtime errors in Dokploy logs.

### Risks & Edge Cases
- Yarn 4 in build environments: if Nixpacks doesn’t invoke corepack correctly, use the Dockerfile (it enables corepack explicitly).
- DB migrations: ensure `predeploy` runs before start to avoid mismatched schema. If migrations are destructive, back up DB first.
- CORS and Admin URL: misconfigured `STORE_CORS`, `ADMIN_CORS`, or `MEDUSA_BACKEND_URL` will break Admin or auth—set these after you know your Dokploy route.
- Memory/CPU: Medusa recommends ≥2GB RAM; ensure Dokploy resources match, especially under load.
- Secrets: keep `JWT_SECRET` and `COOKIE_SECRET` random and long; rotate if exposed.
- Networking: make sure `DATABASE_URL` and `REDIS_URL` are reachable from the app containers (service URLs vs public endpoints).
- Health check path must be `/health`, not `/` (or the check will fail even when server is fine).

### Testing Plan
- Build-time: verify successful `yarn build` in Dokploy logs.
- Runtime: check `/health`, Admin `/app` loads, login works after creating an admin user.
- Background: test a subscriber or a scheduled job (logs show worker activity).
- Negative tests: bad CORS (expect 403), wrong DB URL (app fails quickly), worker-only deployment (server paths unavailable).

### Docs Used
- Medusa deployment guide (v2.11.1): general requirements, worker mode, admin backend URL, Redis URL, predeploy, health check. See “General Medusa Application Deployment Guide” and deployment overview. 
  - [General deployment](https://docs.medusajs.com/learn/deployment/general)
  - [Deployment](https://docs.medusajs.com/learn/deployment)
- Dokploy Applications, Advanced, Build Types, Going Production, Preview Deployments, Docker Compose:
  - [Applications](https://docs.dokploy.com/docs/core/applications)
  - [Advanced](https://docs.dokploy.com/docs/core/applications/advanced)
  - [Build Type](https://docs.dokploy.com/docs/core/applications/build-type)
  - [Going Production](https://docs.dokploy.com/docs/core/applications/going-production)
  - [Preview Deployments](https://docs.dokploy.com/docs/core/applications/preview-deployments)
  - [Docker Compose](https://docs.dokploy.com/docs/core/docker-compose)
  - [Compose example](https://docs.dokploy.com/docs/core/docker-compose/example)
  - [Compose utilities](https://docs.dokploy.com/docs/core/docker-compose/utilities)

### Change Plan (backend only)
- Files to touch:
  - `nick-a-deal-shop/medusa-config.ts`
  - `nick-a-deal-shop/package.json`
- Code ops:
  - Add `workerMode`, `admin.disable`, `admin.backendUrl`, `redisUrl`.
  - Add `"predeploy": "medusa db:migrate"` script.
  - Optional: add production modules (caching/event-bus/workflow/locking Redis) later.
- Compatibility:
  - Public API unchanged; adds env vars only.
- Rollout:
  - Safe to deploy in two apps (server/worker). Backout: revert env to single-node (“shared”) mode if needed.

### What you have today
Current `medusa-config.ts` lacks worker/admin/redis configuration:
```1:16:nick-a-deal-shop/medusa-config.ts
import { loadEnv, defineConfig } from '@medusajs/framework/utils'

loadEnv(process.env.NODE_ENV || 'development', process.cwd())

module.exports = defineConfig({
  projectConfig: {
    databaseUrl: process.env.DATABASE_URL,
    http: {
      storeCors: process.env.STORE_CORS!,
      adminCors: process.env.ADMIN_CORS!,
      authCors: process.env.AUTH_CORS!,
      jwtSecret: process.env.JWT_SECRET || "supersecret",
      cookieSecret: process.env.COOKIE_SECRET || "supersecret",
    }
  }
})
```

Your `package.json` doesn’t include `predeploy`:
```1:52:nick-a-deal-shop/package.json
{
  "name": "nick-a-deal-shop",
  "version": "0.0.1",
  ...
  "scripts": {
    "build": "medusa build",
    "seed": "medusa exec ./src/scripts/seed.ts",
    "start": "medusa start",
    "dev": "medusa develop",
    ...
  },
  ...
  "packageManager": "yarn@4.3.0+sha512.1606bef7c84..."
}
```

### Proposed edits (copy into your repo)

- `nick-a-deal-shop/medusa-config.ts` (adds worker mode, admin, backend URL, redis URL):
```ts
import { loadEnv, defineConfig } from '@medusajs/framework/utils'

loadEnv(process.env.NODE_ENV || 'development', process.cwd())

module.exports = defineConfig({
  projectConfig: {
    databaseUrl: process.env.DATABASE_URL,
    // Required for production per Medusa guide: run separate server/worker instances
    workerMode: process.env.MEDUSA_WORKER_MODE as 'shared' | 'worker' | 'server',
    // Redis session store URL (also used by event bus/workflow if you add those modules)
    redisUrl: process.env.REDIS_URL,
    http: {
      storeCors: process.env.STORE_CORS!,
      adminCors: process.env.ADMIN_CORS!,
      authCors: process.env.AUTH_CORS!,
      jwtSecret: process.env.JWT_SECRET!,          // set securely in Dokploy
      cookieSecret: process.env.COOKIE_SECRET!,    // set securely in Dokploy
    },
  },
  admin: {
    // Disable admin build on worker instance only (set via env in Dokploy)
    disable: process.env.DISABLE_MEDUSA_ADMIN === 'true',
    // Point Admin to your backend URL (server instance)
    backendUrl: process.env.MEDUSA_BACKEND_URL,
  },
})
```

- `nick-a-deal-shop/package.json` (add `predeploy`):
```json
{
  "scripts": {
    "build": "medusa build",
    "predeploy": "medusa db:migrate",
    "start": "medusa start",
    "dev": "medusa develop",
    "seed": "medusa exec ./src/scripts/seed.ts",
    "test:integration:http": "TEST_TYPE=integration:http NODE_OPTIONS=--experimental-vm-modules jest --silent=false --runInBand --forceExit",
    "test:integration:modules": "TEST_TYPE=integration:modules NODE_OPTIONS=--experimental-vm-modules jest --silent=false --runInBand --forceExit",
    "test:unit": "TEST_TYPE=unit NODE_OPTIONS=--experimental-vm-modules jest --silent --runInBand --forceExit"
  }
}
```

Optional (recommended later): add Redis-based caching/event-bus/workflow/locking modules for production per Medusa docs. See “Install Production Modules and Providers” section in [General deployment](https://docs.medusajs.com/learn/deployment/general).

---

## Dokploy configuration

### Option A — Two Dokploy Applications (Nixpacks build)
Create two Applications in Dokploy from the same repository.

- Common
  - Build Type: “Nixpacks” (Dokploy detects Node + Yarn via `package.json` and `yarn.lock`) [Build Type](https://docs.dokploy.com/docs/core/applications/build-type)
  - Build Command: `yarn install && yarn build`
  - Start Command:
    - Use a single line that runs migrations then starts the built app:
    - `yarn predeploy && yarn --cwd .medusa/server install --production --frozen-lockfile && yarn --cwd .medusa/server start`
  - Port: 9000
  - Health Check: Path `/health`, interval 10s, timeout 5s [Going Production](https://docs.dokploy.com/docs/core/applications/going-production)
  - Resources: ≥2GB RAM recommended (Medusa guidance)

- medusa-server (serves API + Admin)
  - Environment
    - `MEDUSA_WORKER_MODE=server`
    - `DISABLE_MEDUSA_ADMIN=false`
    - `PORT=9000`
    - `DATABASE_URL=<your dokploy Postgres URL>`
    - `REDIS_URL=<your dokploy Redis URL>`
    - `JWT_SECRET=<random 32+ char secret>`
    - `COOKIE_SECRET=<random 32+ char secret>`
    - `STORE_CORS=https://<your-storefront-domain>` (can leave blank initially)
    - `ADMIN_CORS=https://<your-backend-domain>`
    - `AUTH_CORS=https://<your-storefront-domain>,https://<your-backend-domain>`
    - `MEDUSA_BACKEND_URL=https://<your-backend-domain>`
  - Domain/Route: attach a domain in Dokploy so Admin can load at `<BACKEND_URL>/app`.
  - After you know the URL, set `ADMIN_CORS` and `MEDUSA_BACKEND_URL` accordingly, then redeploy. [General deployment](https://docs.medusajs.com/learn/deployment/general)

- medusa-worker (background jobs)
  - Environment
    - `MEDUSA_WORKER_MODE=worker`
    - `DISABLE_MEDUSA_ADMIN=true`
    - Same DB/Redis/secret variables as server.
  - No route/domain needed. Same start command and port, but you don’t need to expose it publicly.

- Optional Nixpacks knobs (only if needed):
  - If you must override commands explicitly: set `NIXPACKS_BUILD_CMD` and `NIXPACKS_START_CMD` in Dokploy env. See [Build Type](https://docs.dokploy.com/docs/core/applications/build-type).
  - If Yarn 4 isn’t recognized, prefer the Dockerfile option below.

- Preview deployments: You can enable previews (PRs) for the server app if desired, but ensure they point to staging DB/Redis and use different CORS. [Preview Deployments](https://docs.dokploy.com/docs/core/applications/preview-deployments)

### Option B — Two Dokploy Applications (Dockerfile)
If Nixpacks has issues with Yarn 4/corepack, add this `Dockerfile` at `nick-a-deal-shop/Dockerfile` and select “Dockerfile” build:

```dockerfile
# syntax=docker/dockerfile:1

# --- build stage ---
FROM node:20-alpine AS build
WORKDIR /app
# Enable corepack for Yarn 4
RUN corepack enable
COPY package.json yarn.lock ./
RUN yarn install --immutable
COPY . .
# Build Medusa to .medusa/server
RUN yarn build

# --- runtime stage ---
FROM node:20-alpine AS runtime
WORKDIR /app
RUN corepack enable
ENV NODE_ENV=production
# Copy only what we need at runtime
COPY --from=build /app/package.json /app/yarn.lock ./
COPY --from=build /app/.medusa/server /app/.medusa/server
# Install server runtime deps inside the server output
RUN yarn --cwd .medusa/server install --production --frozen-lockfile

EXPOSE 9000
# Run migrations at container start, then start the server
CMD ["sh", "-lc", "yarn predeploy && yarn --cwd .medusa/server start"]
```

- Build Context: repo root `nick-a-deal-shop`
- Start command: leave default (Dockerfile CMD).
- Create two Dokploy apps from same Dockerfile with different env:
  - medusa-server and medusa-worker as described above.

### Option C — Docker Compose (one Dokploy “Compose” app)
If you prefer a single deployment entry in Dokploy, use Compose to run both services:

```yaml
version: "3.9"
services:
  medusa-server:
    build:
      context: .
      dockerfile: Dockerfile
    environment:
      MEDUSA_WORKER_MODE: "server"
      DISABLE_MEDUSA_ADMIN: "false"
      PORT: "9000"
      DATABASE_URL: "<your postgres url>"
      REDIS_URL: "<your redis url>"
      JWT_SECRET: "<secret>"
      COOKIE_SECRET: "<secret>"
      STORE_CORS: "https://<storefront>"
      ADMIN_CORS: "https://<backend>"
      AUTH_CORS: "https://<storefront>,https://<backend>"
      MEDUSA_BACKEND_URL: "https://<backend>"
    ports:
      - "9000:9000"
    healthcheck:
      test: ["CMD", "wget", "-qO-", "http://localhost:9000/health"]
      interval: 10s
      timeout: 5s
      retries: 5
    restart: unless-stopped

  medusa-worker:
    build:
      context: .
      dockerfile: Dockerfile
    environment:
      MEDUSA_WORKER_MODE: "worker"
      DISABLE_MEDUSA_ADMIN: "true"
      PORT: "9000"
      DATABASE_URL: "<your postgres url>"
      REDIS_URL: "<your redis url>"
      JWT_SECRET: "<secret>"
      COOKIE_SECRET: "<secret>"
    restart: unless-stopped
```

- Import this compose file in Dokploy under Docker Compose. [Docker Compose](https://docs.dokploy.com/docs/core/docker-compose) | [Example](https://docs.dokploy.com/docs/core/docker-compose/example)

---

## Post-deploy steps

- Health check: visit `https://<backend-domain>/health` (expect `OK`). [General deployment](https://docs.medusajs.com/learn/deployment/general)
- Admin UI: `https://<backend-domain>/app` (ensure `MEDUSA_BACKEND_URL` and `ADMIN_CORS` are set).
- Create an admin user (run once inside the server container via Dokploy “Run Command”):
  - Bash:
    - `npx medusa user -e <email> -p <password>`
- Logs/monitoring: watch Dokploy logs and metrics; scale replicas if needed. [Advanced](https://docs.dokploy.com/docs/core/applications/advanced) | [Going Production](https://docs.dokploy.com/docs/core/applications/going-production)

## Windows/PowerShell notes
- Local testing (if you do it before pushing): run commands one-by-one (PowerShell doesn’t support `&&`). For Dokploy containers (Linux), chaining with `&&` in start scripts is fine.

## Rollback
- If the worker causes issues, scale it to 0 replicas temporarily in Dokploy.
- If the server fails after env changes, revert last env edits, redeploy, and verify `/health`.
- If migrations break prod, restore DB from backup, remove the failing migration, redeploy.


- References: [Medusa general deployment](https://docs.medusajs.com/learn/deployment/general), [Medusa deployment](https://docs.medusajs.com/learn/deployment), Dokploy [Applications](https://docs.dokploy.com/docs/core/applications), [Advanced](https://docs.dokploy.com/docs/core/applications/advanced), [Build Type](https://docs.dokploy.com/docs/core/applications/build-type), [Going Production](https://docs.dokploy.com/docs/core/applications/going-production), [Preview Deployments](https://docs.dokploy.com/docs/core/applications/preview-deployments), [Docker Compose](https://docs.dokploy.com/docs/core/docker-compose).