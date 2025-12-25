#!/usr/bin/env pwsh
# Pull updates from OpenFrontIO upstream

$ErrorActionPreference = "Stop"

# Import the subtree management module
Import-Module "$PSScriptRoot/modules/SubtreeManagement.psm1" -Force

$SubtreePath = "external/openfrontio"

Write-Host "======================================"
Write-Host "OpenFrontIO - Pull from Upstream"
Write-Host "======================================"
Write-Host ""

# Pull from upstream
Invoke-SubtreePull -Prefix $SubtreePath -Remote "openfrontio-upstream" -Branch "main"

Write-Host ""
Write-Host "======================================"
Write-Host "✓ Pull completed!" -ForegroundColor Green
Write-Host "======================================"
Write-Host ""
Write-Host "The OpenFrontIO subtree has been updated from upstream."
Write-Host ""

