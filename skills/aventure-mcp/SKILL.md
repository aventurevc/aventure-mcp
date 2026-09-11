# aventure-mcp

Configure the public aVenture MCP server over Streamable HTTP.

1. Install with `npm install --global @aventurevc/mcp-server --registry=https://registry.npmjs.org/`.
2. Run `aventure-mcp-server --help`, then keep `aventure-mcp-server` running.
3. Configure the MCP client URL as `http://localhost:3333/mcp`.
4. Authenticate through OAuth, or send `Authorization: Bearer <personal-api-key>`.
   Obtain a personal key from aventure.vc under Settings → API keys → Add new key.
   Use the client's secret storage and never print the key.
5. List tools, call `aventure_status`, and use `aventure_help` to find permitted operations.

The server starts without static credentials. Ordinary users see read tools;
explicit permissions govern mutations. The public package keeps diagnostics local
and disables OTLP, Prometheus, and Sentry reporting.

See the repository README for a complete client configuration example.
