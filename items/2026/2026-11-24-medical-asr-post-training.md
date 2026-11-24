# Besimple post-trains two open speech models on medical terms for about $500 and beats three closed models on medical dictation; Softanza measures its own transcriber on the words of a domain

```json
{
  "id": "2026-11-24-medical-asr-post-training",
  "date": "2026-11-24",
  "title": "Besimple post-trains two open speech models on medical terms for about $500 and beats three closed models on medical dictation; Softanza measures its own transcriber on the words of a domain",
  "kind": "practice",
  "summary": "On November 23, 2026 Baseten published how Besimple adapted two open speech recognition models, Nemotron 3.5 Transcribe and Qwen3-ASR, to medical vocabulary. From a dictionary of 274,541 terms they generated sentences, spoke them with synthetic voices of varied accents, replaced about 29% of those clips with human recordings over several rounds, and mixed in general speech: 813 hours in all, trained with LoRA for an estimated $500 of GPU time for both models. Errors on medical terms in human dictation fell from 2.83% to 0.87% for Nemotron and from 5.84% to 2.05% for Qwen3-ASR; the best closed model measured scored 1.05%. On general English speech the adapted models stay behind the closed ones, and Qwen3-ASR lost ground there. The figures are the authors' own.",
  "stance": "learn",
  "relevance": "high",
  "level": "advice",
  "audiences": ["developer", "maintainer"],
  "notice": {
    "developer": "An overall word error rate hides the words that matter. A transcriber can be right on 95% of words and wrong on the drug name; score the domain's terms on their own, and keep a general set to see what adapting cost.",
    "maintainer": "Softanza's transcriber runs Whisper in its own engine, raises its hearing with a glossary prompt, and already routes Hausa to an adapted checkpoint by the court's measure. The same route serves a domain: a term-dense set spoken from the glossary, errors on terms scored apart, and an adapter kept only where it wins."
  },
  "areas": ["aicha", "softanza"],
  "domains": ["models", "data"],
  "concerns": ["correctness", "cost", "sovereignty"],
  "actions": [
    {"area": "stzlib.intelligence", "do": "score the transcriber's errors on a domain's own words apart from its overall word error rate, on a term-dense set spoken from the glossary and a general set kept as a guard against regression; then compare the glossary prompt with a small adapter trained on that set, and route a domain to the adapter only where the court measures it better", "state": "routed", "dates": {"proposed": "2026-11-24", "routed": "2026-11-24"}}
  ],
  "status": "routed",
  "confidence": "claimed",
  "sources": [
    {"title": "Post-train your own medical ASR model to outperform the frontier", "url": "https://www.baseten.co/blog/post-train-your-own-medical-asr-model-to-outperform-the-frontier/", "by": "Lei Pan, Ardin Lo, Brandon Tai, Reese Tateo, Yi Zhong (Baseten, Besimple)", "read": "2026-11-24"}
  ],
  "review_by": "2027-02-24",
  "tags": ["speech-recognition", "asr", "medical", "lora", "synthetic-data", "nemotron", "qwen3-asr", "post-training"]
}
```

## What happened

Baseten published on November 23, 2026 how Besimple, a data company, adapted two open speech recognition models to
medical vocabulary on Baseten's training service: Nemotron 3.5 Transcribe and Qwen3-ASR.

How the data was built:

- **From a dictionary.** 274,541 medical terms. Sentences were generated around terms the model got wrong, spoken by
  synthetic voices with varied accents, and the round was repeated; about 28.9% of the synthetic clips were then
  replaced by human recordings.
- **A mix with general speech.** 482 hours of short dictionary passages, 243 hours of synthetic dense medical text,
  21 hours of human medical speech and 67 hours of human general speech: 813 hours. An earlier attempt on 100 hours of
  human script reading alone gave small gains and made the model repeat itself on long recordings.
- **Training.** Full fine-tuning first, then LoRA with general speech mixed in, on H100 and B200 GPUs, for an
  estimated $120 for Qwen3-ASR and $380 for Nemotron.

What was measured, as error rates on the medical terms only (Term-WER) and on all words (WER):

| model | medical dictation, terms | synthetic clinical notes, terms | general English, WER |
|---|---|---|---|
| Nemotron 3.5 Transcribe | 2.83% | 12.45% | 5.36% |
| the same, adapted | 0.87% | 6.43% | 5.13% |
| Qwen3-ASR | 5.84% | 14.72% | 4.59% |
| the same, adapted | 2.05% | 4.82% | 5.52% |
| Gemini 3.5 Transcribe | 1.05% | 9.61% | 4.39% |
| ElevenLabs Scribe V2 Medical | 1.13% | 7.09% | 4.23% |
| OpenAI GPT Transcribe | 1.48% | 10.64% | 4.86% |

The sets are Corti's MedDictate (24 human recordings) and MedTerm (200 synthetic recordings) and Google's FLEURS
(647 recordings). The authors note that the gain depends on the base model, that gains on the full dictionary levelled
off after the third round, and that a benchmark should match the speech it will serve. The recipe, data and
checkpoint are offered on request; a cookbook for Qwen3-ASR is public.

## Why it matters to Softanza

Softanza transcribes speech in its own engine with Whisper, offered as the `:transcribe` faculty. A glossary given as
a prompt raised its hearing of a test set from 7 to 9 of 10, and Hausa is routed to an adapted checkpoint because the
court measured it better for that language. Besimple's account carries that route from languages to domains, with
three parts Softanza can take as they are: errors on a domain's own words are scored apart from the overall rate,
a term-dense set can be spoken from the glossary itself, and a general set stays beside it to show what adapting cost.
A small adapter is then one more candidate for the court, kept for a domain only where it wins.

## What we do

- Route to the intelligence plane a domain measure for the transcriber: term errors scored apart, a set spoken from
  the glossary, a general set as guard, and the glossary prompt compared with an adapter.
- Look again by 2027-02-24.

## Sources

- Lei Pan, Ardin Lo, Brandon Tai, Reese Tateo and Yi Zhong,
  [Post-train your own medical ASR model to outperform the frontier](https://www.baseten.co/blog/post-train-your-own-medical-asr-model-to-outperform-the-frontier/),
  Baseten, November 23, 2026, read 2026-11-24. The text was read in full; the demo video and the two charts were
  read by their captions. All figures are the authors' own, on 24 human recordings for medical dictation.
