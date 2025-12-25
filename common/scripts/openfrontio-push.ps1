#!/usr/bin/env pwsh
# Push changes to OpenFrontIO fork

$ErrorActionPreference = "Stop"

# Import the subtree management module
Import-Module "$PSScriptRoot/modules/SubtreeManagement.psm1" -Force

$SubtreePath = "external/openfrontio/upstream"

Write-Host "======================================"
Write-Host "OpenFrontIO - Push to Fork"
Write-Host "======================================"
Write-Host ""

# Save current state for rollback
$rollbackCommit = git rev-parse HEAD

# Function to rollback on error
function Invoke-Rollback {
    Write-Host "⚠ Rolling back changes..." -ForegroundColor Yellow
    try {
        git reset --hard $rollbackCommit
        Write-Host "✓ Rollback completed" -ForegroundColor Green
    } catch {
        Write-Host "✗ Rollback failed - manual intervention required" -ForegroundColor Red
        Write-Host "Please run: git reset --hard $rollbackCommit" -ForegroundColor Yellow
    }
}

try {
    # Push to fork
    Invoke-SubtreePush -Prefix $SubtreePath -Remote "openfrontio-fork" -Branch "main"

    Write-Host ""
    Write-Host "======================================"
    Write-Host "✓ Push completed!" -ForegroundColor Green
    Write-Host "======================================"
    Write-Host ""
    Write-Host "Changes have been pushed to your fork."
    Write-Host "You can now create a PR from your fork to upstream on GitHub."
    Write-Host ""
} catch {
    Write-Host ""
    Write-Host "======================================"
    Write-Host "✗ Push failed!" -ForegroundColor Red
    Write-Host "======================================"
    Write-Host ""
    Write-Host "Error: $_" -ForegroundColor Red
    Invoke-Rollback
    exit 1
}

