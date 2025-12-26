#!/usr/bin/env pwsh
# Getting Started Script for OpenFront Projects Monorepo

$ErrorActionPreference = "Stop"

Write-Host "======================================"
Write-Host "OpenFront Projects - Setup Script"
Write-Host "======================================"
Write-Host ""

# Check if Node.js is installed
$nodeCommand = Get-Command node -ErrorAction SilentlyContinue
if (-not $nodeCommand) {
    Write-Host "❌ Node.js is not installed!" -ForegroundColor Red
    Write-Host "Please install Node.js 20.x or 22.x LTS from https://nodejs.org/"
    exit 1
}

$nodeVersion = node -v
Write-Host "✓ Node.js version: $nodeVersion" -ForegroundColor Green

# Check if npm is installed
$npmCommand = Get-Command npm -ErrorAction SilentlyContinue
if (-not $npmCommand) {
    Write-Host "❌ npm is not installed!" -ForegroundColor Red
    exit 1
}

$npmVersion = npm -v
Write-Host "✓ npm version: $npmVersion" -ForegroundColor Green
Write-Host ""

# Install Rush globally if not already installed
$rushCommand = Get-Command rush -ErrorAction SilentlyContinue
if (-not $rushCommand) {
    Write-Host "📦 Installing Rush globally..." -ForegroundColor Cyan
    npm install -g @microsoft/rush
    Write-Host "✓ Rush installed" -ForegroundColor Green
} else {
    $rushVersionOutput = rush --version 2>&1 | Select-String "Rush Multi-Project"
    if ($rushVersionOutput) {
        $rushVersion = ($rushVersionOutput -split '\s+')[4]
        Write-Host "✓ Rush already installed (version $rushVersion)" -ForegroundColor Green
    } else {
        Write-Host "✓ Rush already installed" -ForegroundColor Green
    }
}
Write-Host ""

# Configure git remotes for OpenFrontIO subtree
Write-Host "🔧 Configuring git remotes for OpenFrontIO subtree..." -ForegroundColor Cyan
try {
    git remote get-url openfrontio-fork 2>&1 | Out-Null
    Write-Host "✓ openfrontio-fork remote already configured" -ForegroundColor Green
} catch {
    git remote add openfrontio-fork https://github.com/bosconian-dynamics/OpenFrontIO
    Write-Host "✓ Added openfrontio-fork remote" -ForegroundColor Green
}

try {
    git remote get-url openfrontio-upstream 2>&1 | Out-Null
    Write-Host "✓ openfrontio-upstream remote already configured" -ForegroundColor Green
} catch {
    git remote add openfrontio-upstream https://github.com/openfrontio/OpenFrontIO
    Write-Host "✓ Added openfrontio-upstream remote" -ForegroundColor Green
}
Write-Host ""

# Run rush update
Write-Host "📦 Installing dependencies with Rush..." -ForegroundColor Cyan
rush update

Write-Host ""
Write-Host "======================================"
Write-Host "✓ Setup complete!" -ForegroundColor Green
Write-Host "======================================"
Write-Host ""
Write-Host "Next steps:"
Write-Host "  1. Build all packages:     rush build"
Write-Host "  2. List all packages:      rush list"
Write-Host "  3. Run tests:              rush test"
Write-Host ""
Write-Host "Subtree management:"
Write-Host "  - Pull updates:            rush sync-subtree"
Write-Host "  - Push to fork:            pwsh common/scripts/openfrontio-push.ps1"
Write-Host ""
Write-Host "For VSCode users:"
Write-Host "  - Install the 'Dev Containers' extension"
Write-Host "  - Reopen this folder in container for a ready-to-go environment"
Write-Host ""
Write-Host "Documentation:"
Write-Host "  - AGENTS.md               - AI coding agent guidelines"
Write-Host "  - docs/MONOREPO.md        - Monorepo structure and usage"
Write-Host "  - docs/ADDING_PACKAGES.md - How to add new packages"
Write-Host "  - docs/SUBTREE.md         - Git subtree management"
Write-Host ""
