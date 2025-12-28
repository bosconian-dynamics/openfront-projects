#!/usr/bin/env pwsh

Write-Host "🔧 Setting up git worktrees for external dependencies..." -ForegroundColor Cyan

# Setup OpenFrontIO worktree
if (-not (Test-Path "external/openfrontio")) {
    Write-Host "📦 Setting up OpenFrontIO worktree..." -ForegroundColor Yellow
    
    # Add the remote if it doesn't exist
    try {
        git remote get-url openfrontio 2>&1 | Out-Null
    } catch {
        Write-Host "Adding openfrontio remote..." -ForegroundColor Yellow
        git remote add openfrontio https://github.com/bosconian-dynamics/OpenFrontIO.git
    }
    
    # Fetch the remote
    Write-Host "Fetching from openfrontio remote..." -ForegroundColor Yellow
    git fetch openfrontio
    
    # Remove the old local branch if it exists
    if (git show-ref --verify --quiet refs/heads/main) {
        Write-Host "Removing old local main branch..." -ForegroundColor Yellow
        git branch -D main
    }
    
    # Create the worktree
    git worktree add -b main external/openfrontio openfrontio/main
    
    Push-Location external/openfrontio
    
    # Add local-only modifications required by Rush
    Write-Host "✏️  Adding Rush-required fields to package.json..." -ForegroundColor Yellow
    npm pkg set version="0.0.0-external"
    npm pkg set scripts.build="npm run build-prod"
    
    # Tell git to ignore these local changes
    git update-index --assume-unchanged package.json
    
    Pop-Location
    Write-Host "✅ OpenFrontIO worktree ready" -ForegroundColor Green
} else {
    Write-Host "✅ OpenFrontIO worktree already exists" -ForegroundColor Green
}

Write-Host ""
Write-Host "🎉 Worktree setup complete!" -ForegroundColor Green
Write-Host ""
Write-Host "Next steps:"
Write-Host "  1. Run 'rush update' to install dependencies"
Write-Host "  2. Run 'rush build' to build all projects"
Write-Host ""
