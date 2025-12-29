# Monorepo Scripts

This directory contains PowerShell scripts and modules for managing the monorepo.

## Worktree Setup Scripts

The repository includes setup scripts for initializing git worktrees for external dependencies.

### setup-worktrees.sh (Linux/macOS)

Sets up git worktrees for external packages like OpenFrontIO.

```bash
./scripts/setup-worktrees.sh
```

**What it does:**
1. Adds the openfrontio remote if not already present
2. Fetches from the remote
3. Creates a worktree at `external/openfrontio` tracking the main branch
4. Adds Rush-required fields to package.json (version, build script)
5. Marks package.json as assume-unchanged (local-only changes)

### setup-worktrees.ps1 (Windows)

Windows PowerShell version of the worktree setup script.

```powershell
.\scripts\setup-worktrees.ps1
```

Same functionality as the bash version, optimized for PowerShell.

## OpenFrontIO Worktree Management

With git worktrees, OpenFrontIO is a separate git repository at `external/openfrontio`.

### Pull Updates
```bash
cd external/openfrontio
git pull
```

### Push Changes
```bash
cd external/openfrontio
git add .
git commit -m "Your changes"
git push origin main
```

### Why Local-Only Modifications?

Rush requires a `version` field and standard `build` script in package.json. The worktree setup adds these locally:
- `version: "0.0.0-external"`
- `scripts.build: "npm run build-prod"`

These modifications are marked as assume-unchanged with `git update-index --assume-unchanged package.json`, so they never appear in git status and are never committed to OpenFrontIO.

See `docs/WORKTREE_WORKFLOW.md` for detailed information.
