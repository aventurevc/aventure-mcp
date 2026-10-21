# aVenture MCP Server

Give Claude, ChatGPT, Cursor, or any MCP client aVenture data on private
companies, founders, investors, funding rounds, and news. aVenture hosts the
server; you sign in with your aVenture account.

## Connect by Pasting One Prompt

Paste this into Claude, ChatGPT, Claude Code, or your AI app:

```text
Connect the aVenture MCP server for me.
- URL: https://mcp.aventure.vc/mcp
- Transport: Streamable HTTP
- OAuth: leave client fields blank when the app supports dynamic registration;
  use client ID KL7mINzGk0le0QiD when it requires a pre-registered client.
If you can add it yourself (in Claude Code, run
`claude mcp add --scope user --transport http --client-id KL7mINzGk0le0QiD --callback-port 6276 aventure https://mcp.aventure.vc/mcp`),
do that. Otherwise tell me exactly where to enter these settings in this app.
When it's connected and I've signed in, read aVenture's profile for stripe.com
to confirm it works. Docs: https://docs.aventure.vc/mcp
```

## Connect by Hand

1. In Claude, ChatGPT, or Cursor, open the settings for custom connectors (MCP
   servers).
2. Add the aVenture server: URL `https://mcp.aventure.vc/mcp`, transport
   Streamable HTTP.
3. Leave the OAuth client fields blank when the app supports dynamic
   registration; enter client ID `KL7mINzGk0le0QiD` when it requires a
   pre-registered client.
4. Sign in to aVenture in the browser window that opens.

Claude Code: run
`claude mcp add --scope user --transport http --client-id KL7mINzGk0le0QiD --callback-port 6276 aventure https://mcp.aventure.vc/mcp`,
then `/mcp`, select `aventure`, and sign in.

Other MCP clients: follow the app's OAuth setup. URL-only clients can use the
advertised registration endpoint; clients requiring pre-registration use the
client ID from step 3. In Claude and ChatGPT, the client ID goes under advanced
settings.

## Free vs. Paid

- Free account: 25 company and 25 person profile reads a month and 20 name
  lookups a day. [Create an account](https://aventure.vc/sign-up).
- AI Plus, $49/mo: plain-English questions, competitor and investor-activity
  questions, 500 company and 500 person profile reads, and 30 company and 30
  person research requests a month. [Get AI Plus](https://aventure.vc/pricing).

## MCP, CLI, or Researchly?

| Where you work | Use |
| --- | --- |
| Claude, ChatGPT, or another desktop, web, or cloud AI app | This MCP server |
| A terminal, shell scripts, or a coding agent with a shell | The [aVenture CLI](https://docs.aventure.vc/cli) |
| [Researchly](https://researchly.chat) | Open [Profile, then MCP servers](https://researchly.chat/profile/mcp-servers) and choose **Connect aVenture** |

## If Sign-In Fails

- `does not support dynamic client registration`: enter the client ID above in
  the client's OAuth settings.
- `401` on a server that worked before: the sign-in expired. Reconnect the server
  in your client; in Claude Code, run `/mcp`, select `aventure`, and sign in.
- More fixes: [MCP troubleshooting](https://docs.aventure.vc/mcp#troubleshooting).

## Ask Your First Question

- "Read aVenture's profile for ramp.com."
- "Look up Stripe on aVenture and summarize its funding history."
- "Who is Patrick Collison, and which companies is he connected to?"
- "Which company owns ramp.com, and who founded it?"
- "Find seed-stage climate software companies in Austin."

## Plans and Usage

Profile views, web searches, and research requests count toward your plan's monthly
allowance. When one runs out, the answer says which limit you reached and how to
upgrade. Ask your assistant to list aVenture plans with monthly and annual
prices, or to upgrade you. You can also manage your plan in
[subscription settings](https://aventure.vc/settings/subscription).

## Advanced: Run the Server Locally

Run the server yourself only when your client can't complete an OAuth sign-in or
you need it inside your own network. It requires Node.js 24.18.0 or later.

```sh
npm install --global @aventurevc/mcp-server
aventure-mcp-server
```

The server listens at `http://localhost:3333/mcp`, which only clients on the same
machine can reach; a cloud app such as ChatGPT cannot. Create a key in
[API key settings](https://aventure.vc/settings/api-keys) and have your client send
it with every request:

```json
{
  "mcpServers": {
    "aventure": {
      "type": "http",
      "url": "http://localhost:3333/mcp",
      "headers": { "Authorization": "Bearer <your-api-key>" }
    }
  }
}
```

Store the key in your client's secret storage, not in a file you commit.
`AVENTURE_MCP_PORT` and `AVENTURE_MCP_PATH` change the port and route.

## Documentation

- [MCP quickstart](https://docs.aventure.vc/mcp)
- [Authentication and plans](https://docs.aventure.vc/authentication)
- [Errors](https://docs.aventure.vc/errors)
