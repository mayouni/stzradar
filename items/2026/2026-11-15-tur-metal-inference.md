# Tur serves eight requests from one small model at six times the speed of one by reading the weights once per step; Softanza measures the same rule on its own decoder

```json
{
  "id": "2026-11-15-tur-metal-inference",
  "date": "2026-11-15",
  "title": "Tur serves eight requests from one small model at six times the speed of one by reading the weights once per step; Softanza measures the same rule on its own decoder",
  "kind": "release",
  "summary": "Tur, by Danylo Kravchenko, is an Apache-2.0 inference engine in Rust for Apple Silicon Macs: one binary for generation, an OpenAI-compatible server, Whisper transcription and quantization, on Metal kernels and the Candle framework. Its continuous batching packs every request's next token into one pass, so the weights are read once for all of them: on an M3 Pro, Qwen3.5-0.8B at 8 bits decodes 123 tokens per second for one sequence and 729 for eight, against llama.cpp's 113 and 456. It plans all memory before loading a weight, keeps most experts of a mixture-of-experts model on the SSD behind a fixed cache, reuses shared prefixes, and drafts tokens from the prompt's own text. Figures are the author's.",
  "stance": "learn",
  "relevance": "medium",
  "level": "advice",
  "audiences": ["developer", "maintainer"],
  "notice": {
    "developer": "One decode step of a small model is mostly the time to read its weights from memory. Several sequences decoded in the same step share that read, so total speed grows with the number of sequences while each one slows a little: Tur reports a gap between tokens of 17.4 ms alone and 25.9 ms with eight.",
    "maintainer": "Softanza's decoder holds several models in slots under one memory budget and decodes one sequence at a time. Decoding several independent sequences of one model in one step is the next measure: total tokens per second at 1, 2, 4 and 8 sequences on the processor, with each sequence's text identical to its solo run."
  },
  "areas": ["softanza", "aicha"],
  "domains": ["models", "devices"],
  "concerns": ["speed", "cost"],
  "actions": [
    { "area": "stzlib.intelligence", "do": "decode several independent sequences of one model in one step and measure total tokens per second and the gap between tokens at 1, 2, 4 and 8 sequences on the processor, each sequence's text identical to its solo run; and measure drafting from the prompt's own text, which adds no second model, on a task that copies from its prompt", "state": "routed", "dates": { "proposed": "2026-11-15", "routed": "2026-11-15" } }
  ],
  "status": "routed",
  "confidence": "claimed",
  "sources": [
    { "title": "Tur: local inference with a little muscle", "url": "https://danylokravchenko.github.io/tur/", "by": "Danylo Kravchenko", "read": "2026-11-15" },
    { "title": "Tur benchmarks", "url": "https://danylokravchenko.github.io/tur/benchmarks/", "by": "Danylo Kravchenko", "read": "2026-11-15" },
    { "title": "Tur design: scope", "url": "https://danylokravchenko.github.io/tur/docs/design/scope/", "by": "Danylo Kravchenko", "read": "2026-11-15" },
    { "title": "tur (repository)", "url": "https://github.com/danylokravchenko/tur", "by": "Danylo Kravchenko", "read": "2026-11-15" }
  ],
  "review_by": "2027-02-15",
  "tags": ["inference", "continuous-batching", "apple-silicon", "metal", "rust", "speculative-decoding", "prefix-cache"]
}
```

## What happened

Danylo Kravchenko publishes Tur, an inference engine written in Rust for Apple Silicon Macs under the Apache-2.0
licence. One binary generates text, serves an OpenAI-compatible endpoint, transcribes speech with Whisper and
quantizes models. It runs on the Mac's GPU through Metal, on top of the Candle framework, with a custom kernel only
where the author measured it faster than Candle's. It serves the Qwen3.5, 3.6 and 3.8 families, Gemma 4 and gpt-oss.

Its mechanisms, each with the author's own figure:

- **Continuous batching.** Every request's next token, and pieces of new prompts, go through the model in one pass with
  no padding, so the weights are read once for all of them. On an M3 Pro with 36 GB, Qwen3.5-0.8B at 8 bits decodes
  123, 240, 420 and 729 tokens per second for 1, 2, 4 and 8 sequences; llama.cpp on the same machine gives 113, 172,
  320 and 456. On a 16 GB M1 serving eight clients, the median gap between tokens is 25.9 ms, against 17.4 ms for one.
- **Memory planned before loading.** A configuration that exceeds the machine fails at startup, before a weight is read.
- **Expert cache.** For a mixture-of-experts model, most experts stay on the SSD and enter a fixed cache when routed
  to: 12.8 GiB of weights served on a 16 GB Mac, at 3.3 tokens per second for one request.
- **Prefix reuse.** Eight users sharing a 1,500-token prompt get their first token in 0.56 s, against 9.46 s without.
- **Drafting from the prompt.** Tokens are proposed from the prompt's own text and verified by the model, so the output
  is unchanged: 161.8 tokens per second against 52.8 on repetitive text.
- **Quantization quality, measured.** Against the full-precision model's top token on held-out prose, 8-bit agrees
  98.4% of the time and plain 4-bit rounding 79.7%.

The author also publishes where Tur loses: two prefill cases 1 to 3% behind llama.cpp, a sixteen-client case on the
35B model at 25.7 tokens per second against llama.cpp's 81.4, and a lead over oMLX that ends at two sequences. Tur
serves one chat model per process on Apple Silicon only. The repository shows 73 commits; the pages read name v0.3.0
in an install example.

## Why it matters to Softanza

Softanza's decoder runs small models on the processor, restores a read prompt from disk, and holds several models in
named slots under one memory budget, making room from a file's size before it reads it. Its measured finding matches
Tur's premise: one decode step of a small model is bound by the read of its weights from memory.

Tur shows what follows from that premise. When the read is the cost, several sequences in one step share it, and one
model serves several callers at close to the price of one. For a system built from many small models, each serving
several agents, that is the difference between a queue and a shared pass. Softanza measured drafting with a second
model and found it slower on the processor; drafting from the prompt's own text removes the second model and is worth
its own measurement on tasks that copy from their prompt, such as extraction.

## What we do

- Route to the intelligence plane a measurement of several sequences decoded in one step, and of drafting from the
  prompt's own text.
- Look again by 2027-02-15.

## Sources

- Danylo Kravchenko, [Tur](https://danylokravchenko.github.io/tur/), its
  [benchmarks](https://danylokravchenko.github.io/tur/benchmarks/), its
  [scope](https://danylokravchenko.github.io/tur/docs/design/scope/) and its
  [repository](https://github.com/danylokravchenko/tur), read 2026-11-15. The architecture and measured-performance
  chapters of its book were left unread. All figures are the author's own.
