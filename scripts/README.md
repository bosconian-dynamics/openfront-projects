# Monorepo Scripts

This directory contains PowerShell scripts and modules for managing the monorepo.

## SubtreeManagement Module

The `modules/SubtreeManagement.psm1` module provides generic functions for working with git subtrees in this monorepo.

### Functions

- **Invoke-SubtreePull**: Pull updates from a subtree remote
- **Invoke-SubtreePush**: Push subtree changes to a remote
- **Add-PackageVersion**: Add version and private fields to package.json for Rush
- **Remove-PackageVersion**: Remove version and private fields from package.json

## OpenFrontIO Scripts

### openfrontio-pull.ps1

Pulls updates from the upstream OpenFrontIO repository and adds Rush-compatible fields.

```powershell
./scripts/openfrontio-pull.ps1
```

**What it does:**
1. Pulls from `openfrontio-upstream/main`
2. Adds `version: "0.0.0-external"` and `private: true` to package.json
3. Stages the changes

**When to use:**
- After pulling changes from upstream
- When switching to a new branch
- When syncing with upstream

### openfrontio-push.ps1

Pushes changes to your fork while keeping the package.json clean for PRs.

```powershell
./scripts/openfrontio-push.ps1
```

**What it does:**
1. Removes `version` and `private` fields from package.json
2. Commits and pushes to `openfrontio-fork/main`
3. Restores the fields for local Rush compatibility
4. Commits the restoration

**When to use:**
- Before creating a PR from your fork to upstream
- When pushing feature branches to your fork

## Why the version/private Management?

Rush requires a `version` field in package.json to manage packages. However, the upstream OpenFrontIO repository doesn't have this field, and we don't want to include it in PRs to upstream.

The solution:
- **In monorepo**: package.json has `version: "0.0.0-external"` and `private: true`
- **In fork/PRs**: These fields are removed

The scripts automate this to prevent accidentally including monorepo-specific modifications in upstream contributions.

## Creating New Subtree Scripts

To add scripts for another external package, follow this pattern:

1. Create pull script:
   ```powershell
   Import-Module "$PSScriptRoot/modules/SubtreeManagement.psm1" -Force
   
   $SubtreePath = "external/PackageName"
   $PackageJsonPath = "$SubtreePath/package.json"
   
   Invoke-SubtreePull -Prefix $SubtreePath -Remote "remote-name" -Branch "main"
   Add-PackageVersion -PackageJsonPath $PackageJsonPath -Version "0.0.0-external"
   git add $PackageJsonPath
   ```

2. Create push script:
   ```powershell
   Import-Module "$PSScriptRoot/modules/SubtreeManagement.psm1" -Force
   
   $SubtreePath = "external/PackageName"
   $PackageJsonPath = "$SubtreePath/package.json"
   
   Remove-PackageVersion -PackageJsonPath $PackageJsonPath
   git add $PackageJsonPath
   git commit -m "Remove version/private fields before subtree push"
   
   Invoke-SubtreePush -Prefix $SubtreePath -Remote "remote-name" -Branch "main"
   
   Add-PackageVersion -PackageJsonPath $PackageJsonPath -Version "0.0.0-external"
   git add $PackageJsonPath
   git commit -m "Restore version/private fields after subtree push"
   ```
