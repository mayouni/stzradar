# MeMo trains a small model on question-answer pairs drawn from a corpus and lets the main model question it in place of a search index; it leads retrieval on long narratives and ties it on web questions, at 240 to 420 GPU-hours per corpus

```json
{
  "id": "2026-11-26-memo-memory-as-a-model",
  "date": "2026-11-26",
  "title": "MeMo trains a small model on question-answer pairs drawn from a corpus and lets the main model question it in place of a search index; it leads retrieval on long narratives and ties it on web questions, at 240 to 420 GPU-hours per corpus",
  "kind": "paper",
  "summary": "MeMo: Memory as a Model (arXiv 2605.15156, May 2026), by nine authors from NUS, A*STAR, the University of Tokyo, Liquid AI, MIT CSAIL and the Singapore-MIT Alliance, replaces the retrieval index with a model. A 32B generator turns the corpus into question-answer pairs (about 0.7 to 1.6 million per corpus); a smaller model, Qwen2.5-14B in the main setting, is fully fine-tuned on them and never sees the documents; the main model, left unchanged, questions it in three stages. On NarrativeQA with Gemini 3 Flash as the main model, MeMo scores 53.58% against 26.62% for dense retrieval and 23.21% for graph retrieval; on BrowseComp-Plus graph retrieval scores 56.11% against MeMo's 54.22% with Qwen2.5-32B, and the two tie with Gemini. With added false documents, retrieval loses up to 6.22 points and MeMo stays level. Building one corpus's memory costs about 240 to 420 H200 GPU-hours. The figures are the authors' own.",
  "stance": "watch",
  "relevance": "medium",
  "level": "advice",
  "audiences": ["developer", "maintainer"],
  "notice": {
    "developer": "Retrieval finds the passages that look like the question; an answer spread across a long story or many documents is where it falls short. A model trained on the corpus can hold those connections, at the price of training it, and of training it again when the documents change.",
    "maintainer": "Softanza runs small models on the machine that holds the data. MeMo's memory model is that kind of model, specialised to one corpus. Its cost of 240 to 420 GPU-hours per corpus and its update by model merging decide where it fits: a fixed corpus, many cross-document questions, and a client who keeps the data at home."
  },
  "areas": ["aicha", "softanza"],
  "domains": ["models", "data"],
  "concerns": ["correctness", "cost", "sovereignty"],
  "actions": [
    {"area": "stzlib.intelligence", "do": "record MeMo in the needs map as a candidate for a fixed corpus whose questions span many documents, with its cost per corpus; and when a client corpus of that kind exists, measure a small memory model trained on its question-answer pairs against retrieval with the same main model, counting accuracy, hours to build, and hours to absorb a changed document", "state": "routed", "dates": {"proposed": "2026-11-26", "routed": "2026-11-26"}}
  ],
  "status": "routed",
  "confidence": "claimed",
  "sources": [
    {"title": "MeMo: Memory as a Model", "url": "https://arxiv.org/abs/2605.15156", "by": "Ryan Wei Heng Quek, Sanghyuk Lee, Alfred Wei Lun Leong, Arun Verma, Alok Prakash, Nancy F. Chen, Bryan Kian Hsiang Low, Daniela Rus, Armando Solar-Lezama", "read": "2026-11-26"}
  ],
  "review_by": "2027-02-26",
  "tags": ["memory", "rag", "retrieval", "fine-tuning", "small-models", "model-merging", "long-documents"]
}
```

## What happened

Nine authors from the National University of Singapore, A*STAR, the University of Tokyo, Liquid AI, MIT CSAIL and the
Singapore-MIT Alliance published MeMo: Memory as a Model on arXiv (2605.15156, May 14, 2026, revised May 20). It gives
a language model the knowledge of a corpus without a retrieval index.

- **Build the memory.** A generator model (Qwen2.5-32B) reads the corpus in five steps: it extracts facts,
  consolidates them, verifies them, surfaces entities and joins facts across documents. The result is question-answer
  pairs: about 1.64 million for BrowseComp-Plus, 1.28 million for NarrativeQA and 665,000 for MuSiQue.
- **Train the memory model.** A smaller model, Qwen2.5-14B in the main setting, is fully fine-tuned on those pairs and
  never sees the documents themselves. Models from 1B to 1.5B parameters were also tried.
- **Ask it.** The main model stays unchanged. It questions the memory model in three stages: probing clues,
  identifying the entity, and seeking the answer, then writes its reply.

Accuracy in percent, with Qwen2.5-32B / Gemini 3 Flash as the main model:

| system | BrowseComp-Plus | NarrativeQA | MuSiQue |
|---|---|---|---|
| dense retrieval (NV-Embed-V2) | 50.67 / 57.00 | 20.59 / 26.62 | 37.47 / 46.60 |
| graph retrieval (HippoRAG2) | 56.11 / 66.33 | 21.39 / 23.21 | 42.17 / 57.00 |
| MeMo | 54.22 / 66.67 | 26.85 / 53.58 | 48.30 / 60.20 |
| the right passages given by hand | 79.67 / 88.33 | 51.42 / 60.41 | 62.83 / 73.00 |

With false documents added to the corpus, the retrieval systems lose up to 6.22 points on BrowseComp-Plus and MeMo
stays within its own variation. Changing the main model from Qwen2.5-32B to Gemini 3 Flash raises MeMo by 12 to 27
points with no retraining of the memory.

**The cost.** Generating the pairs takes about 150 to 240 H200 GPU-hours per corpus, and training the memory model 90
to 180 more. A new corpus can be merged into an existing memory model for about a third less than retraining, at a
loss of accuracy (34.47% against 53.58% on NarrativeQA). The authors list the cost per corpus, the capacity of the
memory model and the untuned question budgets among their limits; code and data are in supplementary material.

A widely shared post presented the paper as the end of retrieval and as MIT's proof. The paper reports a comparison
on three benchmarks, with MIT among six institutions, in which retrieval leads or ties on one of the three.

## Why it matters to Softanza

Softanza runs small models on the machine that holds the data, so that a client's documents stay at home. MeMo shows
a second use for such a model: holding a corpus itself, so that questions whose answer spreads across a long text or
many documents are answered from what the model learned rather than from passages found by resemblance. The cost
sets the place where it fits: a corpus that changes rarely, many questions that cross documents, and data that must
not leave the client. Retrieval keeps the rest, at no training cost and with an index that changes as fast as the
documents.

## What we do

- Route to the intelligence plane: MeMo in the needs map as a candidate with its cost per corpus, and a measure
  against retrieval on the first client corpus of that kind.
- Look again by 2027-02-26.

## Sources

- Ryan Wei Heng Quek and eight co-authors, [MeMo: Memory as a Model](https://arxiv.org/abs/2605.15156), arXiv,
  version 2 of May 20, 2026, read 2026-11-26 in its HTML version: the method in full, the results and appendices
  through a summary. All figures are the authors' own.
