# GitHub Copilot Instructions for OpenFront Projects

## Repository Overview

This is a **Rush-based monorepo** for managing OpenFront-related projects and packages. The repository uses Microsoft Rush for build orchestration and pnpm as the package manager.

### Key Technologies

- **Build System**: Rush 5.164.0
- **Package Manager**: pnpm 9.15.9 (managed by Rush)
- **Runtime**: Node.js 20.x or 22.x (both are LTS versions)
- **Languages**: TypeScript, JavaScript
- **Primary Project**: OpenFrontIO (multiplayer strategy game maintained as git subtree)

## Repository Structure

```
openfront-projects/
├── .github/                 # GitHub configuration and workflows
├── .devcontainer/          # VSCode dev container setup
├── common/                 # Rush shared configuration
│   ├── config/rush/        # Rush configuration files
│   └── scripts/            # Monorepo automation scripts
├── docs/                   # Documentation
│   ├── MONOREPO.md         # Monorepo structure guide
│   ├── ADDING_PACKAGES.md  # Package creation guide
│   └── SUBTREE.md          # Git subtree management
├── AGENTS.md               # Instructions for AI coding agents
├── external/               # External packages (git subtrees)
│   └── openfrontio/        # OpenFrontIO game (git subtree)
├── apps/                   # Application packages
├── packages/               # Internal packages
├── experiments/            # Experimental packages
├── rush.json               # Main Rush configuration
└── README.md               # Main documentation
```

### Package Organization

- Packages are organized **one level deep** within their category directory
- Category directories: `apps/`, `external/`, `packages/`, `experiments/`
- Examples: `apps/my-app/`, `external/openfrontio/`, `packages/my-lib/`, `experiments/prototype/`
- Configured in rush.json with `projectFolderMinDepth: 2` and `projectFolderMaxDepth: 3`

## Build and Test Instructions

### Initial Setup

```bash
# Install Rush globally (if not already installed)
npm install -g @microsoft/rush

# Install all package dependencies
rush update

# Build all packages
rush build
```

### Common Commands

```bash
# Update dependencies after package.json changes
rush update

# Build all packages
rush build

# Rebuild all packages (clean + build)
rush rebuild

# Build specific package and its dependencies
rush build --to <package-name>

# Run tests for all packages
rush test

# List all packages in the monorepo
rush list
```

### Working with Individual Packages

```bash
# Navigate to a package directory
cd apps/[package-name]
# or
cd external/openfrontio

# Run package.json scripts using rushx
rushx build
rushx test
rushx lint
```

### OpenFrontIO-Specific Commands

The `external/openfrontio` package has these common scripts:

```bash
cd external/openfrontio
rushx build-dev      # Development build
rushx build-prod     # Production build
rushx dev            # Start dev server (client + server)
rushx test           # Run tests
rushx lint           # Check for linting errors
rushx lint:fix       # Auto-fix linting errors
rushx format         # Format code with Prettier
```

## Coding Conventions

### TypeScript

- Use **strict mode** TypeScript
- Prefer explicit types over `any`
- Use ES modules (`import`/`export`)
- Follow existing naming conventions in each package

### Code Style

- **Formatting**: Prettier handles formatting automatically
- **Indentation**: 2 spaces
- **Quotes**: Single quotes for strings
- **Trailing Commas**: Yes, in multi-line structures
- **ESLint**: Flat config format (eslint.config.js)

### Dependency Management

- Use `workspace:^` protocol for internal package dependencies
- Use Rush commands for adding/removing dependencies:
  ```bash
  rush add -p <package-name>      # Add dependency
  rush remove -p <package-name>   # Remove dependency
  ```
- Always run `rush update` after modifying dependencies

### Testing

- Write tests for new features
- Use Jest for testing (in OpenFrontIO)
- Use descriptive test names
- Maintain or improve existing test coverage

### Commits

- Write clear, descriptive commit messages
- Keep commits focused and atomic
- Reference issues/tickets when applicable
- Test changes before committing

## Adding New Packages

Follow this process when creating new packages:

1. **Create package directory** (one level deep within appropriate category):
   ```bash
   # For application packages:
   mkdir -p apps/[package-name]
   
   # For internal library packages:
   mkdir -p packages/[package-name]
   
   # For experimental packages:
   mkdir -p experiments/[package-name]
   
   # For external packages (subtrees):
   mkdir -p external/[package-name]
   ```

2. **Create package.json**:
   ```json
   {
     "name": "@openfront/package-name",
     "version": "1.0.0",
     "private": true,
     "scripts": {
       "build": "tsc",
       "test": "jest"
     }
   }
   ```

3. **Register in rush.json** under the `projects` array:
   ```json
   {
     "packageName": "@openfront/package-name",
     "projectFolder": "apps/package-name"  // or "packages/", "experiments/", "external/" as appropriate
   }
   ```

4. **Run Rush update**:
   ```bash
   rush update
   ```

See `docs/ADDING_PACKAGES.md` for detailed step-by-step guide.

## Git Subtree Workflow (OpenFrontIO)

The `external/openfrontio` directory is maintained as a git subtree with a fork-based workflow:

- **Fork**: https://github.com/bosconian-dynamics/OpenFrontIO
- **Upstream**: https://github.com/openfrontio/OpenFrontIO

### Pull Updates from Upstream

```bash
git subtree pull --prefix=external/openfrontio openfrontio-upstream main --squash
```

### Push Changes to Fork

```bash
git subtree push --prefix=external/openfrontio openfront-fork main
```

Then create a PR from the fork to upstream on GitHub.

**Important**: Do NOT modify the git subtree workflow or remotes without explicit instructions.

See `docs/SUBTREE.md` for comprehensive subtree management guide.

## Troubleshooting

### Common Issues and Solutions

**"Rush not found"**
- Solution: `npm install -g @microsoft/rush`

**"Package not found in monorepo"**
- Solution: Check rush.json registration and run `rush update`

**"Dependency mismatch"**
- Solution: `rush update --full` to rebuild entire dependency tree

**Build failures**
- Check individual package build logs
- Ensure all dependencies are installed with `rush update`
- Verify Node.js version matches requirements (20.x or 22.x)

**pnpm-lock.yaml conflicts**
- Run `rush update` to regenerate lockfile
- Commit the updated lockfile

## Best Practices for AI Assistance

### When Making Changes

1. **Understand context first**: Review existing code patterns in the relevant package
2. **Follow established patterns**: Match the style and structure of existing code
3. **Test your changes**: Run builds and tests before finalizing
4. **Update documentation**: If changing functionality, update relevant docs
5. **Use Rush commands**: Don't modify node_modules or lockfiles manually

### When Adding Features

1. Understand the package structure and dependencies
2. Add tests for new functionality
3. Follow TypeScript and ESLint conventions
4. Run `rush build` and `rush test` to verify

### When Fixing Bugs

1. Understand root cause before making changes
2. Add tests that would have caught the bug
3. Consider edge cases
4. Verify fix doesn't introduce new issues

### When Refactoring

1. Make small, incremental changes
2. Ensure tests pass after each change
3. Maintain backward compatibility when possible
4. Document breaking changes clearly

## Additional Resources

- **Rush Documentation**: https://rushjs.io/
- **AI Agent Guidelines**: See `AGENTS.md` in the repository root for comprehensive guidelines
- **Monorepo Structure**: See `docs/MONOREPO.md` for detailed structure documentation
- **Package Management**: See `docs/ADDING_PACKAGES.md` for package creation guide
- **Subtree Workflow**: See `docs/SUBTREE.md` for git subtree management

## Important Notes

- **Node.js Version**: Use Node.js 20.x or 22.x (both are LTS versions). Rush.json specifies `nodeSupportedVersionRange: ">=20.0.0 <21.0.0 || >=22.0.0 <23.0.0"`. The .nvmrc file specifies 20.19.0 as the default version.
- **Package Manager**: pnpm is managed by Rush - do not install or use pnpm directly
- **Git Subtree**: OpenFrontIO is a subtree - changes must follow the subtree workflow
- **Rush First**: Always use Rush commands for dependency and build management
- **Documentation**: Keep docs in sync with code changes

When uncertain about any aspect of the repository structure or workflow, refer to the documentation in the `docs/` directory or ask for clarification.
