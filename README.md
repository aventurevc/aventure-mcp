# aventure-mcp

Public aVenture Streamable HTTP MCP server.

Requires Node.js 24.18 or later in the 24.x series.

## Install and start

```sh
npm install --global @aventurevc/mcp-server --registry=https://registry.npmjs.org/
aventure-mcp-server --help
aventure-mcp-server
```

The server listens at `http://localhost:3333/mcp`. Leave it running while your
MCP client connects. It starts without a static credential; each MCP request needs
a user credential. This package uses Streamable HTTP, so configure a URL instead
of a stdio command.

## Connect with a personal API key

Sign in at [aventure.vc](https://aventure.vc), open **Settings → API keys**,
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

An OAuth-capable MCP client can use the same URL without an `Authorization`
header and follow the sign-in flow advertised by the server's protected-resource
metadata. Use either this flow or the personal-key header for a client registration.

### Codex discovery

Read the public OAuth configuration from
`https://api.aventure.vc/v1/auth/providers`. Use `oauthClient.clientId` and
`oauthClient.redirectUri` for the two placeholders below in your Codex configuration:

```toml
[mcp_servers.aventure]
url = "http://localhost:3333/mcp"

[mcp_servers.aventure.oauth]
client_id = "<oauthClient.clientId>"
callback_url = "<oauthClient.redirectUri>"
```

With the server running, run `codex mcp login aventure` and complete browser
sign-in. Codex discovers the OAuth resource from the endpoint; omit a separate
`oauth_resource` entry.

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
