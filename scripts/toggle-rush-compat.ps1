#!/usr/bin/env pwsh

param(
    [Parameter(Mandatory=$true)]
    [ValidateSet("on", "off")]
    [string]$Mode,
    
    [Parameter(Mandatory=$false)]
    [string]$WorktreePath = "external/openfrontio"
)

if (-not (Test-Path $WorktreePath)) {
    Write-Error "Worktree path '$WorktreePath' does not exist"
    exit 1
}

Push-Location $WorktreePath

try {
    if ($Mode -eq "off") {
        Write-Host "🔄 Disabling Rush compatibility - ready for upstream changes" -ForegroundColor Yellow
        
        # Stop ignoring package.json
        git update-index --no-assume-unchanged package.json
        
        # Remove Rush-specific changes
        try { npm pkg delete version 2>$null } catch {}
        try { npm pkg delete scripts.build 2>$null } catch {}
        
        Write-Host "✅ Rush compatibility disabled" -ForegroundColor Green
        Write-Host "   You can now make changes to package.json that will be tracked by git" -ForegroundColor Gray
        
    } elseif ($Mode -eq "on") {
        Write-Host "🔄 Enabling Rush compatibility" -ForegroundColor Yellow
        
        # Add Rush-required fields
        npm pkg set version="0.0.0-external"
        npm pkg set scripts.build="npm run build-prod"
        
        # Ignore the file again
        git update-index --assume-unchanged package.json
        
        Write-Host "✅ Rush compatibility enabled" -ForegroundColor Green
        Write-Host "   package.json changes are now ignored by git" -ForegroundColor Gray
    }
} finally {
    Pop-Location
}