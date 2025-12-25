/**
 * OpenFront API polling utility
 * @module api/poller
 * 
 * Polls OpenFront instance API for data and updates the database
 */

import type { ApiPollingConfig, ApiPollingResult } from '../types/index.js';
import type { ApiSyncLog } from '../schemas/validation.js';
import { createDb } from '../db/config.js';
import { apiSyncLogs } from '../schemas/index.js';

/**
 * Internal config with required retry parameters
 */
type InternalPollingConfig = ApiPollingConfig & {
  retryAttempts: number;
  retryDelay: number;
};

/**
 * OpenFront API Poller class
 */
export class OpenFrontPoller {
  private config: InternalPollingConfig;
  private timeoutId?: NodeJS.Timeout;
  private isRunning: boolean = false;
  private lastPollTime?: number;

  constructor(config: ApiPollingConfig) {
    this.config = {
      retryAttempts: 3,
      retryDelay: 5000,
      ...config,
    };
  }

  /**
   * Start polling the OpenFront API
   */
  start(): void {
    if (this.isRunning) {
      console.warn('Polling is already running');
      return;
    }

    console.log('Starting OpenFront API polling...');
    this.isRunning = true;
    this.lastPollTime = Date.now();
    
    // Start the polling cycle
    this.schedulePoll();
  }

  /**
   * Stop polling
   */
  stop(): void {
    if (this.timeoutId) {
      clearTimeout(this.timeoutId);
      this.timeoutId = undefined;
    }
    this.isRunning = false;
    console.log('Stopped OpenFront API polling');
  }

  /**
   * Schedule the next poll with drift correction
   */
  private schedulePoll(): void {
    if (!this.isRunning) {
      return;
    }

    // Execute poll and schedule next
    this.pollAll().finally(() => {
      if (!this.isRunning) {
        return;
      }

      // Calculate drift correction
      const now = Date.now();
      const expectedTime = (this.lastPollTime || now) + this.config.pollInterval;
      const drift = now - expectedTime;
      const nextInterval = Math.max(0, this.config.pollInterval - drift);

      this.lastPollTime = expectedTime;
      this.timeoutId = setTimeout(() => this.schedulePoll(), nextInterval);
    });
  }

  /**
   * Poll all configured endpoints
   */
  private async pollAll(): Promise<void> {
    const results = await Promise.allSettled(
      this.config.endpoints.map(endpoint => this.pollEndpoint(endpoint))
    );

    // Log results
    results.forEach((result, index) => {
      const endpoint = this.config.endpoints[index];
      if (result.status === 'fulfilled') {
        console.log(`Successfully polled ${endpoint}:`, result.value);
      } else {
        console.error(`Failed to poll ${endpoint}:`, result.reason);
      }
    });
  }

  /**
   * Poll a single endpoint
   */
  private async pollEndpoint(endpoint: string): Promise<ApiPollingResult> {
    const url = `${this.config.apiUrl}${endpoint}`;
    let lastError: string | undefined;

    // Retry logic
    for (let attempt = 0; attempt < this.config.retryAttempts; attempt++) {
      try {
        const response = await fetch(url, {
          headers: {
            'Content-Type': 'application/json',
          },
        });

        if (!response.ok) {
          throw new Error(`HTTP ${response.status}: ${response.statusText}`);
        }

        const data = await response.json();
        
        // Save sync log to database
        await this.saveSyncLog({
          endpoint,
          status: 'success',
          recordCount: Array.isArray(data) ? data.length : undefined,
        });

        return {
          endpoint,
          success: true,
          timestamp: new Date(),
          recordCount: Array.isArray(data) ? data.length : undefined,
        };
      } catch (error) {
        lastError = error instanceof Error ? error.message : String(error);
        
        if (attempt < this.config.retryAttempts - 1) {
          console.log(`Retry ${attempt + 1} for ${endpoint} after ${this.config.retryDelay}ms`);
          await this.delay(this.config.retryDelay);
        }
      }
    }

    // All retries failed
    await this.saveSyncLog({
      endpoint,
      status: 'error',
      errorMessage: lastError,
    });

    return {
      endpoint,
      success: false,
      timestamp: new Date(),
      error: lastError,
    };
  }

  /**
   * Save sync log to database
   * Note: Creates a new connection for each log entry. For high-frequency logging,
   * consider passing a database instance to the constructor.
   */
  private async saveSyncLog(log: Omit<ApiSyncLog, 'id' | 'syncedAt'>): Promise<void> {
    try {
      const db = createDb();
      await db.insert(apiSyncLogs).values({
        ...log,
      });
    } catch (error) {
      console.error('Failed to save sync log:', error);
    }
  }

  /**
   * Delay helper
   */
  private delay(ms: number): Promise<void> {
    return new Promise(resolve => setTimeout(resolve, ms));
  }
}

/**
 * Create and configure an OpenFront API poller
 */
export function createPoller(config: ApiPollingConfig): OpenFrontPoller {
  return new OpenFrontPoller(config);
}
