# llm.asm runs Qwen3-0.6B from 17,252 lines of x86-64 assembly, as a 14.7 KB Linux program with no libc and as a 24 KB kernel booted by GRUB; it states decode speeds above llama.cpp's on the same processor

```json
{
  "id": "2026-11-26-llm-asm-bare-metal",
  "date": "2026-11-26",
  "title": "llm.asm runs Qwen3-0.6B from 17,252 lines of x86-64 assembly, as a 14.7 KB Linux program with no libc and as a 24 KB kernel booted by GRUB; it states decode speeds above llama.cpp's on the same processor",
  "kind": "release",
  "summary": "llm.asm (MIT, published by alesha-pro on November 25, 2026) runs the full 28-layer forward pass of Qwen3-0.6B, with its BPE tokenizer, in NASM assembly. It comes as a static Linux program of 14,712 bytes that uses raw system calls and no libc, and as a bare-metal kernel of 24,252 bytes booted by GRUB through Multiboot, with VGA text, a PS/2 keyboard and a serial port, which boots in 74 to 94 ms. A Python script converts the published weights once into a 613.66 MiB Q8_0 file. On an AMD EPYC 7642 the author measures 20.70 tokens per second on one thread and 125.86 on 40, and states 18 to 36% faster decoding than llama.cpp at Q8_0, with the prompt read one token at a time where llama.cpp reads it in batches; the kernel reaches 134.9 tokens per second under KVM. Its greedy output matches PyTorch on 64 of 64 tokens. The figures are the author's own.",
  "stance": "learn",
  "relevance": "medium",
  "level": "advice",
  "audiences": ["developer", "maintainer"],
  "notice": {
    "developer": "A small model needs very little beneath it: a forward pass, a tokenizer, threads and memory. The program around the weights can be kilobytes; the weights themselves stay hundreds of megabytes, and a speed comparison holds only when both sides read the prompt the same way.",
    "maintainer": "Harobanda declares the machine an application runs on. llm.asm shows how small that machine can be when its one job is a 0.6B model: 24 KB of kernel, under a tenth of a second to boot. That is a floor Harobanda can measure its own image against."
  },
  "areas": ["harobanda", "aicha"],
  "domains": ["models", "devices"],
  "concerns": ["speed", "sovereignty", "cost"],
  "actions": [
    {"area": "harobanda", "do": "take llm.asm's figures as the floor for a machine that only runs a small model: build a Harobanda image that runs Qwen3-0.6B at Q8_0 and measure, on the same virtual machine, its image size without the weights, its time from boot to the first token, and its decode speed at 1 and at every core, beside llm.asm's kernel", "state": "routed", "dates": {"proposed": "2026-11-26", "routed": "2026-11-26"}}
  ],
  "status": "routed",
  "confidence": "reported",
  "sources": [
    {"title": "llm.asm", "url": "https://github.com/alesha-pro/llm.asm", "by": "alesha-pro", "read": "2026-11-26"},
    {"title": "Tiny assembly LLM runs without Linux or libraries", "url": "https://digitalqazaqstan.com/tiny-assembly-llm-runs-without-linux-or-libraries/", "by": "Alexandr Pavlenko, Digital Qazaqstan", "read": "2026-11-26"}
  ],
  "review_by": "2027-02-26",
  "tags": ["assembly", "bare-metal", "inference", "qwen3", "quantization", "small-models", "unikernel"]
}
```

## What happened

A developer publishing as alesha-pro released llm.asm on GitHub on November 25, 2026, under the MIT licence: 17,252
lines of x86-64 assembly, built with NASM and ld, that run Qwen3-0.6B, the published model from Qwen. It carries the
full 28-layer forward pass (grouped-query attention, QK-Norm, RoPE, SwiGLU) and its own BPE tokenizer.

- **On Linux, with no libraries.** A static program of 14,712 bytes uses raw system calls, with `clone()` and
  `futex()` for its threads, and no libc.
- **With no operating system.** A kernel of 24,252 bytes is booted by GRUB through Multiboot, sets up paging, long
  mode and AVX2, and talks through 80x25 VGA text, a PS/2 keyboard and the COM1 serial port. The weights are loaded as
  Multiboot modules. It boots in 74 to 94 ms and was tested under QEMU with KVM and on Proxmox.
- **The weights.** A Python script converts the Hugging Face checkpoint once into a Q8_0 file of 613.66 MiB.
- **A trainer.** A third program of 32,944 bytes trains a small GPT from scratch on TinyShakespeare.

The author's measures, on an AMD EPYC 7642, a 34-token prompt and 64 generated tokens, averaged over three runs:

| run | tokens per second |
|---|---|
| Linux program, 1 thread | 20.70 |
| Linux program, 40 threads | 125.86 |
| kernel under KVM | 134.9 |
| kernel in a Proxmox VM, Xeon E5-2670 v3 | 55.4 |

The README states 18 to 36% faster decoding than llama.cpp on the CPU at Q8_0, and notes that llama.cpp reads the
prompt in batches where llm.asm reads it one token at a time. Against PyTorch in FP32 the logits agree at a cosine of
0.9996517 and the greedy output matches on 64 of 64 tokens.

## Why it matters to Softanza

Harobanda declares the machine an application runs on, and runs Softanza's small models on the machine that holds the
data. llm.asm sets a clear floor for a machine whose single job is one small model: a kernel of 24 KB, a boot of under
a tenth of a second, and a decode speed measured against llama.cpp on the same processor. The weights stay the large
part, at more than 600 MiB, which is where a small machine's memory goes. The numbers give Harobanda a reference to
measure its own model image against, on the same virtual machine.

## What we do

- Route to Harobanda: a Harobanda image that runs Qwen3-0.6B at Q8_0, measured beside llm.asm's kernel for image size
  without the weights, time from boot to the first token, and decode speed on one core and on all.
- Look again by 2027-02-26.

## Sources

- alesha-pro, [llm.asm](https://github.com/alesha-pro/llm.asm), its README and commits, read 2026-11-26.
- Alexandr Pavlenko, [Tiny assembly LLM runs without Linux or libraries](https://digitalqazaqstan.com/tiny-assembly-llm-runs-without-linux-or-libraries/),
  Digital Qazaqstan, November 26, 2026, read 2026-11-26. Both were read through a summarising reader. All figures are
  the author's own.
