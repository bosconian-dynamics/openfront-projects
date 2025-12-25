# Git Subtree Management Guide

This document explains how to manage the OpenFrontIO git subtree in this repository.

## What is a Git Subtree?

A git subtree allows you to include another repository as a subdirectory of your repository. Unlike submodules, subtrees are simpler to work with and don't require special commands for cloning or checking out.

## OpenFrontIO Subtree

The `external/OpenFrontIO` directory is a git subtree of the OpenFrontIO repository:

- **Fork (Primary)**: https://github.com/bosconian-dynamics/OpenFrontIO
- **Upstream**: https://github.com/openfrontio/OpenFrontIO
- **Fork Remote Name**: `openfrontio-fork`
- **Upstream Remote Name**: `openfrontio-upstream`
- **Branch**: `main`
- **Local Path**: `external/OpenFrontIO`

This setup allows you to:
- Work on OpenFrontIO within the monorepo
- Push changes to your fork
- Open PRs from your fork to upstream
- Pull updates from upstream
- Maintain branch naming parity between fork and subtree

### Rush Integration

OpenFrontIO is registered in `rush.json` as an external package. To maintain interoperability:

- **In the monorepo**: package.json includes `version: "0.0.0-external"` and `private: true` for Rush compatibility
- **When pushing upstream**: These fields are temporarily removed to preserve the pristine upstream state
- **Automated scripts**: Handle adding/removing these fields automatically

This approach allows Rush to manage the package while keeping the subtree clean for upstream contributions.

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
git subtree add --prefix=external/OpenFrontIO openfrontio-fork main --squash
```

The `--squash` flag combines all commits into a single commit in your repository.

## Regular Operations

### Using PowerShell Scripts (Recommended)

The repository includes PowerShell scripts that automate subtree management and handle Rush compatibility by managing the `version` and `private` fields in package.json.

**Important**: The `version: "0.0.0-external"` and `private: true` fields in `external/OpenFrontIO/package.json` are **monorepo-only** modifications. They exist to make Rush work with the external package but should NOT be pushed to your fork (and thus not included in PRs to upstream).

**Pull updates from upstream:**
```powershell
./common/scripts/openfrontio-pull.ps1
```

This script will:
1. Pull updates from `openfrontio-upstream`
2. Automatically add `version: "0.0.0-external"` and `private: true` to package.json
3. Stage the changes for you to commit

Use this when:
- Pulling new work from upstream
- Switching branches
- Syncing with upstream changes

**Push changes to your fork:**
```powershell
./common/scripts/openfrontio-push.ps1
```

This script will:
1. Temporarily remove `version` and `private` fields from package.json
2. Commit the removal
3. Push to `openfrontio-fork` (with clean package.json)
4. Restore the `version` and `private` fields
5. Commit the restoration

Use this when:
- Pushing your changes to create a PR to upstream
- Pushing feature branches to your fork

This ensures the monorepo-specific fields never make it into your fork or upstream PRs.

### Manual Operations

### Pulling Updates from Upstream

To get the latest changes from the upstream OpenFrontIO repository:

```bash
git subtree pull --prefix=external/OpenFrontIO openfrontio-upstream main --squash
```

This will:
1. Fetch changes from the upstream repository
2. Merge them into your repository
3. Create a merge commit

**Best Practice**: Pull updates regularly to stay in sync with upstream.

### Pushing Changes to Your Fork

To push changes from `external/OpenFrontIO` to your fork:

```bash
git subtree push --prefix=external/OpenFrontIO openfrontio-fork main
```

This will:
1. Extract commits that touch `external/OpenFrontIO`
2. Push them to your fork

You can then open a PR from your fork to the upstream repository on GitHub.

### Working with Branches

The fork-based workflow allows branch naming parity between your fork and the monorepo subtree:

```bash
# Push a feature branch to your fork
git subtree push --prefix=external/OpenFrontIO openfrontio-fork feature-branch

# Pull a specific branch from your fork
git subtree pull --prefix=external/OpenFrontIO openfrontio-fork feature-branch --squash

# Pull a specific branch from upstream
git subtree pull --prefix=external/OpenFrontIO openfrontio-upstream feature-branch --squash
```

## Development Workflow

### Making Changes in the Subtree

1. **Normal Development**: Just edit files in `external/OpenFrontIO` as you would any other files
   ```bash
   cd external/OpenFrontIO
   # Make your changes
   git add .
   git commit -m "Your change description"
   ```

2. **Regular Commits**: Commit changes to your monorepo as normal
   - Changes will be tracked in your repository's history
   - The subtree relationship is maintained automatically

3. **Sync with Upstream**: Periodically pull updates
   ```bash
   git subtree pull --prefix=external/OpenFrontIO openfrontio-upstream main --squash
   ```

4. **Contribute Back**: When ready to contribute to upstream
   ```bash
   # Push to your fork
   git subtree push --prefix=external/OpenFrontIO openfrontio-fork main
   
   # Then create a PR on GitHub from your fork to the upstream repository
   ```

### Handling Conflicts

If you encounter merge conflicts when pulling from upstream:

1. Git will pause and show you the conflicts
2. Resolve conflicts in the `external/OpenFrontIO` files
3. Stage the resolved files: `git add external/OpenFrontIO`
4. Continue the merge: `git commit`

## Advantages of Fork-Based Subtree Workflow

1. **Simple Cloning**: No special commands needed, just `git clone`
2. **No Extra Files**: No `.gitmodules` or submodule complexity
3. **Offline Work**: All code is in your repository
4. **Easy to Understand**: Works like regular git operations
5. **Flexible Workflow**: Can work on upstream code within your monorepo
6. **Branch Parity**: Maintain consistent branch names between fork and subtree
7. **PR Workflow**: Easy to open PRs against upstream via your fork

## Disadvantages and Considerations

1. **History Complexity**: Subtree operations create merge commits
2. **Repository Size**: Includes full history of subtree (mitigated with `--squash`)
3. **Push Complexity**: Pushing requires extracting relevant commits
4. **Learning Curve**: Less familiar than submodules for some teams

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
git subtree pull --prefix=external/OpenFrontIO openfrontio-upstream main --squash
```

## Advanced Operations

### Splitting Out Commits

To see commits that only affect the subtree:

```bash
git log -- external/OpenFrontIO
```

### Checking Subtree Status

To verify the subtree is set up correctly:

```bash
# Check remotes
git remote -v | grep openfront

# Check subtree history
git log --grep="git-subtree-dir: external/OpenFrontIO"
```

### Removing a Subtree

If you need to remove the subtree (careful!):

```bash
git rm -r external/OpenFrontIO
git commit -m "Remove OpenFrontIO subtree"
```

## References

- [Git Subtree Documentation](https://git-scm.com/book/en/v2/Git-Tools-Advanced-Merging#_subtree_merge)
- [Atlassian Subtree Guide](https://www.atlassian.com/git/tutorials/git-subtree)
- [GitHub Subtree Tutorial](https://docs.github.com/en/get-started/using-git/about-git-subtree-merges)
