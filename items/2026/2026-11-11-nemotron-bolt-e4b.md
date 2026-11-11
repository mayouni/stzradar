# NVIDIA's Nemotron 3.5 Bolt E4B: a 4 GB model for local agents; Softanza adds its Gemma 4 family and takes it to the model court

```json
{
  "id": "2026-11-11-nemotron-bolt-e4b",
  "date": "2026-11-11",
  "title": "NVIDIA's Nemotron 3.5 Bolt E4B: a 4 GB model for local agents; Softanza adds its Gemma 4 family and takes it to the model court",
  "kind": "release",
  "summary": "On October 23, 2026 NVIDIA released Nemotron 3.5 Bolt E4B, a small language model post-trained by reinforcement learning from Google's Gemma 4 E4B for multi-turn tool use, instruction following and grounding. It has 8 billion parameters, 4 billion of them effective, a 64K-token context, and ships as a 4 GB Q4_K_M GGUF file for llama.cpp with a companion DFlash drafter for speculative decoding. Its weights, training data and recipes are published under the OpenMDW-1.1 licence, and NVIDIA's own benchmark table puts it ahead of Gemma 4 E4B on most of 21 agent and instruction tests.",
  "stance": "adopt",
  "relevance": "high",
  "level": "advice",
  "audiences": ["developer", "maintainer"],
  "notice": {
    "developer": "A 4 GB open model tuned for tool calls and short answers now runs locally through llama.cpp; Softanza tests it on its own golden sets before it offers it.",
    "maintainer": "Bolt E4B uses the Gemma 4 architecture, so Softanza's engine adds that decoder family first, then the model court compares Bolt with Granite-4.0-1b on extraction, classification and brief."
  },
  "areas": ["softanza", "aicha"],
  "domains": ["models", "agents"],
  "concerns": ["cost", "speed", "sovereignty"],
  "actions": [
    { "area": "stzlib", "do": "add the Gemma 4 decoder family (Gemma 4 E4B and its per-layer embeddings) to the engine's own Zig decoder, checked token by token against a reference run of the same GGUF file", "state": "proposed", "dates": { "proposed": "2026-11-11" } },
    { "area": "stzlib.intelligence", "do": "put Nemotron 3.5 Bolt E4B (Q4_K_M) before the model court as a challenger to Granite-4.0-1b on the support-desk golden sets, read by probability as the incumbent is, and record CPU and wgpu speeds on the 6 GB laptop GPU beside the scores", "state": "proposed", "dates": { "proposed": "2026-11-11" } }
  ],
  "status": "analysed",
  "confidence": "claimed",
  "sources": [
    { "title": "NVIDIA-Nemotron-3.5-Bolt-E4B-4GB (model card)", "url": "https://huggingface.co/nvidia/NVIDIA-Nemotron-3.5-Bolt-E4B-4GB", "by": "NVIDIA", "read": "2026-11-11" },
    { "title": "NVIDIA's models on Hugging Face, Nemotron 3.5", "url": "https://huggingface.co/models?author=nvidia&sort=created&search=nemotron-3.5", "by": "Hugging Face", "read": "2026-11-11" }
  ],
  "review_by": "2027-01-11",
  "tags": ["nvidia", "nemotron", "slm", "gguf", "local-agents", "gemma"]
}
```

## What happened

NVIDIA published Nemotron 3.5 Bolt E4B on Hugging Face and on its build site on October 23, 2026. The model card
calls it a small language model, post-trained from Google's Gemma 4 E4B instruction model with multi-environment
reinforcement learning (GRPO) on instruction following, multi-step tool use, multi-turn conversation and structured
output. It has 8 billion parameters, 4 billion of them effective, takes up to 64K tokens of context, and offers a
thinking mode that a chat-template switch turns on or off.

The release is shaped for local use. The 4 GB file is a Q4_K_M GGUF that llama.cpp, Ollama and LM Studio load
directly, and a separate DFlash drafter of about 0.4 billion parameters speeds up generation by speculative decoding.
NVIDIA's table, measured by NVIDIA in its own harness, compares it with Gemma 4 E4B, Qwen3.5 4B and its own
Nemotron 3 Nano 4B at full precision and at Q4_K_M; the quantized Bolt leads on most of the 21 rows, including
instruction-hierarchy and tool-reliability tests, and trails Qwen3.5 4B on long-context and some tool benchmarks.
Weights, post-training data and recipes are published under OpenMDW-1.1; the Gemma 4 base stays under Apache 2.0.

## Why it matters to Softanza

Softanza's intelligence plane runs small models on the user's own machine, through its own decoder written in Zig
over a CPU build of ggml, and chooses among them with a model court: a challenger replaces the incumbent only when
an exact test on the golden items where the two disagree says its wins are unlikely to be chance. On the
support-desk sets of October 2026 the first model to beat a hand-written floor was Granite-4.0-1b on extraction,
read by probability; below 1 billion parameters every model lost to the floors.

Bolt E4B is aimed exactly at that gap: a model of the 4 GB class trained for the work Softanza's agents do (calling
tools, following instructions, keeping answers short and grounded). Its figures are NVIDIA's, so the court is where
they become Softanza's. The engine's decoder runs the llama, Qwen2, Qwen3, SmolLM and Granite families; Gemma 4 is
the family Bolt needs, and adding it also opens Gemma 4 itself and the other models built on it.

## What we do

- Propose to stzlib the Gemma 4 decoder family, checked token by token against a reference run.
- Propose to the intelligence plane a court hearing: Bolt E4B against Granite-4.0-1b, with speeds recorded beside
  the scores.
- Look again by 2027-01-11, with the court's verdict if it exists.

## Sources

- NVIDIA, [NVIDIA-Nemotron-3.5-Bolt-E4B-4GB model card](https://huggingface.co/nvidia/NVIDIA-Nemotron-3.5-Bolt-E4B-4GB),
  read 2026-11-11. Benchmark figures are NVIDIA's own.
- Hugging Face, [NVIDIA's Nemotron 3.5 models](https://huggingface.co/models?author=nvidia&sort=created&search=nemotron-3.5),
  read 2026-11-11.
