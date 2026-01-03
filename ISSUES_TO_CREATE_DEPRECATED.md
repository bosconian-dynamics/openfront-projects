# DEPRECATED: Issues to Create

**Note: This file has been deprecated.** 

The issues listed here were related to the old git subtree/worktree workflow that has been replaced with git submodules in the main branch.

The git submodule approach resolves the complexity and workflow issues that these issues were intended to address:

- ✅ **Subtree complexity**: Resolved by switching to submodules
- ✅ **Version pinning**: Now handled natively by submodules  
- ✅ **Simplified workflow**: Standard git submodule commands
- ✅ **No branch conflicts**: Separate repositories with submodules
- ✅ **Clean history**: No complex merge/push operations needed

See [docs/SUBMODULE_WORKFLOW.md](docs/SUBMODULE_WORKFLOW.md) for the current workflow.

## Original Issues (For Historical Reference)

These were the original planned issues before the switch to submodules:

1. **Improve git subtree push complexity** - No longer needed with submodules
2. **Add Rush change log verification bypass** - Still relevant for initialization
3. **Investigate submodule alternative** - ✅ Completed: switched to submodules
4. **Add automated testing for external dependency management** - Still relevant for submodules
5. **Document subtree workflow edge cases** - Replaced with submodule documentation
6. **Add subtree operation rollback functionality** - Not needed with submodules
7. **Improve error handling** - Simplified with submodule workflow

## Remaining Relevant Issues

Some issues from the original list are still relevant in the submodule context:

1. **Rush change log verification bypass** - Still needed for monorepo initialization
2. **Automated testing for dependency management** - Should cover submodule operations
3. **Documentation** - Completed with SUBMODULE_WORKFLOW.md