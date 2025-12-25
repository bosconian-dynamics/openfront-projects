# OpenFront Projects - Monorepo Structure

This repository is a Rush-based monorepo for managing OpenFront-related projects.

## Overview

This monorepo uses [Rush](https://rushjs.io/) to manage multiple packages in a scalable and efficient way. Rush provides:

- Consistent dependency management across all packages
- Efficient builds with caching and parallelization
- Standardized tooling and workflows
- Better collaboration across teams

## Repository Structure

```
openfront-projects/
├── .devcontainer/          # VSCode dev container configuration
├── common/                 # Rush shared configuration
│   └── config/rush/        # Rush configuration files
├── docs/                   # Documentation
├── packages/               # All packages (2 levels deep)
│   └── OpenFrontIO/        # OpenFrontIO subtree from upstream
└── rush.json               # Main Rush configuration
```

### Package Organization

Packages in this monorepo are organized with a flexible depth structure (1-2 levels):

```
packages/
  ├── [category]/          # Category folder (e.g., apps, libraries, tools)
  │   └── [package-name]/  # Individual package (2 levels deep)
  └── [package-name]/      # Direct package (1 level deep, for special cases)
```

**Guidelines:**
- **New packages** should be placed 2 levels deep under a category (e.g., `packages/apps/my-app`)
- **Special cases** like OpenFrontIO (git subtree from upstream) may be 1 level deep
- Categories help organize related packages (e.g., apps, libraries, tools, prototypes)
- This structure keeps the repository organized and prevents over-nesting

**Current packages:**
- `external/OpenFrontIO` - Main OpenFrontIO game (git subtree, not Rush-managed)
  - Fork: https://github.com/bosconian-dynamics/OpenFrontIO (primary remote)
  - Upstream: https://github.com/openfrontio/OpenFrontIO (secondary remote)
  - Version tracked by git commit hash (currently: `28e22c9c`)
  - Not registered in Rush to preserve upstream state
  - Manage dependencies independently within this package

## Getting Started

### Prerequisites

- Node.js 20.x (LTS) or 22.x (latest LTS)
- npm 10.x or later
- Git

### Installation

1. Install Rush globally:
   ```bash
   npm install -g @microsoft/rush
   ```

2. Install all package dependencies:
   ```bash
   rush update
   ```

3. Build all packages:
   ```bash
   rush build
   ```

## Working with Rush

### Common Commands

- `rush update` - Install/update all package dependencies
- `rush build` - Build all packages
- `rush rebuild` - Clean and rebuild all packages
- `rush test` - Run tests for all packages
- `rush add -p <package> --all` - Add a dependency to all packages
- `rush add -p <package> --make-consistent` - Add a dependency and make it consistent across packages

### Working on a Single Package

```bash
cd packages/[category]/[package-name]
rushx <script-name>  # Run a package.json script
```

### Adding a New Package

1. Create the package directory (must be 2 levels deep):
   ```bash
   mkdir -p packages/[category]/[package-name]
   ```

2. Create a `package.json` in the package directory

3. Add the package to `rush.json`:
   ```json
   {
     "packageName": "@yourscope/package-name",
     "projectFolder": "packages/[category]/[package-name]"
   }
   ```

4. Run `rush update` to register the package

## OpenFrontIO Subtree

The `external/OpenFrontIO` directory is maintained as a git subtree with a fork-based workflow:
- **Fork (Primary)**: https://github.com/bosconian-dynamics/OpenFrontIO
- **Upstream**: https://github.com/openfrontio/OpenFrontIO
- **Branch**: main

### Subtree Commands

Pull updates from upstream:
```bash
git subtree pull --prefix=external/OpenFrontIO openfrontio-upstream main --squash
```

Push changes to your fork:
```bash
git subtree push --prefix=external/OpenFrontIO openfrontio-fork main
```

Remotes are already configured:
```bash
# View remotes
git remote -v | grep openfront
```

## Development Environment

### VSCode Dev Container

This repository includes a VSCode dev container configuration for a consistent development environment:

- Based on Node.js 20 LTS
- Pre-configured with ESLint, Prettier, and TypeScript support
- Automatically installs Rush and dependencies on container creation

To use:
1. Install the "Dev Containers" extension in VSCode
2. Open the repository in VSCode
3. Click "Reopen in Container" when prompted

### Local Development

If not using dev containers:

1. Ensure Node.js 20.x or 22.x is installed
2. Install Rush globally: `npm install -g @microsoft/rush`
3. Run `rush update` to install dependencies
4. Start developing!

## Package Manager

This monorepo uses **pnpm** (version 9.15.9) as the package manager, managed by Rush. You don't need to install pnpm separately - Rush will handle it automatically.

## Best Practices

1. **Keep packages focused**: Each package should have a single, well-defined purpose
2. **Use workspace protocol**: When depending on other monorepo packages, use `workspace:^` protocol
3. **Run rush update after pulling**: Always run `rush update` after pulling changes that might affect dependencies
4. **Test before committing**: Run `rush build` and `rush test` before pushing changes
5. **Follow the 2-level structure**: Always create packages exactly 2 levels deep under `/packages`

## Resources

- [Rush Documentation](https://rushjs.io/)
- [Rush Best Practices](https://rushjs.io/pages/best_practices/repo_setup/)
- [OpenFrontIO Repository](https://github.com/openfrontio/OpenFrontIO)
