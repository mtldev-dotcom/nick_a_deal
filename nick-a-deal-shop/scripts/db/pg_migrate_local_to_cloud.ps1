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