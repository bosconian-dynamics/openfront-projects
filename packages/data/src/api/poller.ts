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
 * OpenFront API Poller class
 */
export class OpenFrontPoller {
  private config: ApiPollingConfig;
  private intervalId?: NodeJS.Timeout;

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
    if (this.intervalId) {
      console.warn('Polling is already running');
      return;
    }

    console.log('Starting OpenFront API polling...');
    
    // Initial poll
    this.pollAll();

    // Set up interval polling
    this.intervalId = setInterval(() => {
      this.pollAll();
    }, this.config.pollInterval);
  }

  /**
   * Stop polling
   */
  stop(): void {
    if (this.intervalId) {
      clearInterval(this.intervalId);
      this.intervalId = undefined;
      console.log('Stopped OpenFront API polling');
    }
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
    for (let attempt = 0; attempt < this.config.retryAttempts!; attempt++) {
      try {
        const response = await fetch(url, {
          headers: {
            'Content-Type': 'application/json',
            ...(this.config.apiKey && { 'Authorization': `Bearer ${this.config.apiKey}` }),
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
        
        if (attempt < this.config.retryAttempts! - 1) {
          console.log(`Retry ${attempt + 1} for ${endpoint} after ${this.config.retryDelay}ms`);
          await this.delay(this.config.retryDelay!);
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
