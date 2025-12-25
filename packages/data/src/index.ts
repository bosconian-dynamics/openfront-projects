/**
 * @bosconian-dynamics/ofp-data
 * 
 * Database configuration, schemas, migrations, core data typings,
 * and OpenFront API polling utility
 * 
 * @license AGPL-3.0
 * @packageDocumentation
 */

// Database configuration
export {
  getDatabaseConfig,
  getDatabaseUrl,
  createConnection,
  createDb,
  type DatabaseConfig,
} from './db/config.js';

// Schemas
export { players, gameSessions, apiSyncLogs } from './schemas/index.js';

// Validation schemas
export {
  PlayerSchema,
  GameSessionSchema,
  ApiSyncLogSchema,
  OpenFrontApiResponseSchema,
} from './schemas/validation.js';

// Types
export type {
  DbConnectionOptions,
  ApiPollingConfig,
  ApiPollingResult,
  MigrationStatus,
  Player,
  GameSession,
  ApiSyncLog,
  OpenFrontApiResponse,
} from './types/index.js';

// API Poller
export { OpenFrontPoller, createPoller } from './api/poller.js';
