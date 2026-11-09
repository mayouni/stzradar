# Two MCP clients let a malicious server obtain a token meant for another server

```json
{
  "id": "2026-11-08-mcp-oauth-resource-check",
  "date": "2026-11-08",
  "updated": "2026-11-09",
  "title": "Two MCP clients let a malicious server obtain a token meant for another server",
  "kind": "security",
  "summary": "Two advisories published on November 5, 2026 describe the same flaw in two MCP clients, the Go SDK mcp-go before 1.2.1 and the ChatCLI agent before 1.215.2: the client took the resource named in a server's protected resource metadata without checking that it matched the server it had connected to. A malicious MCP server could name another server on the same authorization server, have the user sign in, and replay the token it received.",
  "stance": "defend",
  "relevance": "medium",
  "level": "advice",
  "audiences": ["developer", "maintainer"],
  "notice": {
    "developer": "If you use mcp-go or ChatCLI, update to mcp-go 1.2.1 or ChatCLI 1.215.2, and only sign in to MCP servers you chose yourself.",
    "maintainer": "An MCP client must check that the resource a server declares is the server URL it connected to before it asks for a token."
  },
  "areas": ["stzlib", "haro"],
  "domains": ["agents", "security"],
  "concerns": ["trust"],
  "actions": [
    { "area": "stzlib", "do": "record as a requirement for any MCP client Softanza builds: the declared resource is checked against the configured server URL before a token is requested, with a guard that a mismatching server is refused", "state": "routed" }
  ],
  "status": "routed",
  "confidence": "read",
  "sources": [
    { "title": "GHSA-h3x9-8c36-m89w: mcp-go OAuth protected resource metadata not validated", "url": "https://github.com/advisories/GHSA-h3x9-8c36-m89w", "by": "GitHub Advisory Database", "read": "2026-11-08" },
    { "title": "GHSA-2gm2-hpg7-78f2: ChatCLI MCP OAuth resource indicator", "url": "https://github.com/advisories/GHSA-2gm2-hpg7-78f2", "by": "GitHub Advisory Database", "read": "2026-11-08" },
    { "title": "MCP specification 2026-07-28: Authorization", "url": "https://modelcontextprotocol.io/specification/2026-07-28/basic/authorization", "by": "Model Context Protocol", "read": "2026-11-08" }
  ],
  "review_by": "2027-02-08",
  "tags": ["mcp", "oauth", "agents", "tokens"]
}
```

## What happened

When an MCP client meets a server that needs authorization, it reads the server's protected resource metadata,
which names the resource the token is for, and asks the authorization server for a token for that resource. The two
advisories (CVE-2026-123272 for mcp-go, CVE-2026-123271 for ChatCLI, both CVSS 5.1, unreviewed by GitHub at the time
of reading) say both clients used the declared resource as given. A malicious server could declare a different,
legitimate server as its resource; the user's sign-in then produced a token valid there, which the malicious server
received and could replay. The fixes check the declared resource against the server URL the client was configured
with.

We also read the current MCP authorization specification. It requires a client to send the server's canonical URI as
the resource in authorization and token requests, and to check the authorization server's issuer. In the pages we
read, it does not state the comparison of the declared resource with the server URL as a separate requirement. That
is our reading of the pages, not a statement from the specification's authors.

## Why it matters to Softanza

Softanza's developers use MCP clients every day through their coding agents, and Softanza may build its own client.
We propose it as a requirement for every MCP client Softanza builds: the declared resource is checked against the
configured server URL, with a guard that proves a mismatching server is refused. It costs one sentence and one guard.

## What we do

- Propose to stzlib, through Central, the requirement and the guard above, for any MCP client it builds.

## Sources

- GitHub Advisory Database, [GHSA-h3x9-8c36-m89w](https://github.com/advisories/GHSA-h3x9-8c36-m89w) and
  [GHSA-2gm2-hpg7-78f2](https://github.com/advisories/GHSA-2gm2-hpg7-78f2), published November 5, 2026, read 2026-11-08.
- Model Context Protocol, [Authorization, revision 2026-07-28](https://modelcontextprotocol.io/specification/2026-07-28/basic/authorization),
  with its pages on server discovery and security considerations, read 2026-11-08.

## Corrections

- 2026-11-09: the paragraph on Softanza now says what holds and what is proposed, in affirmative sentences; the facts are unchanged.
- 2026-11-09: placed on the estate map, with the domains and concerns it touches; the facts are unchanged.
