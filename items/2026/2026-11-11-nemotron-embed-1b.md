# NVIDIA's Nemotron 3.5 Embed 1B finds pages by text or by image in 34 languages; Softanza measures it on Arabic and French retrieval

```json
{
  "id": "2026-11-11-nemotron-embed-1b",
  "date": "2026-11-11",
  "title": "NVIDIA's Nemotron 3.5 Embed 1B finds pages by text or by image in 34 languages; Softanza measures it on Arabic and French retrieval",
  "kind": "release",
  "summary": "On October 20, 2026 NVIDIA released Nemotron 3.5 Embed 1B, an embedding model that turns a query, a passage or the image of a document page into one vector, for retrieval across text, tables, charts and infographics. NVIDIA evaluated text retrieval in 34 languages, Arabic, French and Persian among them, and image retrieval in 18; its vectors can be cut to 1024 or 512 dimensions and stay usable once normalised. It is published under OpenMDW-1.1, with an NVFP4 variant for recent NVIDIA GPUs.",
  "stance": "watch",
  "relevance": "medium",
  "level": "advice",
  "audiences": ["developer", "maintainer"],
  "notice": {
    "developer": "A 1B open model now retrieves document pages from their images as well as their text, in many languages; Softanza keeps its own embedding model until a multilingual test says otherwise.",
    "maintainer": "Softanza adds Arabic and French retrieval items to its embedding golden set, so the court can judge multilingual challengers such as Nemotron 3.5 Embed against MiniLM and SigLIP2."
  },
  "areas": ["softanza", "aicha"],
  "domains": ["models", "data"],
  "concerns": ["correctness", "sovereignty"],
  "actions": [
    { "area": "stzlib.intelligence", "do": "add Arabic and French items to the retrieval golden set, so the model court can judge a multilingual embedding challenger against all-MiniLM-L6-v2 on text and SigLIP2 on page images", "state": "proposed", "dates": { "proposed": "2026-11-11" } }
  ],
  "status": "analysed",
  "confidence": "claimed",
  "sources": [
    { "title": "Nemotron-3.5-Embed-1B-BF16 (model card)", "url": "https://huggingface.co/nvidia/Nemotron-3.5-Embed-1B-BF16", "by": "NVIDIA", "read": "2026-11-11" }
  ],
  "review_by": "2027-02-11",
  "tags": ["nvidia", "nemotron", "embeddings", "retrieval", "multilingual"]
}
```

## What happened

NVIDIA released Nemotron 3.5 Embed 1B on Hugging Face on October 20, 2026, with an 8B sibling and an NVFP4 copy of
the 1B. It is a bi-encoder: a text query, a passage, the image of a page, or an image with its text each becomes one
fixed-size vector, so a question typed in words can find the page that answers it even when that page is a chart or
a table. Its vision encoder comes from Mistral's Ministral 3 model. NVIDIA evaluated text retrieval in 34 languages,
including Arabic, French, Persian, Urdu and Swahili, and image retrieval in 18, and reports state-of-the-art results
among models of its size. Its vectors can be truncated to their first 1024 or 512 dimensions and remain effective
once L2-normalised.

## Why it matters to Softanza

Retrieval is the one faculty where a small model already beats its hand-written floor in Softanza: all-MiniLM-L6-v2,
a 25 MB English-trained model, scored 1.00 against 0.50 on the support-desk sets, and SigLIP2 embeds images for the
image plane. Softanza serves readers of Arabic and French as well as English, and Embed 1B is built for exactly that
mix, with pages as images too.

The stance is to watch, because the test that would judge it is the one to build first. The golden set that crowned
MiniLM is English; with Arabic and French items in it, the court can hear any multilingual challenger fairly, this
one included. The model is about forty times the size of MiniLM and its architecture is one the engine would add, so
it has to win clearly to be worth it.

## What we do

- Propose to the intelligence plane Arabic and French items in the retrieval golden set.
- Look again by 2027-02-11.

## Sources

- NVIDIA, [Nemotron-3.5-Embed-1B-BF16 model card](https://huggingface.co/nvidia/Nemotron-3.5-Embed-1B-BF16), read
  2026-11-11. Results are NVIDIA's own.
