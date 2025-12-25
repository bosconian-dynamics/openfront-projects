#!/usr/bin/env pwsh
# Push changes to OpenFrontIO fork

$ErrorActionPreference = "Stop"

# Import the subtree management module
Import-Module "$PSScriptRoot/modules/SubtreeManagement.psm1" -Force

$SubtreePath = "external/OpenFrontIO"
$PackageJsonPath = "$SubtreePath/package.json"

Write-Host "======================================"
Write-Host "OpenFrontIO - Push to Fork"
Write-Host "======================================"
Write-Host ""

# Step 1: Remove version and private fields
Write-Host "Removing version and private fields from package.json..." -ForegroundColor Cyan
Remove-PackageVersion -PackageJsonPath $PackageJsonPath

# Step 2: Stage and commit the changes
Write-Host ""
Write-Host "Staging and committing package.json changes..." -ForegroundColor Cyan
git add $PackageJsonPath

# Check if there are changes to commit
$status = git status --porcelain $PackageJsonPath
if ($status) {
    git commit -m "Remove version/private fields before subtree push"
    Write-Host "✓ Committed package.json changes" -ForegroundColor Green
} else {
    Write-Host "⚠ No changes to commit in package.json" -ForegroundColor Yellow
}

# Step 3: Push to fork
Write-Host ""
Invoke-SubtreePush -Prefix $SubtreePath -Remote "openfrontio-fork" -Branch "main"

# Step 4: Restore version and private fields
Write-Host ""
Write-Host "Restoring version and private fields..." -ForegroundColor Cyan
Add-PackageVersion -PackageJsonPath $PackageJsonPath -Version "0.0.0-external"

# Step 5: Stage and commit the restoration
git add $PackageJsonPath
git commit -m "Restore version/private fields after subtree push"

Write-Host ""
Write-Host "======================================"
Write-Host "✓ Push completed!" -ForegroundColor Green
Write-Host "======================================"
Write-Host ""
Write-Host "Changes have been pushed to your fork."
Write-Host "You can now create a PR from your fork to upstream on GitHub."
Write-Host ""
