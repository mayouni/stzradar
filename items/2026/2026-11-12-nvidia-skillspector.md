# NVIDIA SkillSpector scans an agent skill before it is installed; Softanza checks its agent files the same way

```json
{
  "id": "2026-11-12-nvidia-skillspector",
  "date": "2026-11-12",
  "title": "NVIDIA SkillSpector scans an agent skill before it is installed; Softanza checks its agent files the same way",
  "kind": "release",
  "summary": "NVIDIA SkillSpector is an open-source (Apache 2.0) scanner for the skills that coding agents such as Claude Code, Codex CLI and Gemini CLI install, at v2.13.4 on November 4, 2026. It checks a skill from a directory, a file, a zip, a URL or a Git repository against 71 patterns in 17 categories, among them prompt injection, data exfiltration, excessive agency, memory poisoning and MCP tool poisoning, first by static analysis and optionally by a language model, and reports a 0-100 risk score in terminal, JSON, Markdown or SARIF. Its README cites a study of 31,132 marketplace skills in which 26.1% held at least one vulnerability and 5.2% showed likely malicious intent.",
  "stance": "learn",
  "relevance": "medium",
  "level": "advice",
  "audiences": ["developer", "maintainer"],
  "notice": {
    "developer": "A skill your coding agent installs runs with its trust; scan it first with SkillSpector's static mode, which needs no model and no key.",
    "maintainer": "A Softanza agent file is data that may come from a colleague or a model; Softanza checks its text for the same risks SkillSpector names, and Radar shows the scan before any install it suggests."
  },
  "areas": ["softanza", "aicha", "radar"],
  "domains": ["agents", "security"],
  "concerns": ["trust"],
  "actions": [
    { "area": "stzlib.security", "do": "check a .pia agent file at load for the risks SkillSpector names that apply to it (instructions that override the agent's role, endpoints that could carry data out, tools beyond the declared task, MCP servers with broader rights than needed), reported in the unified rule shape through stzRuleReport beside the existing function and posture refusals", "state": "routed", "dates": { "proposed": "2026-11-12", "routed": "2026-11-12" } },
    { "area": "radar", "do": "show a SkillSpector static scan before every skill install a Radar lesson suggests", "state": "done", "dates": { "proposed": "2026-11-12", "done": "2026-11-12" } }
  ],
  "status": "routed",
  "confidence": "read",
  "sources": [
    { "title": "NVIDIA/SkillSpector (README)", "url": "https://github.com/NVIDIA/SkillSpector", "by": "NVIDIA", "read": "2026-11-12" },
    { "title": "SkillSpector releases (v2.13.4)", "url": "https://github.com/NVIDIA/SkillSpector/releases", "by": "NVIDIA", "read": "2026-11-12" }
  ],
  "review_by": "2027-02-12",
  "tags": ["nvidia", "skillspector", "agent-skills", "supply-chain", "scanner"]
}
```

## What happened

NVIDIA publishes SkillSpector, an open-source scanner for agent skills, under Apache 2.0; its latest release is
v2.13.4, dated November 4, 2026. A skill is a folder of instructions, and often scripts, that a coding agent installs
and then follows with the agent's own trust. SkillSpector answers one question before installation: is this skill
safe to install?

It reads a skill from a local directory, a single `SKILL.md`, a zip, a URL or a Git repository, and checks it against
71 patterns in 17 categories: prompt injection, data exfiltration, privilege escalation, supply chain, excessive
agency, output handling, system-prompt leakage, memory poisoning, tool misuse, rogue agents, anti-refusal, trigger
abuse, dangerous code found by syntax tree, taint tracking, YARA signatures, MCP least privilege and MCP tool
poisoning. A fast static stage runs alone with `--no-llm`; an optional second stage asks a language model, hosted or
local, to judge meaning. It caps downloads and archives and fails closed when a cap is reached, looks up known
vulnerabilities in OSV.dev, and writes a 0-100 risk score with findings as terminal text, JSON, Markdown or SARIF for
continuous integration. NVIDIA uses it in its Verified Skills pipeline, which scans, evaluates and signs skills
before they enter NVIDIA's skills catalog.

The README grounds the need in a study it cites, "Agent Skills in the Wild" (Liu et al., 2026): of 42,447 skills
collected from marketplaces, 31,132 were analysed, 26.1% held at least one vulnerability, 5.2% showed likely malicious
intent, and skills with executable scripts were 2.12 times more likely to be vulnerable. Those figures are the study's,
as the README reports them.

## Why it matters to Softanza

Softanza's declarative agents have the same shape as a skill: a `.pia` file is data, and it may come from a folder, a
colleague or a language model composing agents. Softanza already treats it that way where it matters most: code, not
the file, decides which functions an agent may call and under which posture, and a file asking for more is refused at
load. SkillSpector's categories show what else such a file can carry in its text, where a function list cannot see
it: instructions that try to override the agent's role, an endpoint that could carry data out, tools beyond the task,
an MCP server with broader rights than the task needs. Checking those at load, in the rule shape Softanza's other
checks already report in, completes the refusal it has.

Radar applies the lesson to itself today. The lesson written yesterday for A2UI suggested installing a skill in one
command; it now shows the scan first, and every lesson that suggests an install will.

## What we do

- Propose to stzlib's security plane a text-level check of agent files at load, in the unified rule shape.
- Show a SkillSpector static scan before every skill install a Radar lesson suggests: done with this entry.
- Look again by 2027-02-12.

## Sources

- NVIDIA, [NVIDIA/SkillSpector](https://github.com/NVIDIA/SkillSpector) and its
  [releases](https://github.com/NVIDIA/SkillSpector/releases), read 2026-11-12. The study figures are cited from the
  README.
