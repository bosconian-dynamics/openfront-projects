# Git Subtree Management Guide

This document explains how to manage the OpenFrontIO git subtree in this repository.

## What is a Git Subtree?

A git subtree allows you to include another repository as a subdirectory of your repository. Unlike submodules, subtrees are simpler to work with and don't require special commands for cloning or checking out.

## OpenFrontIO Subtree

The `packages/OpenFrontIO` directory is a git subtree of the upstream OpenFrontIO repository:

- **Upstream Repository**: https://github.com/openfrontio/OpenFrontIO
- **Remote Name**: `openfrontio`
- **Branch**: `main`
- **Local Path**: `packages/OpenFrontIO`

## Initial Setup

The subtree has already been set up, but if you need to add it again or add additional subtrees, here's how:

### Add the Remote

```bash
git remote add -f openfrontio https://github.com/openfrontio/OpenFrontIO
```

### Add the Subtree

```bash
git subtree add --prefix=packages/OpenFrontIO openfrontio main --squash
```

The `--squash` flag combines all upstream commits into a single commit in your repository.

## Regular Operations

### Pulling Updates from Upstream

To get the latest changes from the upstream OpenFrontIO repository:

```bash
git subtree pull --prefix=packages/OpenFrontIO openfrontio main --squash
```

This will:
1. Fetch changes from the upstream repository
2. Merge them into your repository
3. Create a merge commit

**Best Practice**: Pull updates regularly to stay in sync with upstream.

### Pushing Changes to Upstream

If you've made changes in `packages/OpenFrontIO` that should be contributed back to the upstream repository:

```bash
git subtree push --prefix=packages/OpenFrontIO openfrontio main
```

This will:
1. Extract commits that touch `packages/OpenFrontIO`
2. Push them to the upstream repository

**Note**: You need write access to the upstream repository for this to work. If you don't have access, you can:
1. Fork the upstream repository
2. Push to your fork
3. Create a pull request to the upstream repository

### Working with a Fork

If you've forked the upstream repository to contribute:

```bash
# Add your fork as a remote
git remote add openfrontio-fork https://github.com/YOUR_USERNAME/OpenFrontIO

# Push to your fork
git subtree push --prefix=packages/OpenFrontIO openfrontio-fork main

# Then create a PR on GitHub from your fork to the upstream repository
```

## Development Workflow

### Making Changes in the Subtree

1. **Normal Development**: Just edit files in `packages/OpenFrontIO` as you would any other files
   ```bash
   cd packages/OpenFrontIO
   # Make your changes
   git add .
   git commit -m "Your change description"
   ```

2. **Regular Commits**: Commit changes to your monorepo as normal
   - Changes will be tracked in your repository's history
   - The subtree relationship is maintained automatically

3. **Sync with Upstream**: Periodically pull updates
   ```bash
   git subtree pull --prefix=packages/OpenFrontIO openfrontio main --squash
   ```

4. **Contribute Back**: When ready to contribute to upstream
   ```bash
   git subtree push --prefix=packages/OpenFrontIO openfrontio main
   # Or push to your fork and create a PR
   ```

### Handling Conflicts

If you encounter merge conflicts when pulling from upstream:

1. Git will pause and show you the conflicts
2. Resolve conflicts in the `packages/OpenFrontIO` files
3. Stage the resolved files: `git add packages/OpenFrontIO`
4. Continue the merge: `git commit`

## Advantages of Subtrees

1. **Simple Cloning**: No special commands needed, just `git clone`
2. **No Extra Files**: No `.gitmodules` or submodule complexity
3. **Offline Work**: All code is in your repository
4. **Easy to Understand**: Works like regular git operations
5. **Flexible Workflow**: Can work on upstream code within your monorepo

## Disadvantages and Considerations

1. **History Complexity**: Subtree operations create merge commits
2. **Repository Size**: Includes full history of subtree (mitigated with `--squash`)
3. **Push Complexity**: Pushing to upstream requires extracting relevant commits
4. **Learning Curve**: Less familiar than submodules for some teams

## Troubleshooting

### Remote Not Found

If you get an error about the remote not existing:

```bash
git remote add -f openfrontio https://github.com/openfrontio/OpenFrontIO
```

### Push Rejected

If push is rejected (no write access):

1. Fork the upstream repository on GitHub
2. Add your fork as a remote
3. Push to your fork
4. Create a PR from your fork

### Stale References

If you're having issues with stale references:

```bash
git fetch openfrontio
git subtree pull --prefix=packages/OpenFrontIO openfrontio main --squash
```

## Advanced Operations

### Splitting Out Commits

To see commits that only affect the subtree:

```bash
git log -- packages/OpenFrontIO
```

### Checking Subtree Status

To verify the subtree is set up correctly:

```bash
git remote -v | grep openfrontio
git log --grep="git-subtree-dir: packages/OpenFrontIO"
```

### Removing a Subtree

If you need to remove the subtree (careful!):

```bash
git rm -r packages/OpenFrontIO
git commit -m "Remove OpenFrontIO subtree"
```

## References

- [Git Subtree Documentation](https://git-scm.com/book/en/v2/Git-Tools-Advanced-Merging#_subtree_merge)
- [Atlassian Subtree Guide](https://www.atlassian.com/git/tutorials/git-subtree)
- [GitHub Subtree Tutorial](https://docs.github.com/en/get-started/using-git/about-git-subtree-merges)
