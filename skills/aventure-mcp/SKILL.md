---
name: aventure-mcp
description: Use when connecting an MCP client to aVenture, or when calling aVenture MCP tools to research companies, people, funding, or news.
---

# aVenture MCP server

## Connect

The MCP server requires an aVenture account (free or paid). If the user has none,
point them to https://aventure.vc/sign-up.

- Prefer the hosted server: URL `https://mcp.aventure.vc/mcp`, transport Streamable
  HTTP, OAuth client ID `KL7mINzGk0le0QiD`. The user completes
  browser sign-in. Setup details: https://docs.aventure.vc/mcp
- Self-host only when the client cannot complete OAuth:
  1. Install with `npm install --global @aventurevc/mcp-server`
     (requires Node.js 24.18 or later in the 24.x series).
  2. Start `aventure-mcp-server` and keep it running.
  3. Configure the client URL `http://localhost:3333/mcp`. The server speaks
     Streamable HTTP, not stdio.
  4. Send `Authorization: Bearer <api-key>` on every request. The user
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

## Usage limits

Profile views, searches, and web searches count toward the user's monthly plan
allowance. A `429` with code `billing_allowance_exhausted` means the user reached
it; do not retry. Tell the user which limit they reached, then offer to upgrade:
ask `aventure_help` for the billing plan list, show each plan's monthly and annual
price, and after the user confirms, run the plan change (paid plans, card on file)
or create a checkout session (free plan) and give the user the returned link. The
user can also upgrade at https://aventure.vc/settings/subscription.
