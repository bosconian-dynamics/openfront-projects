#!/bin/bash
set -e

USAGE="Usage: $0 [on|off|auto] [worktree-path]"
MODE="$1"
WORKTREE_PATH="${2:-external/openfrontio}"

if [ ! -d "$WORKTREE_PATH" ]; then
    echo "Error: Worktree path '$WORKTREE_PATH' does not exist"
    exit 1
fi

cd "$WORKTREE_PATH"

# Auto-detect current mode if not specified or if 'auto' is specified
if [ -z "$MODE" ] || [ "$MODE" = "auto" ]; then
    # Check if Rush compatibility is currently enabled by looking for the version field
    if npm pkg get version | grep -q '"0.0.0-external"'; then
        MODE="off"  # Currently on, so toggle off
        echo "📋 Auto-detected: Rush compatibility is ON, toggling OFF"
    else
        MODE="on"   # Currently off, so toggle on
        echo "📋 Auto-detected: Rush compatibility is OFF, toggling ON"
    fi
fi

if [ "$MODE" != "on" ] && [ "$MODE" != "off" ]; then
    echo "Error: Invalid mode '$MODE'. Use 'on', 'off', or 'auto' (or omit for auto)"
    echo "$USAGE"
    exit 1
fi

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