# NVIDIA Snapshot restores a warmed-up GPU inference worker in seconds; Softanza saves the warm state it pays for, a read prompt

```json
{
  "id": "2026-11-11-nvidia-snapshot",
  "date": "2026-11-11",
  "updated": "2026-11-12",
  "title": "NVIDIA Snapshot restores a warmed-up GPU inference worker in seconds; Softanza saves the warm state it pays for, a read prompt",
  "kind": "release",
  "summary": "On November 8, 2026 NVIDIA released Snapshot v0.3.0, an open-source (Apache 2.0) Kubernetes system that checkpoints a fully initialised GPU inference pod, CPU and GPU memory together, and restores it on another node instead of starting it again. It combines CRIU for the process with NVIDIA's cuda-checkpoint for the GPU, and works with vLLM, SGLang and TensorRT-LLM. On NVIDIA's own B200 tests, restore was 8.1 to 35.9 times faster than a cold start across 22 configurations, for example 4.7 seconds against 104 seconds for Qwen3-0.6B on vLLM.",
  "stance": "correct",
  "relevance": "medium",
  "level": "advice",
  "audiences": ["developer", "maintainer"],
  "notice": {
    "developer": "Restoring a warm process beats rebuilding it; for a small local model the warm state worth keeping is the prompt the model has already read, which can be saved and reloaded.",
    "maintainer": "Softanza loads a small model in 0.2 to 1.3 seconds, so its cost is reading long fixed prompts; it measures saving a prefilled KV cache and restoring it against prefilling again."
  },
  "areas": ["softanza", "aicha"],
  "domains": ["models", "agents"],
  "concerns": ["speed", "cost"],
  "actions": [
    { "area": "stzlib.intelligence", "do": "save the KV cache of a prefilled fixed prompt (system instructions, examples, a document) to disk, keyed by the model's sha256 and the prompt's tokens, and restore it instead of prefilling; measure restore time against the recorded 38.5 tokens per second CPU prefill, and check the next-token probabilities are identical", "state": "done", "dates": { "proposed": "2026-11-11", "routed": "2026-11-11", "done": "2026-11-11" } }
  ],
  "status": "done",
  "confidence": "claimed",
  "sources": [
    { "title": "ai-dynamo/snapshot (README)", "url": "https://github.com/ai-dynamo/snapshot", "by": "NVIDIA", "read": "2026-11-11" },
    { "title": "Snapshot v0.3.0 release notes", "url": "https://github.com/ai-dynamo/snapshot/releases", "by": "NVIDIA", "read": "2026-11-11" },
    { "title": "Snapshot performance", "url": "https://github.com/ai-dynamo/snapshot/blob/main/docs/overview/performance.md", "by": "NVIDIA", "read": "2026-11-11" },
    { "title": "NVIDIA Dynamo Snapshot: Fast Startup for Inference Workloads on Kubernetes", "url": "https://developer.nvidia.com/blog/nvidia-dynamo-snapshot-fast-startup-for-inference-workloads-on-kubernetes/", "by": "NVIDIA", "read": "2026-11-11" }
  ],
  "review_by": "2027-01-11",
  "tags": ["nvidia", "snapshot", "cold-start", "checkpoint", "kv-cache", "inference"]
}
```

## What happened

NVIDIA published Snapshot as a project of its own, `ai-dynamo/snapshot`, under Apache 2.0; v0.3.0 is dated November 8,
2026, and NVIDIA's product team announced it publicly on November 10. Snapshot checkpoints a GPU pod once it is fully
initialised (weights in GPU memory, CUDA initialised, kernels compiled and tuned, graphs captured) and restores that
state on any node with the same GPU and driver, so the process resumes where it was paused. CRIU saves the process
tree, NVIDIA's cuda-checkpoint saves the GPU state, and an operator with a privileged agent on each node drives both
through Kubernetes resources. Snapshots live on shared storage or, since v0.3.0, in an S3-compatible store.

A workload makes itself snapshot-ready by a small contract: it releases its KV cache, signals that it is safe to
checkpoint, and waits for the restore to finish before reconnecting to the world. vLLM has merged that contract as
its own checkpoint and restore endpoints, and TensorRT-LLM the memory management it relies on. NVIDIA tested 22
configurations of vLLM, SGLang and TensorRT-LLM on one to eight B200 GPUs: restore was 8.1 to 35.9 times faster than a
cold start, from 4.7 seconds against 104 for Qwen3-0.6B on vLLM to about 29 seconds against 394 for GLM-5.3 on eight
GPUs. The figures are NVIDIA's own, on its hardware and storage. The project lists Linux on x86_64 or arm64, NVIDIA
GPUs and one node per workload.

## Why it matters to Softanza

Snapshot answers a cost that Softanza's design avoids. Most of the 104 seconds a GPU serving engine spends starting
Qwen3-0.6B goes to compiling kernels, tuning them and capturing graphs; Softanza runs its small models through its own
decoder on a CPU build of ggml, with no compilation step, and its measured load-swap between models is 0.2 to 1.3
seconds. Snapshot itself is a Kubernetes and data-centre tool, and Softanza applications run on the user's machine.

The idea transfers all the same: keep the warm state you paid for, and restore it instead of rebuilding it. For
Softanza the expensive warm state is a read prompt. On this estate's laptop, Qwen2.5-Coder-1.5B prefills at 38.5
tokens per second on the CPU, so a fixed 1,000-token instruction costs about 26 seconds every time a flow starts, while
its KV cache for that prefix is tens of megabytes that a disk returns in a fraction of a second. The engine already
keeps the KV cache between the turns of one conversation; saving it to disk for a fixed prefix, keyed by the model and
the exact tokens, carries the same saving across runs, agents and restarts. It pairs with the shared-prefill reading
proposed from LFM3's decision models: read once, answer many times.

The stance is to correct: take Snapshot's principle at Softanza's scale, where the warm state is a prompt and not a
process, and measure it.

## What we do

- Propose to the intelligence plane a saved and restored prefix KV cache, measured against prefilling, with identical
  next-token probabilities as the check.
- Look again by 2027-01-11.

## Sources

- NVIDIA, [ai-dynamo/snapshot](https://github.com/ai-dynamo/snapshot), its
  [v0.3.0 release notes](https://github.com/ai-dynamo/snapshot/releases) and its
  [performance page](https://github.com/ai-dynamo/snapshot/blob/main/docs/overview/performance.md), read 2026-11-11.
- NVIDIA, [NVIDIA Dynamo Snapshot: Fast Startup for Inference Workloads on Kubernetes](https://developer.nvidia.com/blog/nvidia-dynamo-snapshot-fast-startup-for-inference-workloads-on-kubernetes/),
  May 27, 2026, read 2026-11-11.

## Corrections

- 2026-11-12: the proposals are routed to their desks; the facts are unchanged.
- 2026-11-12: the proposal was built and measured on 2026-11-11. Softanza keeps a read prompt in memory and on disk with
  logits equal to the bit: six tickets behind a 113-token system turn answered in 4.0 s instead of 29.9 s on
  Nemotron 3.5 Bolt E4B, and the turn restored from disk in 113 ms instead of about 4.3 s of reading.
