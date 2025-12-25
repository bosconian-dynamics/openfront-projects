#!/bin/bash
# Getting Started Script for OpenFront Projects Monorepo

set -e

echo "======================================"
echo "OpenFront Projects - Setup Script"
echo "======================================"
echo ""

# Check if Node.js is installed
if ! command -v node &> /dev/null; then
    echo "❌ Node.js is not installed!"
    echo "Please install Node.js 20.x or 22.x LTS from https://nodejs.org/"
    exit 1
fi

NODE_VERSION=$(node -v)
echo "✓ Node.js version: $NODE_VERSION"

# Check if npm is installed
if ! command -v npm &> /dev/null; then
    echo "❌ npm is not installed!"
    exit 1
fi

NPM_VERSION=$(npm -v)
echo "✓ npm version: $NPM_VERSION"
echo ""

# Install Rush globally if not already installed
if ! command -v rush &> /dev/null; then
    echo "📦 Installing Rush globally..."
    npm install -g @microsoft/rush
    echo "✓ Rush installed"
else
    RUSH_VERSION=$(rush --version 2>&1 | grep "Rush Multi-Project" | awk '{print $5}')
    echo "✓ Rush already installed (version $RUSH_VERSION)"
fi
echo ""

# Run rush update
echo "📦 Installing dependencies with Rush..."
rush update

echo ""
echo "======================================"
echo "✓ Setup complete!"
echo "======================================"
echo ""
echo "Next steps:"
echo "  1. Build all packages:     rush build"
echo "  2. List all packages:      rush list"
echo "  3. Run tests:              rush test"
echo ""
echo "For VSCode users:"
echo "  - Install the 'Dev Containers' extension"
echo "  - Reopen this folder in container for a ready-to-go environment"
echo ""
echo "Documentation:"
echo "  - docs/MONOREPO.md        - Monorepo structure and usage"
echo "  - docs/AI_GUIDANCE.md     - AI/LLM assistance guidelines"
echo "  - docs/ADDING_PACKAGES.md - How to add new packages"
echo "  - docs/SUBTREE.md         - Git subtree management"
echo ""
