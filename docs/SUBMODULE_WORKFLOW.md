# Git Submodule Workflow Guide

This document explains how to work with the OpenFrontIO git submodule in this repository.

## What is a Git Submodule?

A git submodule allows you to include one repository inside another repository at a specific commit. In our case, `external/openfrontio` is the OpenFrontIO repository embedded as a submodule, allowing us to pin specific versions and track dependencies.

## OpenFrontIO Submodule

The OpenFrontIO project is integrated as a git submodule:

- **Repository**: https://github.com/bosconian-dynamics/OpenFrontIO
- **Upstream**: https://github.com/openfrontio/OpenFrontIO  
- **Submodule Path**: `external/openfrontio`
- **Default Branch**: `main`

This setup allows you to:
- Pin specific versions of OpenFrontIO in the monorepo
- Work on OpenFrontIO within the monorepo context
- Make local-only modifications for Rush compatibility
- Push changes to your fork
- Open PRs to upstream
- Pull updates from upstream
- Track which version of OpenFrontIO each monorepo commit uses

## Initial Setup

### For New Developers

After cloning the monorepo, you need to initialize the submodules:

**Clone with submodules:**
```bash
git clone --recurse-submodules https://github.com/bosconian-dynamics/openfront-projects.git
cd openfront-projects
rush update
rush build
```

**Or initialize submodules after cloning:**
```bash
git clone https://github.com/bosconian-dynamics/openfront-projects.git
cd openfront-projects
./scripts/setup-submodules.sh  # Linux/macOS
# or
.\scripts\setup-submodules.ps1  # Windows (PowerShell)
rush update
rush build
```

The setup script will:
1. Initialize and update all submodules
2. Configure Rush compatibility for OpenFrontIO
3. Add local-only modifications to `package.json` (version and build script)
4. Mark `package.json` to ignore local changes

## Daily Workflow

### Working on OpenFrontIO

```bash
# Navigate to the submodule
cd external/openfrontio

# Create a feature branch
git checkout -b feature/my-feature

# Make your changes
# ... edit files ...

# Build and test
rushx build
rushx test
rushx lint

# Commit your changes
git add .
git commit -m "Add my feature"

# Push to your fork
git push origin feature/my-feature

# Go back to monorepo root
cd ../..
```

### Updating OpenFrontIO Version

**Update to latest version:**
```bash
cd external/openfrontio
git checkout main
git pull origin main
cd ../..

# Pin the new version in the monorepo
git add external/openfrontio
git commit -m "Update OpenFrontIO to latest version"
```

**Update to specific version/tag:**
```bash
cd external/openfrontio
git checkout v1.2.3  # or specific commit hash
cd ../..

# Pin the specific version
git add external/openfrontio
git commit -m "Update OpenFrontIO to v1.2.3"
```

**Pull updates from upstream:**
```bash
cd external/openfrontio
git remote add upstream https://github.com/openfrontio/OpenFrontIO.git  # first time only
git fetch upstream
git merge upstream/main  # or rebase
git push origin main  # push to your fork
cd ../..

# Pin the updated version
git add external/openfrontio
git commit -m "Update OpenFrontIO with upstream changes"
```

## Rush Compatibility

OpenFrontIO requires local modifications to work with Rush. These are managed by the toggle scripts:

**Enable Rush compatibility:**
```bash
./scripts/toggle-rush-compat.sh on external/openfrontio
```

**Disable Rush compatibility (for upstream contributions):**
```bash
./scripts/toggle-rush-compat.sh off external/openfrontio
```

**Auto-toggle (detects current state):**
```bash
./scripts/toggle-rush-compat.sh auto external/openfrontio
```

## Contributing to OpenFrontIO Upstream

When contributing changes back to the original OpenFrontIO repository:

1. **Disable Rush compatibility:**
   ```bash
   ./scripts/toggle-rush-compat.sh off external/openfrontio
   ```

2. **Make your changes and commit:**
   ```bash
   cd external/openfrontio
   git checkout -b feature/upstream-contribution
   # ... make changes ...
   git add .
   git commit -m "Your contribution"
   ```

3. **Push to your fork:**
   ```bash
   git push origin feature/upstream-contribution
   ```

4. **Create PR on GitHub** to `openfrontio/OpenFrontIO`

5. **Re-enable Rush compatibility:**
   ```bash
   cd ../..
   ./scripts/toggle-rush-compat.sh on external/openfrontio
   ```

## Common Tasks

### Check submodule status
```bash
git submodule status
```

### Update all submodules
```bash
git submodule update --remote
```

### Reset submodule to committed version
```bash
git submodule update --init --recursive
```

### See which version is currently pinned
```bash
cd external/openfrontio
git log --oneline -1
cd ../..
```

### View submodule changes since last commit
```bash
git diff external/openfrontio
```

## Troubleshooting

### Submodule appears dirty after setup
This is normal - the local Rush modifications make the submodule appear "dirty":
```bash
cd external/openfrontio
git status  # Will show modified package.json
cd ../..
```
The `package.json` changes are ignored and won't be committed.

### Submodule not initialized
```bash
git submodule update --init --recursive
```

### Submodule pointing to wrong commit
```bash
git submodule update  # Reset to committed version
# or
cd external/openfrontio
git checkout main     # Switch to main branch
cd ../..
git add external/openfrontio  # Pin new version
git commit -m "Update submodule version"
```

### Cannot push because of dirty submodule
Make sure Rush compatibility is properly configured:
```bash
./scripts/toggle-rush-compat.sh on external/openfrontio
```

## Best Practices

1. **Always commit submodule updates** - When updating OpenFrontIO, commit the change to track the version
2. **Use descriptive commit messages** - Include version numbers or key changes
3. **Test after updates** - Run `rush build` and `rush test` after updating the submodule
4. **Keep Rush compatibility on** - Only disable it temporarily for upstream contributions
5. **Pin stable versions** - Prefer tagged releases over commit hashes when possible

## Migration from Worktrees

If you're migrating from the old worktree setup:

1. **Remove old worktree:**
   ```bash
   git worktree remove external/openfrontio --force
   ```

2. **Setup new submodule:**
   ```bash
   ./scripts/setup-submodules.sh
   ```

3. **Update your workflow** - Use submodule commands instead of worktree commands

## Daily Operations

### Building and Running

Once the worktree is set up, Rush commands work normally:

```bash
# Build all packages
rush build

# Build only OpenFrontIO
rush build --to openfront-client

# Rebuild everything
rush rebuild

# Run dev server (from external/openfrontio)
cd external/openfrontio
rushx dev
```

### Updating from Upstream

To pull the latest changes from the OpenFrontIO repository:

```bash
cd external/openfrontio
git pull
```

This updates your local worktree with changes from the repository.

### Making Changes

To make changes to OpenFrontIO:

1. Navigate to the worktree directory:
   ```bash
   cd external/openfrontio
   ```

2. Make your changes to the source files

3. Commit your changes:
   ```bash
   git add src/
   git commit -m "Your change description"
   ```

4. Push to your fork:
   ```bash
   git push origin main
   # Or to a feature branch:
   git push origin feature-branch
   ```

5. Open a PR on GitHub from your fork to the upstream repository

### Working with Branches

```bash
cd external/openfrontio

# Create a new feature branch
git checkout -b feature-my-feature

# Make changes and commit
git add .
git commit -m "Add new feature"

# Push to your fork
git push origin feature-my-feature

# Switch back to main
git checkout main

# Pull latest from main
git pull origin main
```

## Managing package.json

The `package.json` file in the worktree has local-only modifications that are required for Rush integration but should never be committed to OpenFrontIO:

- `version: "0.0.0-external"` - Rush requires a version field
- `scripts.build: "npm run build-prod"` - Rush expects a standard build script

These modifications are automatically managed and marked as "assume-unchanged" so git ignores them.

### Adding Dependencies for Upstream Contributions

The most common scenario is adding a new dependency that should be committed to OpenFrontIO. The **auto-toggle** feature makes this simple:

#### Simple Auto-Toggle Workflow (Recommended)

```bash
# 1. Toggle to opposite mode (auto-detects current state)
rush toggle-compat

# 2. Add your dependency
npm install some-new-package

# 3. Commit the change
git add package.json package-lock.json
git commit -m "Add some-new-package dependency"
git push origin main  # or your feature branch

# 4. Toggle back (auto-detects and switches back)
rush toggle-compat
```

#### Explicit Mode Control

If you prefer explicit control or need to force a specific state:

```bash
# 1. Disable Rush compatibility (enables git tracking)
rush toggle-compat --mode off

# 2. Add your dependency
npm install some-new-package

# 3. Commit the change
git add package.json package-lock.json
git commit -m "Add some-new-package dependency"
git push origin main  # or your feature branch

# 4. Re-enable Rush compatibility
rush toggle-compat --mode on
```

#### Using Scripts Directly

```bash
cd external/openfrontio

# 1. Auto-toggle (detects current state and switches to opposite)
../scripts/toggle-rush-compat.sh

# 2. Make your changes
npm install some-new-package
git add package.json package-lock.json
git commit -m "Add dependency"

# 3. Auto-toggle back
../scripts/toggle-rush-compat.sh
```

**Explicit mode control with scripts:**
```bash
# Bash (Linux/macOS)
./scripts/toggle-rush-compat.sh off    # Force disable Rush compatibility
./scripts/toggle-rush-compat.sh on     # Force enable Rush compatibility
./scripts/toggle-rush-compat.sh auto   # Auto-detect and toggle (default)

# PowerShell (Windows)
.\scripts\toggle-rush-compat.ps1 -Mode off
.\scripts\toggle-rush-compat.ps1 -Mode on
.\scripts\toggle-rush-compat.ps1 -Mode auto  # Default if -Mode omitted
```

### Manual Process (Not Recommended)

If you need to manage this manually for some reason:

1. **Un-ignore the file:**
   ```bash
   cd external/openfrontio
   git update-index --no-assume-unchanged package.json
   ```

2. **Revert local changes:**
   ```bash
   git checkout package.json
   ```
   This removes the local-only modifications (version and build script).

3. **Make your upstream changes:**
   Edit `package.json` with your changes (e.g., adding a dependency).

4. **Commit and push:**
   ```bash
   git add package.json
   git commit -m "Add new dependency"
   git push origin main
   ```

5. **Re-add local modifications:**
   After pushing, re-add the Rush-required fields:
   ```bash
   npm pkg set version="0.0.0-external"
   npm pkg set scripts.build="npm run build-prod"
   ```

6. **Re-ignore the file:**
   ```bash
   git update-index --assume-unchanged package.json
   ```

### Available Toggle Scripts

The repository includes cross-platform scripts for managing Rush compatibility:

- **`scripts/toggle-rush-compat.sh`** - Bash script (Linux/macOS)
- **`scripts/toggle-rush-compat.ps1`** - PowerShell script (Windows)

**Script Usage:**
```bash
# Auto-toggle (detect current state and switch to opposite) - RECOMMENDED
./scripts/toggle-rush-compat.sh
./scripts/toggle-rush-compat.sh auto

# Explicit mode control
./scripts/toggle-rush-compat.sh [on|off] [optional-worktree-path]

# PowerShell (Windows)
.\scripts\toggle-rush-compat.ps1                    # Auto-toggle (default)
.\scripts\toggle-rush-compat.ps1 -Mode [on|off|auto] [-WorktreePath path]

# Via Rush (any platform) - RECOMMENDED
rush toggle-compat                    # Auto-toggle (default)
rush toggle-compat --mode [on|off|auto]
```

**How Auto-Detection Works:**
The scripts detect the current mode by checking if `package.json` contains `"version": "0.0.0-external"`. If present, Rush compatibility is ON and will be toggled OFF. If absent, it's OFF and will be toggled ON.

2. **Revert local changes:**
   ```bash
   git checkout package.json
   ```
   This removes the local-only modifications (version and build script).

3. **Make your upstream changes:**
   Edit `package.json` with your changes (e.g., adding a dependency).

4. **Commit and push:**
   ```bash
   git add package.json
   git commit -m "Add new dependency"
   git push origin main
   ```

5. **Re-add local modifications:**
   After pushing, re-add the Rush-required fields:
   ```bash
   npm pkg set version="0.0.0-external"
   npm pkg set scripts.build="npm run build-prod"
   ```

6. **Re-ignore the file:**
   ```bash
   git update-index --assume-unchanged package.json
   ```

### Checking Ignored Files

To see if `package.json` is marked as assume-unchanged:

```bash
cd external/openfrontio
git ls-files -v | grep "^h.*package.json"
```

If you see output starting with `h`, the file is ignored.

### Untracked Rush Build Artifacts

When you run `git status` in the worktree, you may see untracked directories:
- `.rush/` - Rush build cache and temporary files
- `rush-logs/` - Rush build logs

**These are expected and safe to ignore.** Here's why:

1. **Never Committed**: These files only appear when Rush compatibility is ON (when `package.json` changes are ignored)
2. **Upstream Safe**: When you toggle to OFF mode for upstream contributions, Rush recreates these as needed  
3. **Standard Rush**: Every Rush project has these files, they're just not typically in git worktrees

**Note**: These files cannot be added to `.gitignore` in the worktree because modifying upstream files would break compatibility. The toggle workflow ensures they never accidentally get committed.

## Troubleshooting

### Worktree Directory Missing

If `external/openfrontio` doesn't exist, run the setup script:

```bash
./scripts/setup-worktrees.sh    # Linux/macOS
.\scripts\setup-worktrees.ps1   # Windows
```

### Rush Can't Find the Package

If Rush reports that it can't find `openfront-client`:

1. Ensure the worktree is set up: `ls external/openfrontio`
2. Check that `package.json` exists in the worktree
3. Run `rush update` to refresh Rush's cache

### Git Push Rejected

If push is rejected:

1. Verify you have write access to your fork
2. Ensure you're pushing to the correct remote: `git remote -v`
3. Check you're authenticated with GitHub

### Local Modifications Showing Up

If `git status` shows modifications to `package.json`:

1. Check if the file is properly ignored:
   ```bash
   git ls-files -v | grep package.json
   ```

2. If not ignored, re-apply:
   ```bash
   git update-index --assume-unchanged package.json
   ```

### Cannot Build After Pull

If you can't build after pulling updates:

1. Run `rush update` to install any new dependencies
2. Run `rush rebuild` to do a clean build
3. Check if there are any breaking changes in the OpenFrontIO release notes

## Advantages of Git Worktree Approach

1. **Clean Separation**: Worktree is not tracked in monorepo history
2. **No History Pollution**: Local modifications never appear in git log
3. **Simple Sync**: Standard `git pull` to update from upstream
4. **Easy PR Workflow**: Direct push to fork, then PR to upstream
5. **No Subtree Complexity**: Avoids complex subtree merge commands
6. **Independent Repository**: Full git functionality within the worktree
7. **Rush Integration**: Full dependency management and build orchestration

## Key Differences from Subtree

| Aspect | Subtree (Old) | Worktree (New) |
|--------|---------------|----------------|
| Tracked in monorepo | ✅ Yes | ❌ No (gitignored) |
| Local modifications | Committed to history | Never committed |
| Update command | `git subtree pull` | `git pull` |
| Push command | `git subtree push` | `git push` |
| History complexity | High (merge commits) | Low (separate repo) |
| Setup complexity | Low (already there) | Medium (setup script) |
| Developer experience | Complex | Simple |

## References

- [Git Worktree Documentation](https://git-scm.com/docs/git-worktree)
- [Git Update-Index Documentation](https://git-scm.com/docs/git-update-index)
- [OpenFrontIO Repository](https://github.com/openfrontio/OpenFrontIO)
- [Rush Documentation](https://rushjs.io/)
