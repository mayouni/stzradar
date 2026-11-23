# A small on-device agent that decided correctly several times is more likely to allow what its policy forbids; Softanza's governed actor decides each act apart from the model

```json
{
  "id": "2026-11-23-correct-precedents-small-agents",
  "date": "2026-11-23",
  "title": "A small on-device agent that decided correctly several times is more likely to allow what its policy forbids; Softanza's governed actor decides each act apart from the model",
  "kind": "paper",
  "summary": "In 'Correct Precedents Induce Policy Violations in On-Device LLM Agents' (arXiv 2611.27216, November 20, 2026) Chong Tian and co-authors study small agents that run on a device and hand some work to a cloud model under restrictions. They find that correct earlier decisions in a session make a later violation more likely, an effect they name correct-precedent generalization: in 13 open-weight models from nine developers, and a single correct precedent can roughly halve the safe rate of the most affected agent. Their remedy, Paired Decision Distillation, trains a small adapter on the decisions of a weakly affected teacher and restores the safe rate to nearly 100% in every distilled model, with no added prompt text or model call. The abstract was read; the figures are the authors'.",
  "stance": "defend",
  "relevance": "high",
  "level": "advice",
  "audiences": ["developer", "maintainer"],
  "notice": {
    "developer": "A small model's decision depends on the session before it: after a few allowed requests it tends to allow the next one too. A restriction that must hold is checked by code that sees the single act, with no history.",
    "maintainer": "Softanza lets a small model propose and a governed actor decide, so a forbidden act is refused whatever the session held. The paper gives a precise test for the models of the court: the refusal rate after one, three and five correct allowed decisions."
  },
  "areas": ["aicha", "agents", "security"],
  "domains": ["models", "agents", "security"],
  "concerns": ["trust", "correctness"],
  "actions": [
    {"area": "stzlib.intelligence", "do": "measure on the court's small models the rate at which a forbidden act is refused after zero, one, three and five correct allowed decisions in the same session, and show with a guard that the governed actor refuses the act in every case", "state": "routed", "dates": {"proposed": "2026-11-23", "routed": "2026-11-23"}}
  ],
  "status": "routed",
  "confidence": "claimed",
  "sources": [
    {"title": "Correct Precedents Induce Policy Violations in On-Device LLM Agents", "url": "https://arxiv.org/abs/2611.27216", "by": "Chong Tian and co-authors", "read": "2026-11-23"}
  ],
  "review_by": "2027-02-23",
  "tags": ["small-models", "on-device", "agents", "policy", "distillation", "safety"]
}
```

## What happened

Chong Tian and co-authors published on November 20, 2026 a study of small agents that run on a person's device and
pass part of their work to a model in the cloud, under restrictions on what may leave the device. Their finding is
about the session, and they name it correct-precedent generalization: when the agent has made correct decisions
earlier in a session, it becomes more likely to make a wrong one later, as if the earlier permissions were a
pattern to continue.

The authors' figures, from the abstract:

- The effect appears in 13 open-weight models from nine developers.
- A single correct precedent can roughly halve the safe rate of the most affected agent.
- Their remedy, Paired Decision Distillation, trains a small adapter on the decisions of a teacher model that is
  weakly affected. It restores the safe rate to nearly 100% in every distilled model, and adds no prompt text and no
  model call.

## Why it matters to Softanza

Softanza builds systems from small models on the user's own device, and its rule for agents is that a model proposes
and a governed actor commits. The paper shows why that separation carries weight with small models in particular: a
model's judgment of one act is coloured by the acts before it, and code that decides each act apart is free of
that memory. The paper also gives the model court a new question, measured in a few minutes for each model: how often a
forbidden act is refused after a run of allowed ones. A model that holds its refusal is the better choice for a role
that decides, and the governed actor holds it in every case.

## What we do

- Route to the intelligence plane the refusal rate of the court's small models after a run of correct decisions,
  with a guard on the governed actor.
- Look again by 2027-02-23.

## Sources

- Chong Tian and co-authors, [Correct Precedents Induce Policy Violations in On-Device LLM Agents](https://arxiv.org/abs/2611.27216),
  arXiv 2611.27216, November 20, 2026. The abstract was read on 2026-11-23; figures are the authors' own.
