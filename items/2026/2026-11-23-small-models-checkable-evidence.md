# Small open models asked to quote the page that proves each answer reach 84.5% on company filings, and 16 to 167 wrong answers in 1,000 pass every automatic check; Softanza counts the same on its own set

```json
{
  "id": "2026-11-23-small-models-checkable-evidence",
  "date": "2026-11-23",
  "title": "Small open models asked to quote the page that proves each answer reach 84.5% on company filings, and 16 to 167 wrong answers in 1,000 pass every automatic check; Softanza counts the same on its own set",
  "kind": "paper",
  "summary": "In 'Show Your Work' (arXiv 2611.24990, November 18, 2026) Krishna Nandula publishes Filing-Evidence: 1,000 questions over 90 annual and quarterly filings of 45 United States companies, with answer keys taken from the filings' own machine-readable tags. Each answer must give a page and a verbatim quote, which a program checks. Ten open models of 7 to 21 billion parameters ran on one RTX 4090. Accuracy with checkable evidence ran from 17.1% to 82.7% in the plain setup, and the best result was 84.5%, by Qwen3.5-9B. Between 16 and 167 answers per 1,000 were wrong and passed every automatic check; 57% of those were errors of scale or unit. Retrying after a failed check added up to 3.9 points. Code and data are public. The abstract was read; the figures are the author's.",
  "stance": "learn",
  "relevance": "medium",
  "level": "advice",
  "audiences": ["developer", "maintainer"],
  "notice": {
    "developer": "Ask a model for the quote and the place that prove its answer, and check both by program. Then count the answers that pass the check and are wrong: that number is the true limit of the check, and here most of them were a thousand or a million read as a unit.",
    "maintainer": "Softanza's model court judges small models on a golden set. The paper adds a measure the court can take on its extraction tasks: answers with a quote a program verified, and among them the wrong answers the check let through, by kind."
  },
  "areas": ["aicha"],
  "domains": ["models", "data"],
  "concerns": ["correctness", "trust"],
  "actions": [
    {"area": "stzlib.intelligence", "do": "ask each extraction answer of the support-desk set for a verbatim quote and its place in the source, verify both by program, and report per model the answers that pass the check and are wrong, sorted by kind of error", "state": "routed", "dates": {"proposed": "2026-11-23", "routed": "2026-11-23"}}
  ],
  "status": "routed",
  "confidence": "claimed",
  "sources": [
    {"title": "Show Your Work: Can Small Open Models Read SEC Filings with Evidence a Machine Can Check?", "url": "https://arxiv.org/abs/2611.24990", "by": "Krishna Nandula", "read": "2026-11-23"}
  ],
  "review_by": "2027-02-23",
  "tags": ["small-models", "evaluation", "evidence", "extraction", "benchmark"]
}
```

## What happened

Krishna Nandula's paper of November 18, 2026 asks whether a small open model can read a company's filing and prove
its answer. The benchmark, Filing-Evidence, has 1,000 questions over 90 annual and quarterly filings of 45 United
States companies. The correct answers come from the tags the filings themselves carry for machines, so no person had
to label them. Every answer must name a page and give a quote, word for word, and a program checks that the quote is
on that page and holds the answer.

Ten open models of 7 to 21 billion parameters ran on one RTX 4090, in three setups: plain, with a retry after a
failed check, and with the model's reasoning mode. The author's figures, from the abstract:

- Accuracy with checkable evidence ran from 17.1% to 82.7% in the plain setup; the best overall was 84.5%, by
  Qwen3.5-9B.
- Between 16 and 167 answers in 1,000 were wrong and passed every automatic check. In the plain setup 57% of them
  were errors of scale or unit, such as thousands read as units.
- Reasoning lowered such errors for 4 of the 5 models that offer it. A retry after a failed check added up to
  3.9 points.

The code and the data are public.

## Why it matters to Softanza

Softanza selects its small models in a court, by measured results on a golden set, and several of its tasks are
extractions from a document: a figure, a date, a sentence that states a problem. The paper's method fits that work
at any model size. An answer with a quote and a place is an answer a program can verify, on the user's own machine,
with no second model. And its most useful number is the one a check cannot give by itself: how many wrong answers
passed. Knowing their kinds, units and scale first, says which second check is worth writing.

## What we do

- Route to the intelligence plane a count, on its extraction set, of verified answers and of wrong answers that pass
  the check, by kind.
- Look again by 2027-02-23.

## Sources

- Krishna Nandula, [Show Your Work: Can Small Open Models Read SEC Filings with Evidence a Machine Can Check?](https://arxiv.org/abs/2611.24990),
  arXiv 2611.24990, November 18, 2026. The abstract was read on 2026-11-23; figures are the author's own.
