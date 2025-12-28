#!/usr/bin/env pwsh

Write-Host "🔧 Setting up git worktrees for external dependencies..." -ForegroundColor Cyan

# Setup OpenFrontIO worktree
if (-not (Test-Path "external/openfrontio")) {
    Write-Host "📦 Setting up OpenFrontIO worktree..." -ForegroundColor Yellow
    git worktree add external/openfrontio https://github.com/bosconian-dynamics/OpenFrontIO.git main
    
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
