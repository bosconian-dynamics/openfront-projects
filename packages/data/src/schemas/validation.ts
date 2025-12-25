/**
 * Zod validation schemas for data types
 * @module schemas/validation
 */

import { z } from 'zod';

/**
 * Player validation schema
 */
export const PlayerSchema = z.object({
  id: z.string().uuid().optional(),
  username: z.string().min(3).max(255),
  email: z.string().email().optional(),
  createdAt: z.date().optional(),
  updatedAt: z.date().optional(),
});

export type Player = z.infer<typeof PlayerSchema>;

/**
 * Game session validation schema
 */
export const GameSessionSchema = z.object({
  id: z.string().uuid().optional(),
  playerId: z.string().uuid(),
  startedAt: z.date().optional(),
  endedAt: z.date().optional().nullable(),
  status: z.enum(['active', 'completed', 'abandoned']),
  data: z.string().optional().nullable(),
});

export type GameSession = z.infer<typeof GameSessionSchema>;

/**
 * API sync log validation schema
 */
export const ApiSyncLogSchema = z.object({
  id: z.string().uuid().optional(),
  endpoint: z.string().max(255),
  syncedAt: z.date().optional(),
  status: z.enum(['success', 'error', 'partial']),
  recordCount: z.number().int().optional(),
  errorMessage: z.string().optional().nullable(),
});

export type ApiSyncLog = z.infer<typeof ApiSyncLogSchema>;

/**
 * OpenFront API response schemas
 * These are placeholders and should be extended based on actual API
 */
export const OpenFrontApiResponseSchema = z.object({
  success: z.boolean(),
  data: z.unknown(),
  error: z.string().optional(),
});

export type OpenFrontApiResponse = z.infer<typeof OpenFrontApiResponseSchema>;
