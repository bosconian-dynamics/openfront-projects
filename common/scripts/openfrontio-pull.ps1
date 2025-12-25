#!/usr/bin/env pwsh
# Pull updates from OpenFrontIO upstream

$ErrorActionPreference = "Stop"

# Import the subtree management module
Import-Module "$PSScriptRoot/modules/SubtreeManagement.psm1" -Force

$SubtreePath = "external/OpenFrontIO"
$PackageJsonPath = "$SubtreePath/package.json"

Write-Host "======================================"
Write-Host "OpenFrontIO - Pull from Upstream"
Write-Host "======================================"
Write-Host ""

# Step 1: Pull from upstream
Invoke-SubtreePull -Prefix $SubtreePath -Remote "openfrontio-upstream" -Branch "main"

# Step 2: Add version and private fields for Rush compatibility
Write-Host ""
Write-Host "Adding version field for Rush compatibility..." -ForegroundColor Cyan
Add-PackageVersion -PackageJsonPath $PackageJsonPath -Version "0.0.0-external"

# Step 3: Stage the changes
Write-Host ""
Write-Host "Staging package.json changes..." -ForegroundColor Cyan
git add $PackageJsonPath

Write-Host ""
Write-Host "======================================"
Write-Host "✓ Pull completed!" -ForegroundColor Green
Write-Host "======================================"
Write-Host ""
Write-Host "The package.json has been updated with:"
Write-Host "  - version: 0.0.0-external"
Write-Host "  - private: true"
Write-Host ""
Write-Host "These changes are staged. Commit them with:"
Write-Host "  git commit -m 'Update OpenFrontIO from upstream'"
Write-Host ""
