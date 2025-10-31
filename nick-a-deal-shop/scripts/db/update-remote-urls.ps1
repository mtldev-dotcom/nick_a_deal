# PowerShell script to update image URLs in remote database
# Replaces: http://localhost:9000/static/
# With:     https://pub-0e79c5d9c3514966abd6173d388518b2.r2.dev/product-demo-image/

# Step 1: Add PostgreSQL to PATH
$env:Path += ";C:\Program Files\PostgreSQL\18\bin"

# Step 2: Navigate to script directory
Set-Location $PSScriptRoot

# Step 3: Test connection to remote database
Write-Host "Testing connection to remote database..." -ForegroundColor Cyan
$testConnection = Test-NetConnection -ComputerName 5.161.238.111 -Port 5433 -WarningAction SilentlyContinue
if (-not $testConnection.TcpTestSucceeded) {
    Write-Host "ERROR: Cannot connect to remote database. Check firewall and network." -ForegroundColor Red
    exit 1
}
Write-Host "Connection test passed." -ForegroundColor Green

# Step 4: Show what will be updated (dry run query)
Write-Host "`nChecking how many URLs need updating..." -ForegroundColor Cyan
$dryRunQuery = @"
SELECT 
    (SELECT COUNT(*) FROM public.image WHERE url LIKE 'http://localhost:9000/static/%') as image_count,
    (SELECT COUNT(*) FROM public.product WHERE thumbnail LIKE 'http://localhost:9000/static/%') as product_count,
    (SELECT COUNT(*) FROM public.cart_line_item WHERE thumbnail LIKE 'http://localhost:9000/static/%') as cart_count;
"@

$dryRunResult = $dryRunQuery | psql -h 5.161.238.111 -p 5433 -U postgres -d nick_deal_db -t -A
if ($LASTEXITCODE -eq 0) {
    $counts = $dryRunResult -split '\|'
    Write-Host "Found:" -ForegroundColor Yellow
    Write-Host "  - Image URLs: $($counts[0])" -ForegroundColor Yellow
    Write-Host "  - Product thumbnails: $($counts[1])" -ForegroundColor Yellow
    Write-Host "  - Cart line items: $($counts[2])" -ForegroundColor Yellow
} else {
    Write-Host "WARNING: Could not check counts. Proceeding anyway..." -ForegroundColor Yellow
}

# Step 5: Ask for confirmation
Write-Host "`nThis will update image URLs in the remote database." -ForegroundColor Cyan
Write-Host "Old: http://localhost:9000/static/" -ForegroundColor Yellow
Write-Host "New: https://pub-0e79c5d9c3514966abd6173d388518b2.r2.dev/product-demo-image/" -ForegroundColor Green
$confirm = Read-Host "`nContinue? (yes/no)"

if ($confirm -ne "yes") {
    Write-Host "Cancelled." -ForegroundColor Yellow
    exit 0
}

# Step 6: Run the SQL update script
Write-Host "`nUpdating URLs in remote database..." -ForegroundColor Yellow
psql -h 5.161.238.111 -p 5433 -U postgres -d nick_deal_db -f update-remote-urls.sql

if ($LASTEXITCODE -eq 0) {
    Write-Host "`n✅ URLs updated successfully!" -ForegroundColor Green
} else {
    Write-Host "`n❌ ERROR: Update failed. Check error messages above." -ForegroundColor Red
    exit 1
}

# Step 7: Verify update
Write-Host "`nVerifying update..." -ForegroundColor Cyan
$verifyQuery = @"
SELECT 
    COUNT(*) FILTER (WHERE url LIKE 'http://localhost:9000/static/%') as old_urls,
    COUNT(*) FILTER (WHERE url LIKE 'https://pub-0e79c5d9c3514966abd6173d388518b2.r2.dev/product-demo-image/%') as new_urls
FROM public.image;
"@

$verifyResult = $verifyQuery | psql -h 5.161.238.111 -p 5433 -U postgres -d nick_deal_db -t -A
if ($LASTEXITCODE -eq 0) {
    $verifyCounts = $verifyResult -split '\|'
    Write-Host "Verification:" -ForegroundColor Cyan
    Write-Host "  - Old URLs remaining: $($verifyCounts[0])" -ForegroundColor $(if ([int]$verifyCounts[0] -eq 0) { "Green" } else { "Yellow" })
    Write-Host "  - New URLs found: $($verifyCounts[1])" -ForegroundColor Green
}

Write-Host "`n✅ Update completed!" -ForegroundColor Green
Write-Host "Next steps:" -ForegroundColor Cyan
Write-Host "  1. Restart your MedusaJS application"
Write-Host "  2. Verify images load correctly in the storefront"

