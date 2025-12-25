# AI/LLM Development Guidance

This document provides guidance for AI assistants (like GitHub Copilot, ChatGPT, Claude, etc.) when working with this codebase.

## Repository Context

This is a **Rush monorepo** containing multiple packages organized with one-level depth within category directories. The primary package is OpenFrontIO, maintained as a git subtree with a fork-based workflow.

## Key Technologies

- **Build System**: Rush 5.164.0
- **Package Manager**: pnpm 9.15.9 (managed by Rush)
- **Runtime**: Node.js 20.x or 22.x (both LTS)
- **Languages**: TypeScript, JavaScript
- **Main Project**: OpenFrontIO (multiplayer strategy game)

## Repository Structure

### Package Organization

Packages are **one level deep** within their category directory:

```
apps/          # Application packages
packages/      # Internal library packages
experiments/   # Experimental packages
external/      # External packages (git subtrees)
```

**Rush Configuration:**
- `projectFolderMinDepth: 2`
- `projectFolderMaxDepth: 3`

**Examples:** `apps/map-editor/`, `external/openfrontio/`, `packages/my-lib/`, `experiments/prototype/`

### Current Packages

**external/openfrontio** - OpenFrontIO game (git subtree)
- TypeScript-based multiplayer strategy game
- PixiJS frontend, Express backend, WebSockets
- Webpack bundling, Jest testing, ESLint + Prettier

**apps/map-editor** - Map editor application

## Working with Rush

### Essential Commands

```bash
# Install/update dependencies after package.json changes
rush update

# Build all packages
rush build

# Build specific package and its dependencies
rush build --to <package-name>

# Add a dependency to a package (run from package directory)
rush add -p <dependency-name>

# Remove a dependency
rush remove -p <dependency-name>
```

### Adding New Packages

1. **Create directory** (one level deep in category):
   ```bash
   mkdir -p apps/[package-name]
   # or packages/, experiments/, external/
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

3. **Register in rush.json**:
   ```json
   {
     "packageName": "@openfront/package-name",
     "projectFolder": "apps/package-name"
   }
   ```

4. **Run `rush update`**

## OpenFrontIO Package

The `external/openfrontio` package contains the main game client and server.

### Technology Stack

- **Frontend**: PixiJS, TypeScript, Webpack, Tailwind CSS
- **Backend**: Express, WebSockets, TypeScript
- **Testing**: Jest
- **Linting**: ESLint (flat config)
- **Formatting**: Prettier

### Common Scripts

Use `rushx` from the `external/openfrontio` directory:

```bash
rushx build-dev        # Development build
rushx build-prod       # Production build
rushx dev              # Start both client and server
rushx test             # Run tests
rushx lint             # Check linting
rushx lint:fix         # Auto-fix linting
rushx format           # Format with Prettier
```

## Git Subtree Management

OpenFrontIO at `external/openfrontio` is maintained as a git subtree with fork-based workflow:

**Fork:** https://github.com/bosconian-dynamics/OpenFrontIO  
**Upstream:** https://github.com/openfrontio/OpenFrontIO

### Pull from Upstream

```bash
git subtree pull --prefix=external/openfrontio openfrontio-upstream main --squash
```

### Push to Fork

```bash
git subtree push --prefix=external/openfrontio openfront-fork main
```

Then create a PR from fork to upstream on GitHub.

### Why Subtree?

- Work on OpenFrontIO within monorepo
- Submit PRs to upstream
- Clean history with squashed commits
- No submodule complexity

## Code Style and Conventions

### TypeScript

- Use strict mode with explicit types (avoid `any`)
- Use ES modules (`import`/`export`)
- Follow existing naming conventions

### Formatting

- **Prettier** handles formatting (2-space indentation, single quotes, trailing commas)
- **ESLint** enforces code quality (flat config format)

### Commits

- Keep commits focused and atomic
- Write clear, descriptive messages
- Reference issues when applicable

## Common Patterns

### Dependency Management

- Use `workspace:^` protocol for internal packages
- Use Rush commands (`rush add`, `rush remove`)
- Always run `rush update` after dependency changes

### Testing

- Write tests for new features
- Maintain test coverage
- Use descriptive test names
- Mock external dependencies

### Error Handling

- Use proper error types with meaningful messages
- Log errors appropriately
- Handle edge cases

## Best Practices for AI Assistance

### Adding Features

1. Understand existing code structure
2. Follow established patterns
3. Add tests for new functionality
4. Update documentation
5. Run linting and tests

### Refactoring

1. Make small, incremental changes
2. Ensure tests pass after each change
3. Maintain backward compatibility
4. Document breaking changes

### Fixing Bugs

1. Understand root cause
2. Add tests that catch the bug
3. Consider edge cases
4. Verify no new issues introduced

### Answering Questions

1. Reference actual code
2. Explain "why" not just "how"
3. Suggest ecosystem best practices
4. Consider broader context

## Troubleshooting

**"Rush not found"**
- Install: `npm install -g @microsoft/rush`

**"Package not found"**
- Check rush.json registration
- Run `rush update`

**"Dependency mismatch"**
- Run `rush update --full`

**"Build failures"**
- Check package build logs
- Ensure dependencies installed

## Resources

- [Rush Documentation](https://rushjs.io/)
- [TypeScript Handbook](https://www.typescriptlang.org/docs/)
- [PixiJS Documentation](https://pixijs.com/)
- [OpenFrontIO Fork](https://github.com/bosconian-dynamics/OpenFrontIO)
- [OpenFrontIO Upstream](https://github.com/openfrontio/OpenFrontIO)
