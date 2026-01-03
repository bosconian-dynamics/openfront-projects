#!/usr/bin/env pwsh

Write-Host "🔧 Setting up git submodules for external dependencies..." -ForegroundColor Cyan

# Initialize and update submodules
Write-Host "📦 Initializing and updating submodules..." -ForegroundColor Yellow
git submodule update --init --recursive

# Setup OpenFrontIO submodule for Rush
if (Test-Path "external/openfrontio") {
    Write-Host "✏️  Configuring Rush compatibility for OpenFrontIO submodule..." -ForegroundColor Yellow
    & .\scripts\toggle-rush-compat.ps1 on external/openfrontio
    Write-Host "✅ OpenFrontIO submodule ready" -ForegroundColor Green
} else {
    Write-Host "❌ OpenFrontIO submodule not found. Please ensure the submodule is properly configured." -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "🎉 Submodule setup complete!" -ForegroundColor Green
Write-Host ""
Write-Host "Next steps:"
Write-Host "  1. Run 'rush update' to install dependencies"
Write-Host "  2. Run 'rush build' to build all projects"
Write-Host ""
Write-Host "Submodule management commands:"
Write-Host "  - Update to latest: cd external/openfrontio && git pull origin main && cd ../.. && git add external/openfrontio"
Write-Host "  - Pin current version: git add external/openfrontio && git commit -m 'Update OpenFrontIO to [version]'"
Write-Host "  - Update submodules after clone: git submodule update --init --recursive"
Write-Host ""
