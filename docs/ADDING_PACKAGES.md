# Example: Adding a New Package

This guide shows how to add a new package to the monorepo.

## Example Scenario

Let's add a new package called `my-library`.

## Step 1: Create the Package Directory

```bash
mkdir -p packages/my-library
cd packages/my-library
```

## Step 2: Initialize package.json

Create `packages/my-library/package.json`:

```json
{
  "name": "@openfront/my-library",
  "version": "1.0.0",
  "description": "A library for the OpenFront project",
  "main": "dist/index.js",
  "types": "dist/index.d.ts",
  "scripts": {
    "build": "tsc",
    "test": "jest",
    "lint": "eslint src"
  },
  "keywords": ["openfront", "library"],
  "author": "",
  "license": "ISC",
  "devDependencies": {
    "@types/node": "^20.0.0",
    "typescript": "^5.0.0"
  }
}
```

## Step 3: Add TypeScript Configuration

Create `packages/my-library/tsconfig.json`:

```json
{
  "compilerOptions": {
    "target": "ES2020",
    "module": "commonjs",
    "declaration": true,
    "outDir": "./dist",
    "rootDir": "./src",
    "strict": true,
    "esModuleInterop": true,
    "skipLibCheck": true,
    "forceConsistentCasingInFileNames": true
  },
  "include": ["src/**/*"],
  "exclude": ["node_modules", "dist"]
}
```

## Step 4: Create Source Files

Create `packages/my-library/src/index.ts`:

```typescript
/**
 * Example library function
 */
export function hello(name: string): string {
  return `Hello, ${name}!`;
}
```

## Step 5: Register in rush.json

Add the package to the `projects` array in `rush.json`:

```json
{
  "projects": [
    {
      "packageName": "openfront-client",
      "projectFolder": "external/openfrontio",
      "tags": ["game", "client", "server"]
    },
    {
      "packageName": "@openfront/my-library",
      "projectFolder": "packages/my-library",
      "tags": ["library"]
    }
  ]
}
```

## Step 6: Run Rush Update

```bash
rush update
```

This will:
- Install dependencies for the new package
- Update the pnpm workspace
- Create symlinks for the package

## Step 7: Build the Package

```bash
# Build all packages
rush build

# Or build just this package
cd packages/my-library
rushx build
```

## Using the Package in Another Package

To use your new library in another package (e.g., OpenFrontIO):

1. Add it to the other package's `package.json`:
   ```json
   {
     "dependencies": {
       "@openfront/my-library": "workspace:^1.0.0"
     }
   }
   ```

2. Run `rush update` to link the packages

3. Import and use it:
   ```typescript
   import { hello } from '@openfront/my-library';
   
   console.log(hello('World'));
   ```

## Common Package Categories

Here are suggested categories for organizing packages:

- **apps/** - Standalone applications
- **libraries/** - Reusable libraries
- **tools/** - Development tools and scripts
- **prototypes/** - Experimental or proof-of-concept projects
- **services/** - Backend services or microservices

## Best Practices

1. **Choose descriptive names**: Use clear, descriptive names for packages
2. **Follow naming conventions**: Use `@openfront/` scope for internal packages
3. **Add tags**: Use tags in rush.json for easier filtering (`rush list --only tag:library`)
4. **Document dependencies**: Clearly document what each package does and its dependencies
5. **Keep packages focused**: Each package should have a single, well-defined purpose
6. **Use workspace protocol**: Always use `workspace:^` for internal dependencies

## Troubleshooting

### Package not found after adding

Run `rush update --full` to rebuild the entire dependency graph.

### Build errors

Check that:
- All dependencies are listed in package.json
- TypeScript configuration is correct
- You've run `rush update` after changes

### Circular dependencies

Rush will detect and report circular dependencies. Restructure your packages to avoid them, or use the `decoupledLocalDependencies` field in rush.json if absolutely necessary.

## Next Steps

- Add tests for your package
- Set up linting and formatting
- Add documentation
- Consider adding to CI/CD pipeline
