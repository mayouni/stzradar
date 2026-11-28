# Micro language models of 8 to 30 million parameters write the first four to eight words of an answer on the device in 55 ms while a cloud model continues it; people rated the joined answer as good as the cloud's alone or better in 75.6% of judgments

```json
{
  "id": "2026-11-28-micro-language-models",
  "date": "2026-11-28",
  "title": "Micro language models of 8 to 30 million parameters write the first four to eight words of an answer on the device in 55 ms while a cloud model continues it; people rated the joined answer as good as the cloud's alone or better in 75.6% of judgments",
  "kind": "paper",
  "summary": "Wen Cheng, Tuochao Chen, Karim Helwani, Sriram Srinivasan, Luke Zettlemoyer and Shyamnath Gollakota, of the University of Washington and Meta AI, present micro language models at EMNLP 2026 (pages 3240-3264). Models of 8.8 to 29.5 million parameters, trained from scratch on 1.485 billion tokens of chat, write the first 4 to 8 words of an answer on the device and commit them; a cloud model, prompted as a continuator, finishes the sentence. On an Orange Pi the 28M model gives its first token in 45 ms and four words in 55 ms, against 0.2 to 5 seconds or more for a cloud answer. The cloud model must correct the opener in 3.7% of answers at 4 words, 8.4% at 8 and 16.4% at 16. With 25 participants the joined answer was preferred in 33.6% of cases, judged equal in 42.0% and the cloud's alone preferred in 24.4%; in a live test 10 participants preferred it in 42 of 50 trials. The checkpoint and a demo are published. The figures are the authors' own.",
  "stance": "learn",
  "relevance": "high",
  "level": "advice",
  "audiences": ["developer", "maintainer", "learner"],
  "notice": {
    "developer": "The wait before the first word is what a user feels. A model small enough for a watch can write the first words while a large model answers the rest; keep the committed opener to 4 to 8 words, where the large model rarely has to repair it.",
    "maintainer": "Softanza places models where the data and the user are. This paper adds a placement: a micro model on the device for the first words, a large model for the rest, joined mid-sentence. It sets a figure to measure Softanza's own small models against, the time to the first word on the user's machine.",
    "learner": "A very small AI on your watch can start an answer at once while a big AI far away writes the rest, so you never wait for the first word."
  },
  "areas": ["aicha", "harobanda-edge"],
  "domains": ["models", "devices", "interfaces"],
  "concerns": ["speed", "sovereignty"],
  "actions": [
    {"area": "stzlib.intelligence", "do": "measure the time to the first word of the local answer path on the client's machine beside the time to the whole answer, and evaluate a micro opener model that writes the first 4 to 8 words while the chosen model continues, counting how often the continuation must repair the opener", "state": "routed", "dates": {"proposed": "2026-11-28", "routed": "2026-11-28"}}
  ],
  "status": "routed",
  "confidence": "reported",
  "sources": [
    {"title": "Micro Language Models Enable Instant Responses", "url": "https://aclanthology.org/2026.emnlp-main.141/", "by": "Wen Cheng, Tuochao Chen, Karim Helwani, Sriram Srinivasan, Luke Zettlemoyer, Shyamnath Gollakota", "read": "2026-11-28"}
  ],
  "review_by": "2027-02-28",
  "tags": ["small-models", "on-device", "latency", "wearables", "collaborative-generation", "edge"]
}
```

## What happened

Wen Cheng and Tuochao Chen, with Karim Helwani and Sriram Srinivasan of Meta AI and Luke Zettlemoyer and Shyamnath
Gollakota of the University of Washington, presented Micro Language Models Enable Instant Responses at EMNLP 2026 in
Budapest (pages 3240 to 3264, CC BY 4.0).

- **The models.** Decoder-only models of 8.8 to 29.5 million parameters, trained from scratch on 1.485 billion tokens
  of cleaned chat and fine-tuned on 323.4 million more. Between 14 and 29 million parameters they compare with several
  models of 70 to 256 million on short dialogue answers.
- **The handoff.** The micro model writes the first 4 to 8 words on the device and shows them at once, without
  waiting for a check. The cloud model receives the question and those words, is prompted to continue rather than to
  answer, and finishes the sentence. Adults read about 4 words a second, so 4 to 8 words hide 1 to 2 seconds of cloud
  delay.
- **When the opener is wrong.** Three repairs: an explicit correction, a natural pivot, and a humorous one.
  Participants preferred the natural pivot and the humour to the explicit correction.

| measure | figure |
|---|---|
| first token, 28M model on an Orange Pi | 45 ms (prefill 42 ms, first decode 3 ms) |
| four words, same | 55 ms |
| first token of a cloud answer, light to moderate load | 0.2 to 5+ s |
| answers the cloud must correct, at 4 / 8 / 16 words | 3.7% / 8.4% / 16.4% |
| 25 participants: joined preferred / equal / cloud alone preferred | 33.6% / 42.0% / 24.4% |
| live test, 10 participants: joined preferred | 42 of 50 trials |

The cloud models were Qwen2.5-72B and Qwen3-235B-A22B; the best joined setting also beat Qwen3-0.6B running alone.
The authors bound the work to everyday conversation in single turns: long prompts, exact arithmetic and specialised
terms raise the rate of repairs, and the Orange Pi stands in for a wearable's chip. The checkpoint and a demo are at
ulm.cs.washington.edu.

## Why it matters to Softanza

Softanza places each model where the data and the user are, and measures its small models by what they get right and
what they cost. This paper measures what a user feels first: the wait before the first word. It shows that a model of
28 million parameters is enough to open an answer, and that a large model can continue mid-sentence. For Softanza that
gives a placement to evaluate, a micro opener on the client's machine with the chosen model behind it, and a figure to
report for every answer path: the time to the first word on the user's own machine.

## What we do

- Route to the intelligence plane: measure the time to the first word of the local answer path, and evaluate a
  micro opener with the repair rate counted.
- Look again by 2027-02-28.

## Sources

- Wen Cheng and five co-authors, [Micro Language Models Enable Instant Responses](https://aclanthology.org/2026.emnlp-main.141/),
  EMNLP 2026, read 2026-11-28 in its PDF: the introduction, the method, the results, the user studies and the
  limitations. All figures are the authors' own.
