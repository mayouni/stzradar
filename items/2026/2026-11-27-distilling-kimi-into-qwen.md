# Together AI distils Kimi-K3.1-Pro's Lao translation into Qwen3.8-27B for $260 in all, from 4,000 teacher translations, reaching 93% of the teacher's score while a language it was not trained on holds

```json
{
  "id": "2026-11-27-distilling-kimi-into-qwen",
  "date": "2026-11-27",
  "title": "Together AI distils Kimi-K3.1-Pro's Lao translation into Qwen3.8-27B for $260 in all, from 4,000 teacher translations, reaching 93% of the teacher's score while a language it was not trained on holds",
  "kind": "practice",
  "summary": "Together AI (Zain Hasan and Sonny Khan, November 26, 2026) taught Qwen3.8-27B to translate English into Lao from Kimi-K3.1-Pro's own translations. The two models use different tokenizers, so the teacher passes only text: it translates FLORES-200 and Wikipedia sentences at temperature 0 with thinking off, a filter keeps translations written at least 70% in the target script, and the student is trained on them with LoRA and cross-entropy on its own chat template. On chrF++ the student's Lao rises from 5.5 to 44.3, against 47.5 for the teacher, and its Thai, mixed into the data, rises from 46.7 to 47.8; training on 945 human Lao references alone scores 44.7 on Lao and drops Thai to 5.3. The teacher's 4,000 Lao translations cost $7.46 and all the experiments $260. A five-language adapter raised Northern Sotho from 32.7 to 48.0 and Zulu from 37.7 to 39.2. The figures are the authors' own.",
  "stance": "adopt",
  "relevance": "high",
  "level": "advice",
  "audiences": ["developer", "maintainer", "learner"],
  "notice": {
    "learner": "A large AI model can teach a small one a new language from its own translations; check the languages the small one already knew, because it can forget them.",
    "developer": "A large model's translations can teach a small one a language it barely knows, for a few dollars of teacher text. Check a language you did not train on as well: training on Lao alone took the student's Thai from 46.7 to 5.3.",
    "maintainer": "Softanza measures its models language by language, and runs small models where the data lives. This recipe moves a large model's skill in one language into a small model, with text alone, across different tokenizers: the way to raise a language where the local model trails, measured with a guard language beside it."
  },
  "areas": ["aicha", "softanza"],
  "domains": ["models", "data"],
  "concerns": ["cost", "correctness", "sovereignty"],
  "actions": [
    {"area": "stzlib.intelligence", "do": "for each language of the matrix where a small local model trails a large one, generate the large model's translations of public sentences, keep those in the right script, train the small model on them with a guard language mixed in, and measure on held-out sentences the target language, the guard language, and the cost of the teacher's text", "state": "routed", "dates": {"proposed": "2026-11-27", "routed": "2026-11-27"}}
  ],
  "status": "routed",
  "confidence": "claimed",
  "sources": [
    {"title": "Distilling Kimi into Qwen", "url": "https://www.together.ai/blog/distilling-kimi-into-qwen", "by": "Zain Hasan and Sonny Khan, Together AI", "read": "2026-11-27"},
    {"title": "post-training cookbook: distillation", "url": "https://github.com/togethercomputer/post-training-cookbook/tree/main/post_training_cookbook/distillation", "by": "Together AI", "read": "2026-11-27"}
  ],
  "review_by": "2027-02-27",
  "tags": ["distillation", "translation", "low-resource-languages", "lora", "fine-tuning", "small-models", "multilingual"]
}
```

## What happened

Zain Hasan and Sonny Khan of Together AI published on November 26, 2026 how they taught Qwen3.8-27B to translate
English into Lao, a language it barely wrote, from the translations of Kimi-K3.1-Pro.

- **Why text and not probabilities.** Distillation on the student's own outputs needs the teacher's probabilities on
  the student's tokens, which in practice means a shared tokenizer. Kimi and Qwen do not share one, so the teacher
  passes only text, and the student is trained on it as ordinary examples in its own chat template.
- **The teacher's text.** Kimi translated 997 FLORES-200 sentences and 4,000 English Wikipedia sentences, at
  temperature 0 and with thinking off; thinking scored lower on Lao (43.5 against 47.3) for about eight times the
  tokens. A filter kept translations written at least 70% in the target script, which removed 4% of the Lao.
- **The training.** LoRA of rank 64 on the student, cross-entropy on the answer tokens only, batch 16, a learning
  rate peaking at 1e-4. A step took about 3 seconds on B200 GPUs; the best Lao run held its machine 46 minutes.
- **The price.** The teacher's 4,000 Lao translations cost $7.46, and all the experiments $260.

chrF++ on FLORES devtest (1,012 Lao sentences, 300 Thai):

| run | Lao | Thai |
|---|---|---|
| Qwen3.8-27B as published | 5.5 | 46.7 |
| trained on 945 human Lao translations | 44.7 | 5.3 |
| distilled, Lao only | 41.8 | 44.3 |
| distilled, Lao and Thai | 41.9 | 47.4 |
| distilled, Lao and Thai, four times the Lao | 44.3 | 47.8 |
| Kimi-K3.1-Pro, the teacher | 47.5 | 49.9 |

Every distilled run writes Lao in its own script on all sentences, against 11% for the published model. The
authors note that the human translations score higher partly because the test set was translated by the same
process. A five-language adapter, 8,871 examples, raised Northern Sotho from 32.7 to 48.0 (teacher 50.7), Yoruba
from 20.7 to 25.7 (27.7), Zulu from 37.7 to 39.2 (50.3), where 1 to 2% of outputs fell into repetition, and Thai
from 46.7 to 48.0. The scripts are in Together's post-training cookbook.

## Why it matters to Softanza

Softanza measures its models language by language, and runs small models on the machine that holds the data; the
languages its users write are where a small local model trails a large one. This post gives a measured, cheap way
to close that gap: a large model's translations, filtered by script, taught to a small model as plain text, so the
two need not share a tokenizer. Its two lessons carry over whole. Mix a language you are not teaching into the
data, and measure it: training on one language alone broke another. And prefer the teacher with thinking off when
the task is translation: it scored higher at an eighth of the tokens.

## What we do

- Route to the intelligence plane: for each language where the local model trails, distil a large model's
  translations into it with a guard language mixed in, and measure the target, the guard and the teacher's cost.
- Look again by 2027-02-27.

## Sources

- Zain Hasan and Sonny Khan, [Distilling Kimi into Qwen](https://www.together.ai/blog/distilling-kimi-into-qwen),
  Together AI, November 26, 2026, read 2026-11-27 in full; and the
  [distillation scripts](https://github.com/togethercomputer/post-training-cookbook/tree/main/post_training_cookbook/distillation)
  it links. All figures are the authors' own.
