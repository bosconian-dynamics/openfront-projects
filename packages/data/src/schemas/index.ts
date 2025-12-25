/**
 * Database schema definitions using Drizzle ORM
 * @module schemas/index
 */

import { pgTable, uuid, timestamp, varchar, text, integer } from 'drizzle-orm/pg-core';

/**
 * Example: Players table
 * This is a placeholder schema that can be extended based on OpenFront data model
 */
export const players = pgTable('players', {
  id: uuid('id').primaryKey().defaultRandom(),
  username: varchar('username', { length: 255 }).notNull().unique(),
  email: varchar('email', { length: 255 }),
  createdAt: timestamp('created_at').defaultNow().notNull(),
  updatedAt: timestamp('updated_at').defaultNow().notNull(),
});

/**
 * Example: Game sessions table
 * This is a placeholder schema that can be extended based on OpenFront data model
 */
export const gameSessions = pgTable('game_sessions', {
  id: uuid('id').primaryKey().defaultRandom(),
  playerId: uuid('player_id').references(() => players.id),
  startedAt: timestamp('started_at').defaultNow().notNull(),
  endedAt: timestamp('ended_at'),
  status: varchar('status', { length: 50 }).notNull(),
  data: text('data'), // JSON data
});

/**
 * Example: API sync logs table
 * Tracks when data was last synced from OpenFront API
 */
export const apiSyncLogs = pgTable('api_sync_logs', {
  id: uuid('id').primaryKey().defaultRandom(),
  endpoint: varchar('endpoint', { length: 255 }).notNull(),
  syncedAt: timestamp('synced_at').defaultNow().notNull(),
  status: varchar('status', { length: 50 }).notNull(),
  recordCount: integer('record_count'),
  errorMessage: text('error_message'),
});
