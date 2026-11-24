# Microsoft announces seven MAI models at Ignite, among them a coding model priced against GPT-6.1 Sol and Claude Opus 5.5 and a routing model built on Gemma 4; Softanza states the price basis of every comparison and measures its own router

```json
{
  "id": "2026-11-24-microsoft-mai-ignite",
  "date": "2026-11-24",
  "title": "Microsoft announces seven MAI models at Ignite, among them a coding model priced against GPT-6.1 Sol and Claude Opus 5.5 and a routing model built on Gemma 4; Softanza states the price basis of every comparison and measures its own router",
  "kind": "release",
  "summary": "At Ignite on November 17, 2026, Microsoft AI announced seven models: MAI Code 2 and MAI Code 2 Flash for coding, MAI Cyber 2 Flash for security defence, MAI Image 2.7 and MAI Image 2.7 Flash, MAI Realtime 1 for live speech to speech, and Microsoft Decision 1.1 for routing requests inside applications. Microsoft states that MAI Code 2 reaches 98% of GPT-6.1 Sol's performance at 40% of the cost and 96% of Claude Opus 5.5's at 5%, averaged over four coding benchmarks, with MAI Code 2's cost taken at its 50% promotional price. MAI Realtime 1 is priced at $0.01 per audio minute. Decision 1.1 is built on Gemma 4 26B A4B and is described as 50 times faster and 79 times cheaper than GPT-6.1 Sol. The coding models are in GitHub Copilot; none of the seven is released as open weights. The figures are Microsoft's own.",
  "stance": "watch",
  "relevance": "medium",
  "level": "advice",
  "audiences": ["developer", "maintainer"],
  "notice": {
    "developer": "A model priced at a fraction of another is a claim about two things: the score and the price. Microsoft's 5% of Claude Opus 5.5's cost uses MAI Code 2's promotional price, half its list price; read the footnote before the headline.",
    "maintainer": "A large lab now sells a routing model, built on an open model, as a product of its own. Softanza routes with its court, by measured results per task. The court's own figures as a router, cost per decision and cost per correct answer, are the comparison this release invites."
  },
  "areas": ["aicha", "agents"],
  "domains": ["models", "code"],
  "concerns": ["cost", "sovereignty"],
  "actions": [
    {"area": "stzlib.intelligence", "do": "measure the court's choice of model on the bench as a router: its cost per decision, the share of tasks where it picks the model that scores best, and the cost per correct answer against always running the single best model; and state in every published cost comparison whether the price is a list price", "state": "routed", "dates": {"proposed": "2026-11-24", "routed": "2026-11-24"}}
  ],
  "status": "routed",
  "confidence": "claimed",
  "sources": [
    {"title": "Seven new world-class models at scalable price-performance", "url": "https://microsoft.ai/news/microsoft-ignite-2026/", "by": "Microsoft AI", "read": "2026-11-24"},
    {"title": "Introducing MAI Code 2 and MAI Code 2 Flash", "url": "https://microsoft.ai/news/introducing-mai-code-2-and-mai-code-2-flash/", "by": "Microsoft AI", "read": "2026-11-24"},
    {"title": "Introducing MAI Cyber 2 Flash", "url": "https://microsoft.ai/news/introducing-mai-cyber-2-flash/", "by": "Microsoft AI", "read": "2026-11-24"},
    {"title": "Introducing MAI Image 2.7", "url": "https://microsoft.ai/news/introducing-mai-image-2-7/", "by": "Microsoft AI", "read": "2026-11-24"},
    {"title": "Introducing MAI Realtime 1", "url": "https://microsoft.ai/news/introducing-mai-realtime-1/", "by": "Microsoft AI", "read": "2026-11-24"},
    {"title": "MAI Code 2 and MAI Code 2 Flash in GitHub Copilot", "url": "https://github.blog/changelog/2026-11-17-mai-code-2-and-mai-code-2-flash-in-github-copilot/", "by": "GitHub", "read": "2026-11-24"}
  ],
  "review_by": "2027-02-24",
  "tags": ["microsoft", "mai", "ignite", "coding-models", "model-routing", "speech", "pricing"]
}
```

## What happened

Microsoft AI announced seven models at Ignite in San Francisco on November 17, 2026:

| model | for | Microsoft's figures |
|---|---|---|
| MAI Code 2 | demanding agentic coding | 98% of GPT-6.1 Sol's performance at 40% of the cost; 96% of Claude Opus 5.5's at 5% |
| MAI Code 2 Flash | everyday coding at volume | comparable to GPT-6 Luna and Claude Haiku 5.5 at 65% and 20% of the cost |
| MAI Cyber 2 Flash | security defence | 92.3% on CyberGym-E2E against 91.5% for GPT-6 Astra; $0.10 / $0.50 per million tokens in / out |
| MAI Image 2.7 | image generation and editing | first on AA-Image-Editing v2.1 (1,215 Elo); about $35 per 1,000 images |
| MAI Image 2.7 Flash | images at volume | about $10 per 1,000 images |
| MAI Realtime 1 | live speech to speech | $0.01 per audio minute, reasoning billed apart |
| Microsoft Decision 1.1 | routing requests inside applications | 68 on the Artificial Analysis Decision Index v2.1; built on Gemma 4 26B A4B |

**How the coding figures are made.** Performance is a score averaged over DeepSWE 1.1, Terminal Bench 2.1, SWE-Atlas
and FrontierCode v1.1, every model at maximum reasoning effort; three of the four ran on Microsoft's internal
evaluation platform through the GitHub Copilot CLI. MAI Code 2's cost is taken at its 50% promotional price. Microsoft
writes that the models are tuned for everyday work rather than the hardest or longest agentic tasks.

**Where they run.** Both coding models are in GitHub Copilot, billed by use; MAI Code 2 Flash also on the free plan.
MAI Cyber 2 Flash runs inside Microsoft's security products. The image models and Decision 1.1 are offered through
Foundry and other platforms; MAI Realtime 1 is in a limited preview. A customer can run a model's weights inside its
own Azure environment under MAI Licensed Weights; the weights are not published.

A press summary of the event listed MAI Transcribe 2 among the seven: Microsoft launched it on September 3, 2026. A
widely shared photo of a slide naming MAI Image-2.5, Transcribe-1.5, Thinking-1, Voice-2 and Code-1-Flash comes from
Microsoft Build in June 2026.

## Why it matters to Softanza

Two lines of this release bear on Softanza. Microsoft now sells routing, the choice of which model answers a request,
as a model of its own, built on an open model and priced as a fraction of a frontier one. Softanza routes with its
court, which chooses a model for each kind of task by measured results on its own bench; the release invites the same
figures for the court: what a decision costs, how often it picks the best model, and the cost of each correct answer.
And the headline price ratios rest on a promotional price stated in a footnote. Softanza's own comparisons state
the price basis beside every ratio.

## What we do

- Route to the intelligence plane the court's figures as a router, and a price basis for every cost comparison.
- Look again by 2027-02-24, when the promotional price has ended.

## Sources

- Microsoft AI, [the Ignite announcement](https://microsoft.ai/news/microsoft-ignite-2026/) and the pages of
  [MAI Code 2](https://microsoft.ai/news/introducing-mai-code-2-and-mai-code-2-flash/),
  [MAI Cyber 2 Flash](https://microsoft.ai/news/introducing-mai-cyber-2-flash/),
  [MAI Image 2.7](https://microsoft.ai/news/introducing-mai-image-2-7/) and
  [MAI Realtime 1](https://microsoft.ai/news/introducing-mai-realtime-1/), November 17, 2026, and GitHub's
  [changelog](https://github.blog/changelog/2026-11-17-mai-code-2-and-mai-code-2-flash-in-github-copilot/), read
  2026-11-24 through a summarising reader. Microsoft's Book of News was read in part. All figures are Microsoft's own.
