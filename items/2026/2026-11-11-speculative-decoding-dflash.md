# NVIDIA ships a small drafter with each new model and speeds up llama.cpp; Softanza takes the algorithm into its own decoder

```json
{
  "id": "2026-11-11-speculative-decoding-dflash",
  "date": "2026-11-11",
  "title": "NVIDIA ships a small drafter with each new model and speeds up llama.cpp; Softanza takes the algorithm into its own decoder",
  "kind": "practice",
  "summary": "On September 3, 2026 NVIDIA said its work with the llama.cpp and vLLM communities gives up to 1.9 times higher local throughput on a GeForce RTX 5090, from GPU kernel work, better speculative decoding and faster prefill. Since then its new models ship with a small DFlash drafter, which llama.cpp's official server runs, and its open-source C++ runtime TensorRT Edge-LLM (0.11.1, October 28) added the Bolt E4B drafter and TensorRT for RTX on Windows. Most of the speed comes from CUDA code for NVIDIA's newest GPUs; the speculative-decoding algorithm itself is portable.",
  "stance": "correct",
  "relevance": "high",
  "level": "advice",
  "audiences": ["maintainer"],
  "notice": {
    "maintainer": "Softanza's decoder keeps its CPU and wgpu paths and measures speculative decoding with a small drafter of the same tokenizer, against its recorded 17.6 tokens per second decode."
  },
  "areas": ["softanza"],
  "domains": ["models", "code"],
  "concerns": ["speed", "sovereignty", "cost"],
  "actions": [
    { "area": "stzlib", "do": "measure speculative decoding in the engine's Zig decoder (a small drafter proposes several tokens, the main model checks them in one pass), with a drafter that shares the main model's tokenizer, against the recorded Qwen2.5-Coder-1.5B decode of 17.6 tokens per second on the CPU", "state": "routed", "dates": { "proposed": "2026-11-11", "routed": "2026-11-11" } },
    { "area": "stzlib", "do": "record the upstream ggml commit Softanza's vendored copy came from, so each later ggml improvement can be judged against it", "state": "routed", "dates": { "proposed": "2026-11-11", "routed": "2026-11-11" } }
  ],
  "status": "routed",
  "confidence": "claimed",
  "sources": [
    { "title": "Sparks Fly: NVIDIA Accelerates Local AI at IFA 2026", "url": "https://blogs.nvidia.com/blog/local-ai-ifa-next-gen-agents-nv-pair-rtx-spark/", "by": "NVIDIA", "read": "2026-11-11" },
    { "title": "TensorRT Edge-LLM releases (0.11.0 and 0.11.1)", "url": "https://github.com/NVIDIA/TensorRT-Edge-LLM/releases", "by": "NVIDIA", "read": "2026-11-11" },
    { "title": "NVIDIA-Nemotron-3.5-Bolt-E4B-4GB (model card, quick start with the DFlash drafter)", "url": "https://huggingface.co/nvidia/NVIDIA-Nemotron-3.5-Bolt-E4B-4GB", "by": "NVIDIA", "read": "2026-11-11" }
  ],
  "review_by": "2027-01-11",
  "tags": ["nvidia", "llama-cpp", "ggml", "speculative-decoding", "inference"]
}
```

## What happened

At IFA on September 3, 2026, NVIDIA announced faster local inference from its collaboration with the open-source
llama.cpp and vLLM projects: up to 1.9 times higher throughput for llama.cpp on a GeForce RTX 5090, credited to
kernel optimisations, enhanced speculative decoding and faster prefill, and 1.2 to 1.4 times for vLLM on its
workstation and DGX Spark systems. The same post announced PAIR, a free, open-source router that spreads local
inference requests across the PCs of a home network.

Speculative decoding has since become part of how NVIDIA ships a model. A small drafter guesses the next several
tokens and the main model checks them all in one pass, keeping only what it would have written itself, so the answer
is unchanged and arrives sooner. Nemotron 3.5 Bolt E4B and Nemotron 3.5 Parse each come with a DFlash drafter, and
the Bolt card's quick start runs it in llama.cpp's official CUDA server. NVIDIA's open-source C++ runtime for edge
devices, TensorRT Edge-LLM, added DFlash2 drafting in 0.11.0 (September 29) and, in 0.11.1 (October 28), the Bolt
E4B drafter and engine building on Windows through TensorRT for RTX. The speed figures are NVIDIA's.

## Why it matters to Softanza

Softanza runs its models through its own decoder, written in Zig over a copy of ggml built for the CPU, with large
matrix products sent to the GPU through wgpu. Its model-flow design chose that path on purpose: a CUDA backend would
make every Softanza application ship NVIDIA's runtime libraries and run only on NVIDIA hardware. So NVIDIA's CUDA
kernels and TensorRT runtimes stay outside Softanza, and the 1.9 times does not arrive by updating a dependency.

The algorithm does arrive. Decoding is where a small model spends its time on a laptop (17.6 tokens per second
recorded for Qwen2.5-Coder-1.5B on the CPU), and speculative decoding speeds it up on any hardware without changing
a single output token. Softanza already holds small models of the same tokenizer family that can draft for larger
ones. The stance is to correct: take the idea, and build it the way Softanza builds, in its own decoder, measured.

Recording which upstream ggml commit the vendored copy came from belongs to the same work: it is the reference
against which every later ggml improvement, NVIDIA's included, is judged.

## What we do

- Propose to stzlib a measured speculative decoder in the engine, against the recorded baseline.
- Propose to stzlib the upstream ggml commit, recorded beside the vendored copy.
- Look again by 2027-01-11.

## Sources

- NVIDIA, [Sparks Fly: NVIDIA Accelerates Local AI at IFA 2026](https://blogs.nvidia.com/blog/local-ai-ifa-next-gen-agents-nv-pair-rtx-spark/),
  September 3, 2026, read 2026-11-11.
- NVIDIA, [TensorRT Edge-LLM releases](https://github.com/NVIDIA/TensorRT-Edge-LLM/releases), 0.11.0 and 0.11.1, read
  2026-11-11.
- NVIDIA, [Nemotron 3.5 Bolt E4B model card](https://huggingface.co/nvidia/NVIDIA-Nemotron-3.5-Bolt-E4B-4GB), quick
  start with the DFlash drafter, read 2026-11-11.
