# Development Container

This directory contains the configuration for the development container used in this repository.

## Overview

The devcontainer is configured using Docker Compose to orchestrate multiple services:

1. **devcontainer** - The main development environment based on `typescript-node:1-20-bookworm`
2. **postgres** - PostgreSQL database from the `ofp-data` package

## Architecture

The setup uses Docker Compose orchestration instead of a simple container image to avoid docker-in-docker scenarios. This allows the devcontainer to communicate with other services (like the PostgreSQL database) running in separate containers.

### Services

#### devcontainer
- **Base Image**: `mcr.microsoft.com/devcontainers/typescript-node:1-20-bookworm`
- **User**: `node`
- **Working Directory**: `/workspaces/openfront-projects`
- **Features**: Git, GitHub CLI, PowerShell
- **Environment Variables**:
  - `POSTGRES_HOST=postgres` - Points to the postgres service
  - `POSTGRES_PORT=5432`
  - `POSTGRES_DB=openfront`
  - `POSTGRES_USER=postgres`
  - `POSTGRES_PASSWORD=postgres`
  - `DATABASE_URL=postgresql://postgres:postgres@postgres:5432/openfront`

#### postgres
- **Build Context**: `packages/data` - Uses the Dockerfile from the ofp-data package
- **Container Name**: `ofp-postgres`
- **Port**: `5432` (exposed to host)
- **Volume**: `postgres_data` for persistent storage
- **Healthcheck**: Ensures database is ready before starting devcontainer

## Usage

### Opening the Devcontainer

1. Install the [Dev Containers extension](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers) in VS Code
2. Open the repository in VS Code
3. Press `F1` and select **"Dev Containers: Reopen in Container"**
4. Wait for the containers to build and start

The devcontainer will automatically:
- Start the PostgreSQL database
- Wait for the database to be healthy
- Install Rush globally
- Run `rush update` to install dependencies

### Accessing the Database

From within the devcontainer, you can access the PostgreSQL database using:

```bash
# Using environment variables
psql $DATABASE_URL

# Or explicitly
psql -h postgres -p 5432 -U postgres -d openfront
```

From your host machine, the database is accessible at:
```
postgresql://postgres:postgres@localhost:5432/openfront
```

### Rebuilding the Containers

If you make changes to the Dockerfile or docker-compose.yaml:

1. Press `F1` in VS Code
2. Select **"Dev Containers: Rebuild Container"**

## Network

Both services are connected to the `openfront-network` bridge network, allowing them to communicate using service names as hostnames.

## Volumes

- **postgres_data**: Named volume for PostgreSQL data persistence
- **workspace**: Bind mount of the repository to `/workspaces/openfront-projects`

## Customizations

### VS Code Extensions

The following extensions are automatically installed:
- ESLint
- Prettier
- TypeScript
- Tailwind CSS
- GitHub Actions

### VS Code Settings

- Auto-format on save with Prettier
- ESLint auto-fix on save
- TypeScript SDK from workspace

## Troubleshooting

### Database Connection Issues

If you can't connect to the database:

1. Check if the postgres container is running:
   ```bash
   docker ps | grep ofp-postgres
   ```

2. Check the postgres logs:
   ```bash
   docker logs ofp-postgres
   ```

3. Verify the healthcheck:
   ```bash
   docker inspect ofp-postgres | grep -A 10 Health
   ```

### Container Build Issues

If the devcontainer fails to build:

1. Try rebuilding without cache:
   ```bash
   docker compose -f .devcontainer/docker-compose.yaml build --no-cache
   ```

2. Check Docker logs for errors

### Rush Update Fails

If `rush update` fails during post-create:

1. Check that you have network connectivity
2. Try running `rush update` manually after the container starts
3. Check the Rush logs in `common/temp/`

## Related Files

- `devcontainer.json` - Main devcontainer configuration
- `docker-compose.yaml` - Service orchestration configuration
- `../packages/data/Dockerfile` - PostgreSQL database image
- `../packages/data/docker-compose.yml` - Standalone database compose file (for reference)
