FROM python:3.11-slim

WORKDIR /app

# Install system dependencies
RUN apt-get update && apt-get install -y \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Install uv for faster dependency management
RUN pip install --no-cache-dir uv

# Copy project files
COPY . .

# Install Python dependencies using uv sync
RUN uv sync --frozen --no-dev --extra disk

# Create credentials directory (writable)
RUN mkdir -p /app/store_creds && chmod 755 /app/store_creds

# Make entrypoint executable
RUN chmod +x /app/docker-entrypoint.sh

# Default environment variables for Railway
ENV WORKSPACE_MCP_CREDENTIALS_DIR=/app/store_creds
ENV OAUTHLIB_INSECURE_TRANSPORT=1
ENV TOOL_TIER=""
ENV TOOLS=""

# Expose port (Railway sets PORT env var)
EXPOSE 8000

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=30s --retries=3 \
    CMD sh -c 'curl -f http://localhost:${PORT:-8000}/health || exit 1'

# Use custom entrypoint that pre-seeds credentials
ENTRYPOINT ["/app/docker-entrypoint.sh"]
