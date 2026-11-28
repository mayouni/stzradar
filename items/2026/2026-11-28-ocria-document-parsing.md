# LlamaIndex publishes the weights of OCRia-1, a 4B vision-language model fine-tuned from Qwen3.5-4B that turns a page image into Markdown with HTML tables, first of 23 open-weight models on ParseBench 2 at 85.24, and OCRia-nano-1, an 8.1M-parameter CPU pipeline; both under a licence that charges larger companies and bars competing parsers

```json
{
  "id": "2026-11-28-ocria-document-parsing",
  "date": "2026-11-28",
  "title": "LlamaIndex publishes the weights of OCRia-1, a 4B vision-language model fine-tuned from Qwen3.5-4B that turns a page image into Markdown with HTML tables, first of 23 open-weight models on ParseBench 2 at 85.24, and OCRia-nano-1, an 8.1M-parameter CPU pipeline; both under a licence that charges larger companies and bars competing parsers",
  "kind": "release",
  "summary": "LlamaIndex published the weights of OCRia-1 on Hugging Face and Ollama in November 2026, a day after OCRia-nano-1. OCRia-1 is fine-tuned from Qwen3.5-4B on 100,979 pages, 82,943 real and 18,036 synthetic, with supervised training then reinforcement learning on verifiable rewards. It reads one page image and writes Markdown, with tables and chart data as HTML tables with merged cells, diagrams as Mermaid and formulas in LaTeX. On ParseBench 2 (4,317 pages) it scores 85.24 overall, seventh of 61 systems and first of 23 open-weight ones; on charts 77.63, where the next open models score 62 to 63. Ollama offers it at 8 bits (5.8 GB) and in BF16 (10 GB); a 4-bit build lost 6.3 points on financial tables and is not published. Thinking must be off. OCRia-nano-1 is 8.1M parameters of ONNX models, distilled from OCRia-1, that run on the CPU inside LiteParse at 27.8 pages per second on 16 vCPUs and score 59.2 on ParseBench 2. Both licences, based on Open RAIL-M, allow research, evaluation and personal use; commercial use is free below $2M of annual revenue and $2M of funding, and a parsing product that competes with LlamaParse needs a commercial licence at any size. The figures are LlamaIndex's own.",
  "stance": "learn",
  "relevance": "medium",
  "level": "advice",
  "audiences": ["developer", "maintainer", "learner"],
  "notice": {
    "developer": "A 4B model now turns scanned pages, tables and charts into Markdown about as well as models nine times larger, and runs on a single workstation GPU through Ollama. Read the licence before building on it: commercial use above $2M of revenue or funding, or in any competing parser, needs a paid licence. Keep it at 8 bits: 4 bits lost over 6 points on tables.",
    "maintainer": "Softanza reads documents through its own OCR faculty. OCRia-1's licence lets Softanza evaluate and benchmark it freely and bars building a parser on it, so its place is as a measured reference beside the faculty's own engine. Its method carries over whole: a general vision model fine-tuned on real and synthetic pages, then reinforcement learning on rewards a program can check.",
    "learner": "A model can now read a photo of a page and rewrite it as clean text, with its tables and charts turned into tables. Its maker shares the model, but larger companies must pay to use it in their products."
  },
  "areas": ["aicha", "softanza"],
  "domains": ["models", "data"],
  "concerns": ["correctness", "cost", "sovereignty"],
  "actions": [
    {"area": "stzlib.intelligence", "do": "measure OCRia-1 at 8 bits through Ollama as an evaluation reference for the OCR faculty: run it on the faculty's golden pages, including Arabic and French, and record text, table and reading-order scores and seconds per page on this machine beside the faculty's own engine; record its licence as permitting evaluation and excluding it from anything Softanza ships", "state": "routed", "dates": {"proposed": "2026-11-28", "routed": "2026-11-28"}}
  ],
  "status": "routed",
  "confidence": "claimed",
  "sources": [
    {"title": "llamaindex/ocria-1", "url": "https://ollama.com/llamaindex/ocria-1", "by": "LlamaIndex", "read": "2026-11-28"},
    {"title": "OCRia-1 model card", "url": "https://huggingface.co/llamaindex/OCRia-1", "by": "LlamaIndex", "read": "2026-11-28"},
    {"title": "OCRia-nano-1 model card", "url": "https://huggingface.co/llamaindex/OCRia-nano-1", "by": "LlamaIndex", "read": "2026-11-28"}
  ],
  "review_by": "2027-02-28",
  "tags": ["ocr", "document-parsing", "vision-language-models", "tables", "licensing", "ollama", "qwen"]
}
```

## What happened

LlamaIndex published the weights of two document-parsing models in November 2026, on Hugging Face and Ollama:
OCRia-nano-1, then OCRia-1 a day later. Its paid service, LlamaParse, runs a tuned version of the same family.

- **OCRia-1.** A vision-language model fine-tuned from Qwen3.5-4B (Hugging Face counts 5B parameters with the vision
  encoder). Training used 100,979 pages: 82,943 real pages from eleven permissively licensed sources and 18,036
  synthetic ones, mostly tables and charts. Two epochs of supervised training, then GRPO with rewards a program can
  check, then an average of two checkpoints.
- **Input and output.** One page image per request, about 4.1 megapixels for the published scores; a PDF is rendered
  by the caller. Markdown out, with tables and chart data as HTML tables with merged cells, diagrams as Mermaid,
  formulas as LaTeX, and headers, footers and checkboxes marked.
- **Running it.** `ollama run llamaindex/ocria-1 --think=false ./page.png`; thinking must be off. Ollama offers q8_0
  (5.8 GB) and BF16 (10 GB). A 4-bit build lost 6.3 points on financial tables and 4.8 on insurance tables, and is not
  published. On one B200 with LlamaIndex's own kernels it parses 10.2 pages per second; the published weights on
  stock vLLM decode about 320 tokens per second.
- **OCRia-nano-1.** 8.1 million parameters of ONNX models, distilled from OCRia-1, that run on the CPU inside
  LiteParse (Apache 2.0), with recognizers for Latin, CJK, Arabic and Hebrew and about 17 more scripts.

ParseBench 2, 4,317 pages, LlamaIndex's figures:

| system | overall | text | tables | charts | forms |
|---|---|---|---|---|---|
| OCRia-1, 4B | 85.24 | 87.87 | 86.28 | 77.63 | 82.09 |
| Infinity-Parser2-Pro, 35B | 78.50 | 85.55 | 86.27 | 55.64 | 77.79 |
| LightOnOCR-3, 4B | 78.39 | 84.30 | 78.25 | 62.90 | 79.19 |
| Chandra-OCR-2, 4B | 77.54 | 77.18 | 85.60 | 62.48 | 78.73 |
| Mistral OCR 4.1 | 73.96 | 84.44 | 81.89 | 29.83 | 79.78 |
| LiteParse with OCRia-nano-1, CPU | 59.2 | 68.5 | 59.5 | 3.1 | 69.8 |

On olmOCR-bench (tables and formulas) OCRia-1 scores 90.5, on PulseBench-Tab 84 and on fr-bench-pdf2md 72.1, each
the highest in its table. The nano pipeline parses 27.8 pages per second on 16 vCPUs.

**The licence.** Both models carry a licence based on Open RAIL-M. Research, teaching, evaluation, benchmarking and
personal use are free. Commercial use is free for an organisation under $2M of annual revenue and $2M of total
funding. Above that, and for any document parsing or extraction product that competes with LlamaParse or LlamaCloud
at any size, a commercial licence is needed. Users own their outputs.

## Why it matters to Softanza

Softanza reads documents through its own OCR faculty, in Arabic, French and English. OCRia-1 shows how far a 4B model
now goes on tables and charts, the parts of a page that line-by-line OCR loses, and its licence decides its place:
free to evaluate and benchmark, closed to a parser built on it. So Softanza uses it as a measured reference for the
faculty, and keeps its method: a general vision model, real and synthetic pages, then rewards a program can check.

## What we do

- Route to the intelligence plane: run OCRia-1 at 8 bits on the OCR faculty's golden pages as an evaluation
  reference, scored and timed beside the faculty's own engine, with its licence recorded as evaluation only.
- Look again by 2027-02-28.

## Sources

- LlamaIndex, [llamaindex/ocria-1 on Ollama](https://ollama.com/llamaindex/ocria-1), the
  [OCRia-1 model card](https://huggingface.co/llamaindex/OCRia-1) and the
  [OCRia-nano-1 model card](https://huggingface.co/llamaindex/OCRia-nano-1), read 2026-11-28 through a summarising
  reader, from a LinkedIn announcement by Jerry Liu. All figures are LlamaIndex's own.
