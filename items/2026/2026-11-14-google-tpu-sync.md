# Google's TPU Sync moves a model's working memory between chip, host memory, disk and network; Softanza manages its small models' state as one memory budget

```json
{
  "id": "2026-11-14-google-tpu-sync",
  "date": "2026-11-14",
  "title": "Google's TPU Sync moves a model's working memory between chip, host memory, disk and network; Softanza manages its small models' state as one memory budget",
  "kind": "release",
  "summary": "On November 9, 2026 Google Cloud announced TPU Sync, an open-source C++ library with PyTorch and JAX bindings that treats a TPU's on-chip memory, the host's pinned memory, shared storage and the data-centre network as one hierarchy for a model's key-value cache and weights. Tensors keep the chip's own layout at every level and move by direct memory access while the chip computes. In Google's lab test of July 2026 on TPU v7x, serving Qwen3 235B with prefill and decode on separate nodes, the median transfer of the cache fell from several seconds to about 230 ms and time to first token fell by 60% on average; with prefix caching on 64K-token contexts it reports up to 90% lower time to first token.",
  "stance": "learn",
  "relevance": "low",
  "level": "advice",
  "audiences": ["developer", "maintainer"],
  "notice": {
    "developer": "What a model has already read is an asset: stored in the layout the engine computes on, it can leave fast memory and come back without conversion. Keep it by a hash of the text it stands for, and evict the least recently used first.",
    "maintainer": "Softanza's decoder already keeps a read prompt in memory and on disk, keyed by the model's hash; with several small models on one machine it adds the layer above: one memory budget for weights and read prompts, with a measured time to bring each back."
  },
  "areas": ["softanza", "aicha"],
  "domains": ["models", "devices"],
  "concerns": ["speed", "cost"],
  "actions": [
    { "area": "stzlib.intelligence", "do": "measure, for each model of the support-desk set, the time from disk to first token with a cold file, a file already in the system's cache and a restored prefix cache, and the memory each holds when ready; then give the engine one memory budget across loaded models and their prefix caches, evicting the least recently used to disk, and report how many models stay ready within the budget", "state": "routed", "dates": { "proposed": "2026-11-14", "routed": "2026-11-14" } }
  ],
  "status": "routed",
  "confidence": "claimed",
  "sources": [
    { "title": "Introducing TPU Sync: Fast KV cache and weight transfer for inference and RL on TPU", "url": "https://cloud.google.com/blog/topics/ai-infrastructure/introducing-tpu-sync-fast-kv-cache-and-weight-transfer-on-tpu", "by": "Fenghui Zhang, Weiren Yu (Google Cloud)", "read": "2026-11-14" }
  ],
  "review_by": "2027-02-14",
  "tags": ["google", "tpu", "kv-cache", "prefix-cache", "memory-hierarchy", "inference"]
}
```

## What happened

Google Cloud announced TPU Sync on November 9, 2026: a C++ library, published as open source with Python packages for
PyTorch and JAX, for moving a model's live state on Google's TPU accelerators. That state is of two kinds: the
key-value cache, which is what a model keeps of the text it has already read, and the weights themselves during
reinforcement learning. The library connects to vLLM and SGLang through their TPU ports and to llm-d on Google's
Kubernetes service.

Its idea is one hierarchy with four levels: the chip's own memory, the host's pinned memory, shared storage, and the
network between hosts. A tensor keeps the chip's physical layout at every level, so it arrives ready to compute on,
with no serialisation and no conversion. Transfers go by direct memory access while the chip keeps computing, paced so
that they leave the chip's own work on time, at up to 223 GB per second per host. A global store maps the hash of a
prefix to its blocks, evicts the least recently used, and demotes blocks from one level to the next. The storage level
and the reinforcement-learning module are marked experimental.

The figures come from Google's lab test of July 2026 on TPU v7x. Serving Qwen3 235B with reading and writing on
separate nodes, the median transfer of the cache went from several seconds to about 230 ms, time to first token fell by
60% on average, and throughput rose by 30 to 70% under traffic spikes. With a 480-billion-parameter model the fall in
time to first token was 90%. With prefix caching on 64K-token contexts, it reports up to 90% lower time to first token
and over 50% more throughput. All figures are Google's.

## Why it matters to Softanza

Softanza's decoder holds the same asset at the scale of one machine. It keeps the prompt a model has read, reuses the
part a new prompt shares, and saves it to disk under the hash of the model's file; on its support-desk set that turned
six answers from 29.9 seconds into 4.0, and brought a system prompt back from disk in 113 ms.

TPU Sync shows the layer above a single cache. When several models and many read prompts compete for one memory, the
question becomes which of them stays ready, which waits on disk, and how long each takes to return. Google answers with
a store keyed by hash, eviction by recency and demotion between levels. Softanza runs several small models on one
machine, each chosen for its task, and the same three mechanisms decide how many of them can be ready at once: a
model's weights are a file the system can map, a read prompt is a file the decoder can restore, and one budget over
both makes the choice explicit and measurable.

## What we do

- Route to the intelligence plane a measurement of the time and memory each model needs to be ready, and one memory
  budget across loaded models and their read prompts.
- Look again by 2027-02-14.

## Sources

- Fenghui Zhang and Weiren Yu, Google Cloud,
  [Introducing TPU Sync: Fast KV cache and weight transfer for inference and RL on TPU](https://cloud.google.com/blog/topics/ai-infrastructure/introducing-tpu-sync-fast-kv-cache-and-weight-transfer-on-tpu),
  November 9, 2026, read 2026-11-14. Figures are Google's own, from a lab test.
