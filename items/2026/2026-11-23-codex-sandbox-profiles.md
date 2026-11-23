# OpenAI describes the sandbox of its coding agent: rules by the operating system, a tool server outside them by default, and deny patterns read once at start; Softanza checks its own rules at each access

```json
{
  "id": "2026-11-23-codex-sandbox-profiles",
  "date": "2026-11-23",
  "title": "OpenAI describes the sandbox of its coding agent: rules by the operating system, a tool server outside them by default, and deny patterns read once at start; Softanza checks its own rules at each access",
  "kind": "practice",
  "summary": "On November 18, 2026 OpenAI published an engineering account of the sandbox in Codex, its coding agent. Shell commands run under the operating system's own mechanisms: Seatbelt on macOS, bubblewrap with seccomp-bpf on Linux, and a Microsoft sandbox on Windows. The built-in workspace profile allows writes inside the workspace, keeps the .git and .codex folders read-only, and closes the network; an optional proxy applies allow and deny rules by domain. The article states three bounds in its own words: a tool server started over standard input and output runs outside the sandbox by default, deny patterns are expanded when the sandbox starts so a file created later is outside them, and name lookups can carry data out.",
  "stance": "learn",
  "relevance": "medium",
  "level": "advice",
  "audiences": ["developer", "maintainer"],
  "notice": {
    "developer": "A rule expanded once protects the files that existed at that moment. A file created afterwards is a new name, so a rule that must hold is decided each time a file is opened.",
    "maintainer": "Softanza decides a path or a command at the moment an agent asks for it. OpenAI's account names two places worth a guard of their own: a forbidden file created after the rules load, and a tool server started for an agent, which should run inside the agent's bounds."
  },
  "areas": ["security", "agents"],
  "domains": ["agents", "security", "code"],
  "concerns": ["trust"],
  "actions": [
    {"area": "stzlib.security", "do": "add a guard that creates a forbidden file after the rules are loaded and shows the agent is refused it, and run a tool server started for an agent under the same file and network bounds as the agent, with one measured call", "state": "routed", "dates": {"proposed": "2026-11-23", "routed": "2026-11-23"}}
  ],
  "status": "routed",
  "confidence": "claimed",
  "sources": [
    {"title": "Inside the Codex sandbox", "url": "https://openai.com/index/inside-the-codex-sandbox/", "by": "Michael Bolin (OpenAI)", "read": "2026-11-23"}
  ],
  "review_by": "2027-02-23",
  "tags": ["openai", "codex", "sandbox", "coding-agents", "mcp", "permissions"]
}
```

## What happened

OpenAI's Michael Bolin described on November 18, 2026 how Codex confines the commands its agent runs. It uses what
each operating system already provides, in place of containers: Seatbelt on macOS, bubblewrap with a seccomp-bpf
filter on Linux, and a sandbox from Microsoft on Windows. A permission profile names what a command may do. The
built-in workspace profile lets a command write inside the workspace, keeps the `.git` and `.codex` folders
read-only, and closes the network. A proxy can open the network by domain.

The account is precise about its own bounds:

- **A tool server runs outside the sandbox by default.** A server started over standard input and output is an
  ordinary process; the article shows how to wrap one in a profile with the network closed.
- **Deny patterns are read once.** They are expanded into a list of files when the sandbox starts, so a file created
  later that matches a pattern is outside the rule.
- **A name lookup is a way out.** With the network proxied, the lookup of a host name can still carry data.

The same week's release of Codex, 0.171.0, blocks one more system call in its Linux network filter and adds routing
of all connections through the proxy as an option.

## Why it matters to Softanza

Softanza's governed agent asks before each act: a path, a command, a network call is decided when it is asked for,
and a boundary outside the process applies the same decisions to the operating system. OpenAI's account gives two
precise tests for any such design. The first is time: does a rule hold for a file that appears after the rules were
loaded. The second is reach: does the rule cover the helper processes an agent starts, a tool server among them.
Each is a guard of a few lines, and each turns a design statement into a measured fact.

## What we do

- Route to the security side a guard for a forbidden file created after the rules load, and a tool server run inside
  the agent's own bounds.
- Look again by 2027-02-23.

## Sources

- Michael Bolin, OpenAI, [Inside the Codex sandbox](https://openai.com/index/inside-the-codex-sandbox/),
  November 18, 2026, read 2026-11-23. The release notes of Codex 0.171.0 were read on its releases page.
