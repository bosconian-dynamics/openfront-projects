# Git Subtree Management Guide

This document explains how to manage the OpenFrontIO git subtree in this repository.

## What is a Git Subtree?

A git subtree allows you to include another repository as a subdirectory of your repository. Unlike submodules, subtrees are simpler to work with and don't require special commands for cloning or checking out.

## OpenFrontIO Subtree

The OpenFrontIO project is integrated as a git subtree within a wrapper package:

- **Fork (Primary)**: https://github.com/bosconian-dynamics/OpenFrontIO
- **Upstream**: https://github.com/openfrontio/OpenFrontIO
- **Fork Remote Name**: `openfrontio-fork`
- **Upstream Remote Name**: `openfrontio-upstream`
- **Branch**: `main`
- **Subtree Path**: `external/openfrontio/upstream`
- **Wrapper Package**: `external/openfrontio` (Rush-managed)

This setup allows you to:
- Work on OpenFrontIO within the monorepo
- Push changes to your fork
- Open PRs from your fork to upstream
- Pull updates from upstream
- Maintain branch naming parity between fork and subtree

### Wrapper Package Approach

The `external/openfrontio/` directory serves as a **wrapper package** that provides Rush integration:

```
external/openfrontio/
├── package.json          # Wrapper with version, private, and build scripts
└── upstream/             # Git subtree of OpenFrontIO (pristine upstream code)
    ├── src/
    ├── package.json      # Original upstream package.json (unmodified)
    └── ...
```

**Why a wrapper package?**
- **Simplified interoperability**: No need to modify upstream code to work with Rush
- **Clean separation**: Wrapper handles Rush-specific concerns (build scripts, versioning)
- **Pristine subtree**: The `upstream/` directory remains unmodified and clean for PRs
- **Flexibility**: Easy to add wrapper-level configurations without affecting upstream

The wrapper's `package.json` provides:
- `version: "0.0.0-external"` and `private: true` for Rush compatibility
- A `build` script that delegates to upstream's `build-prod`
- Pass-through scripts for other upstream commands

## Initial Setup

The subtree and remotes have already been set up, but if you need to reconfigure them:

### Add the Remotes

```bash
# Add your fork as the primary remote
git remote add -f openfrontio-fork https://github.com/bosconian-dynamics/OpenFrontIO

# Add the upstream as a secondary remote
git remote add -f openfrontio-upstream https://github.com/openfrontio/OpenFrontIO
```

### Add the Subtree

```bash
git subtree add --prefix=external/openfrontio/upstream openfrontio-fork main --squash
```

The `--squash` flag combines all commits into a single commit in your repository.

## Regular Operations

### Using PowerShell Scripts (Recommended)

The repository includes simplified PowerShell scripts that automate subtree management.

**Pull updates from upstream:**
```powershell
./common/scripts/openfrontio-pull.ps1
# Or via Rush command:
rush sync-subtree
```

This script will pull updates from `openfrontio-upstream` into `external/openfrontio/upstream`.

Use this when:
- Pulling new work from upstream
- Switching branches
- Syncing with upstream changes

**Push changes to your fork:**
```powershell
./common/scripts/openfrontio-push.ps1
```

This script pushes the subtree at `external/openfrontio/upstream` to your fork. The upstream code remains pristine - no modifications needed.

Use this when:
- Pushing your changes to create a PR to upstream
- Pushing feature branches to your fork

### Manual Operations

### Pulling Updates from Upstream

To get the latest changes from the upstream OpenFrontIO repository:

```bash
git subtree pull --prefix=external/openfrontio/upstream openfrontio-upstream main --squash
```

This will:
1. Fetch changes from the upstream repository
2. Merge them into your repository
3. Create a merge commit

**Best Practice**: Pull updates regularly to stay in sync with upstream.

### Pushing Changes to Your Fork

To push changes from `external/openfrontio/upstream` to your fork:

```bash
git subtree push --prefix=external/openfrontio/upstream openfrontio-fork main
```

This will:
1. Extract commits that touch `external/openfrontio/upstream`
2. Push them to your fork

You can then open a PR from your fork to the upstream repository on GitHub.

### Working with Branches

The fork-based workflow allows branch naming parity between your fork and the monorepo subtree:

```bash
# Push a feature branch to your fork
git subtree push --prefix=external/openfrontio/upstream openfrontio-fork feature-branch

# Pull a specific branch from your fork
git subtree pull --prefix=external/openfrontio/upstream openfrontio-fork feature-branch --squash

# Pull a specific branch from upstream
git subtree pull --prefix=external/openfrontio/upstream openfrontio-upstream feature-branch --squash
```

## Development Workflow

### Making Changes in the Subtree

1. **Normal Development**: Just edit files in `external/openfrontio/upstream` as you would any other files
   ```bash
   cd external/openfrontio/upstream
   # Make your changes
   git add .
   git commit -m "Your change description"
   ```

2. **Regular Commits**: Commit changes to your monorepo as normal
   - Changes will be tracked in your repository's history
   - The subtree relationship is maintained automatically

3. **Sync with Upstream**: Periodically pull updates
   ```bash
   rush sync-subtree
   # Or manually:
   git subtree pull --prefix=external/openfrontio/upstream openfrontio-upstream main --squash
   ```

4. **Contribute Back**: When ready to contribute to upstream
   ```bash
   # Push to your fork
   ./common/scripts/openfrontio-push.ps1
   # Or manually:
   git subtree push --prefix=external/openfrontio/upstream openfrontio-fork main
   
   # Then create a PR on GitHub from your fork to the upstream repository
   ```

### Handling Conflicts

If you encounter merge conflicts when pulling from upstream:

1. Git will pause and show you the conflicts
2. Resolve conflicts in the `external/openfrontio/upstream` files
3. Stage the resolved files: `git add external/openfrontio/upstream`
4. Continue the merge: `git commit`

## Advantages of Fork-Based Subtree with Wrapper

1. **Simple Cloning**: No special commands needed, just `git clone`
2. **No Extra Files**: No `.gitmodules` or submodule complexity
3. **Offline Work**: All code is in your repository
4. **Easy to Understand**: Works like regular git operations
5. **Flexible Workflow**: Can work on upstream code within your monorepo
6. **Branch Parity**: Maintain consistent branch names between fork and subtree
7. **PR Workflow**: Easy to open PRs against upstream via your fork
8. **Clean Separation**: Wrapper handles Rush integration without modifying upstream code
9. **Rush Integration**: Full dependency management and build orchestration

## Disadvantages and Considerations

1. **History Complexity**: Subtree operations create merge commits
2. **Repository Size**: Includes full history of subtree (mitigated with `--squash`)
3. **Push Complexity**: Pushing requires extracting relevant commits
4. **Learning Curve**: Less familiar than submodules for some teams
5. **Extra Directory Level**: Wrapper adds one level of nesting

## Troubleshooting

### Remote Not Found

If you get an error about the remote not existing:

```bash
# Add your fork
git remote add -f openfrontio-fork https://github.com/bosconian-dynamics/OpenFrontIO

# Add upstream
git remote add -f openfrontio-upstream https://github.com/openfrontio/OpenFrontIO
```

### Push Rejected

If push is rejected (no write access to your fork):

1. Verify you're pushing to your fork: `git remote -v`
2. Check you have write permissions to your fork
3. Ensure you're authenticated with GitHub

### Stale References

If you're having issues with stale references:

```bash
# Fetch from fork
git fetch openfrontio-fork

# Fetch from upstream
git fetch openfrontio-upstream

# Then pull as needed
git subtree pull --prefix=external/openfrontio/upstream openfrontio-upstream main --squash
```

## Advanced Operations

### Splitting Out Commits

To see commits that only affect the subtree:

```bash
git log -- external/openfrontio/upstream
```

### Checking Subtree Status

To verify the subtree is set up correctly:

```bash
# Check remotes
git remote -v | grep openfront

# Check subtree history
git log --grep="git-subtree-dir: external/openfrontio/upstream"
```

### Removing a Subtree

If you need to remove the subtree (careful!):

```bash
git rm -r external/openfrontio/upstream
git commit -m "Remove OpenFrontIO subtree"
```

## References

- [Git Subtree Documentation](https://git-scm.com/book/en/v2/Git-Tools-Advanced-Merging#_subtree_merge)
- [Atlassian Subtree Guide](https://www.atlassian.com/git/tutorials/git-subtree)
- [GitHub Subtree Tutorial](https://docs.github.com/en/get-started/using-git/about-git-subtree-merges)
