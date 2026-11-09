# A coding agent's "don't ask again" writes secrets into a file that gets published

```json
{
  "id": "2026-11-08-agent-approvals-leak-secrets",
  "date": "2026-11-08",
  "updated": "2026-11-09",
  "title": "A coding agent's \"don't ask again\" writes secrets into a file that gets published",
  "kind": "security",
  "summary": "Apiiro reports that when a Claude Code user approves a command with \"Yes, and don't ask again\", the exact command, including any password or key typed into it, is saved as a permission rule in .claude/settings.local.json inside the project. The file is kept out of git only by the developer's global ignore list, not by the repository's own .gitignore, and Apiiro counted 1,122 public copies on GitHub holding a real secret, out of 104,185.",
  "stance": "defend",
  "relevance": "high",
  "level": "action",
  "audiences": ["developer", "maintainer"],
  "notice": {
    "developer": "Open .claude/settings.local.json in each project you use a coding agent in, delete any rule that contains a password, key or token, and rotate it if the file was ever committed.",
    "maintainer": "Add .claude/settings.local.json to your repository's own .gitignore, and scan agent folders, transcripts and memory files for passwords written inside commands."
  },
  "areas": ["softanza", "stzlib", "stzlib.security", "haro"],
  "domains": ["agents", "security"],
  "concerns": ["trust"],
  "actions": [
    { "area": "stzlib", "do": "add .claude/settings.local.json to the repository's own .gitignore, so the protection travels with the repository and not with one machine", "state": "routed" },
    { "area": "haro", "do": "add .claude/settings.local.json to the repository's own .gitignore, for the same reason", "state": "routed" },
    { "area": "stzlib.security", "do": "add a check for passwords written inside commands (PGPASSWORD=, sshpass -p, mysql -p, bearer headers) over agent settings, transcripts, memory files and handoff notes", "state": "routed" },
    { "area": "softanza", "do": "write the house rule: a secret is referenced as an environment variable in a command, never typed into it", "state": "routed" }
  ],
  "status": "routed",
  "confidence": "read",
  "sources": [
    { "title": "Coding Agents Copy Your Secrets to a Hidden File. Thousands Are on GitHub", "url": "https://apiiro.com/blog/coding-agents-leaking-secrets-github-dont-ask-again", "by": "Apiiro", "read": "2026-11-08" }
  ],
  "review_by": "2027-02-08",
  "tags": ["coding-agents", "secrets", "permissions", "supply-chain"]
}
```

## What happened

On November 5, 2026, the security company Apiiro published a study of a file that Claude Code writes. When the agent
proposes a shell command and the user answers "Yes, and don't ask again", Claude Code saves a permission rule so that
it will not ask again, and the rule is the command string itself. If the command carried a database password, a
cloud key or a token, the secret is now in `.claude/settings.local.json`, in the project folder.

The file is meant to stay on the developer's machine. According to the study, Claude Code adds it to the developer's
global git ignore list when it creates it inside a repository. That does not protect a folder that becomes a
repository later, a clone on another machine, or a file already committed, because the rule is never written into
the repository's own `.gitignore`. Apiiro also traced commits co-authored by the agent itself that changed the file.

Apiiro's counts, from read-only GitHub searches on November 1 to 3, 2026 (their measurement, not ours): 104,185
public copies of the file, of which 1,122 hold a real secret; 2,539 distinct secrets across 1,994 repositories once
file history, the shared `settings.json`, agent transcripts, memory files and handoff notes are included. Two common
secret scanners together missed 215 of the 1,122 files, mostly passwords typed inside commands. Apiiro reproduced
the behaviour with current models and says the cause is the tool's behaviour, not the model's. It reports that
Anthropic is looking into prevention, with secret scanning among the approaches to prototype.

## Why it matters to Softanza

Softanza is built every day with coding agents, across many repositories, several of them public. So this is about
our own practice before it is about anyone else's.

We checked six Softanza repositories on 2026-11-08: none tracks the file, and no local copy holds a line that looks
like a secret. Four of them, this one included, ignore their whole `.claude/` folder in their own `.gitignore`. For
stzlib and Haro the protection comes from the global ignore list of the machine that works on them; one line in each
repository's own `.gitignore` makes it travel with every clone, as the study recommends.

The second lesson reaches further. Softanza keeps memory files, handoff notes and session transcripts on purpose,
because they are how its sessions coordinate. The study found the same leak in all three kinds of file: a secret
typed into a command is recorded wherever an agent records what it ran.

## What we do

- Propose to stzlib and Haro, through Central, a `.gitignore` line for `.claude/settings.local.json`.
- Propose to stzlib's security plane a check for passwords inside commands over agent files, the case key-format
  scanners miss.
- Propose a house rule: a secret is referenced as `$NAME` in a command, never typed into it, so an approved rule
  records the name and not the value.

## Sources

- Apiiro, [Coding Agents Copy Your Secrets to a Hidden File. Thousands Are on GitHub](https://apiiro.com/blog/coding-agents-leaking-secrets-github-dont-ask-again),
  November 5, 2026, read 2026-11-08. First seen as a lead on Hacker News; the entry is written from the post itself.

## Corrections

- 2026-11-09: the paragraph on Softanza now says what holds and what is proposed, in affirmative sentences; the facts are unchanged.
- 2026-11-09: placed on the estate map, with the domains and concerns it touches; the facts are unchanged.
