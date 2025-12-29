#!/bin/bash
set -e

echo "🔧 Setting up git worktrees for external dependencies..."

# Setup OpenFrontIO worktree
if [ ! -d "external/openfrontio" ]; then
  echo "📦 Setting up OpenFrontIO worktree..."
  
  # Add the remote if it doesn't exist
  if ! git remote get-url openfrontio &> /dev/null; then
    echo "Adding openfrontio remote..."
    git remote add openfrontio https://github.com/bosconian-dynamics/OpenFrontIO.git
  fi
  
  # Fetch the remote
  echo "Fetching from openfrontio remote..."
  git fetch openfrontio
  
  # Remove the old local branch if it exists
  if git show-ref --verify --quiet refs/heads/main; then
    echo "Removing old local main branch..."
    git branch -D main
  fi
  
  # Create the worktree
  git worktree add -b main external/openfrontio openfrontio/main
  
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
