# aventure-mcp

Public aVenture Streamable HTTP MCP server. Most clients need no install: the
[MCP quickstart](https://docs.aventure.vc/mcp) connects them to the hosted server
at `https://mcp.aventure.vc/mcp`. Self-host with this package when your client
cannot complete an OAuth flow.

Requires Node.js 24.18 or later in the 24.x series.

## Install and start

```sh
npm install --global @aventurevc/mcp-server --@aventurevc:registry=https://registry.npmjs.org/
aventure-mcp-server --help
aventure-mcp-server
```

The server listens at `http://localhost:3333/mcp`. Leave it running while your
MCP client connects. It starts without a static credential; each MCP request needs
a user credential. This package uses Streamable HTTP, so configure a URL instead
of a stdio command.

## Connect with a personal API key

Sign in, open [aventure.vc/settings/api-keys](https://aventure.vc/settings/api-keys),
and choose **Add new key**. Store the key in your MCP client's secret storage.
The HTTP request must carry `Authorization: Bearer <personal-api-key>`.

For clients supporting `mcpServers` URL configuration:

```json
{
  "mcpServers": {
    "aventure": {
      "url": "http://localhost:3333/mcp",
      "headers": {
        "Authorization": "Bearer <personal-api-key>"
      }
    }
  }
}
```

Replace the placeholder through your client's credential configuration; its secret
interpolation syntax may differ.

## Authenticate with native OAuth

Connect to the hosted server at `https://mcp.aventure.vc/mcp` with an
OAuth-capable client and leave the client ID and secret empty. The client
discovers the authorization server from the MCP endpoint, registers itself,
and signs you in with authorization code and PKCE. Every call runs with your
aVenture account's permissions.

In Claude or ChatGPT, add the URL as a custom connector. In Claude Code:

```sh
claude mcp add --scope user --transport http aventure https://mcp.aventure.vc/mcp
```

## Verify access

Connect the client, list its tools, and call `aventure_status`, then `aventure_help`.
The tool list reflects the permissions granted to the signed-in user. The API checks
permission again when an operation runs.

Set `AVENTURE_MCP_PORT` or `AVENTURE_MCP_PATH` to change the listener and update
the client URL to match.

## Diagnostics

The public package writes diagnostics to stderr. OTLP logs, Prometheus metrics,
and Sentry reporting are disabled.

The tool catalog is generated from the public aVenture OpenAPI spec.
