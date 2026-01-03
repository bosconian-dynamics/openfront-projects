#!/bin/bash
set -e

echo "🔧 Setting up git submodules for external dependencies..."

# Initialize and update submodules
echo "📦 Initializing and updating submodules..."
git submodule update --init --recursive

# Setup OpenFrontIO submodule for Rush
if [ -d "external/openfrontio" ]; then
  echo "✏️  Configuring Rush compatibility for OpenFrontIO submodule..."
  ./scripts/toggle-rush-compat.sh on external/openfrontio
  echo "✅ OpenFrontIO submodule ready"
else
  echo "❌ OpenFrontIO submodule not found. Please ensure the submodule is properly configured."
  exit 1
fi

echo ""
echo "🎉 Submodule setup complete!"
echo ""
echo "Next steps:"
echo "  1. Run 'rush update' to install dependencies"
echo "  2. Run 'rush build' to build all projects"
echo ""
echo "Submodule management commands:"
echo "  - Update to latest: cd external/openfrontio && git pull origin main && cd ../.. && git add external/openfrontio"
echo "  - Pin current version: git add external/openfrontio && git commit -m 'Update OpenFrontIO to [version]'"
echo "  - Update submodules after clone: git submodule update --init --recursive"
echo ""
