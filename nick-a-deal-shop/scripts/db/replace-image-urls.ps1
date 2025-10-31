# PowerShell script to replace image URLs in SQL backup file
# Replaces: http://localhost:9000/static/
# With:     https://pub-0e79c5d9c3514966abd6173d388518b2.r2.dev/product-demo-image/

param(
    [string]$SqlFile = "database_backup_10_31.sql",
    [switch]$DryRun = $false
)

# Step 1: Navigate to script directory
Set-Location $PSScriptRoot

# Step 2: Verify file exists
if (-not (Test-Path $SqlFile)) {
    Write-Host "ERROR: SQL file not found: $SqlFile" -ForegroundColor Red
    exit 1
}

# Step 3: Create backup of original file
$backupFile = "$SqlFile.backup_$(Get-Date -Format 'yyyyMMdd_HHmmss')"
Write-Host "Creating backup: $backupFile" -ForegroundColor Cyan
Copy-Item $SqlFile $backupFile

# Step 4: Count occurrences before replacement
$oldPattern = "http://localhost:9000/static/"
$newPattern = "https://pub-0e79c5d9c3514966abd6173d388518b2.r2.dev/product-demo-image/"
$content = Get-Content $SqlFile -Raw
$matchesBefore = ([regex]::Matches($content, [regex]::Escape($oldPattern))).Count

Write-Host "`nFound $matchesBefore occurrences of: $oldPattern" -ForegroundColor Yellow

if ($DryRun) {
    Write-Host "`nDRY RUN MODE - No changes will be made" -ForegroundColor Cyan
    Write-Host "Would replace: $oldPattern" -ForegroundColor Cyan
    Write-Host "With:          $newPattern" -ForegroundColor Cyan
    exit 0
}

# Step 5: Perform replacement
Write-Host "`nReplacing URLs..." -ForegroundColor Yellow
$content = $content -replace [regex]::Escape($oldPattern), $newPattern

# Step 6: Write updated content back to file
Set-Content -Path $SqlFile -Value $content -NoNewline

# Step 7: Verify replacement
$contentAfter = Get-Content $SqlFile -Raw
$matchesAfter = ([regex]::Matches($contentAfter, [regex]::Escape($oldPattern))).Count
$newMatches = ([regex]::Matches($contentAfter, [regex]::Escape($newPattern))).Count

Write-Host "`n✅ Replacement completed!" -ForegroundColor Green
Write-Host "   Old URLs remaining: $matchesAfter" -ForegroundColor $(if ($matchesAfter -eq 0) { "Green" } else { "Yellow" })
Write-Host "   New URLs found: $newMatches" -ForegroundColor Green
Write-Host "`nBackup saved to: $backupFile" -ForegroundColor Cyan
Write-Host "`nNext step: Run sync-to-remote.ps1 to sync to remote database" -ForegroundColor Cyan

