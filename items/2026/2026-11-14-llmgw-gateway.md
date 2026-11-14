# llmgw puts one gateway in front of an organisation's own GPUs; Softanza learns its priority bands and its residency rule

```json
{
  "id": "2026-11-14-llmgw-gateway",
  "date": "2026-11-14",
  "title": "llmgw puts one gateway in front of an organisation's own GPUs; Softanza learns its priority bands and its residency rule",
  "kind": "release",
  "summary": "llmgw, by Ilker Manap, is a gateway in one Go binary for organisations that run language models on their own GPU clusters: one OpenAI- and Anthropic-compatible endpoint over vLLM, SGLang, llama.cpp and TensorRT-LLM, with tenants, keys, budgets, guardrails, per-tenant knowledge bases and a three-machine high-availability setup. Its README, at version 0.16.3 of November 3, 2026, reports that the gateway adds 0.15 to 0.49 ms at the 99th percentile with authentication and guardrail patterns on, measured on loopback, and that with admission control interactive latency stays within 1.24 times idle while 500 batch requests run, against 58 times without. It is published under the Functional Source License, which becomes Apache 2.0 after two years.",
  "stance": "learn",
  "relevance": "low",
  "level": "advice",
  "audiences": ["developer", "maintainer"],
  "notice": {
    "developer": "When people and background jobs share one model, give each request a priority band and let the low band wait: llmgw reports interactive answers within 1.24 times their idle latency under 500 batch requests, and 58 times without that rule.",
    "maintainer": "Softanza runs its agents and models on the user's own machine, where several agents share one local model; it takes from llmgw two declared rules: a person's request is admitted ahead of background work, and a project marked as resident refuses any model outside, as a fallback too."
  },
  "areas": ["softanza", "aicha"],
  "domains": ["agents", "models", "web"],
  "concerns": ["sovereignty", "speed", "trust", "cost"],
  "actions": [
    { "area": "stzlib.agentic", "do": "declare a priority band for each agent that calls a model, admit a person-facing call ahead of background calls when several agents share one local model, and measure a person's answer time with background agents running, with and without the rule; declare where a solution's model calls may run, refuse a model outside that place as a fallback too, and write the refusal in the run's record", "state": "routed", "dates": { "proposed": "2026-11-14", "routed": "2026-11-14" } }
  ],
  "status": "routed",
  "confidence": "claimed",
  "sources": [
    { "title": "ilker/llmgw (repository and README, v0.16.3)", "url": "https://gitea.mynodes.xyz/ilker/llmgw", "by": "Ilker Manap", "read": "2026-11-14" },
    { "title": "llmgw: what leaves the cluster (docs/data.md)", "url": "https://gitea.mynodes.xyz/ilker/llmgw/raw/branch/main/docs/data.md", "by": "Ilker Manap", "read": "2026-11-14" },
    { "title": "llmgw: guardrails (docs/guardrails.md)", "url": "https://gitea.mynodes.xyz/ilker/llmgw/raw/branch/main/docs/guardrails.md", "by": "Ilker Manap", "read": "2026-11-14" }
  ],
  "review_by": "2027-02-14",
  "tags": ["llmgw", "gateway", "on-premises", "admission-control", "data-residency", "guardrails"]
}
```

## What happened

Ilker Manap, a specialist in high-performance computing, published llmgw: a gateway that an organisation places in
front of the language models it runs on its own GPUs. Applications speak to one endpoint, compatible with the OpenAI
and Anthropic APIs, and the gateway serves them from vLLM, SGLang, llama.cpp or TensorRT-LLM. It is written in Go,
builds to one binary, has 847 commits and 95 releases, and stands at version 0.16.3; version 1.0.0 is its next planned
phase. Its licence, the Functional Source License, allows use and forbids offering it as a competing service; each
release becomes Apache 2.0 two years after publication.

Around that endpoint it keeps what a shared service needs. Organisations, teams, projects and keys form a tree, and
budgets, rate limits and guardrails attach to any branch, the strictest setting winning. Guardrails check input and
output for personal data, secrets and prompt injection, with a small judge model on CPUs for what patterns miss. Each
request leaves one usage record with its key, model, token counts, cost and latency, and no prompt text by default.
A project marked as in-cluster refuses every model served outside, as a fallback and as a canary too. Each request
carries a priority band, and low bands wait at the gateway under load.

The README gives two measurements. The gateway adds 0.15 to 0.49 ms at the 99th percentile with authentication,
accounting and guardrail patterns on, from 100 to 2,000 requests per second, measured on one laptop over loopback with
an instant engine. With admission control, interactive latency at the 99th percentile stays within 1.24 times idle
while 500 batch requests run, against 58 times with admission off. Its author's announcement reports under 0.8 ms on a
multi-node cluster. The README states that multi-node placement is proven on a simulated cluster, and names the
InfiniBand and NVLink paths as the part that awaits a machine that has them. All figures are the author's.

## Why it matters to Softanza

llmgw serves an organisation with racks of GPUs; Softanza serves a person or a team on their own machines. The size
differs and the three questions are the same: who may call a model, whose call goes first, and where a call may run.

The second question arrives early on a small machine. A solution made of many agents shares one local model, and a
person waiting for an answer competes with agents working in the background. llmgw's measurement, 1.24 times idle
against 58 times, is the price of leaving that order to chance, and its remedy is small: a band on each request and a
queue for the low one. Softanza declares each agent in a file that is judged when it loads, so the band belongs in that
declaration.

The third question is one Softanza answers by design, since its models run on the device. llmgw shows the form that
makes the answer checkable: residency is a declared property of a project, a model outside is refused in every role
including fallback, and the refusal is recorded. A solution that states where its model calls may run, and a record
that shows each one did, turn a design choice into evidence a second person can read.

## What we do

- Route to the agents' production side a priority band per agent with a measured effect, and a declared residency
  rule whose refusals are recorded.
- Look again by 2027-02-14, when version 1.0.0 is due.

## Sources

- Ilker Manap, [ilker/llmgw](https://gitea.mynodes.xyz/ilker/llmgw), README at v0.16.3, with
  [docs/data.md](https://gitea.mynodes.xyz/ilker/llmgw/raw/branch/main/docs/data.md) and
  [docs/guardrails.md](https://gitea.mynodes.xyz/ilker/llmgw/raw/branch/main/docs/guardrails.md), read 2026-11-14.
  Figures are the author's own.
- The cluster figure is from the author's public announcement of 2026-11-13.
