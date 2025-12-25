# @bosconian-dynamics/ofp-data

Database configuration, schemas, migrations, core data typings, and OpenFront API polling utility for the OpenFront Projects monorepo.

## Features

- 📦 **Supabase-compatible PostgreSQL** database configuration with Docker
- 🔍 **Zod schemas** for runtime validation
- 🗄️ **Drizzle ORM** for type-safe database queries and migrations
- 🔄 **API Polling Utility** for syncing data from OpenFront instances
- 📝 **TypeScript** definitions for all data structures
- 🐳 **Docker** setup for local development

## Installation

This package is part of the OpenFront Projects monorepo and managed by Rush.

```bash
# From the repository root
rush update
rush build --to @bosconian-dynamics/ofp-data
```

## Usage

### Database Connection

```typescript
import { createDb, getDatabaseUrl } from '@bosconian-dynamics/ofp-data';

// Get database connection URL
const url = getDatabaseUrl();
console.log('Database URL:', url);

// Create a Drizzle ORM instance
const db = createDb();
```

### Using Schemas

```typescript
import { players, gameSessions } from '@bosconian-dynamics/ofp-data';
import { eq } from 'drizzle-orm';

const db = createDb();

// Insert a player
await db.insert(players).values({
  username: 'player1',
  email: 'player1@example.com',
});

// Query players
const allPlayers = await db.select().from(players);

// Query with condition
const player = await db
  .select()
  .from(players)
  .where(eq(players.username, 'player1'));
```

### Validation with Zod

```typescript
import { PlayerSchema, type Player } from '@bosconian-dynamics/ofp-data';

// Validate data
const playerData: unknown = {
  username: 'newplayer',
  email: 'newplayer@example.com',
};

const validatedPlayer: Player = PlayerSchema.parse(playerData);
```

### API Polling

```typescript
import { createPoller } from '@bosconian-dynamics/ofp-data';

// Configure the poller
const poller = createPoller({
  apiUrl: 'https://api.openfront.io',
  pollInterval: 60000, // Poll every 60 seconds
  endpoints: ['/players', '/sessions', '/stats'],
  retryAttempts: 3,
  retryDelay: 5000,
});

// Start polling
poller.start();

// Stop polling when done
poller.stop();
```

## Local Development

### Starting the Database

Using Docker Compose:

```bash
cd packages/data
docker-compose up -d
```

The PostgreSQL database will be available at `localhost:5432`.

### Environment Variables

Copy `.env.example` to `.env` and configure:

```env
POSTGRES_DB=openfront
POSTGRES_USER=postgres
POSTGRES_PASSWORD=postgres
POSTGRES_HOST=localhost
POSTGRES_PORT=5432
DATABASE_URL=postgresql://postgres:postgres@localhost:5432/openfront

OPENFRONT_API_URL=https://api.openfront.io
```

### Running Migrations

Generate migration from schema changes:

```bash
npm run db:generate
```

Apply migrations to database:

```bash
npm run db:migrate
```

Open Drizzle Studio (database GUI):

```bash
npm run db:studio
```

### Building

```bash
npm run build
```

### Development Mode

Watch mode for automatic rebuilds:

```bash
npm run dev
```

## Scripts

- `npm run build` - Build the TypeScript code
- `npm run dev` - Build in watch mode
- `npm run lint` - Lint the code
- `npm run lint:fix` - Fix linting issues
- `npm run db:generate` - Generate migrations from schema
- `npm run db:migrate` - Apply migrations to database
- `npm run db:studio` - Open Drizzle Studio

## Project Structure

```
packages/data/
├── src/
│   ├── api/           # API polling utilities
│   ├── db/            # Database configuration
│   ├── migrations/    # Database migrations
│   ├── schemas/       # Zod schemas and Drizzle table definitions
│   ├── types/         # TypeScript type definitions
│   └── index.ts       # Main export file
├── Dockerfile         # PostgreSQL database image
├── docker-compose.yml # Docker Compose configuration
├── init-db.sh        # Database initialization script
├── package.json
├── tsconfig.json
└── README.md
```

## Database Schema

### Players Table

- `id` (uuid) - Primary key
- `username` (varchar) - Unique username
- `email` (varchar) - Email address (optional)
- `created_at` (timestamp) - Creation timestamp
- `updated_at` (timestamp) - Last update timestamp

### Game Sessions Table

- `id` (uuid) - Primary key
- `player_id` (uuid) - Foreign key to players
- `started_at` (timestamp) - Session start time
- `ended_at` (timestamp) - Session end time (nullable)
- `status` (varchar) - Session status
- `data` (text) - JSON data

### API Sync Logs Table

- `id` (uuid) - Primary key
- `endpoint` (varchar) - API endpoint
- `synced_at` (timestamp) - Sync timestamp
- `status` (varchar) - Sync status
- `record_count` (integer) - Number of records synced
- `error_message` (text) - Error message (nullable)

## Extending the Package

### Adding New Tables

1. Define the table schema in `src/schemas/index.ts`:

```typescript
export const newTable = pgTable('new_table', {
  id: uuid('id').primaryKey().defaultRandom(),
  name: varchar('name', { length: 255 }).notNull(),
  // ... other columns
});
```

2. Create Zod validation schema in `src/schemas/validation.ts`:

```typescript
export const NewTableSchema = z.object({
  id: z.string().uuid().optional(),
  name: z.string().max(255),
  // ... other fields
});

export type NewTable = z.infer<typeof NewTableSchema>;
```

3. Export types in `src/types/index.ts`

4. Generate and apply migration:

```bash
npm run db:generate
npm run db:migrate
```

### Adding API Endpoints

Extend the poller configuration with new endpoints:

```typescript
const poller = createPoller({
  apiUrl: 'https://api.openfront.io',
  endpoints: ['/new-endpoint'],
  pollInterval: 60000,
});
```

## Integration with OpenFront

This package is designed to work with the OpenFront ecosystem:

- Uses **AGPL-3.0 license** (compatible with OpenFront)
- Can import and extend types from `openfront-client` package
- Provides data persistence layer for OpenFront applications
- Supports real-time data synchronization from OpenFront API

## License

AGPL-3.0 - See [LICENSE](./LICENSE) file for details.

This package is licensed under AGPL-3.0 in accordance with the OpenFrontIO project's licensing requirements.

## Contributing

See the main repository [CONTRIBUTING.md](../../CONTRIBUTING.md) for contribution guidelines.

## Related Packages

- `openfront-client` - OpenFront game client
- `@bosconian-dynamics/ofp-map-editor` - Map editor application
