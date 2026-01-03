# DEPRECATED: Issues to Create

**Note: This file has been deprecated.** 

The issues listed here were related to the old git subtree/worktree workflow that has been replaced with git submodules.

The git submodule approach resolves the complexity and workflow issues that these issues were intended to address:

- ✅ **Subtree complexity**: Resolved by switching to submodules
- ✅ **Version pinning**: Now handled natively by submodules  
- ✅ **Simplified workflow**: Standard git submodule commands
- ✅ **No branch conflicts**: Separate repositories with submodules
- ✅ **Clean history**: No complex merge/push operations needed

See [docs/SUBMODULE_WORKFLOW.md](docs/SUBMODULE_WORKFLOW.md) for the current workflow.

## Issue 1: Improve git subtree push complexity with worktree approach

**Labels:** `enhancement`, `subtree`

**Title:** Improve git subtree push complexity with worktree approach

**Description:**
The current `openfrontio-push.ps1` script commits package.json modifications to the monorepo history during subtree push operations. This clutters the git history and creates risk if the push fails mid-operation.

**Proposed Solution:**
Use git worktree or a temporary branch for clean subtree extraction, eliminating the need for commits in the main repository.

**Benefits:**
- Cleaner git history
- Simpler error handling  
- No orphaned commits on failure

**Investigation Needed:**
- Test git worktree compatibility with subtrees
- Verify cross-platform support
- Update documentation and scripts

---

## Issue 2: Add Rush change log verification bypass for initialization

**Labels:** `enhancement`, `ci`, `documentation`

**Title:** Add Rush change log verification bypass for initialization

**Description:**
The CI workflow runs `rush change --verify` which blocks legitimate scenarios like repository initialization, automated PRs, emergency fixes, and first-time contributors who may not understand the requirement.

**Proposed Solutions:**
1. Add bypass flag in workflow for commits with special tags
2. Create separate CI workflows for different scenarios
3. Document specific exceptions to verification requirement

**Benefits:**
- Smoother onboarding
- More flexible CI
- Emergency fix capability

**Investigation Needed:**
- Review Rush change log best practices
- Survey team for common bypass scenarios
- Design clear documentation

---

## Issue 3: Add pre-commit hooks for repository hygiene

**Labels:** `enhancement`, `dx`, `tooling`

**Title:** Add pre-commit hooks for repository hygiene

**Description:**
Without automated pre-commit checks, developers can accidentally commit directly to external/ directory, modify package.json improperly, or skip change log entries. These issues are caught late in CI.

**Proposed Solution:**
Implement pre-commit hooks using husky and lint-staged to:
- Block direct commits to external/ directory
- Validate package.json modifications
- Check for rush change log entries
- Run linting and formatting

**Benefits:**
- Early error detection
- Faster feedback loop
- Enforced conventions
- Better code quality

**Investigation Needed:**
- Select hook framework (husky vs simple-git-hooks vs rush-provided)
- Measure performance impact
- Design developer opt-out mechanism
- Test cross-platform compatibility

---

## Issue 4: Automate Rush change log creation

**Labels:** `enhancement`, `dx`, `automation`

**Title:** Automate Rush change log creation

**Description:**
Creating Rush change logs manually is error-prone and tedious. Developers must remember to run `rush change` for each modified package, leading to forgotten entries and CI failures.

**Proposed Solutions:**
1. Automated generation from conventional commit messages
2. Interactive bulk change helper script
3. Integration with PR workflow via GitHub Actions

**Benefits:**
- Reduced friction
- Consistency across changes
- Less context switching
- Better compliance

**Investigation Needed:**
- Explore Rush change API for programmatic usage
- Evaluate conventional commits standard
- Survey team preferences
- Assess impact on release notes quality

---

## Issue 5: Document subtree workflow edge cases

**Labels:** `documentation`, `subtree`

**Title:** Document subtree workflow edge cases  

**Description:**
Current subtree documentation covers the happy path but doesn't address edge cases developers will encounter: merge conflicts, breaking changes from upstream, script failures, branch divergence, and rollback scenarios.

**Proposed Documentation Additions:**
1. Conflict resolution guide
2. Breaking change migration strategy
3. Script failure recovery steps
4. Branch divergence management
5. Comprehensive troubleshooting section

**Benefits:**
- Reduced support burden
- Faster incident resolution
- Better onboarding
- Improved tooling based on real-world issues

**Investigation Needed:**
- Collect real-world issues from team
- Test each edge case scenario
- Create video walkthroughs if needed

---

## Issue 6: Establish version policies for internal packages

**Labels:** `enhancement`, `versioning`, `process`

**Title:** Establish version policies for internal packages

**Description:**
The monorepo has no defined version policies for internal packages. As it grows, this will cause inconsistent versioning, difficult breaking change management, and dependency conflicts.

**Proposed Approach:**
Start with individual versioning using semantic versioning guidelines:
- Major (X.0.0): Breaking changes
- Minor (1.X.0): New features, backward compatible
- Patch (1.0.X): Bug fixes only

**Implementation Plan:**
1. Create versioning guidelines document
2. Configure version-policies.json
3. Add to package creation process
4. Consider automation for version bumping

**Investigation Needed:**
- Expected package count and release frequency
- Team preferences for manual vs automated versioning
- Rush version management capabilities

---

## Issue 7: Evaluate Rush subspaces for multi-release cadence support

**Labels:** `enhancement`, `architecture`, `investigation`

**Title:** Evaluate Rush subspaces for multi-release cadence support

**Description:**
Rush subspaces allow partitioning a monorepo into multiple workspaces with independent dependencies and release cadences. Currently disabled, but may be valuable as the repo grows.

**Recommendation:**
- **Phase 1 (Now - 10 packages):** Don't enable yet, but plan directory structure
- **Phase 2 (10-20 packages):** Evaluate when conflicts or CI time becomes problematic
- **Phase 3 (20+ packages):** Implement if benefits outweigh complexity

**Investigation Needed:**
- Review latest Rush subspaces capabilities
- Study case studies from other Rush monorepos
- Determine tipping point (package count, team size)
- Understand migration path
- Measure potential CI time savings

**Questions to Answer:**
- When do subspaces become valuable?
- How do they affect developer experience?
- Can they be added incrementally?
- How do they interact with build cache?

---

## Creating These Issues

These issue descriptions can be copied into GitHub's issue creation form. Each includes:
- Clear problem statement
- Proposed solutions
- Benefits
- Investigation needed

Priority suggested order:
1. Issue 5 (Documentation) - Quick win, helps everyone
2. Issue 2 (CI bypass) - Unblocks development scenarios
3. Issue 3 (Pre-commit hooks) - Prevents common mistakes
4. Issue 4 (Change log automation) - Improves DX
5. Issue 1 (Subtree complexity) - Technical improvement
6. Issue 6 (Version policies) - Process improvement
7. Issue 7 (Subspaces) - Future planning
