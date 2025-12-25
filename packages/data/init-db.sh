#!/bin/bash
set -e

# Initialize Supabase-compatible PostgreSQL database
echo "Initializing OpenFront database..."

# Create extensions commonly used by Supabase
psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<-EOSQL
    -- Enable UUID generation
    CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
    
    -- Enable PostGIS for geospatial data (if needed)
    -- CREATE EXTENSION IF NOT EXISTS "postgis";
    
    -- Enable pg_trgm for text search
    CREATE EXTENSION IF NOT EXISTS "pg_trgm";
    
    -- Enable btree_gist for exclusion constraints
    CREATE EXTENSION IF NOT EXISTS "btree_gist";
EOSQL

echo "Database initialization complete."
