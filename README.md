# aVenture MCP server

Give an AI client access to aVenture's research data on companies, people, funding,
and news through the Model Context Protocol (MCP).

Most clients need no install: connect them to the hosted server at
`https://mcp.aventure.vc/mcp` and sign in with OAuth. Install this package only to
run the server yourself, for example when your client cannot complete an OAuth
sign-in. The [aVenture MCP quickstart](https://docs.aventure.vc/mcp) covers both
paths.

## Connect to the hosted server

Configure your client with these settings:

- URL: `https://mcp.aventure.vc/mcp`
- Transport: Streamable HTTP
- OAuth client ID: `KL7mINzGk0le0QiD`
- Client secret: none; this is a public client

The client discovers the authorization server from the MCP URL and signs in with
authorization code and PKCE. Dynamic client registration is disabled, so enter the
client ID explicitly. A client that accepts only a URL fails with
`does not support dynamic client registration`.

For example, add the server to Claude Code for all your projects:

```sh
claude mcp add --scope user --transport http \
  --client-id KL7mINzGk0le0QiD --callback-port 6276 \
  aventure https://mcp.aventure.vc/mcp
```

Then run `/mcp` in Claude Code, select `aventure`, and complete browser sign-in.

The registered redirect URIs are:

- `http://127.0.0.1/callback`
- `http://localhost/callback`
- `https://chatgpt.com/connector_platform_oauth_redirect`
- `https://claude.ai/api/mcp/auth_callback`

A loopback redirect may use any available port, such as
`http://127.0.0.1:6276/callback`, as long as it keeps the `/callback` path.

To test the sign-in flow without a client, run the MCP Inspector in a terminal,
sign in to aVenture, and approve access. The Inspector lists the tools when sign-in
succeeds.

```sh
npx @modelcontextprotocol/inspector@2.6.0 --cli \
  --server-url https://mcp.aventure.vc/mcp \
  --client-id KL7mINzGk0le0QiD \
  --callback-url http://127.0.0.1:6276/callback \
  --method tools/list
```

## Run the server yourself

The server requires Node.js 24.18 or later in the 24.x series. Installation fails
on any other major version.

```sh
npm install --global @aventurevc/mcp-server --@aventurevc:registry=https://registry.npmjs.org/
aventure-mcp-server
```

The `--@aventurevc:registry` flag makes npm install from the public npm registry
even when your npm configuration maps the `@aventurevc` scope somewhere else. The
package installs the same server under two command names, `aventure-mcp-server`
and `aventure-mcp`.

The server listens at `http://localhost:3333/mcp` and accepts connections from this
computer only. Keep it running while your client is connected. It speaks
Streamable HTTP, not stdio, so configure your client with a URL, not a command.

| Setting | What it changes |
| --- | --- |
| `AVENTURE_MCP_PORT` environment variable | Listening port (default `3333`) |
| `AVENTURE_MCP_PATH` environment variable | MCP route (default `/mcp`) |
| `AVENTURE_MCP_JSON_LIMIT` environment variable | Maximum request body size |
| `--host <address>` option | Network address to bind instead of `127.0.0.1`; `0.0.0.0` exposes the server to your network |

Update the client URL when you change the port or route.

### Authenticate with a personal API key

A self-hosted server has no OAuth sign-in and no credential of its own. Every
request must carry a personal API key as a bearer token.

1. Sign in to aVenture and create a key in
   [aVenture API key settings](https://aventure.vc/settings/api-keys).
2. Store the key in your MCP client's secret storage. Never commit it to a file.
3. Configure the client to send `Authorization: Bearer <personal-api-key>`.

For clients that read an `mcpServers` configuration:

```json
{
  "mcpServers": {
    "aventure": {
      "type": "http",
      "url": "http://localhost:3333/mcp",
      "headers": {
        "Authorization": "Bearer <personal-api-key>"
      }
    }
  }
}
```

Replace `<personal-api-key>` using your client's secret interpolation syntax, which
differs between clients. A request without a key receives status `401`.

## Verify the connection

List the tools, call `aventure_status`, and then call `aventure_help`.

| Tool | What it does |
| --- | --- |
| `aventure_status` | Returns API status, host, and the access your credential carries |
| `aventure_help` | Finds the operation for a task and lists the inputs it needs |
| `aventure_search` | Runs a search operation over companies, people, news, or content |
| `aventure_lookup` | Resolves a name, URL, domain, slug, or other identifier to a record |
| `aventure_read` | Reads one record or the records attached to it |

Accounts with write permission also see `aventure_write` and `aventure_delete`,
which change shared data immediately. The tool list reflects the signed-in
account's permissions, and the API checks permission again on every call.

## Plans and usage

Calls count toward your aVenture plan's usage. Some operations, such as
plain-English search, need a plan that includes them; without one, the API
responds with status `402`.

- Compare plans on the [aVenture pricing page](https://aventure.vc/pricing).
- Check your plan and current usage in
  [aVenture subscription settings](https://aventure.vc/settings/subscription).

## Diagnostics

The server writes diagnostics to standard error. It sends no logs, metrics, or
error reports to aVenture.

## Documentation

- [MCP quickstart](https://docs.aventure.vc/mcp)
- [Authentication guide](https://docs.aventure.vc/authentication)
- [Error reference](https://docs.aventure.vc/errors)
- [API reference](https://docs.aventure.vc/api-reference)

The tool catalog is generated from the public aVenture OpenAPI specification.

## License

Apache License 2.0. See the [LICENSE file](LICENSE).
