#!/bin/bash
set -e

echo "🔧 Setting up git worktrees for external dependencies..."

# Setup OpenFrontIO worktree
if [ ! -d "external/openfrontio" ]; then
  echo "📦 Setting up OpenFrontIO worktree..."
  git worktree add external/openfrontio https://github.com/bosconian-dynamics/OpenFrontIO.git main
  
  cd external/openfrontio
  
  # Add local-only modifications required by Rush
  echo "✏️  Adding Rush-required fields to package.json..."
  npm pkg set version="0.0.0-external"
  npm pkg set scripts.build="npm run build-prod"
  
  # Tell git to ignore these local changes
  git update-index --assume-unchanged package.json
  
  cd ../..
  echo "✅ OpenFrontIO worktree ready"
else
  echo "✅ OpenFrontIO worktree already exists"
fi

echo ""
echo "🎉 Worktree setup complete!"
echo ""
echo "Next steps:"
echo "  1. Run 'rush update' to install dependencies"
echo "  2. Run 'rush build' to build all projects"
echo ""
