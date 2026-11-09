# The radar for agents: an MCP server

Any agent that speaks MCP -- Claude Code, an IDE, a desktop assistant -- can ask the radar questions while it works:
what this week asks of a developer, which signals touch a part of the project, one signal in full. The server is
`tools/mcp.haro`, a small read-only program that runs on Haro beside a checkout of the radar.

## What it answers

- **`radar_week`** -- the signals of one week, most pressing first, each with the sentence written for the reader.
  Without a week, the latest surveyed week.
- **`radar_search`** -- signals that match a project, layer, domain or concern of the map, a lowest level, a week, or
  words in the title or summary.
- **`radar_signal`** -- one signal in full: what happened, the sentence for each reader, what was proposed, its sources.
- **`radar_map`** -- the layers, parts, domains and concerns, with the ids the other tools take.

Each tool takes a `reader` (`developer`, `maintainer`, `learner` or `user`) where the answer is written for one.

## What it trusts

- **The signed feed, and nothing else.** It reads `feed/index.json`, the map and `app/config.json` from the checkout.
- **Checked first.** Before it answers anything, `feed/index.json`'s signature must check against
  `keys/allowed_signers` (`ssh-keygen`, as `haro tools/feed.haro verify` does). A feed that fails is not served:
  every tool answers why.
- **Read-only.** It writes no file and calls nothing outside the checkout but `ssh-keygen`.

## Add it to an agent

- **Claude Code**, from any project:

  ```
  claude mcp add softanza-radar -- haro /path/to/stzradar/tools/mcp.haro /path/to/stzradar
  ```

- **Any MCP client**, in its configuration (`.mcp.json` for a project):

  ```json
  { "mcpServers": { "softanza-radar": {
      "command": "haro", "args": ["/path/to/stzradar/tools/mcp.haro", "/path/to/stzradar"] } } }
  ```

- **Keep it current** with `git pull` in the checkout; the server reads the files at start.

## Your own radar

- **The same server serves any watch.** Point it at your own checkout: it takes its name, readers and map from your
  `radar.yaml` (through `app/config.json`) and your key.
- **Name it for your project** in the client's configuration, e.g. `acme-radar`.

## The protocol

- **MCP over standard input and output:** JSON-RPC 2.0, one message per line.
- **Answers** `initialize`, `ping`, `tools/list` and `tools/call`; notifications get no answer.
