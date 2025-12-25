# Database Migrations

This directory contains database migrations managed by Drizzle Kit.

## Creating a Migration

To generate a new migration based on schema changes:

```bash
npm run db:generate
```

This will analyze your schema definitions in `src/schemas/` and generate SQL migration files.

## Running Migrations

To apply pending migrations to the database:

```bash
npm run db:migrate
```

## Migration Naming Convention

Migrations are automatically named with timestamps by Drizzle Kit:
- `0000_initial_setup.sql`
- `0001_add_players_table.sql`
- etc.

## Manual Migrations

If you need to create a manual migration:

1. Create a new `.sql` file in this directory
2. Follow the naming convention: `NNNN_description.sql`
3. Write your SQL DDL statements
4. Run `npm run db:migrate` to apply

## Rollback

Drizzle Kit doesn't have built-in rollback. For critical migrations:
1. Test in a development environment first
2. Create a backup of production database before applying
3. Consider writing a reverse migration if needed

## Best Practices

1. **Always test migrations** in development before production
2. **Keep migrations small** - one logical change per migration
3. **Use transactions** for data migrations
4. **Document** complex migrations with comments
5. **Never edit** applied migrations - create new ones instead
