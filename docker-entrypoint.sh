#!/bin/sh
set -e

echo "================================================"
echo "  Google Workspace MCP - Railway Entrypoint"
echo "================================================"

# Ensure credentials directory exists and is writable
CREDS_DIR="${WORKSPACE_MCP_CREDENTIALS_DIR:-/app/store_creds}"
mkdir -p "$CREDS_DIR"
echo "Credentials directory: $CREDS_DIR"

# Pre-seed credentials if GOOGLE_REFRESH_TOKEN is provided
# This allows credentials to survive Railway redeploys
if [ -n "$GOOGLE_REFRESH_TOKEN" ] && [ -n "$USER_GOOGLE_EMAIL" ]; then
    CRED_FILE="$CREDS_DIR/${USER_GOOGLE_EMAIL}.json"
    echo "Pre-seeding credentials for $USER_GOOGLE_EMAIL..."
    cat > "$CRED_FILE" << CRED_EOF
{
  "token": null,
  "refresh_token": "$GOOGLE_REFRESH_TOKEN",
  "token_uri": "https://oauth2.googleapis.com/token",
  "client_id": "$GOOGLE_OAUTH_CLIENT_ID",
  "client_secret": "$GOOGLE_OAUTH_CLIENT_SECRET",
  "scopes": null,
  "expiry": null
}
CRED_EOF
    chmod 600 "$CRED_FILE"
    echo "Credentials pre-seeded successfully at $CRED_FILE"
else
    echo "No GOOGLE_REFRESH_TOKEN set - server will require OAuth flow on first use"
fi

# Build the command
CMD="uv run main.py --transport streamable-http --single-user"

# Add optional tool tier
if [ -n "$TOOL_TIER" ]; then
    CMD="$CMD --tool-tier $TOOL_TIER"
fi

# Add optional tools filter
if [ -n "$TOOLS" ]; then
    CMD="$CMD --tools $TOOLS"
fi

echo ""
echo "Starting: $CMD"
echo ""
exec $CMD
