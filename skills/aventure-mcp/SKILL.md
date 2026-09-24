---
name: aventure-mcp
description: Use when connecting an MCP client to aVenture, or when calling aVenture MCP tools to research companies, people, funding, or news.
---

# aVenture MCP server

## Connect

- Prefer the hosted server: URL `https://mcp.aventure.vc/mcp`, transport Streamable
  HTTP, OAuth client ID `KL7mINzGk0le0QiD`, no client secret. The user completes
  browser sign-in. Setup details: https://docs.aventure.vc/mcp
- Self-host only when the client cannot complete OAuth:
  1. Install with `npm install --global @aventurevc/mcp-server --@aventurevc:registry=https://registry.npmjs.org/`
     (requires Node.js 24.18 or later in the 24.x series).
  2. Start `aventure-mcp-server` and keep it running.
  3. Configure the client URL `http://localhost:3333/mcp`. The server speaks
     Streamable HTTP, not stdio.
  4. Send `Authorization: Bearer <personal-api-key>` on every request. The user
     creates the key at https://aventure.vc/settings/api-keys and stores it in the
     client's secret storage. Never print, log, or echo the key.

## Call tools

1. Call `aventure_status` to confirm the connection and the credential's access.
2. Call `aventure_help` with `{ "q": "<task in plain English>", "resolve": true }`.
   It names the tool to call, the method and path, and the inputs the operation
   needs.
3. Call that tool (`aventure_search`, `aventure_lookup`, or `aventure_read`) with the
   `operationId`, or with `method` and `path` exactly as help printed them. Put path
   values in `pathParams`, URL query values in `query`, and body values in `body`.

Never invent an `operationId`, slug, or input name; take them from `aventure_help`
or an earlier result. `aventure_write` and `aventure_delete` appear only for
accounts with write permission and change shared data immediately; call them only
when the user asked for that change.

## Usage

Calls count toward the user's plan usage. A `402` response means the operation
needs a plan that includes it; point the user to https://aventure.vc/pricing and
https://aventure.vc/settings/subscription instead of retrying.
