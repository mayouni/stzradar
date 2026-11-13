# A small recogniser trained on synthetic Arabic words reads words it never saw; Softanza trains its Arabic recogniser the same way

```json
{
  "id": "2026-11-13-trocr-arabic-synthetic",
  "date": "2026-11-13",
  "title": "A small recogniser trained on synthetic Arabic words reads words it never saw; Softanza trains its Arabic recogniser the same way",
  "kind": "practice",
  "summary": "An engineer reports fine-tuning Microsoft's TrOCR-Small, a 61-million-parameter recogniser of single printed text lines trained on English receipts, into an Arabic word reader: 78,000 unique Arabic words rendered into about 900,000 synthetic images with realistic augmentation, 80 minutes on one RTX 3090, 97.6% exact-word accuracy on vocabulary held out of training and 77.3% on photographs of street signs. TrOCR pairs an image Transformer encoder with a text Transformer decoder, scores 95.86 F1 on SROIE in its small size, and reads one line at a time.",
  "stance": "learn",
  "relevance": "medium",
  "level": "advice",
  "audiences": ["developer", "maintainer"],
  "notice": {
    "developer": "A recogniser learns a script from rendered text: tens of thousands of words, many fonts, realistic damage, and a test on words kept out of training; one consumer GPU and about an hour were enough for Arabic.",
    "maintainer": "Softanza's OCR already runs an Arabic recogniser in its own engine; it trains that recogniser on synthetic lines built from its Arabic word list, with the periods and Western digits real documents carry, and judges it on its Arabic golden sentences."
  },
  "areas": ["softanza", "aicha"],
  "domains": ["models"],
  "concerns": ["correctness", "sovereignty"],
  "actions": [
    { "area": "stzlib.intelligence", "do": "generate synthetic Arabic text lines from the engine's Arabic word list, with punctuation, Western and Arabic-Indic digits and mixed Latin words, in several fonts with scan and photo damage; fine-tune the PP-OCR Arabic recogniser the engine already runs on them, test on words held out of training, and judge it on the Arabic golden sentences against the platform floor", "state": "routed", "dates": { "proposed": "2026-11-13", "routed": "2026-11-13" } }
  ],
  "status": "routed",
  "confidence": "claimed",
  "sources": [
    { "title": "microsoft/trocr-small-printed (model card)", "url": "https://huggingface.co/microsoft/trocr-small-printed", "by": "Microsoft", "read": "2026-11-13" },
    { "title": "TrOCR: Transformer-based Optical Character Recognition with Pre-trained Models", "url": "https://arxiv.org/abs/2109.10282", "by": "Li et al., Microsoft", "read": "2026-11-13" },
    { "title": "microsoft/unilm, TrOCR (README)", "url": "https://github.com/microsoft/unilm/tree/master/trocr", "by": "Microsoft", "read": "2026-11-13" }
  ],
  "review_by": "2027-02-13",
  "tags": ["ocr", "arabic", "trocr", "synthetic-data", "fine-tuning"]
}
```

## What happened

An AI and computer-vision engineer described, in a public post this week, an Arabic text reader built on Microsoft's
TrOCR-Small. He rendered 78,000 unique Arabic words into about 900,000 synthetic images, with augmentation that
imitates real photographs, and fine-tuned the model for 80 minutes on a single NVIDIA RTX 3090. He reports 97.6%
exact-word accuracy on Arabic words kept out of the training vocabulary, and 77.3% on real photographs of street
signs. The point of the held-out test is generalisation: the model reads letters and their joins, and does more than
recall the words it was shown. The figures are the author's own.

The model he started from, `microsoft/trocr-small-printed`, is a 61-million-parameter recogniser published with the
TrOCR paper: an image Transformer encoder initialised from DeiT reads 16-by-16 patches of the picture, and a text
Transformer decoder initialised from UniLM writes the characters one token after another. This variant was fine-tuned
on SROIE, a set of scanned English receipts, where the small model scores 95.86 F1. It reads one line of printed text
per image and ships as PyTorch and Safetensors files of 246 MB; a page needs a separate step that finds its lines.

## Why it matters to Softanza

Softanza reads documents with an OCR faculty that chooses, per language, between the platform's reader and a PP-OCR
model running in Softanza's own engine. French and Russian are settled. Arabic is the language with the most to gain:
on Softanza's Arabic golden sentences the platform reader scores 0.62, and the engine's Arabic recogniser, a published
5-million-parameter model, reads the letters and drops the periods and Western digits that real documents carry.

The post gives the recipe for exactly that gap. A recogniser's vocabulary of shapes comes from its training pictures,
and synthetic pictures can hold whatever the documents hold. Softanza already has the ingredients: an Arabic word list
in its engine, font rendering, the scan and photo damage its OCR tests generate, a recogniser whose every operation runs
in the engine, and golden sentences that say whether the result is better. Training lines that mix Arabic words with
periods, both digit families and Latin product codes teach the recogniser what its first training left out, and a
5-million-parameter model trains on the estate's own 6 GB GPU.

Softanza keeps its own recogniser as the base: it is twelve times smaller than TrOCR-Small, reads a whole line in one
pass, and already has its place in the pipeline. TrOCR contributes the method and a reference point for accuracy.

## What we do

- Route to the intelligence plane synthetic Arabic training lines and a fine-tune of the engine's Arabic recogniser,
  judged on held-out words and on the Arabic golden sentences.
- Look again by 2027-02-13.

## Sources

- Microsoft, [microsoft/trocr-small-printed](https://huggingface.co/microsoft/trocr-small-printed), read 2026-11-13.
- Li et al., [TrOCR: Transformer-based Optical Character Recognition with Pre-trained Models](https://arxiv.org/abs/2109.10282),
  and the [TrOCR README](https://github.com/microsoft/unilm/tree/master/trocr) for the small model's scores, read
  2026-11-13.
- The Arabic fine-tune is reported in its author's public post of 2026-11-12; its figures are his own.
