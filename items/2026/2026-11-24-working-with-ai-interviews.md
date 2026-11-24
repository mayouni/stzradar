# Anthropic interviews 58 companies: AI's value comes from more output and from roles rebuilt around a whole workflow, and the bottleneck is review; Softanza's Foundry states the review each pack creates

```json
{
  "id": "2026-11-24-working-with-ai-interviews",
  "date": "2026-11-24",
  "title": "Anthropic interviews 58 companies: AI's value comes from more output and from roles rebuilt around a whole workflow, and the bottleneck is review; Softanza's Foundry states the review each pack creates",
  "kind": "paper",
  "summary": "On November 23, 2026 Anthropic's economics team (Nathan Wilmers, Maxim Massenkoff, Peter McCrory) published Working with AI, a study of 66 face-to-face interviews in 58 US companies adopting AI, covering nearly 300 applications. Most of the value interviewees reported came from more output rather than lower cost, and around half of the output gains came from doing existing work faster. The largest gains came with broad change: one person or team owning a whole workflow, and staff moved to the tasks that hold work up. The bottlenecks named were inside the companies, above all the load of reviewing what AI produces and uneven adoption. Two-thirds of the companies reported hiring less because of AI, 10 reported hiring more, and two saw a position fully automated away. The authors describe the study as qualitative, with value as the interviewees describe it.",
  "stance": "learn",
  "relevance": "medium",
  "level": "advice",
  "audiences": ["developer", "maintainer"],
  "notice": {
    "developer": "When AI writes more, a person reviews more. The study found that review, not the model, is where work most often waits, so the time a reviewer spends per item is the figure that decides whether a tool pays.",
    "maintainer": "A Softanza pack delivers an agentic solution whole. The study says the value of such a solution shows as output and as a role rebuilt around the workflow, and that review is the common bottleneck; each pack can state the review it creates and its measured minutes per item."
  },
  "areas": ["foundry", "agents"],
  "domains": ["agents"],
  "concerns": ["cost", "trust"],
  "actions": [
    {"area": "foundry", "do": "record in each pack's delivery the review its outputs need: what a person checks, how many items a day, and the minutes per item measured in the pilot; and report the pack's value as the output it adds, beside any cost it removes", "state": "routed", "dates": {"proposed": "2026-11-24", "routed": "2026-11-24"}}
  ],
  "status": "routed",
  "confidence": "reported",
  "sources": [
    {"title": "Working with AI", "url": "https://www.anthropic.com/research/working-with-ai", "by": "Nathan Wilmers, Maxim Massenkoff, Peter McCrory (Anthropic)", "read": "2026-11-24"}
  ],
  "review_by": "2027-02-24",
  "tags": ["anthropic", "economics", "adoption", "work", "review", "interviews"]
}
```

## What happened

Anthropic's economics team published Working with AI on November 23, 2026. Nathan Wilmers, Maxim Massenkoff and Peter
McCrory held 66 face-to-face interviews in 58 US companies that are adopting AI, with executives, managers and people
who do the work, and discussed nearly 300 applications in detail. The companies were chosen to span industries, sizes
and levels of use; all are Anthropic customers, and many use other tools as well.

What they report:

- **Value is mostly more output.** Interviewees described more work done more often than lower cost. Around half of
  the output gains came from doing existing work faster; the other half from better work or new products.
- **The largest gains came with broad change.** One person or team owning a whole workflow, staff moved to the tasks
  that hold work up, shared infrastructure, and wide access to the company's own data.
- **The bottlenecks are inside the company.** The load of reviewing what AI produces, and adoption that is uneven
  across people, were named far more often than customers' doubts or regulation.
- **Jobs.** Two-thirds of the companies reported hiring less because of AI, a third of those through people who left
  and were not replaced; 10 reported hiring more; two saw a position fully automated away; five pushed out employees
  who would not adopt AI.
- **Two ways in.** Automation decided at the top proved brittle and drew resistance; experiments from the bottom gave
  pockets of value that depended on who adopted and who maintained them.

The authors describe the work as qualitative: the value is the interviewees' own account, and they call for
quantitative studies to test it. The interviews are anonymous.

## Why it matters to Softanza

Softanza's Foundry delivers an agentic solution as one signed pack, with its rules decided in code and its evidence
graded by Testoor. The study gives that delivery two figures to carry. The first is the review a pack creates: every
output a person must check is time taken from the role the pack was meant to free, and the study finds that time is
the usual bottleneck. Evidence a program can verify shortens that review, which is the reason Softanza grades its
evidence. The second is how value is stated: as the output a pack adds and the workflow one person now owns, the
measure the companies themselves used.

## What we do

- Route to the Foundry: each pack's delivery records the review its outputs need and the minutes per item measured in
  the pilot, and states its value as output added beside any cost removed.
- Look again by 2027-02-24.

## Sources

- Nathan Wilmers, Maxim Massenkoff and Peter McCrory, Anthropic,
  [Working with AI](https://www.anthropic.com/research/working-with-ai), November 23, 2026, read 2026-11-24. The web
  page was read; the report's PDF, with its appendix and references, and the data inside the figures were left for a
  second reading. All figures are the authors' and the interviewees' own.
