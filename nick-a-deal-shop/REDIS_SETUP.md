# Redis Setup for Local Development

## Problem
MedusaJS is attempting to connect to Redis (port 6379) but Redis is not running locally, causing connection errors:
```
[ioredis] Unhandled error event: Error: connect ECONNREFUSED 127.0.0.1:6379
```

**Note:** The server still starts successfully, but these errors are noisy and some features may not work without Redis.

## Solution Options

### Option 1: Install Redis via Docker (Recommended for Windows)

**Prerequisites:** Docker Desktop must be installed and running.

1. **Start Redis container:**
```powershell
docker run -d --name redis-medusa -p 6379:6379 redis:7-alpine
```

2. **Verify Redis is running:**
```powershell
docker ps | Select-String redis
```

3. **Create/update `.env` file:**
```env
REDIS_URL=redis://localhost:6379
```

4. **Restart the dev server:**
```powershell
# Stop current server (Ctrl+C), then:
yarn dev
```

**To stop Redis container later:**
```powershell
docker stop redis-medusa
docker rm redis-medusa
```

---

### Option 2: Install Redis for Windows (Native)

1. **Download Redis for Windows:**
   - Option A: Use WSL2 with Redis (recommended):
     ```powershell
     wsl --install
     # Then in WSL:
     sudo apt update
     sudo apt install redis-server
     sudo service redis-server start
     ```
   - Option B: Use Memurai (Redis-compatible Windows service):
     - Download from: https://www.memurai.com/get-memurai
     - Install and start the service
     - Default port: 6379

2. **Create/update `.env` file:**
```env
REDIS_URL=redis://localhost:6379
```

3. **Restart the dev server**

---

### Option 3: Use Cloud Redis (For Development)

If you prefer a managed Redis instance:

1. **Sign up for a free Redis cloud service:**
   - Redis Cloud (https://redis.com/try-free/)
   - Upstash (https://upstash.com/)
   - Render Redis (https://render.com/docs/redis)

2. **Get connection URL** (usually format: `redis://username:password@host:port`)

3. **Add to `.env`:**
```env
REDIS_URL=redis://username:password@your-redis-host:6379
```

4. **Restart the dev server**

---

## Verify Redis Connection

After setting up Redis, verify it's working:

```powershell
# Test Redis connection (if you have redis-cli installed)
redis-cli ping
# Should return: PONG

# Or via Docker:
docker exec -it redis-medusa redis-cli ping
# Should return: PONG
```

---

## Optional: Make Redis Optional for Development

If you don't need Redis features for local development, you can suppress the errors by ensuring `REDIS_URL` is not set. However, some MedusaJS features (caching, workflows, event bus) may not work without it.

**Current behavior:** Server starts and runs, but shows Redis connection errors.

---

## Troubleshooting

### Port 6379 Already in Use

If port 6379 is already taken:

```powershell
# Find what's using port 6379
netstat -ano | Select-String ":6379"

# Kill the process (replace PID with actual process ID)
Stop-Process -Id <PID> -Force
```

### Redis Container Won't Start

```powershell
# Check Docker logs
docker logs redis-medusa

# Remove and recreate container
docker rm -f redis-medusa
docker run -d --name redis-medusa -p 6379:6379 redis:7-alpine
```

---

## Notes

- Redis is **optional** for basic development but **recommended** for full feature support
- Production deployments should always use Redis
- The connection errors don't prevent the server from starting, but they indicate missing functionality
