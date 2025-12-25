'use strict';

/**
 * When using the PNPM package manager, you can use pnpmfile.js to workaround
 * dependencies that have mistakes in their package.json file.  (This feature is
 * functionally similar to Yarn's "resolutions".)
 *
 * For details, see the PNPM documentation:
 * https://pnpm.io/pnpmfile#hooks
 *
 * IMPORTANT: SINCE THIS FILE CONTAINS EXECUTABLE CODE, MODIFYING IT IS LIKELY TO INVALIDATE
 * ANY CACHED DEPENDENCY ANALYSIS.  After any modification to pnpmfile.js, it's recommended to run
 * "rush update --full" so that PNPM will recalculate all version selections.
 */
module.exports = {
  hooks: {
    readPackage
  }
};

/**
 * This hook is invoked during installation before a package's dependencies
 * are selected.
 * The `packageJson` parameter is the deserialized package.json
 * contents for the package that is about to be installed.
 * The `context` parameter provides a log() function.
 * The return value is the updated object.
 */
function readPackage(packageJson, context) {

  // // The karma types have a missing dependency on typings from the log4js package.
  // if (packageJson.name === '@types/karma') {
  //  context.log('Fixed up dependencies for @types/karma');
  //  packageJson.dependencies['log4js'] = '0.6.38';
  // }

  // Dynamically inject missing dependencies for openfront-client (git subtree)
  // This keeps most of the upstream package.json pristine while adding only
  // genuinely missing dependencies
  if (packageJson.name === 'openfront-client') {
    // Add missing dependencies that are not in upstream but required for build
    context.log('Adding missing devDependencies for openfront-client');
    packageJson.devDependencies = {
      ...packageJson.devDependencies,
      'glob': '^11.0.0',  // Required by tests/NationNameLength.test.ts
      'lit-html': '^3.3.1'  // Required by src/client/graphics/layers/PlayerInfoOverlay.ts
    };
  }

  return packageJson;
}
