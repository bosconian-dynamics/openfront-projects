# CI/CD Environment

This directory contains CI/CD configuration with environmental parity to the development container.

## Components

### Dockerfile
Defines the CI environment based on:
- **Base Image**: `mcr.microsoft.com/devcontainers/typescript-node:1-20-bookworm`
- **OS**: Debian 12 (Bookworm) LTS
- **Node.js**: 20.x LTS
- **PowerShell**: Latest LTS
- **GitHub CLI**: Latest
- **Rush**: Globally installed

This matches the dev container configuration in `.devcontainer/devcontainer.json`.

### ci.yml Workflow
GitHub Actions workflow that:
1. Uses the same Debian Bookworm + Node 20 base image
2. Installs PowerShell LTS for monorepo tooling
3. Installs GitHub CLI
4. Runs Rush commands for verification and build

### docker-compose.yml
Local testing configuration for the CI environment. Use this to test CI builds locally:

```bash
cd .github
docker-compose run ci
```

## Environmental Parity

The CI environment matches the dev container:

| Component | Dev Container | CI Environment |
|-----------|--------------|----------------|
| OS | Debian 12 (Bookworm) | Debian 12 (Bookworm) |
| Node.js | 20.x LTS | 20.x LTS |
| PowerShell | LTS | LTS |
| GitHub CLI | Latest | Latest |
| Git | Included | Included |
| Rush | Globally installed | Globally installed |

## PowerShell Support

PowerShell is installed to support monorepo tooling scripts in `common/scripts/`:
- `openfrontio-pull.ps1` - Pull subtree updates
- `openfrontio-push.ps1` - Push subtree changes
- PowerShell modules in `common/scripts/modules/`

## Testing CI Locally

To test the CI environment locally:

```bash
# Build the Docker image
cd .github
docker build -t openfront-ci .

# Run interactively
docker run -it -v $(pwd)/..:/workspace openfront-ci

# Or use docker-compose
docker-compose run ci
```

## Updating the Environment

When updating the dev container (`.devcontainer/devcontainer.json`), ensure corresponding updates to:
1. `.github/Dockerfile` - Match base image and installed tools
2. `.github/workflows/ci.yml` - Update container image and installation steps

This ensures consistent behavior across development and CI environments.
