# OpenInfer measures a serving GPU's math units busy 6 to 11% of the time and schedules the rest; Softanza gives its one GPU a single owner

```json
{
  "id": "2026-11-14-openinfer-gpu-os",
  "date": "2026-11-14",
  "title": "OpenInfer measures a serving GPU's math units busy 6 to 11% of the time and schedules the rest; Softanza gives its one GPU a single owner",
  "kind": "paper",
  "summary": "In 'The GPU Needs an Operating System' (arXiv 2611.08720, November 5, 2026), Reza Nourai and Behnam Bastani of OpenInfer measure two large open models served with stock vLLM on NVIDIA RTX PRO 6000 Blackwell cards: the tensor units are active 6 to 11% of the time while kernels occupy the GPU about 94% of it, because each decoding step waits on memory. They propose a scheduler that lends idle parts of the chip to background work in pieces of 20 microseconds or less. With NVIDIA's static partitions, work written to share adds about a quarter of a GPU at a 5% slower decode step; their research kernel, running Llama-3.1-8B, adds the same at 0.3 to 1.6%.",
  "stance": "learn",
  "relevance": "low",
  "level": "advice",
  "audiences": ["developer", "maintainer"],
  "notice": {
    "developer": "A GPU that reports itself busy can have most of its arithmetic idle: text generation is limited by how fast memory delivers the weights. Read tokens per second and memory bandwidth, and treat the utilisation percentage as occupancy.",
    "maintainer": "Softanza's GPU faculty already reports each kernel against the measured arithmetic peak and the memory bandwidth of the adapter; the paper adds the question of who may use the GPU at a given moment, and Softanza answers it for one machine with one owner at a time."
  },
  "areas": ["softanza", "harobanda"],
  "domains": ["models", "devices"],
  "concerns": ["speed", "cost", "correctness"],
  "actions": [
    { "area": "stzlib.gpu", "do": "give the GPU one owner at a time across processes: a named lease the engine takes before it creates its device, so that a second process waits its turn or runs its job on the CPU; and report, for one decode step of a court model, the fraction of the adapter's measured peak and of its memory bandwidth", "state": "routed", "dates": { "proposed": "2026-11-14", "routed": "2026-11-14" } }
  ],
  "status": "routed",
  "confidence": "claimed",
  "sources": [
    { "title": "The GPU Needs an Operating System (arXiv 2611.08720v1)", "url": "https://arxiv.org/html/2611.08720v1", "by": "Reza Nourai, Behnam Bastani (OpenInfer)", "read": "2026-11-14" },
    { "title": "Busy isn't efficient: why the GPU needs an operating system", "url": "https://openinfer.io/news/2026-11-09-busy-isnt-efficient-why-the-gpu-needs-an-operating-system/", "by": "OpenInfer", "read": "2026-11-14" }
  ],
  "review_by": "2027-02-14",
  "tags": ["openinfer", "gpu", "scheduling", "inference", "roofline", "memory-bandwidth"]
}
```

## What happened

OpenInfer, a company in San Mateo, published a paper on November 5, 2026 and an article four days later. Its authors
served two large open models with stock vLLM on NVIDIA RTX PRO 6000 Blackwell cards and read the hardware counters ten
thousand times a second. On a 397-billion-parameter model across four cards, the tensor units were active about 7% of
the time; on Kimi K2 across eight cards, 6.1 to 10.7%. In the same runs a kernel occupied the GPU about 94% of the
time, which is the figure a utilisation gauge shows.

The paper explains the gap with one ratio. A chip can do a certain number of operations for each byte its memory
delivers, between 240 and 560 on current cards. Generating a token reads every weight once and does only a few
operations on each, so the arithmetic finishes early and waits for the next bytes. Models that route each token to a
few experts out of hundreds widen the gap.

Its proposal is to share the chip the way an operating system shares a processor: admit work every few milliseconds,
and place and take back resources every few microseconds on the GPU itself. Background work cut into pieces of 20
microseconds or less left the urgent work on time; pieces of 50 microseconds made it miss every deadline. With the
static partitions NVIDIA ships, synthetic work written to share added about a quarter of a GPU while the decode step
slowed by 5%; a real matrix-multiply job added 0.09 of a GPU at 4.7%. A research kernel that holds all of Llama-3.1-8B
in one long-lived program added 0.22 to 0.24 of a GPU at 0.3 to 1.6%. The authors built parts of three of their six
layers, measured on one card, and ask chip makers for fast pausing, memory priority and enforced partitions. All
figures are theirs.

## Why it matters to Softanza

Softanza runs models on the user's own machine, where the GPU is one small card shared by everything the person does.
Its GPU faculty already speaks the paper's language: it measures each adapter's arithmetic peak and its memory
bandwidth, and its checks print every kernel as a fraction of both. The paper's ratio of operations per byte is the
line between those two limits, and it says in advance which of them a given model step will meet.

The paper's larger subject is who uses the GPU at a given moment, and Softanza met that subject on its own hardware:
two processes computing on the same card at once ended in a driver reset that stopped both. A data centre answers with
a scheduler at microsecond grain. One machine with one person needs the simple form of the same idea: one owner at a
time, a queue for the next, and the CPU for a job that prefers to start now. Softanza's engine already routes each
operation to the CPU or the GPU, so the lease is a small addition to a decision it makes anyway.

For Harobanda, which declares a whole machine in one file, the paper is a statement of where operating systems are
going: the accelerator becomes a resource the system schedules, beside the processor and the memory.

## What we do

- Route to the GPU desk a single-owner lease for the adapter across processes, and a reading of one decode step
  against the adapter's measured peak and bandwidth.
- Look again by 2027-02-14.

## Sources

- Reza Nourai and Behnam Bastani, OpenInfer,
  [The GPU Needs an Operating System](https://arxiv.org/html/2611.08720v1), version 1, read 2026-11-14 in part: the
  main text and the first appendix. Figures are the paper's own.
- OpenInfer, [Busy isn't efficient: why the GPU needs an operating system](https://openinfer.io/news/2026-11-09-busy-isnt-efficient-why-the-gpu-needs-an-operating-system/),
  read 2026-11-14.
