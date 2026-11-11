# NVIDIA's Nemotron 3.5 Parse reads a page into text, tables and layout with 0.63 billion parameters; Softanza's OCR court hears it

```json
{
  "id": "2026-11-11-nemotron-parse",
  "date": "2026-11-11",
  "title": "NVIDIA's Nemotron 3.5 Parse reads a page into text, tables and layout with 0.63 billion parameters; Softanza's OCR court hears it",
  "kind": "release",
  "summary": "On October 17, 2026 NVIDIA released Nemotron 3.5 Parse, a 0.631-billion-parameter model that turns a page image into text, tables, chart data, reading order, semantic classes and bounding boxes, exported as Markdown, HTML or JSON. NVIDIA reports 75.20 on the ParseBench benchmark in its three-pass mode, the best of the systems it compares, and multilingual OCR evaluated over 163 language and script entries. On November 4 it added a native 89.3-million-parameter DFlash2 drafter for speculative decoding; the model is published under OpenMDW-1.1.",
  "stance": "learn",
  "relevance": "high",
  "level": "advice",
  "audiences": ["developer", "maintainer"],
  "notice": {
    "developer": "An open 0.63B model now reads whole pages, tables and charts included, into Markdown or JSON; Softanza measures it against its own OCR pipeline before choosing.",
    "maintainer": "Softanza's OCR court measures Nemotron 3.5 Parse on its golden pages, by a reference run, before any port of its encoder and decoder is planned."
  },
  "areas": ["softanza", "aicha"],
  "domains": ["models", "data"],
  "concerns": ["correctness", "cost", "sovereignty"],
  "actions": [
    { "area": "stzlib", "do": "run Nemotron 3.5 Parse once by its published reference path on the OCR plane's golden pages, single and triple pass, and enter the result in the OCR court beside the PP-OCR pipeline and Granite-Docling, with the languages and scripts each one reads", "state": "proposed", "dates": { "proposed": "2026-11-11" } }
  ],
  "status": "analysed",
  "confidence": "claimed",
  "sources": [
    { "title": "Nemotron-3.5-Parse (model card)", "url": "https://huggingface.co/nvidia/Nemotron-3.5-Parse", "by": "NVIDIA", "read": "2026-11-11" }
  ],
  "review_by": "2027-01-11",
  "tags": ["nvidia", "nemotron", "ocr", "document-parsing", "slm"]
}
```

## What happened

NVIDIA released Nemotron 3.5 Parse on Hugging Face on October 17, 2026. It takes a page image (a scan, a rendered
PDF page, a slide, a form) and returns its text, tables, chart data, reading order, the class of each block and its
bounding box, as Markdown, HTML or structured JSON. The card gives 0.631 billion parameters, an encoder from NVIDIA's
C-RADIOv4 vision family and an mBART-style decoder.

It offers three modes. A single pass reads the full page once; a double pass re-reads the tables and charts it found
at higher detail; a triple pass also runs an independent layout detector and refines the union of both. NVIDIA
reports ParseBench overall scores of 72.74, 74.92 and 75.20 for the three modes, and about 18.6, 14.6 and 13.5 pages
per second on one H200 data-centre GPU with the DFlash2 drafter added on November 4. It says multilingual OCR was
evaluated over 163 language and script entries in 26 script groups. The figures are NVIDIA's own.

## Why it matters to Softanza

Reading documents is one of Softanza's most used faculties: the OCR plane, the PDF reader and the document flows all
start from a page. They run the PP-OCR models through Softanza's own engine, chosen by an OCR court on golden pages,
and the engine also holds Granite-Docling, a 258-million-parameter document model. Parse does in one small model what that pipeline does in stages, which makes it worth
learning from even before it is worth adopting: it predicts reading order and block classes with the text, and it
re-reads tables and charts on purpose.

The stance is to learn first. Its speed figures come from a data-centre GPU and its accuracy from NVIDIA's
comparison, and its encoder and decoder are two architectures the engine would have to add. One reference run on
Softanza's own pages, in the languages and scripts its users write, says whether that work is worth doing.

## What we do

- Propose to stzlib one measured run on the OCR golden pages, entered in the OCR court.
- Plan a port only if the court's verdict calls for one.
- Look again by 2027-01-11.

## Sources

- NVIDIA, [Nemotron-3.5-Parse model card](https://huggingface.co/nvidia/Nemotron-3.5-Parse), read 2026-11-11.
  Accuracy and speed figures are NVIDIA's own.
