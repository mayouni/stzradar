# Code repaired by a model after an API change can pass its checks and still be wrong

```json
{
  "id": "2026-11-08-llm-repairs-pass-wrong",
  "date": "2026-11-08",
  "updated": "2026-11-09",
  "title": "Code repaired by a model after an API change can pass its checks and still be wrong",
  "kind": "paper",
  "summary": "A study submitted on November 5, 2026 looks at code that models repair after documented changes in CPython, Node.js and SQLite. Repairs that run cleanly can still give wrong answers: a gate built on typical inputs let 41% of the wrong repairs through, and adding one input written from the release note cut that to 6.5%. The expected outputs came from the old program on the old runtime.",
  "stance": "adopt",
  "relevance": "high",
  "level": "advice",
  "audiences": ["developer", "learner", "maintainer"],
  "notice": {
    "developer": "When an agent repairs code for a changed API, test the repair with one input that exercises the change, and take the expected answer from the old version.",
    "learner": "A program that runs without errors can still be wrong: test it with the case that changed, not only with the usual ones.",
    "maintainer": "Gate every model-made port or repair on edge inputs taken from the change itself, with expected outputs from the old runtime, never from the model's own tests alone."
  },
  "areas": ["stzlib", "haro"],
  "domains": ["code", "models"],
  "concerns": ["correctness"],
  "actions": [
    { "area": "stzlib", "do": "for code ported to Haro by an agent, gate each change on at least one input that exercises the documented difference, with the expected output read off the old runtime", "state": "routed", "dates": { "proposed": "2026-11-08", "routed": "2026-11-08" } }
  ],
  "status": "routed",
  "confidence": "read",
  "sources": [
    { "title": "Accepted but Wrong: Silent Failures of LLM Code Repairs after API Migrations", "url": "https://arxiv.org/abs/2611.08269", "by": "Xiaobo Chen et al.", "read": "2026-11-08" },
    { "title": "Accepted but Wrong, full text (HTML)", "url": "https://arxiv.org/html/2611.08269v1", "by": "Xiaobo Chen et al.", "read": "2026-11-08" }
  ],
  "review_by": "2027-05-08",
  "tags": ["code-repair", "testing", "migration", "paper"]
}
```

## What happened

The authors built 73 tasks over 60 documented changes: CPython 3.9 to 3.12, Node.js 20 to 24, and the SQLite shell
3.51 to 3.54. A frontier model and three open-weight models run locally chose repairs, and each repair went through a
release gate, the checks a team would run before shipping it. The expected outputs came from the old program on the
old runtime. They froze their design in timestamped files before calling any model.

The finding is in the title. With assertions over typical inputs, the gate let 0.410 of the wrong repairs through.
One extra input, written by hand from the release note so that it exercises the change, cut that to 0.065, and the
cut held in all three open-weight families. Inputs from a blind model writer did about as well (0.070), but a writer
allowed to decide which old outputs still applied did worse, because it removed exactly the inputs that showed the
change. The model's own self-tests did not reach significance. All are the authors' reported results, measured over
a menu of candidate repairs rather than free-form code, which they name as a limit.

## Why it matters to Softanza

Softanza is in the middle of exactly this situation. Its library is being moved to Haro, largely by agents, and the
old and new runtimes differ in documented ways. Softanza's own working rules already say
that a test and the thing it checks must have separate authors. This study measures why, and gives the cheapest
remedy: one input per documented difference, with the expected answer read off the old runtime, does most of the
work.

## What we do

- Propose to stzlib, through Central, the gate above for agent-made port changes.

## Sources

- Xiaobo Chen et al., [Accepted but Wrong](https://arxiv.org/abs/2611.08269), arXiv 2611.08269, submitted
  November 5, 2026, and its [HTML full text](https://arxiv.org/html/2611.08269v1), read 2026-11-08. The first part
  of the full text was read word for word; the rest was read through a summary, and nothing here rests on it alone.

## Corrections

- 2026-11-09: placed on the estate map, with the domains and concerns it touches; the facts are unchanged.
- 2026-11-09: each proposal now carries the day it reached each stage, read from this repository's history; the facts are unchanged.
- 2026-11-09: the port is named by where it goes, Haro; the action and this section say so. Decided by the author.
