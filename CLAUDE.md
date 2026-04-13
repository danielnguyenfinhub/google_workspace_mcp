# Google Workspace MCP — CLAUDE.md

## 1. Project Overview
MCP server exposing Gmail, Google Calendar, Drive, and Tasks APIs for Finance Hub operations.
Deployed on Railway at googleworkspacemcp-production-69c0.up.railway.app/mcp.
Primary email routing for all client communications — preferred over native Gmail connector.

## 2. Tech Stack
- Runtime: Node.js 18+ (Python alternative available)
- Framework: MCP SDK
- Transport: Streamable HTTP
- Auth: Google OAuth 2.0
- Scopes: Gmail send/read, Calendar r/w, Drive r/w, Tasks r/w
- Host: Railway (auto-deploy from main branch)
- Env vars: GOOGLE_CLIENT_ID, GOOGLE_CLIENT_SECRET, GOOGLE_REFRESH_TOKEN, PORT

## 3. Conventions
- Gmail send params: from_email = daniel@finhub.net.au | user_google_email = daniel@finhub.net.au | from_name = "Daniel Nguyen" | body_format = "html"
- Email routing: client emails with threading → send_gmail_message | transactional → Mercury send_email | bulk 20 → Mercury send_bulk_email
- Bulk >20 recipients = HARD STOP — do not send without explicit confirmation
- All client emails: AIDA structure + ASIC RG 234 compliant + full signature
- Signature exact: Kind regards, / Daniel Nguyen / Finance Hub and Networks / Mob: 0430 11 11 88 / Email: daniel@finhub.net.au
- Tasks: always set due date — no open tasks without deadline
- Drive: 80+ folder structure — do not create top-level folders without approval

## 4. Files — Never Touch
- .env / .env.production
- railway.toml
- Any file containing GOOGLE_CLIENT_SECRET or GOOGLE_REFRESH_TOKEN
- OAuth token cache files (token.json, credentials.json)
