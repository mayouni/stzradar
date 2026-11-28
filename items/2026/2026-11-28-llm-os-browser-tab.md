# LLM.OS runs Qwen models in a browser tab from a 52 KB engine written in Zig and compiled to WebAssembly: Qwen3-0.6B at about 124 tokens per second on an M3 Max's CPU, against 163 for llama.cpp on the same CPU, with a Python sandbox in the tab

```json
{
  "id": "2026-11-28-llm-os-browser-tab",
  "date": "2026-11-28",
  "title": "LLM.OS runs Qwen models in a browser tab from a 52 KB engine written in Zig and compiled to WebAssembly: Qwen3-0.6B at about 124 tokens per second on an M3 Max's CPU, against 163 for llama.cpp on the same CPU, with a Python sandbox in the tab",
  "kind": "release",
  "summary": "Tesseracted Labs GmbH published LLM.OS, a terminal in a browser tab that runs Qwen3.5-2B, Qwen3.5-0.8B, Qwen3-1.7B and Qwen3-0.6B, as Unsloth's Q4_K_M weights downloaded once and kept in the browser cache. The engine is 52 to 55 KB, written in Zig for wasm32-freestanding, and began as a port of llm.asm; it runs on the CPU with a small thread pool on shared memory and a faster dot product where the browser has relaxed SIMD. Measured on 27 and 28 November 2026 on an Apple M3 Max with 8 threads in headless Chrome, it decodes Qwen3-0.6B at about 124 tokens per second and Qwen3-1.7B at about 52, against 163 and 80 for llama.cpp on the same CPU; it reads the prompt one token at a time, at about 160 tokens per second against llama.cpp's 513. The tab holds 0.6 to 1.4 GB. A /python command has the model write code that runs in Pyodide in the same tab, with the standard library only, no network and a 15-second limit. The page measures how often Qwen3-0.6B's first choice matches full precision: 98.5% at 8 bits, 90.6% at Q4_K_M, 84.4% at Q4_0. The figures are the authors' own.",
  "stance": "learn",
  "relevance": "medium",
  "level": "advice",
  "audiences": ["developer", "maintainer", "learner"],
  "notice": {
    "developer": "A small model needs no server: a 52 KB WebAssembly engine runs a 0.6B model in a tab at about three quarters of native CPU speed. Choose the quantization by measured agreement: at Q4_K_M the 0.6B model's first choice differs from full precision on almost one token in ten.",
    "maintainer": "Softanza's engine is written in Zig and runs small models where the data lives. LLM.OS shows a Zig inference engine compiled to WebAssembly reaching 76% of llama.cpp's CPU decode speed on the same machine, with tools run in a sandbox in the same tab: a measured reference for a tier where the user installs nothing.",
    "learner": "This page runs a small AI inside your web browser. The model is downloaded once, and every word is computed on your own computer, so nothing you type leaves it."
  },
  "areas": ["aicha", "harobanda-edge"],
  "domains": ["models", "web", "devices"],
  "concerns": ["sovereignty", "speed", "cost"],
  "actions": [
    {"area": "stzlib.intelligence", "do": "measure a browser tier for the local answer path: run the same Q4_K_M small model through a Zig engine compiled to wasm32 on the client's machine and record decode and prompt speed against the native engine, the memory the tab holds, and the share of first choices that match full precision at each quantization offered", "state": "routed", "dates": {"proposed": "2026-11-28", "routed": "2026-11-28"}}
  ],
  "status": "routed",
  "confidence": "claimed",
  "sources": [
    {"title": "LLM.OS", "url": "https://tesseracted.com/experiments-llm-os/", "by": "Tesseracted Labs GmbH", "read": "2026-11-28"}
  ],
  "review_by": "2027-02-28",
  "tags": ["webassembly", "browser", "zig", "inference", "qwen3", "quantization", "small-models", "pyodide"]
}
```

## What happened

Tesseracted Labs GmbH published LLM.OS, a terminal in a browser tab that runs a Qwen model on the visitor's own CPU.

- **The engine.** 52 to 55 KB depending on the build, written in Zig and compiled to wasm32-freestanding. It began as a
  port of llm.asm, the assembly program that runs Qwen3-0.6B. A small thread pool runs on shared memory, and browsers
  with relaxed SIMD get a faster dot product.
- **The models.** Qwen3.5-2B, Qwen3.5-0.8B, Qwen3-1.7B and Qwen3-0.6B, all Apache 2.0, as Unsloth's Q4_K_M weights:
  1,060 MiB for the 1.7B model and 382 MiB for the 0.6B. They download once and stay in the browser cache.
- **Tools.** `/python` has the model write code that runs in Pyodide, CPython compiled to WebAssembly, in the same tab:
  standard library only, no network, stopped after 15 seconds. `/bench` runs a fixed speed test.

Decode speed on an Apple M3 Max, 8 threads, headless Chrome, measured 27 and 28 November 2026:

| model | LLM.OS, tokens per second | llama.cpp on the CPU | llama.cpp on Metal |
|---|---|---|---|
| Qwen3-0.6B | about 124 | 163 | 242 |
| Qwen3-1.7B | about 52 | 80 | 147 |
| Qwen3.5-0.8B | about 74 | | |
| Qwen3.5-2B | about 39 | | |

The prompt is read one token at a time, about 160 tokens per second on the 0.6B model against 513 for llama.cpp. The
page also measures, over 645 tokens of Qwen3-0.6B, how often the quantized model's first choice matches full
precision: 98.5% at 8 bits, 96.8% at Q6_K, 94.7% at Q5_K_M, 90.6% at Q4_K_M and 84.4% at Q4_0. The announcement gives
the engine as 40 KB; the page gives 52 to 55 KB.

## Why it matters to Softanza

Softanza's engine is written in Zig, and Softanza runs small models on the machine that holds the data. LLM.OS shows
the same kind of engine compiled to WebAssembly, reaching about three quarters of llama.cpp's decode speed on the same
CPU, from a file of 52 KB, with tool calls run in a sandbox beside it. That is a tier where the user installs nothing
and nothing leaves the machine. Its quantization table is a lesson by itself: choose the bits by measured agreement
with full precision, task by task.

## What we do

- Route to the intelligence plane: measure a browser tier for the local answer path on the client's machine, with
  decode and prompt speed against the native engine, the tab's memory, and agreement with full precision per
  quantization.
- Look again by 2027-02-28.

## Sources

- Tesseracted Labs GmbH, [LLM.OS](https://tesseracted.com/experiments-llm-os/), read 2026-11-28 in full, from a
  LinkedIn announcement the author shared. All figures are the authors' own.
