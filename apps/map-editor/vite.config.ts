import { defineConfig } from 'vite';

// https://vitejs.dev/config/
export default defineConfig({
  build: {
    target: 'es2020',
    outDir: 'dist',
    sourcemap: true,
    minify: 'esbuild',
    rollupOptions: {
      input: {
        main: './index.html'
      }
    }
  },
  server: {
    port: 3000,
    strictPort: false
  },
  preview: {
    port: 4173
  },
  resolve: {
    alias: {
      // Add any path aliases here if needed
    }
  },
  optimizeDeps: {
    include: ['three', 'lit']
  }
});
