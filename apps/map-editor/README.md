# OpenFront Map Editor

A WebGL-based 2D map editor for OpenFront, built with modern web technologies.

## Features

- **WebGL Rendering**: Powered by Three.js for high-performance 2D map rendering
- **Modern UI**: Built with Lit web components for a reactive, component-based architecture
- **TypeScript**: Fully typed for better developer experience and code quality
- **Vite Build**: Fast development and optimized production builds
- **OpenFront Integration**: Direct integration with OpenFrontIO game engine

## Technology Stack

- **[Three.js](https://threejs.org/)**: WebGL-based 3D/2D rendering engine
- **[Lit](https://lit.dev/)**: Fast, lightweight web components
- **[TypeScript](https://www.typescriptlang.org/)**: Type-safe JavaScript
- **[Vite](https://vitejs.dev/)**: Next-generation frontend tooling

## Development

### Prerequisites

- Node.js 20.x or 22.x (LTS)
- Rush package manager (installed globally)

### Getting Started

```bash
# From the monorepo root, install dependencies
rush update

# Start the development server
cd apps/map-editor
rushx dev
```

The development server will start at `http://localhost:3000`.

### Building

```bash
# Build for production
rushx build

# Preview production build
rushx preview
```

### Linting

```bash
# Lint the code
rushx lint

# Lint and fix issues
rushx lint:fix
```

## Docker

Build and run using Docker:

```bash
# Build the image (standalone mode)
docker build -t openfront-map-editor .

# Run the container
docker run -p 3000:3000 openfront-map-editor
```

**Note:** The Dockerfile uses `npm install` for standalone Docker builds. In a Rush monorepo, 
dependencies are managed at the monorepo level. For production deployments, consider building 
the application within the monorepo using `rush build` and copying the `dist` folder to your 
Docker image.

Access the application at `http://localhost:3000`.

## Architecture

The map editor is structured as follows:

- **`src/main.ts`**: Main entry point and application component
- **`index.html`**: HTML entry point
- **`vite.config.ts`**: Vite build configuration
- **`tsconfig.json`**: TypeScript configuration

## Dependencies

This package depends on:

- **openfront-client**: The OpenFrontIO game engine (workspace dependency)
- **three**: WebGL rendering library
- **lit**: Web components framework

All dependency versions are pinned to match the OpenFrontIO package for consistency.

## License

This project is licensed under the **GNU Affero General Public License v3.0 (AGPL-3.0)**.

As a derivative work of OpenFrontIO, this project inherits the AGPL-3.0 license. See the [LICENSE](LICENSE) file for details.

### Key Points

- You must make the source code available to users who interact with this software over a network
- Any modifications must also be licensed under AGPL-3.0
- Copyright notices must be preserved

## Contributing

Contributions are welcome! Please ensure your code:

- Follows the existing code style
- Passes all linting checks
- Includes appropriate type definitions
- Is well-documented

## Resources

- [OpenFrontIO GitHub](https://github.com/openfrontio/OpenFrontIO)
- [Three.js Documentation](https://threejs.org/docs/)
- [Lit Documentation](https://lit.dev/docs/)
- [Vite Documentation](https://vitejs.dev/guide/)
