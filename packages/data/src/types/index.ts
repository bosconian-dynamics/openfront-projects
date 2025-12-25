/**
 * Core TypeScript type definitions
 * @module types
 * 
 * This module can re-export or extend types from OpenFrontIO project
 */

/**
 * Database connection options
 */
export interface DbConnectionOptions {
  host: string;
  port: number;
  database: string;
  user: string;
  password: string;
  ssl?: boolean;
  max?: number;
  idleTimeoutMillis?: number;
  connectionTimeoutMillis?: number;
}

/**
 * API polling configuration
 */
export interface ApiPollingConfig {
  apiUrl: string;
  apiKey?: string;
  pollInterval: number; // in milliseconds
  endpoints: string[];
  retryAttempts?: number;
  retryDelay?: number;
}

/**
 * API polling result
 */
export interface ApiPollingResult {
  endpoint: string;
  success: boolean;
  timestamp: Date;
  recordCount?: number;
  error?: string;
}

/**
 * Migration status
 */
export interface MigrationStatus {
  version: string;
  name: string;
  appliedAt: Date;
  success: boolean;
}

// Re-export validation schemas as types
export type {
  Player,
  GameSession,
  ApiSyncLog,
  OpenFrontApiResponse,
} from '../schemas/validation.js';
