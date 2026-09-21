# aventure-mcp

Configure the public aVenture MCP server over Streamable HTTP.

An OAuth-capable client should use the hosted server instead of installing this
package: https://docs.aventure.vc/mcp. The steps below self-host it for a client
that cannot complete OAuth.

1. Install with `npm install --global @aventurevc/mcp-server --@aventurevc:registry=https://registry.npmjs.org/`.
2. Run `aventure-mcp-server --help`, then keep `aventure-mcp-server` running.
3. Configure the MCP client URL as `http://localhost:3333/mcp`.
4. Send `Authorization: Bearer <personal-api-key>` on every request. Create the key
   at https://aventure.vc/settings/api-keys. Use the client's secret storage and
   never print the key.
5. List tools, call `aventure_status`, and use `aventure_help` to find permitted operations.

The server starts without static credentials. Ordinary users see read tools;
explicit permissions govern mutations. The public package keeps diagnostics local
and disables OTLP, Prometheus, and Sentry reporting.

See the repository README for a complete client configuration example.
