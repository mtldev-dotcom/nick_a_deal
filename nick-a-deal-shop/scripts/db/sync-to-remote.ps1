# PowerShell script to sync local SQL backup to remote database
# Remote DB: 5.161.238.111:5433, Database: nick_deal_db, User: postgres

# Step 1: Ensure PostgreSQL tools are in PATH
$env:Path += ";C:\Program Files\PostgreSQL\18\bin"

# Step 2: Navigate to the script directory
Set-Location "$PSScriptRoot"

# Step 3: Test connection to remote database
Write-Host "Testing connection to remote database..." -ForegroundColor Cyan
$testConnection = Test-NetConnection -ComputerName 5.161.238.111 -Port 5433 -WarningAction SilentlyContinue
if (-not $testConnection.TcpTestSucceeded) {
    Write-Host "ERROR: Cannot connect to remote database. Check firewall and network." -ForegroundColor Red
    exit 1
}
Write-Host "Connection test passed." -ForegroundColor Green

# Step 4: Backup remote database first (SAFETY FIRST!)
Write-Host "`nCreating backup of remote database..." -ForegroundColor Yellow
$remoteBackupFile = "database_remote_backup_$(Get-Date -Format 'yyyyMMdd_HHmmss').sql"
pg_dump -h 5.161.238.111 -p 5433 -U postgres -d nick_deal_db -f $remoteBackupFile
if ($LASTEXITCODE -eq 0) {
    Write-Host "Remote backup created: $remoteBackupFile" -ForegroundColor Green
} else {
    Write-Host "WARNING: Remote backup failed. Proceed with caution!" -ForegroundColor Yellow
    $continue = Read-Host "Continue anyway? (yes/no)"
    if ($continue -ne "yes") {
        exit 1
    }
}

# Step 5: Ask user if they want to clean remote database first
Write-Host "`nDo you want to:" -ForegroundColor Cyan
Write-Host "  1) Clean remote database first (DROP all tables, then import) - RECOMMENDED"
Write-Host "  2) Import directly (may fail if tables already exist)"
$choice = Read-Host "Enter choice (1 or 2)"

if ($choice -eq "1") {
    # Step 6a: Clean remote database
    Write-Host "`nCleaning remote database..." -ForegroundColor Yellow
    $cleanScript = @"
DROP SCHEMA IF EXISTS public CASCADE;
CREATE SCHEMA public;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO public;
"@
    $cleanScript | psql -h 5.161.238.111 -p 5433 -U postgres -d nick_deal_db
    
    if ($LASTEXITCODE -ne 0) {
        Write-Host "ERROR: Failed to clean remote database." -ForegroundColor Red
        exit 1
    }
    Write-Host "Remote database cleaned successfully." -ForegroundColor Green
}

# Step 6b / Step 7: Import SQL file to remote database
Write-Host "`nImporting database_backup_10_31.sql to remote database..." -ForegroundColor Yellow
Write-Host "This may take several minutes depending on database size..." -ForegroundColor Cyan

psql -h 5.161.238.111 -p 5433 -U postgres -d nick_deal_db -f database_backup_10_31.sql

if ($LASTEXITCODE -eq 0) {
    Write-Host "`n✅ SUCCESS: Database imported successfully!" -ForegroundColor Green
} else {
    Write-Host "`n❌ ERROR: Import failed. Check error messages above." -ForegroundColor Red
    Write-Host "You can restore from backup: $remoteBackupFile" -ForegroundColor Yellow
    exit 1
}

# Step 8: Verify import
Write-Host "`nVerifying import..." -ForegroundColor Cyan
$verifyScript = @"
SELECT COUNT(*) as table_count 
FROM information_schema.tables 
WHERE table_schema = 'public' AND table_type = 'BASE TABLE';
"@
$tableCount = $verifyScript | psql -h 5.161.238.111 -p 5433 -U postgres -d nick_deal_db -t -A
Write-Host "Tables found in remote database: $tableCount" -ForegroundColor Green

Write-Host "`n✅ Sync completed successfully!" -ForegroundColor Green
Write-Host "Next steps:" -ForegroundColor Cyan
Write-Host "  1. Restart your MedusaJS application to connect to updated database"
Write-Host "  2. Run: yarn medusa db:migrate (if needed)"
Write-Host "  3. Run: yarn medusa links:sync (if needed)"
Write-Host "  4. Verify your application works with the new database"

