# GPUOS runs background work beside a latency-bound model on one GPU by making it yield at checkpoints; Softanza learns the yield rule for its own GPU jobs

```json
{
  "id": "2026-11-15-gpuos-shared-gpu",
  "date": "2026-11-15",
  "title": "GPUOS runs background work beside a latency-bound model on one GPU by making it yield at checkpoints; Softanza learns the yield rule for its own GPU jobs",
  "kind": "paper",
  "summary": "GPUOS is an MIT research prototype from the Multi-V-VM group, described as sharing a GPU without NVIDIA's MIG or MPS. Its code keeps one persistent kernel running on the GPU with a work queue, replaces operators at run time through a table of device function pointers, and merges many tiny operations into one compiled batch. Its working-draft paper, pushed on November 12, 2026, builds on OpenInfer's 'The GPU Needs an Operating System' and specifies restartable tasks admitted under revocable resource leases. On one RTX 5090, background work that yields every 4 tiles costs a streaming foreground 0.62% at the 99th percentile, against 23.68% when it never yields. The authors state that the measurements support selected mechanisms.",
  "stance": "learn",
  "relevance": "low",
  "level": "advice",
  "audiences": ["developer", "maintainer"],
  "notice": {
    "developer": "Background work on a GPU is safe beside a latency-bound job when it is cut into short slices and checks, between slices, whether the foreground wants the device. The size of the slice is the price: GPUOS measured 0.62% of foreground cost with a short slice and 23.68% with none.",
    "maintainer": "Softanza's engine gives the GPU one owner at a time across processes. Inside that owner, the same rule applies one level down: a background job dispatches in short slices and yields to a foreground job between them, with the foreground's 99th-percentile time measured both ways."
  },
  "areas": ["softanza"],
  "domains": ["models", "devices"],
  "concerns": ["speed", "cost"],
  "actions": [
    { "area": "stzlib.gpu", "do": "inside the process that holds the GPU, let a background job dispatch in short slices and yield to a foreground job between them; measure the foreground's median and 99th-percentile step time alone, beside a background job that never yields and beside one that yields, with the background's own rate in each case; and measure the engine's fixed cost per dispatch, which says when merging small operations into one dispatch pays", "state": "routed", "dates": { "proposed": "2026-11-15", "routed": "2026-11-15" } }
  ],
  "status": "routed",
  "confidence": "claimed",
  "sources": [
    { "title": "GPUOS (repository at commit 9eb66b9)", "url": "https://github.com/Multi-V-VM/GPUOS", "by": "Multi-V-VM", "read": "2026-11-15" },
    { "title": "GPUOS: An Operating-System Architecture for Shared GPU Execution (working draft, source in the repository)", "url": "https://github.com/Multi-V-VM/GPUOS/tree/main/paper/osdi", "by": "Multi-V-VM", "read": "2026-11-15" }
  ],
  "review_by": "2027-02-15",
  "tags": ["gpu", "scheduling", "persistent-kernel", "cuda", "inference", "research-prototype"]
}
```

## What happened

The Multi-V-VM group publishes GPUOS on GitHub under the MIT licence, with the line "Share your GPU without MIG or
MPS"; MIG and MPS are NVIDIA's two ways to share one GPU between programs. The repository began in October 2025 and
received a working-draft paper on November 11 and 12, 2026.

The code shows three mechanisms. A persistent kernel stays on the GPU and takes tasks from a queue, so a small
operation costs a queue entry and saves a kernel launch. Operators are compiled at run time and installed in a table of
device function pointers, so the running kernel gains a new operation while it runs. A PyTorch extension collects many
tiny element-wise operations and executes them as one compiled batch.

The draft paper, "GPUOS: An Operating-System Architecture for Shared GPU Execution", builds on OpenInfer's paper of
the same week and names it as its source. It specifies execution as restartable tasks admitted under revocable leases,
in six layers from compiler safe points to slack-aware admission, and it separates what is specified from what is
built. Its evidence is from one RTX 5090:

- A background job beside a streaming foreground job costs the foreground 23.68% at the 99th percentile when it never
  yields, and 0.62% when it yields every 4 tiles; the yielding job then runs at 6.5% of its solo rate. A yield every
  64 tiles costs 2.50% and runs at 10.2%.
- Beside a replay of Qwen3-0.6B decoding, every policy stays within the 6% budget, and yielding background work
  recovers under 1% of its solo rate.
- A fused path for complete requests is 17.7% and 18.2% faster than native cached execution at two sizes, and a
  matched control built from standard CUDA features is faster again.

The authors mark the bounds themselves: this is a software pool for compatible trusted requests, MIG's isolation is a
separate guarantee, a full ResNet-18 case loses, and an early benchmark in the repository shows its scheduled
attention at 0.21 times plain PyTorch. The README at this commit points to experiment folders that the public tree
omits. All figures are the authors' own.

## Why it matters to Softanza

Softanza's engine opens the GPU under a lease: one process owns the adapter at a time, and a second process waits or
runs its work on the processor. That settles sharing between processes. GPUOS studies the level below, inside one
owner: a job that answers a person and a job that can wait, on the same device at the same moment. Its measurement
gives the rule a size. A background job is welcome when it runs in short slices and looks, between slices, for a
foreground request; the slice length sets how much the foreground pays and how much the background gets.

The persistent kernel also names a cost worth knowing on any GPU interface: the fixed price of one dispatch. When that
price is known, the engine can say at which size several small operations belong in one dispatch.

## What we do

- Route to the GPU desk a yield rule for background jobs inside the lease holder, measured on the foreground's
  99th-percentile time, and a measurement of the engine's fixed cost per dispatch.
- Look again by 2027-02-15.

## Sources

- Multi-V-VM, [GPUOS](https://github.com/Multi-V-VM/GPUOS), commit 9eb66b9 of November 12, 2026, read 2026-11-15: the
  README, the working draft's abstract, evidence section, claim map and generated tables. The design and control
  sections and the code itself were left unread. Figures are the authors' own.
