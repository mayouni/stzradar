# Jon's Arm Reference, a searchable site for the AArch64 instruction set and system registers, closes on December 4, 2026 at Arm's request; a reference a project depends on is safest taken from the vendor's own published source

```json
{
  "id": "2026-11-28-arm-reference-takedown",
  "date": "2026-11-28",
  "title": "Jon's Arm Reference, a searchable site for the AArch64 instruction set and system registers, closes on December 4, 2026 at Arm's request; a reference a project depends on is safest taken from the vendor's own published source",
  "kind": "practice",
  "summary": "Jon's Arm Reference (arm.jonpalmisc.com) gives searchable documentation for the AArch64 instructions (base, SIMD, SVE and SME) and the AArch64 and AArch32 system registers of the Armv8-A and Armv9-A architectures. Its author announces that it will close on December 4, 2026, after Arm's lawyers asked for it to be taken down, and that he is looking for a way to keep its links working. The site states no licence and no data source.",
  "stance": "learn",
  "relevance": "low",
  "level": "advice",
  "audiences": ["developer", "maintainer"],
  "notice": {
    "developer": "A third-party reference built from a vendor's documentation can disappear at the vendor's request. Link the vendor's own pages in code and documents, and save the version you used.",
    "maintainer": "Softanza's machines run on x86-64 and arm64 hosts, and its tools cite architecture references. Citing the vendor's own published source, with its version, keeps a citation valid when a convenient mirror closes."
  },
  "areas": ["harobanda", "softanza"],
  "domains": ["code", "society"],
  "concerns": ["sovereignty", "clarity"],
  "status": "analysed",
  "confidence": "read",
  "sources": [
    {"title": "Jon's Arm Reference", "url": "https://arm.jonpalmisc.com/", "by": "Jon (jonpalmisc.com)", "read": "2026-11-28"}
  ],
  "review_by": "2026-12-05",
  "tags": ["arm", "aarch64", "documentation", "licensing", "references"]
}
```

## What happened

Jon's Arm Reference, at arm.jonpalmisc.com, is a searchable reference for the AArch64 instruction set and system
registers of the Armv8-A and Armv9-A architectures: all instructions, in base, SIMD, SVE and SME groups, and the
AArch64 and AArch32 system registers, with a search on every page. Its front page now announces that the site will
close on December 4, 2026 at Arm's request, after Arm's lawyers asked for it to be taken down, and that its author is
looking for a way to keep bookmarks and links working. The page states no licence and no data source.

## Why it matters to Softanza

Softanza's machines run on x86-64 and arm64 hosts, and its engine and tools are checked against architecture
references. A convenient mirror of a vendor's documentation can close at the vendor's request, and every link to it
closes with it. Softanza cites the vendor's own published reference, with the version it read, so that a citation
stays valid whatever happens to a mirror.

## What we do

- Learn; check on 2026-12-05 whether the site closed and whether its links were kept.

## Sources

- Jon, [Jon's Arm Reference](https://arm.jonpalmisc.com/), its front page read 2026-11-28.
