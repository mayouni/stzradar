# Samsung's LittleBit stores a model's weights in under one bit each; Softanza weighs memory against quality on its small models

```json
{
  "id": "2026-11-12-samsung-littlebit",
  "date": "2026-11-12",
  "updated": "2026-11-13",
  "title": "Samsung's LittleBit stores a model's weights in under one bit each; Softanza weighs memory against quality on its small models",
  "kind": "paper",
  "summary": "LittleBit, from Samsung Research (NeurIPS 2025; fifth version February 5, 2026), compresses a language model's weights to between 0.1 and 1 bit per weight by factoring each weight matrix into two low-rank matrices of signs with three scaling vectors, plus a residual path of the same shape, trained against the original model. The paper reports Llama2-13B in under 0.9 GB at 0.1 bits per weight, about 31 times smaller than 16-bit, and a speedup of up to 11.6 times on one layer with its GPU kernel. Its code, with the follow-up LittleBit-2 (ICML 2026), is published under the non-commercial CC BY-NC 4.0 licence.",
  "stance": "watch",
  "relevance": "low",
  "level": "advice",
  "audiences": ["maintainer"],
  "notice": {
    "maintainer": "Below one bit per weight, a 13B model fits in under a gigabyte, at a measurable cost in quality; Softanza's own question is how low its small models can go and still win their court hearings."
  },
  "areas": ["softanza", "aicha"],
  "domains": ["models"],
  "concerns": ["cost", "correctness"],
  "actions": [
    { "area": "stzlib.intelligence", "do": "measure Nemotron 3.5 Bolt E4B in the lowest-bit GGUF formats the engine's ggml reads, against its Q4_K_M file on the support-desk golden sets: memory, CPU speed and court score at each format, to find the smallest file that keeps its triage-extract win", "state": "done", "dates": { "proposed": "2026-11-12", "routed": "2026-11-12", "done": "2026-11-13" } }
  ],
  "status": "done",
  "confidence": "read",
  "sources": [
    { "title": "LittleBit: Ultra Low-Bit Quantization via Latent Factorization (arXiv 2506.13771v5)", "url": "https://arxiv.org/html/2506.13771v5", "by": "Banseok Lee, Dongkyu Kim, Youngcheon You, Youngmin Kim (Samsung Research)", "read": "2026-11-12" },
    { "title": "SamsungLabs/LittleBit (README and licence)", "url": "https://github.com/SamsungLabs/LittleBit", "by": "Samsung Research", "read": "2026-11-12" }
  ],
  "review_by": "2027-02-12",
  "tags": ["samsung", "littlebit", "quantization", "sub-1-bit", "compression", "slm"]
}
```

## What happened

Samsung Research published LittleBit, accepted at NeurIPS 2025; its fifth version on arXiv is dated February 5, 2026,
and its repository also carries the follow-up LittleBit-2, accepted at ICML 2026. The method writes each weight matrix
as the product of two thin matrices whose entries are only signs, +1 or -1, with three vectors of 16-bit scales: one
per output row, one per input column and one per hidden rank. A second path of the same shape learns what the first
misses. Both start from a singular value decomposition of the original weights and are then trained against the
original model, which serves as teacher, on WikiText-2 and part of C4. The rank sets the size, from 1 bit per weight
down to 0.1.

On WikiText-2, Llama2-7B goes from a perplexity of 5.47 at 16 bits to 9.08 at 1 bit and 15.92 at 0.1 bit, where the
earlier sub-1-bit method STBLLM reaches 19.52 already at 0.7 bit. At 1 bit, the earlier 1-bit methods OneBit and
BinaryMoS score better (8.36 and 7.74). The smallest model in the paper, OPT-1.3B, goes from 14.62 to 20.33 at 1 bit
and 53.76 at 0.1 bit. The paper reports Llama2-13B at 0.84 GB against 26 GB, and a custom GPU kernel running one large
layer 11.6 times faster than 16-bit. The repository holds training and evaluation code for OPT, Llama, Phi-4, Qwen2.5,
Qwen3 and Gemma 2 and 3, under CC BY-NC 4.0.

## Why it matters to Softanza

Softanza runs small models on the user's machine from GGUF files, and memory decides what a machine can hold: Nemotron
3.5 Bolt E4B, which won triage extraction in Softanza's model court, is a 4 GB file offered as an optional pack for
machines with 16 GB. LittleBit shows how far size can fall, and its figures show the price: quality drops fastest on
the smallest model it measures, and a model must be retrained with a teacher on GPUs to get there. Its code is licensed
for non-commercial use only, so Softanza takes the lesson and leaves the code.

The lesson applies with the formats Softanza already reads. The ggml library under its decoder defines GGUF formats
from 8 bits down to below 2, and the court already knows how to say whether a smaller file still wins. Measuring Bolt
E4B across those formats gives the smallest pack that keeps its win, which is the figure that decides how many
machines can install it.

## What we do

- Route to the intelligence plane a measurement of Bolt E4B in lower-bit GGUF formats: memory, speed and court score.
- Look again by 2027-02-12, with LittleBit-2's results.

## Sources

- Banseok Lee, Dongkyu Kim, Youngcheon You and Youngmin Kim, Samsung Research,
  [LittleBit: Ultra Low-Bit Quantization via Latent Factorization](https://arxiv.org/html/2506.13771v5), version 5,
  read 2026-11-12. Figures are the paper's own.
- Samsung Research, [SamsungLabs/LittleBit](https://github.com/SamsungLabs/LittleBit), read 2026-11-12.

## Corrections

- 2026-11-13: the proposal is measured. Every lower-bit Bolt E4B file tested keeps its triage-extraction win in the
  court on the English, French and Arabic sets. The smallest, UD-IQ2_M at 3.53 GB against 6.18 GB, uses 2.5 GB less
  resident memory and peaks at 4.9 GB against 7.5 GB, at about half the speed on CPU; UD-Q3_K_XL at 4.22 GB keeps two
  thirds of the speed. The Q4_K_M file measures 6.18 GB; this entry first gave it as 4 GB.
