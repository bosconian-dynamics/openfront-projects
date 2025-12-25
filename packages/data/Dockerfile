# Supabase-compatible PostgreSQL database
# Based on official PostgreSQL image with extensions commonly used by Supabase
FROM postgres:16-alpine

# Install required extensions for Supabase compatibility
RUN apk add --no-cache \
    postgresql-contrib \
    build-base \
    git

# Set environment variables with defaults
# These can be overridden at runtime
ENV POSTGRES_DB=${POSTGRES_DB:-openfront}
ENV POSTGRES_USER=${POSTGRES_USER:-postgres}
ENV POSTGRES_PASSWORD=${POSTGRES_PASSWORD:-postgres}
ENV POSTGRES_HOST=${POSTGRES_HOST:-localhost}
ENV POSTGRES_PORT=${POSTGRES_PORT:-5432}

# Expose PostgreSQL port
EXPOSE 5432

# Add initialization scripts directory
RUN mkdir -p /docker-entrypoint-initdb.d

# Copy initialization script
COPY init-db.sh /docker-entrypoint-initdb.d/

# Set proper permissions
RUN chmod 755 /docker-entrypoint-initdb.d/init-db.sh

# Use the default postgres entrypoint
CMD ["postgres"]
