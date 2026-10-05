# aVenture MCP Server

Give Claude, ChatGPT, or any MCP client access to aVenture research on private
companies, founders, investors, funding rounds, and news. aVenture hosts the
server, so there is nothing to install.

You need an aVenture account; free and paid plans both work.
[Create an account](https://aventure.vc/sign-up).

## Get Started in One Step

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
When it's connected and I've signed in, call aventure_status, then read aVenture's
profile for stripe.com to confirm it works. Docs: https://docs.aventure.vc/mcp
```

## MCP, CLI, or Researchly?

| Where you work | Use |
| --- | --- |
| Claude, ChatGPT, or another desktop, web, or cloud AI app | This MCP server |
| A terminal, shell scripts, or a coding agent with a shell | The [aVenture CLI](https://docs.aventure.vc/cli) |
| [Researchly](https://researchly.chat) | Nothing to install: open [Profile, then MCP servers](https://researchly.chat/profile/mcp-servers) and choose **Connect aVenture** |

## Connect by Hand

Add a custom connector (or MCP server) in your app with these settings, then sign
in to aVenture in the browser window it opens:

| Setting | Value |
| --- | --- |
| URL | `https://mcp.aventure.vc/mcp` |
| Transport | Streamable HTTP |
| OAuth client ID | Leave blank for dynamic registration; otherwise `KL7mINzGk0le0QiD` |

- **Claude and ChatGPT**: add the URL as a custom connector. Leave client fields
  blank when the app supports the advertised dynamic registration flow. If it
  requires a pre-registered client, enter the client ID under advanced settings.
- **Claude Code**: run the `claude mcp add` command from the prompt above, then run
  `/mcp`, select `aventure`, and sign in.
- **Other clients**: follow the app's OAuth setup. URL-only clients can use the
  advertised registration endpoint; clients requiring pre-registration use the
  client ID above.

## If Sign-In Fails

- `does not support dynamic client registration`: enter the client ID above in
  the client's OAuth settings.
- `401` on a server that worked before: the sign-in expired. Reconnect the server
  in your client; in Claude Code, run `/mcp`, select `aventure`, and sign in.
- More fixes: [MCP troubleshooting](https://docs.aventure.vc/mcp#troubleshooting).

## Ask Your First Question

Looking up a company or person by name, or describing what you want, needs a paid
plan (AI Plus or AI Pro). On the free plan, ask about a company by its website, such
as "Read aVenture's profile for ramp.com."

- "Look up Stripe on aVenture and summarize its funding history."
- "Which company owns ramp.com, and who founded it?"
- "Find seed-stage climate software companies in Austin."
- "Who is Patrick Collison, and which companies is he connected to?"

## Plans and Usage

Profile views, web searches, and research requests count toward your plan's monthly
allowance. When one runs out, the answer says which limit you reached and how to
upgrade. Ask your assistant to list aVenture plans with monthly and annual
prices, or to upgrade you. You can also manage your plan in
[subscription settings](https://aventure.vc/settings/subscription).

## Advanced: Run the Server Locally

Most people never need this. Run the server yourself only when your client can't
complete an OAuth sign-in or you need it inside your own network. It requires
Node.js 24.18.0 or later.

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
