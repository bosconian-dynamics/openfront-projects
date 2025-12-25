/**
 * Database configuration and connection management
 * @module db/config
 */

import postgres from 'postgres';
import { drizzle } from 'drizzle-orm/postgres-js';

/**
 * Database configuration interface
 */
export interface DatabaseConfig {
  host: string;
  port: number;
  database: string;
  user: string;
  password: string;
}

/**
 * Get database configuration from environment variables
 */
export function getDatabaseConfig(): DatabaseConfig {
  return {
    host: process.env.POSTGRES_HOST || 'localhost',
    port: parseInt(process.env.POSTGRES_PORT || '5432', 10),
    database: process.env.POSTGRES_DB || 'openfront',
    user: process.env.POSTGRES_USER || 'postgres',
    password: process.env.POSTGRES_PASSWORD || 'postgres',
  };
}

/**
 * Get database connection URL
 */
export function getDatabaseUrl(): string {
  if (process.env.DATABASE_URL) {
    return process.env.DATABASE_URL;
  }

  const config = getDatabaseConfig();
  return `postgresql://${config.user}:${config.password}@${config.host}:${config.port}/${config.database}`;
}

/**
 * Create a postgres connection
 */
export function createConnection() {
  const url = getDatabaseUrl();
  return postgres(url);
}

/**
 * Create a Drizzle ORM instance
 */
export function createDb() {
  const sql = createConnection();
  return drizzle(sql);
}
