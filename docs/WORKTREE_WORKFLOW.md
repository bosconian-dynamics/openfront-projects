# Git Worktree Workflow Guide

This document explains how to work with the OpenFrontIO git worktree in this repository.

## What is a Git Worktree?

A git worktree allows you to have multiple working trees attached to the same repository. In our case, `external/openfrontio` is a separate git repository (worktree) that is not tracked in the main monorepo, but can have local modifications that are never committed.

## OpenFrontIO Worktree

The OpenFrontIO project is integrated as a git worktree:

- **Repository**: https://github.com/bosconian-dynamics/OpenFrontIO
- **Upstream**: https://github.com/openfrontio/OpenFrontIO
- **Worktree Path**: `external/openfrontio`
- **Branch**: `main` (default)

This setup allows you to:
- Work on OpenFrontIO within the monorepo
- Make local-only modifications for Rush compatibility (never committed)
- Push changes to your fork
- Open PRs to upstream
- Pull updates from upstream
- Keep the monorepo clean (worktree not tracked in monorepo git)

## Initial Setup

### For New Developers

After cloning the monorepo, you need to set up the worktree:

**Linux/macOS:**
```bash
./scripts/setup-worktrees.sh
rush update
rush build
```

**Windows (PowerShell):**
```powershell
.\scripts\setup-worktrees.ps1
rush update
rush build
```

The setup script will:
1. Create the worktree at `external/openfrontio`
2. Clone the OpenFrontIO repository
3. Add local-only modifications to `package.json` (version and build script)
4. Mark `package.json` to ignore local changes

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

These modifications are marked as "assume-unchanged" so git ignores them.

### If You Need to Modify package.json for Upstream

If you need to make changes to `package.json` that should be committed to OpenFrontIO:

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

### Checking Ignored Files

To see if `package.json` is marked as assume-unchanged:

```bash
cd external/openfrontio
git ls-files -v | grep "^h.*package.json"
```

If you see output starting with `h`, the file is ignored.

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
