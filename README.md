# aVenture MCP server

Give Claude, ChatGPT, or any MCP client access to aVenture research on private
companies, founders, investors, funding rounds, and news.

The MCP server requires an aVenture account. Free and paid plans both work;
[create an account](https://aventure.vc/sign-up) before you connect.

## Connect to the hosted server

Most clients need no install. Configure your client with:

- URL: `https://mcp.aventure.vc/mcp`
- Transport: Streamable HTTP
- OAuth client ID: `KL7mINzGk0le0QiD`

Then sign in to aVenture in the browser window the client opens.

In Claude or ChatGPT, add the URL as a custom connector. In Claude Code:

```sh
claude mcp add --scope user --transport http \
  --client-id KL7mINzGk0le0QiD --callback-port 6276 \
  aventure https://mcp.aventure.vc/mcp
```

Then run `/mcp`, select `aventure`, and complete sign-in.

Clients that need a redirect URI can use `http://127.0.0.1:<port>/callback`,
`http://localhost:<port>/callback`,
`https://claude.ai/api/mcp/auth_callback`, or
`https://chatgpt.com/connector_platform_oauth_redirect`.

## Ask your first question

Once connected, ask your assistant things like:

- "Look up Stripe on aVenture and summarize its funding history."
- "Which company owns ramp.com, and who founded it?"
- "Find seed-stage climate software companies in Austin."
- "Who is Patrick Collison, and what companies is he connected to?"
- "Find fintech founders who previously worked at PayPal."

The assistant uses these tools:

| Tool | What it does |
| --- | --- |
| `aventure_lookup` | Finds a company or person by name, website, or LinkedIn URL |
| `aventure_search` | Finds companies, people, and news from a description |
| `aventure_read` | Reads a full profile and its funding rounds, people, and news |
| `aventure_help` | Finds the right operation for a task |
| `aventure_status` | Confirms the connection and your sign-in |

## Plans and usage

Profile views, searches, and web searches count toward your plan's monthly
allowance. When an allowance runs out, the tool answer says which limit you reached
and how to upgrade. Ask your assistant to list the plans and prices, or to upgrade
you, and it can do that from the conversation. You can also manage your plan in
[subscription settings](https://aventure.vc/settings/subscription).

## Run the server yourself

Use this when your client cannot complete an OAuth sign-in. The server requires
Node.js 24.18 or later in the 24.x series.

```sh
npm install --global @aventurevc/mcp-server
aventure-mcp-server
```

The server listens at `http://localhost:3333/mcp`. Create a key in
[API key settings](https://aventure.vc/settings/api-keys) and configure your
client to send it with every request:

```json
{
  "mcpServers": {
    "aventure": {
      "type": "http",
      "url": "http://localhost:3333/mcp",
      "headers": {
        "Authorization": "Bearer <your-api-key>"
      }
    }
  }
}
```

Store the key in your client's secret storage, not in a file you commit.

| Setting | What it changes |
| --- | --- |
| `AVENTURE_MCP_PORT` | Listening port (default `3333`) |
| `AVENTURE_MCP_PATH` | MCP route (default `/mcp`) |
| `AVENTURE_MCP_JSON_LIMIT` | Maximum request body size |
| `--host <address>` | Address to bind instead of `127.0.0.1` |

## Documentation

- [MCP quickstart](https://docs.aventure.vc/mcp)
- [Authentication](https://docs.aventure.vc/authentication)
- [Errors](https://docs.aventure.vc/errors)
