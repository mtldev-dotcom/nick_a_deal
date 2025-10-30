### Approach Options (pros/cons)
- One-time dump and restore (recommended):
  - Pros: Simple, reliable, portable. Supports full schema+data, preserves constraints and sequences.
  - Cons: Requires a maintenance window to avoid write divergence during migration.
- Direct stream (pipe) local→cloud:
  - Pros: No intermediate file; faster for small/medium DBs.
  - Cons: Harder to retry; network hiccups can fail the whole run.
- Continuous sync/replication:
  - Pros: Near-zero downtime.
  - Cons: Complex (logical replication, cutover steps). Overkill if you only need a one-time import.

### Selected Plan
Use a one-time dump in custom format with `pg_dump -Fc` and restore with `pg_restore` into the cloud DB. Freeze local writes during export, restore to cloud, then run Medusa migrations/link-sync in the cloud app to guarantee schema/link consistency. Acceptance: cloud `/health` OK, record counts match, business flows work.

### Risks & Edge Cases
- Writes during migration: can cause drift. Mitigate by pausing local writers until cutover.
- Version mismatch: Postgres client should be same major as server. Use a matching `postgres:<version>` Docker image if needed.
- Privileges/owners: use `--no-owner --no-acl` and connect as a role that owns the target schema.
- Large data: use compressed dump (`-Fc`) and parallel restore (`pg_restore -j <n>`).
- Extensions: ensure required extensions exist on target (same Postgres version); `pg_restore` will attempt to create them.
- Network/SSL: your cloud DB may require `sslmode=require`. Include it in the connection string.

### Windows (PowerShell) one-time migration
Prereqs:
- Ensure `pg_dump`/`pg_restore` are installed, or use Dockerized Postgres client.
- Have both connection strings:
  - Local: e.g., `postgresql://user:pass@localhost:5432/nickadeal`
  - Cloud (Dokploy): from Dokploy Postgres output or secrets, e.g., `postgresql://user:pass@db-host:5432/nickadeal_prod?sslmode=require`

Option A: Using local Postgres client
```powershell
# 1) Export local DB to a compressed custom-format dump
$env:PGPASSWORD = "local_password"
pg_dump --dbname "postgresql://local_user@localhost:5432/nickadeal" --format=c --file ".\nad_backup_$(Get-Date -Format yyyyMMdd_HHmm).dump" --no-owner --no-acl --verbose

# 2) Restore into cloud DB (will drop/replace where possible)
$env:PGPASSWORD = "cloud_password"
pg_restore --dbname "postgresql://cloud_user@db-host:5432/nickadeal_prod?sslmode=require" --clean --if-exists --no-owner --no-acl --verbose ".\nad_backup_YYYYMMDD_HHMM.dump"

# Optional: faster on big DBs (set a higher -j if cloud DB permits)
# pg_restore ... -j 4
```

Option B: Without installing Postgres locally (use Dockerized client)
```powershell
# 1) Dump (replace versions/creds accordingly)
docker run --rm -v ${PWD}:/backups postgres:16 `
  bash -lc "PGPASSWORD=local_password pg_dump --dbname 'postgresql://local_user@host.docker.internal:5432/nickadeal' -Fc -f /backups/nad_backup.dump --no-owner --no-acl --verbose"

# 2) Restore
docker run --rm -v ${PWD}:/backups postgres:16 `
  bash -lc "PGPASSWORD=cloud_password pg_restore --dbname 'postgresql://cloud_user@db-host:5432/nickadeal_prod?sslmode=require' --clean --if-exists --no-owner --no-acl --verbose /backups/nad_backup.dump"
```

Direct stream (small DBs):
```powershell
# Plain-format stream from local to cloud (no intermediate file)
$env:PGPASSWORD = "local_password"
pg_dump --dbname "postgresql://local_user@localhost:5432/nickadeal" --format=p --no-owner --no-acl --verbose > nad_backup.sql

$env:PGPASSWORD = "cloud_password"
psql "postgresql://cloud_user@db-host:5432/nickadeal_prod?sslmode=require" -f ".\nad_backup.sql"
```

### After restore (run in cloud app)
- Ensure your Dokploy app uses the cloud `DATABASE_URL`.
- Run Medusa schema alignment in the cloud (either automatically via your `predeploy` step or manually as a one-off) to sync migrations and links:
```bash
# inside the container or Dokploy "Run Command"
npx medusa db:migrate
# If needed for links only:
npx medusa db:sync-links --execute-safe
```
Per Medusa CLI docs: `db:migrate` runs latest migrations, syncs link definitions, and data migration scripts; `db:sync-links` syncs link definitions. These do not import your business data—they ensure schema/link consistency after the data restore ([Medusa CLI db](https://docs.medusajs.com/resources/medusa-cli/commands/db)).

### Testing Plan
- Compare row counts for key tables (products, orders, customers).
- Verify `/health` on cloud backend; open Admin at `<BACKEND_URL>/app`.
- Sanity-check critical flows (login, list products, create draft order).
- If issues: check Dokploy logs; re-run `db:migrate`; verify cloud DB extensions.

### Rollback
- Keep the local DB intact until verification completes.
- If cloud issues arise, point the app back to local `DATABASE_URL` (or restore the previous cloud backup), fix, repeat dump/restore.

### Docs Used
- Medusa CLI db commands (clarifies `db:migrate`/`db:sync-links` scope): [Medusa CLI db](https://docs.medusajs.com/resources/medusa-cli/commands/db)
- Medusa general deployment (context for predeploy, health, worker/server): [General deployment](https://docs.medusajs.com/learn/deployment/general)


---

### Summary
You want a repeatable PowerShell script to copy your local Postgres data to your cloud Postgres, then finish with Medusa schema/link alignment. We’ll use `pg_dump`/`pg_restore` (or a direct stream) and keep it idempotent, parameterized, and safe by default.

### Intent & Options
You’re asking for an automated, repeatable way to export from local Postgres and import into your cloud DB. We can: (1) dump to a file and restore (`pg_dump -Fc` + `pg_restore`), (2) direct stream (`pg_dump | psql`), or (3) a more complex replication-based approach. For one-time or periodic syncs, the file-based dump/restore is the most reliable and debuggable. The script below supports both dump/restore and streaming modes, plus an option to run Postgres clients via Docker if you don’t have them installed locally.

### Risks & Edge Cases
- Local writes during migration can diverge the data. Best to pause writes for the duration.  
- Postgres version mismatch: use a matching `postgres:<major>` client image if needed.  
- Privileges and owners: use `--no-owner --no-acl` and connect as a role with proper privileges.  
- Large datasets: use custom-format dumps (`-Fc`) and parallel restore (`-j`), and ensure adequate resources.  
- SSL: cloud may require `sslmode=require`; the script can inject it if missing.

### Quality & Scale
This script is parameterized, fail-fast, and logs key steps while masking secrets. It supports parallel restore for large DBs and separates dump from restore so you can resume a failed run. After restore, run Medusa `db:migrate` to ensure schema/links are in sync. The approach scales from small to large datasets, with streaming available for smaller DBs.

### Change Plan
- Add the script at `nick-a-deal-shop/scripts/db/pg_migrate_local_to_cloud.ps1` (new file).
- No code changes in the app required; post-restore, run Medusa migrations in the cloud deployment.

### Testing Plan
- Dry-run: run `-Mode DumpOnly`, verify dump file; then `-Mode RestoreOnly` using the dump.  
- Validate counts on critical tables (products, customers, orders).  
- Verify app `/health` and Admin login in the cloud.  
- If schema issues: run `npx medusa db:migrate` in the cloud app.

### Docs Used
- Medusa CLI DB commands (for `db:migrate` and link sync expectations): [Medusa CLI db](https://docs.medusajs.com/resources/medusa-cli/commands/db)

---

## Script: `nick-a-deal-shop/scripts/db/pg_migrate_local_to_cloud.ps1`

```powershell
<# 
.SYNOPSIS
  Export local Postgres to a dump and restore it to a cloud Postgres, or stream directly.

.DESCRIPTION
  - Supports modes: DumpAndRestore (default), DumpOnly, RestoreOnly, Stream.
  - Uses pg_dump/pg_restore if available, or Dockerized postgres client with -UseDockerClient.
  - Adds sslmode=require to the cloud connection if missing (configurable).

PRECONDITIONS
  - You have connection strings for local and cloud databases.
  - For large DBs, ensure adequate disk space for dump files and enough RAM/CPU on target.
  - Pause writes to the source DB during migration to avoid divergence.

POSTCONDITIONS
  - Cloud DB contains a restored copy of local data.
  - Next step: run "npx medusa db:migrate" in your cloud app to ensure schema/links are aligned.

ERROR PATHS
  - Script exits non-zero on any failure. Check output/logs for details.
#>

[CmdletBinding()]
param(
  [Parameter(Mandatory=$true)]
  [string]$LocalDbUrl,                                # e.g. postgresql://user:pass@localhost:5432/nickadeal

  [Parameter(Mandatory=$true)]
  [string]$CloudDbUrl,                                # e.g. postgresql://user:pass@db-host:5432/nickadeal_prod

  [ValidateSet("DumpAndRestore","DumpOnly","RestoreOnly","Stream")]
  [string]$Mode = "DumpAndRestore",

  [string]$DumpDir = ".\backups",

  [string]$DumpFileName,                               # default auto: nad_backup_yyyyMMdd_HHmm.dump

  [int]$ParallelJobs = 4,                              # pg_restore -j

  [switch]$UseDockerClient,                            # use postgres:<version> docker image to run client tools

  [string]$DockerImage = "postgres:16",                # change to match your server major version if needed

  [switch]$NoOwnerNoAcl = $true,                       # --no-owner --no-acl

  [switch]$CleanIfExists = $true,                      # pg_restore --clean --if-exists

  [string]$CloudSslMode = "require",                   # inject sslmode if missing

  [switch]$Force                                        # skip confirmation
)

$ErrorActionPreference = "Stop"

function New-DumpName {
  param([string]$BaseDir)
  $ts = Get-Date -Format "yyyyMMdd_HHmm"
  return Join-Path $BaseDir "nad_backup_$ts.dump"
}

function Ensure-Dir {
  param([string]$Path)
  if (-not (Test-Path -LiteralPath $Path)) {
    New-Item -ItemType Directory -Path $Path | Out-Null
  }
}

function Mask-ConnStr {
  param([string]$Conn)
  # Mask password between '://' and '@' if present
  if ($Conn -match "://([^:@/]+):([^@/]+)@") {
    return ($Conn -replace "://([^:@/]+):([^@/]+)@", "://`$1:***@")
  }
  return $Conn
}

function Add-SslModeIfMissing {
  param([string]$Conn, [string]$SslMode)
  if ($Conn -match "(?i)sslmode=") { return $Conn }
  if ($Conn -match "\?") {
    return "$Conn&sslmode=$SslMode"
  } else {
    return "$Conn?sslmode=$SslMode"
  }
}

function Ensure-ClientTools {
  if ($UseDockerClient) {
    # Docker presence check
    if (-not (Get-Command docker -ErrorAction SilentlyContinue)) {
      throw "Docker not found. Install Docker Desktop or run without -UseDockerClient."
    }
    return
  }

  $pgDump = Get-Command pg_dump -ErrorAction SilentlyContinue
  $pgRestore = Get-Command pg_restore -ErrorAction SilentlyContinue
  $psql = Get-Command psql -ErrorAction SilentlyContinue

  if (-not $pgDump) { throw "pg_dump not found in PATH. Install Postgres client tools or use -UseDockerClient." }
  if (-not $pgRestore) { throw "pg_restore not found in PATH. Install Postgres client tools or use -UseDockerClient." }
  if (-not $psql) { throw "psql not found in PATH. Install Postgres client tools or use -UseDockerClient." }
}

function Run-InDocker {
  param([string]$Cmd)
  $mounted = (Resolve-Path .).Path
  $dockerCmd = "docker run --rm -v `"$mounted`":/work -w /work $DockerImage bash -lc `"$Cmd`""
  Write-Host ">> $dockerCmd"
  $proc = Start-Process -FilePath "powershell" -ArgumentList "-NoProfile","-Command",$dockerCmd -NoNewWindow -PassThru -Wait
  if ($proc.ExitCode -ne 0) { throw "Command failed in Docker (exit $($proc.ExitCode))" }
}

# Main
$CloudDbUrl = Add-SslModeIfMissing -Conn $CloudDbUrl -SslMode $CloudSslMode
Ensure-ClientTools
Ensure-Dir -Path $DumpDir

if (-not $DumpFileName -and ($Mode -ne "Stream")) {
  $DumpFileName = Split-Path -Leaf (New-DumpName -BaseDir $DumpDir)
}
$DumpPath = if ($DumpFileName) { Join-Path $DumpDir $DumpFileName } else { $null }

Write-Host "Source (local): $(Mask-ConnStr $LocalDbUrl)"
Write-Host "Target (cloud): $(Mask-ConnStr $CloudDbUrl)"
if ($DumpPath) { Write-Host "Dump file: $DumpPath" }
Write-Host "Mode: $Mode"
if (-not $Force) {
  $resp = Read-Host "Proceed? Type 'yes' to continue"
  if ($resp -ne "yes") { Write-Host "Aborted by user."; exit 1 }
}

# DUMP
if ($Mode -in @("DumpAndRestore","DumpOnly")) {
  $noOwnerAcl = if ($NoOwnerNoAcl) { "--no-owner --no-acl" } else { "" }
  $cmd = @(
    "PGPASSWORD=`"$env:PGPASSWORD`" pg_dump --dbname `"$LocalDbUrl`" --format=c --file `"$DumpPath`" $noOwnerAcl --verbose"
  ) -join " "
  if ($UseDockerClient) {
    Run-InDocker -Cmd $cmd
  } else {
    Write-Host ">> pg_dump to $DumpPath"
    $proc = Start-Process -FilePath "powershell" -ArgumentList "-NoProfile","-Command",$cmd -NoNewWindow -PassThru -Wait
    if ($proc.ExitCode -ne 0) { throw "pg_dump failed (exit $($proc.ExitCode))" }
  }
}

# STREAM
if ($Mode -eq "Stream") {
  $noOwnerAcl = if ($NoOwnerNoAcl) { "--no-owner --no-acl" } else { "" }
  $cmd = @(
    "set -o pipefail;",
    "PGPASSWORD=`"$env:PGPASSWORD`" pg_dump --dbname `"$LocalDbUrl`" --format=p $noOwnerAcl --verbose",
    "| PGPASSWORD=`"$env:PGPASSWORD`" psql `"$CloudDbUrl`""
  ) -join " "
  if ($UseDockerClient) {
    Run-InDocker -Cmd $cmd
  } else {
    Write-Host ">> streaming dump to cloud"
    $proc = Start-Process -FilePath "bash" -ArgumentList "-lc",$cmd -NoNewWindow -PassThru -Wait
    if ($proc.ExitCode -ne 0) { throw "streaming dump failed (exit $($proc.ExitCode))" }
  }
}

# RESTORE
if ($Mode -in @("DumpAndRestore","RestoreOnly")) {
  if (-not (Test-Path -LiteralPath $DumpPath)) { throw "Dump file not found: $DumpPath" }
  $clean = if ($CleanIfExists) { "--clean --if-exists" } else { "" }
  $noOwnerAcl = if ($NoOwnerNoAcl) { "--no-owner --no-acl" } else { "" }
  $jobs = if ($ParallelJobs -gt 1) { "-j $ParallelJobs" } else { "" }

  $cmd = @(
    "PGPASSWORD=`"$env:PGPASSWORD`" pg_restore --dbname `"$CloudDbUrl`" $clean $noOwnerAcl $jobs --verbose `"$DumpPath`""
  ) -join " "

  if ($UseDockerClient) {
    Run-InDocker -Cmd $cmd
  } else {
    Write-Host ">> pg_restore to cloud"
    $proc = Start-Process -FilePath "powershell" -ArgumentList "-NoProfile","-Command",$cmd -NoNewWindow -PassThru -Wait
    if ($proc.ExitCode -ne 0) { throw "pg_restore failed (exit $($proc.ExitCode))" }
  }
}

Write-Host ""
Write-Host "SUCCESS."
Write-Host "Next steps:"
Write-Host "  - In your cloud Medusa app, run: npx medusa db:migrate"
Write-Host "  - Verify /health and Admin UI, then sanity-check key data."
```

### Usage examples (PowerShell)
- Dump to file and restore (recommended):
```powershell
# Replace with your actual URLs (include passwords or rely on PGPASSWORD)
.\pg_migrate_local_to_cloud.ps1 `
  -LocalDbUrl "postgresql://local_user:local_pass@localhost:5432/nickadeal" `
  -CloudDbUrl "postgresql://cloud_user:cloud_pass@db-host:5432/nickadeal_prod" `
  -Mode DumpAndRestore `
  -DumpDir ".\backups" `
  -ParallelJobs 4
```

- Dump only:
```powershell
.\pg_migrate_local_to_cloud.ps1 -LocalDbUrl "postgresql://..." -CloudDbUrl "postgresql://..." -Mode DumpOnly
```

- Restore only:
```powershell
.\pg_migrate_local_to_cloud.ps1 -LocalDbUrl "postgresql://..." -CloudDbUrl "postgresql://..." -Mode RestoreOnly -DumpFileName "nad_backup_20250101_1200.dump"
```

- Stream (small DBs) without creating a file:
```powershell
.\pg_migrate_local_to_cloud.ps1 -LocalDbUrl "postgresql://..." -CloudDbUrl "postgresql://..." -Mode Stream
```

- Use Dockerized Postgres client (no local pg_dump installed):
```powershell
.\pg_migrate_local_to_cloud.ps1 -LocalDbUrl "postgresql://..." -CloudDbUrl "postgresql://..." -UseDockerClient -DockerImage "postgres:16"
```

### After restore
- In Dokploy, use “Run Command” on the server app to run:
```bash
npx medusa db:migrate
```
This ensures latest migrations and link definitions are applied per Medusa’s CLI guide: [Medusa CLI db](https://docs.medusajs.com/resources/medusa-cli/commands/db).

- Verify:
  - `https://<backend-domain>/health` shows OK.
  - Admin loads at `https://<backend-domain>/app` and login works.
  - Sample flows (list products, create draft order) succeed.

- Rollback: keep the dump file; if needed, restore the previous cloud backup or re-run with the old dump.
