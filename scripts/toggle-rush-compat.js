#!/usr/bin/env node

const { execSync } = require('child_process');

// Parse command line arguments to find --mode parameter
const args = process.argv.slice(2);
const modeIndex = args.indexOf('--mode');
let mode = 'off'; // default value

if (modeIndex >= 0 && args[modeIndex + 1]) {
  mode = args[modeIndex + 1];
}

// Validate mode
if (mode !== 'on' && mode !== 'off') {
  console.error(`Error: Invalid mode "${mode}". Use 'on' or 'off'`);
  process.exit(1);
}

// Determine which script to run based on platform
const isWindows = process.platform === 'win32';
const script = isWindows
  ? `pwsh scripts/toggle-rush-compat.ps1 ${mode}`
  : `bash scripts/toggle-rush-compat.sh ${mode}`;

try {
  execSync(script, { stdio: 'inherit', cwd: process.cwd() });
} catch (error) {
  console.error(`Failed to execute toggle script: ${error.message}`);
  process.exit(1);
}