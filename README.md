# aVenture MCP server

Give Claude, ChatGPT, or any MCP client access to aVenture research on private
companies, founders, investors, funding rounds, and news. aVenture hosts the
server, so there is nothing to install.

You need an aVenture account; free and paid plans both work.
[Create an account](https://aventure.vc/sign-up).

## Get started in one step

Paste this into Claude, ChatGPT, Claude Code, or your AI app:

```text
Connect the aVenture MCP server for me.
- URL: https://mcp.aventure.vc/mcp
- Transport: Streamable HTTP
- OAuth client ID: KL7mINzGk0le0QiD
If you can add it yourself (in Claude Code, run
`claude mcp add --scope user --transport http --client-id KL7mINzGk0le0QiD --callback-port 6276 aventure https://mcp.aventure.vc/mcp`),
do that. Otherwise tell me exactly where to enter these settings in this app.
When it's connected and I've signed in, read aVenture's profile for stripe.com to confirm
it works. Docs: https://docs.aventure.vc/mcp
```

## MCP, CLI, or Researchly?

| Where you work | Use |
| --- | --- |
| Claude, ChatGPT, or another desktop, web, or cloud AI app | This MCP server |
| A terminal, shell scripts, or a coding agent with a shell | The [aVenture CLI](https://docs.aventure.vc/cli) |
| [Researchly](https://researchly.chat) | Nothing to install: open [Profile, then MCP servers](https://researchly.chat/profile/mcp-servers) and choose **Connect aVenture** |

## Connect by hand

Add a custom connector (or MCP server) in your app with these settings, then sign
in to aVenture in the browser window it opens:

| Setting | Value |
| --- | --- |
| URL | `https://mcp.aventure.vc/mcp` |
| Transport | Streamable HTTP |
| OAuth client ID | `KL7mINzGk0le0QiD` |

- **Claude and ChatGPT**: add the URL as a custom connector, and enter the client
  ID if the app asks for one.
- **Claude Code**: run the `claude mcp add` command from the prompt above, then run
  `/mcp`, select `aventure`, and sign in.
- **Other clients**: enter the client ID in the OAuth settings. A client that only
  accepts a URL fails with `does not support dynamic client registration`.

## Ask your first question

Looking up a company or person by name, or describing what you want, needs a paid
plan (AI Plus or AI Pro). On the free plan, ask about a company by its website, such
as "Read aVenture's profile for ramp.com."

- "Look up Stripe on aVenture and summarize its funding history."
- "Which company owns ramp.com, and who founded it?"
- "Find seed-stage climate software companies in Austin."
- "Who is Patrick Collison, and which companies is he connected to?"

## Plans and usage

Profile views, web searches, and research requests count toward your plan's monthly
allowance. When one runs out, the answer says which limit you reached and how to
upgrade. Ask your assistant to list aVenture plans with monthly and annual
prices, or to upgrade you. You can also manage your plan in
[subscription settings](https://aventure.vc/settings/subscription).

## Advanced: run the server locally

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
