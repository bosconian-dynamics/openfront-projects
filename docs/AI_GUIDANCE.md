# AI/LLM Development Guidance

This document provides guidance for AI assistants (like GitHub Copilot, ChatGPT, Claude, etc.) when working with this codebase.

## Repository Context

This is a **Rush monorepo** containing multiple packages organized in a 2-level hierarchy. The primary package currently in the monorepo is OpenFrontIO, which is maintained as a git subtree with a fork-based workflow (fork: https://github.com/bosconian-dynamics/OpenFrontIO, upstream: https://github.com/openfrontio/OpenFrontIO).

## Key Technologies

- **Build System**: Rush (Microsoft's monorepo build orchestrator)
- **Package Manager**: pnpm 9.15.9 (managed by Rush)
- **Runtime**: Node.js 20.x/22.x LTS
- **Languages**: TypeScript, JavaScript
- **Main Project**: OpenFrontIO (multiplayer strategy game)

## Understanding the Structure

### Folder Hierarchy

**Package Depth Guidelines**: Packages can be 1-2 levels deep from the repository root:

```
packages/
  ├── [category]/          ← Level 1: Category (e.g., apps, libraries, tools)
  │   └── [package-name]/  ← Level 2: Package directory (preferred for new packages)
  └── [package-name]/      ← Level 1: Direct package (for special cases like subtrees)
```

**Rush Configuration:**
- `projectFolderMinDepth: 1`
- `projectFolderMaxDepth: 2`

**Best Practice:** New packages should be 2 levels deep with proper categorization. The 1-level depth is primarily for special cases like git subtrees from upstream repositories.
- `projectFolderMaxDepth: 2`

### Current Packages

1. **packages/OpenFrontIO** - The main OpenFrontIO game client and server
   - Git subtree from upstream repository
   - TypeScript-based multiplayer strategy game
   - Uses webpack for bundling
   - Has both client and server components

## Working with Rush

### Essential Commands

When making changes that affect dependencies or build configuration:

```bash
# After modifying dependencies
rush update

# Build all packages
rush build

# Build specific package and its dependencies
rush build --to <package-name>

# Add a dependency to a package
cd packages/[category]/[package-name]
rush add -p <dependency-name>

# Remove a dependency
rush remove -p <dependency-name>
```

### Adding New Packages

When creating a new package:

1. Create directory structure (2 levels deep):
   ```bash
   mkdir -p packages/[category]/[package-name]
   ```

2. Initialize package.json with appropriate fields:
   ```json
   {
     "name": "@scope/package-name",
     "version": "1.0.0",
     "private": true,
     "scripts": {},
     "dependencies": {},
     "devDependencies": {}
   }
   ```

3. Register in rush.json:
   ```json
   {
     "packageName": "@scope/package-name",
     "projectFolder": "packages/[category]/[package-name]"
   }
   ```

4. Run `rush update`

## OpenFrontIO-Specific Context

### Technology Stack

- **Frontend**: PixiJS, TypeScript, Webpack, Tailwind CSS
- **Backend**: Express, WebSockets, TypeScript
- **Testing**: Jest
- **Linting**: ESLint with TypeScript support
- **Formatting**: Prettier

### Key Files

- `package.json` - Dependencies and scripts
- `webpack.config.js` - Build configuration
- `tsconfig.json` - TypeScript configuration
- `eslint.config.js` - ESLint configuration (flat config)
- `src/client/` - Frontend code
- `src/server/` - Backend code
- `tests/` - Test files

### Common Tasks

**Building:**
```bash
npm run build-dev    # Development build
npm run build-prod   # Production build
```

**Running:**
```bash
npm run dev          # Start both client and server in dev mode
npm run start:client # Start webpack dev server
npm run start:server # Start game server
```

**Testing:**
```bash
npm test            # Run all tests
npm run test:coverage # Run tests with coverage
```

**Linting/Formatting:**
```bash
npm run lint        # Check for linting errors
npm run lint:fix    # Auto-fix linting errors
npm run format      # Format all files with Prettier
```

## Subtree Management

The `packages/OpenFrontIO` directory is a git subtree with a fork-based workflow:

### Pulling Updates from Upstream

```bash
git subtree pull --prefix=packages/OpenFrontIO openfrontio-upstream main --squash
```

### Pushing Changes to Your Fork

```bash
git subtree push --prefix=packages/OpenFrontIO openfrontio-fork main
```

Then create a PR from your fork to upstream on GitHub.

### Why Fork-Based Subtree?

- Allows working on OpenFrontIO within this monorepo
- Enables submitting PRs from fork to upstream repository
- Maintains branch naming parity between fork and subtree
- Clean history with squashed commits
- No submodule complexity

## Code Style and Conventions

### TypeScript

- Use strict mode
- Prefer explicit types over `any`
- Use ES modules (`import`/`export`)
- Follow existing naming conventions in the codebase

### Formatting

- Prettier handles formatting automatically
- 2-space indentation
- Single quotes for strings
- Trailing commas in multi-line structures

### Commits

When making changes:
1. Keep commits focused and atomic
2. Write clear, descriptive commit messages
3. Reference issues/tickets when applicable
4. Test before committing

## Common Patterns

### Dependency Management

- Use `workspace:^` protocol for internal package dependencies
- Keep dependencies updated regularly
- Use exact versions for critical dependencies
- Prefer peer dependencies for shared libraries

### Testing

- Write tests for new features
- Maintain existing test coverage
- Use descriptive test names
- Mock external dependencies appropriately

### Error Handling

- Use proper error types
- Provide meaningful error messages
- Log errors appropriately
- Handle edge cases

## Best Practices for AI Assistance

### When Adding Features

1. Understand the existing code structure first
2. Follow established patterns in the codebase
3. Add tests for new functionality
4. Update documentation as needed
5. Run linting and tests before suggesting changes

### When Refactoring

1. Make small, incremental changes
2. Ensure tests pass after each change
3. Maintain backward compatibility when possible
4. Document breaking changes clearly

### When Fixing Bugs

1. Understand the root cause before fixing
2. Add tests that would have caught the bug
3. Consider edge cases
4. Verify the fix doesn't introduce new issues

### When Answering Questions

1. Reference actual code when possible
2. Explain the "why" not just the "how"
3. Suggest best practices from the ecosystem
4. Consider the broader context of the change

## Resources

- [Rush Documentation](https://rushjs.io/)
- [TypeScript Handbook](https://www.typescriptlang.org/docs/)
- [PixiJS Documentation](https://pixijs.com/)
- [OpenFrontIO Fork](https://github.com/bosconian-dynamics/OpenFrontIO)
- [OpenFrontIO Upstream](https://github.com/openfrontio/OpenFrontIO)

## Troubleshooting

### Common Issues

**"Rush not found"**
- Solution: `npm install -g @microsoft/rush`

**"Package not found in monorepo"**
- Solution: Check rush.json registration and run `rush update`

**"Dependency mismatch"**
- Solution: Run `rush update --full` to rebuild the entire dependency tree

**"Build failures"**
- Solution: Check individual package build logs and ensure all dependencies are installed

## Questions?

When uncertain:
1. Check existing code patterns
2. Review Rush and package documentation
3. Test changes in isolation first
4. Ask for clarification on requirements
