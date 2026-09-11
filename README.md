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

Connect to the hosted server at `https://mcp.aventure.vc/mcp` with an
OAuth-capable client. Configure the public client ID `KL7mINzGk0le0QiD`;
no client secret is required. The client discovers the authorization server
from the MCP endpoint and uses authorization code with PKCE. Dynamic client
registration is disabled.

The registered redirect URIs are:

- `http://127.0.0.1/callback`
- `http://localhost/callback`
- `https://chatgpt.com/connector_platform_oauth_redirect`
- `https://claude.ai/api/mcp/auth_callback`

Loopback redirects may use an available port, such as
`http://127.0.0.1:6276/callback`; keep the `/callback` path. A client using
another callback path needs its own registered OAuth application.

For example, MCP Inspector 2.6.0 supports these settings:

```sh
npx @modelcontextprotocol/inspector@2.6.0 --cli \
  --server-url https://mcp.aventure.vc/mcp \
  --client-id KL7mINzGk0le0QiD \
  --callback-url http://127.0.0.1:6276/callback \
  --method tools/list
```

Run it in an interactive terminal, sign in to aVenture, and approve access.
The Inspector exchanges the authorization code and lists the MCP tools.

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
