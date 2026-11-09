# A prompt library ran any function a template named: tools must come from a registry

```json
{
  "id": "2026-11-08-tool-paths-from-prompts-run-code",
  "date": "2026-11-08",
  "updated": "2026-11-09",
  "title": "A prompt library ran any function a template named: tools must come from a registry",
  "kind": "security",
  "summary": "The Python prompt library banks, up to version 2.4.2, read a tool's import path from the text of a prompt template and imported and called whatever it named when the model asked for that tool (CVE-2026-61536, high). Whoever could write a template, in a shared registry or a fetched prompt, could run code in the application. Version 2.4.3 resolves tools only from a registry filled at render time.",
  "stance": "learn",
  "relevance": "medium",
  "level": "advice",
  "audiences": ["developer", "maintainer"],
  "notice": {
    "developer": "If your agent resolves a tool from a name or path found in a prompt or a config file, resolve it only against a list of tools you registered in code.",
    "maintainer": "Check that every way an agent finds a tool goes through an explicit registry, never through an import or a lookup built from text."
  },
  "areas": ["stzlib", "stzlib.intelligence", "stzlib.security"],
  "domains": ["agents", "security"],
  "concerns": ["trust"],
  "actions": [
    { "area": "stzlib.intelligence", "do": "check that declarative agents resolve their tools only against tools registered in code, and add a guard that a tool named only in the agent's text is refused", "state": "routed", "dates": { "proposed": "2026-11-08", "routed": "2026-11-08" } }
  ],
  "status": "routed",
  "confidence": "read",
  "sources": [
    { "title": "GHSA-64vx-6h2c-rjh7: banks CompletionExtension tool import path", "url": "https://github.com/advisories/GHSA-64vx-6h2c-rjh7", "by": "GitHub Advisory Database", "read": "2026-11-08" },
    { "title": "The fix: resolve tool callables from an explicit registry", "url": "https://github.com/masci/banks/commit/e443f112b80a20ac24438afe4eb8f8a746a8396d", "by": "banks maintainers", "read": "2026-11-08" }
  ],
  "review_by": "2027-02-08",
  "tags": ["agents", "tools", "code-execution", "prompt-templates"]
}
```

## What happened

banks is a Python library for writing prompts as templates. A template can declare the tools a model may call, and
each tool carried an import path. When the model emitted a call to that tool, banks imported the module the path
named, took the function, and called it with the model's arguments. Nothing checked the path. The advisory, published
to the GitHub Advisory Database on November 5, 2026 (CVE-2026-61536, CVSS 7.5), names who could control it: anyone
who can write a template body, for example through a shared prompt registry, files on shared storage, or prompts
fetched over the network. An earlier fix for a sibling flaw did not cover this path.

The fix in 2.4.3 registers each tool's function by name when the template is rendered, looks tools up only in that
registry, no longer imports anything named in text, and stops sending the path to the model.

## Why it matters to Softanza

Softanza has declarative agents: an agent described as text, which names the tools it may use. The pattern that
failed here is general. When text names code and something resolves that name dynamically, whoever writes the text
chooses the code. The cure is equally general, and it is the one the maintainers chose: the text may only pick
among tools that code registered beforehand.

The action asks the owning plane to confirm that Softanza's agents resolve their tools this way, and to keep a guard
that proves a tool named only in text is refused.

## What we do

- Propose to stzlib's intelligence plane, through Central, the check and the guard above.

## Sources

- GitHub Advisory Database, [GHSA-64vx-6h2c-rjh7](https://github.com/advisories/GHSA-64vx-6h2c-rjh7), published there
  on November 5, 2026 (the maintainers' advisory dates from June 26, 2026), read 2026-11-08.
- The fix, [masci/banks@e443f11](https://github.com/masci/banks/commit/e443f112b80a20ac24438afe4eb8f8a746a8396d),
  read 2026-11-08.

## Corrections

- 2026-11-09: the paragraph on Softanza now says what holds and what is proposed, in affirmative sentences; the facts are unchanged.
- 2026-11-09: placed on the estate map, with the domains and concerns it touches; the facts are unchanged.
- 2026-11-09: each proposal now carries the day it reached each stage, read from this repository's history; the facts are unchanged.
