# A list of 14 agent repositories said to be SpaceXAI's overlooked Grok toolkit, checked on GitHub: all 14 exist, Grok Build's Rust coding agent has 27,910 stars, and the published Grok prompts were last changed in November 2025

```json
{
  "id": "2026-11-28-grok-toolkit-list-checked",
  "date": "2026-11-28",
  "title": "A list of 14 agent repositories said to be SpaceXAI's overlooked Grok toolkit, checked on GitHub: all 14 exist, Grok Build's Rust coding agent has 27,910 stars, and the published Grok prompts were last changed in November 2025",
  "kind": "practice",
  "summary": "A widely shared post lists 14 GitHub repositories as a free Grok toolkit that almost nobody opened. Checked on GitHub on 2026-11-28, all 14 exist. Seven belong to xai-org, SpaceXAI's organisation: grok-build, the Rust source of its terminal coding agent (Apache 2.0, opened 2026-07-14, 27,910 stars), synced from the company's monorepo with a SOURCE_REV file naming the commit; grok-build-plugin-cc, a Claude Code plugin that hands reviews and tasks to the grok CLI (Apache 2.0); plugin-marketplace (no licence file); the Python and TypeScript SDKs (Apache 2.0); xai-cookbook; and grok-prompts (AGPL 3.0, 4,686 stars), whose system prompts were last changed on 2025-11-17. The other seven are third-party projects, among them orca (MIT, 143,324 stars), OpenHands (MIT, 94,494), litellm and MetaGPT. Grok Build installs by piping a script from x.ai into a shell, or builds from source.",
  "stance": "watch",
  "relevance": "low",
  "level": "advice",
  "audiences": ["developer", "learner"],
  "notice": {
    "developer": "Grok Build is a vendor's coding agent with its Rust source in the open and the monorepo commit recorded beside it; read it as a reference harness. Check a list before acting on it: the published Grok prompts are a year old, and one repository in the list carries no licence.",
    "learner": "Posts that list many tools often add claims nobody checked. Here every link was real, but the tools were not overlooked, and the prompts called 'the real ones' had not changed for a year."
  },
  "areas": ["agents", "radar"],
  "domains": ["agents", "code"],
  "concerns": ["trust", "correctness"],
  "status": "analysed",
  "confidence": "read",
  "sources": [
    {"title": "xai-org on GitHub", "url": "https://github.com/xai-org", "by": "SpaceXAI", "read": "2026-11-28"},
    {"title": "grok-build", "url": "https://github.com/xai-org/grok-build", "by": "SpaceXAI", "read": "2026-11-28"},
    {"title": "grok-build-plugin-cc", "url": "https://github.com/xai-org/grok-build-plugin-cc", "by": "SpaceXAI", "read": "2026-11-28"},
    {"title": "grok-prompts", "url": "https://github.com/xai-org/grok-prompts", "by": "SpaceXAI", "read": "2026-11-28"}
  ],
  "review_by": "2027-02-28",
  "tags": ["coding-agents", "grok", "open-source", "prompts", "verification", "licensing"]
}
```

## What happened

A post shared on LinkedIn on November 28, 2026 presents 14 GitHub repositories as SpaceXAI's free Grok toolkit,
"almost nobody opened", that turn a chat bot into a software company. Radar checked each one on GitHub the same day.

| repository | owner | licence | opened | stars |
|---|---|---|---|---|
| grok-build | xai-org | Apache 2.0 | 2026-07-14 | 27,910 |
| grok-prompts | xai-org | AGPL 3.0 | 2025-05-15 | 4,686 |
| xai-cookbook | xai-org | not stated by GitHub | 2025-02-23 | 677 |
| xai-sdk-python | xai-org | Apache 2.0 | 2025-06-09 | 634 |
| plugin-marketplace | xai-org | no licence file | 2026-05-15 | 374 |
| grok-build-plugin-cc | xai-org | Apache 2.0 | 2026-07-10 | 291 |
| xai-sdk-ts | xai-org | Apache 2.0 | 2026-08-26 | 78 |
| orca | stablyai | MIT | 2026-03-17 | 143,324 |
| OpenHands | OpenHands | MIT | 2024-03-13 | 94,494 |
| MetaGPT | FoundationAgents | MIT | 2023-06-30 | 71,508 |
| litellm | BerriAI | not stated by GitHub | 2023-07-27 | 64,067 |
| OpenMausBot | milind-soni | Apache 2.0 | | 28,704 |
| happy | slopus | MIT | 2025-07-18 | 24,880 |
| suparagent | Anil-matcha | Apache 2.0 | | 7,199 |

- **Grok Build** is SpaceXAI's terminal coding agent: it edits files, runs commands, searches the web and runs
  headless for scripts or inside editors through the Agent Client Protocol. The repository holds its Rust source,
  synced from the company's monorepo, with a SOURCE_REV file naming the monorepo commit. Prebuilt binaries install by
  piping a script from x.ai into a shell.
- **grok-build-plugin-cc** is a Claude Code plugin that calls the grok CLI to review, critique or take over a task.
- **grok-prompts** holds the system prompts of Grok 3, Grok 4 and Grok 4.1 and of the @grok bot on X, with safety
  prompts; its last change is dated 2025-11-17.

## Why it matters to Softanza

Softanza's agents work under declared rules, and Radar reads every claim before it reaches a desk. The list's links
are real and its framing is not: the tools are among the most starred agent projects, and the prompts it calls the
real ones are a year old. What stands is useful: a vendor's coding agent published as source with its monorepo
commit recorded, and a plugin that lets one vendor's agent hand review to another's.

## What we do

- No action. Look again by 2027-02-28.

## Sources

- The repositories above, read through GitHub's API on 2026-11-28: their metadata, the READMEs of grok-build and
  grok-build-plugin-cc, and the file list and commit history of grok-prompts.
