# Rayline's ARC: an open 0.8B model that picks the model for each step of an agent; Softanza learns its local-first escalation

```json
{
  "id": "2026-11-12-rayline-arc",
  "date": "2026-11-12",
  "title": "Rayline's ARC: an open 0.8B model that picks the model for each step of an agent; Softanza learns its local-first escalation",
  "kind": "release",
  "summary": "On November 11, 2026 Rayline Labs announced ARC 1.0, an open-weight (Apache 2.0) routing model built on Qwen3.5-0.8B. For each step of an agent it predicts, per candidate model, the probability of success and the tokens the step will bill, then a policy weighs that success against the prices the application supplies; a question head answers developer-defined yes/no, choice and score questions with probabilities. On six benchmarks Rayline reports that ARC, routing between Opus 5.5 and a locally served DeepSeek model, keeps 97.5% of Opus 5.5's quality at 92.9% lower cost.",
  "stance": "learn",
  "relevance": "medium",
  "level": "advice",
  "audiences": ["developer", "maintainer"],
  "notice": {
    "developer": "A small model can decide which model answers each step: ARC predicts success and cost per candidate, and its prefer-local policy keeps a step on your own machine whenever the local model is predicted to succeed.",
    "maintainer": "Softanza's court picks one local model per task from evidence; ARC shows the per-call layer above it, and Softanza measures escalating from a 1B model to a larger local pack only when the small model's own option probability is low."
  },
  "areas": ["softanza", "aicha"],
  "domains": ["models", "agents"],
  "concerns": ["cost", "speed", "correctness", "sovereignty"],
  "actions": [
    { "area": "stzlib.intelligence", "do": "measure local escalation on the support-desk golden sets: Granite-4.0-1b answers by StzOptionProbabilities, and a question whose top option probability falls below a threshold goes to the support-quality pack; first check on the same sets that the top probability is calibrated, then record accuracy and seconds per question against each model alone, across thresholds", "state": "routed", "dates": { "proposed": "2026-11-12", "routed": "2026-11-12" } }
  ],
  "status": "routed",
  "confidence": "claimed",
  "sources": [
    { "title": "rayline-ai/ARC-1.0 (model card)", "url": "https://huggingface.co/rayline-ai/ARC-1.0", "by": "Rayline", "read": "2026-11-12" },
    { "title": "ARC: Learned Model Routing for Long-Horizon Agentic Workflows", "url": "https://rayline.ai/research/report", "by": "Rayline Team", "read": "2026-11-12" },
    { "title": "Rayline", "url": "https://rayline.ai/", "by": "Rayline", "read": "2026-11-12" }
  ],
  "review_by": "2027-02-12",
  "tags": ["rayline", "arc", "model-routing", "decision-models", "slm", "local-first"]
}
```

## What happened

Rayline Labs announced ARC 1.0, the Adaptive Routing Controller, on November 11, 2026, and published its weights on
Hugging Face under Apache 2.0 with a technical report. ARC is a decision model built on Qwen3.5-0.8B: one backbone,
with specialised heads that read its lower twelve layers and a general question head that also uses its fine-tuned
upper twelve. The specialised heads predict, from an agent's conversation so far, whether a candidate model will
succeed at the next step, how many tokens the step will bill (fresh input, cache reads, cache writes, output), how much
reasoning it needs, whether the input holds personal data, and what kind of request it is. The question head answers
yes/no, choice and score questions that a developer writes, each with a probability.

A policy turns those predictions into a choice. Prices, available models and devices, and cache state come from the
application at run time, so the same weights serve public API prices, negotiated rates or self-hosted hardware.
Rayline ships two presets that weigh success against expected cost (Sage values success highly, Swift values cost),
and a prefer-local policy that keeps a step on the local model whenever its predicted success clears a threshold (0.85
in the report) and sends it to the cloud otherwise. Rayline offers hosted generation, a routes API that returns only
the choice, a decisions API for structured answers, and Raydock, an open-source gateway for routing between a device
and the cloud.

The report evaluates six benchmarks, among them DeepSWE, Terminal-Bench 2.1 and GPQA Diamond. ARC Sage matches or beats
Opus 5.5 on five of them at 7% to 58% of its cost; prefer-local, with DeepSeek V4.1 Flash served on NVIDIA DGX Spark
systems, keeps 97.5% of Opus 5.5's quality at 92.9% lower cost. On the chance-corrected Decision Index in the same
card, a general decision model scores higher than ARC's question head. All figures are Rayline's own.

## Why it matters to Softanza

Softanza runs its models on the user's machine, and its model court decides which local model serves each task from
paired evidence on golden sets, against an incumbent that may be a larger pack or a hand-written floor. That choice is
made once per task. ARC shows the layer above it: a
choice made for each call, from a prediction of success and cost, with the prices and devices supplied by the
application at run time, as Softanza's placement reports already take an operating system, a memory size and packs.

Its prefer-local policy is the shape that transfers. Softanza reads a small model's answer by the probability of each
allowed option, and that probability is itself a prediction of success: a 1B model that puts 0.95 on one option is
likely right, one that spreads its weight across three is likely to need help. Escalating only those questions to a
larger local model would give most of the larger model's accuracy at close to the small model's speed, with every step
staying on the machine. Whether the 1B model's probabilities are calibrated enough to serve as the threshold is the
first thing to measure, and the golden sets already hold the answers to measure it against.

ARC also confirms two directions Softanza already takes: one forward pass that answers several typed questions, as in
LFM3's d1 models, and pricing that counts cache reads apart from fresh input, which is what a saved prompt cache earns.

## What we do

- Route to the intelligence plane a measured local escalation from Granite-4.0-1b to the support-quality pack,
  triggered by the small model's own option probability, after a calibration check on the golden sets.
- Look again by 2027-02-12.

## Sources

- Rayline, [rayline-ai/ARC-1.0](https://huggingface.co/rayline-ai/ARC-1.0), read 2026-11-12.
- Rayline Team, [ARC: Learned Model Routing for Long-Horizon Agentic Workflows](https://rayline.ai/research/report),
  read 2026-11-12. Benchmark figures are Rayline's own.
- Rayline, [rayline.ai](https://rayline.ai/), read 2026-11-12.
