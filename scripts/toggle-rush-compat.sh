#!/bin/bash
set -e

USAGE="Usage: $0 [on|off] [worktree-path]"
MODE="$1"
WORKTREE_PATH="${2:-external/openfrontio}"

if [ "$MODE" != "on" ] && [ "$MODE" != "off" ]; then
    echo "Error: Invalid mode. Use 'on' or 'off'"
    echo "$USAGE"
    exit 1
fi

if [ ! -d "$WORKTREE_PATH" ]; then
    echo "Error: Worktree path '$WORKTREE_PATH' does not exist"
    exit 1
fi

cd "$WORKTREE_PATH"

if [ "$MODE" = "off" ]; then
    echo "🔄 Disabling Rush compatibility - ready for upstream changes"
    
    # Stop ignoring package.json
    git update-index --no-assume-unchanged package.json
    
    # Remove Rush-specific changes
    npm pkg delete version 2>/dev/null || true
    npm pkg delete scripts.build 2>/dev/null || true
    
    echo "✅ Rush compatibility disabled"
    echo "   You can now make changes to package.json that will be tracked by git"
    
elif [ "$MODE" = "on" ]; then
    echo "🔄 Enabling Rush compatibility"
    
    # Add Rush-required fields
    npm pkg set version="0.0.0-external"
    npm pkg set scripts.build="npm run build-prod"
    
    # Ignore the file again
    git update-index --assume-unchanged package.json
    
    echo "✅ Rush compatibility enabled"
    echo "   package.json changes are now ignored by git"
fi