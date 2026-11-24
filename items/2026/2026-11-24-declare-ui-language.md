# Declare, a user-interface language written by models and checked by its compiler: half React's lines and eleven hidden checks of eleven in one run; Softanza measures Zayn and Haro's diagnostics the same way

```json
{
  "id": "2026-11-24-declare-ui-language",
  "date": "2026-11-24",
  "title": "Declare, a user-interface language written by models and checked by its compiler: half React's lines and eleven hidden checks of eleven in one run; Softanza measures Zayn and Haro's diagnostics the same way",
  "kind": "release",
  "summary": "Declare, by David Temkin (co-founder of Laszlo Systems, which made OpenLaszlo), is an MIT-licensed declarative language for user interfaces, described as a UI language for you and your AI. Square brackets hold the view tree and braces hold TypeScript; an attribute in braces is a constraint whose dependencies the compiler extracts, and an assignment makes its dependents recompute. There is no CSS. The same tree renders to the DOM, to a canvas or to a native Mac host, in Node or the browser with no build step. It ships an agent skill, a six-rung verifier, and diagnostics that each name the rewrite that fixes them. In the author's single-run comparison, a ticket-buying app took 1,279 lines against React's 2,666, and its first build that ran passed eleven hidden checks of eleven against React's six. The figures are the author's own.",
  "stance": "learn",
  "relevance": "high",
  "level": "advice",
  "audiences": ["developer", "maintainer"],
  "notice": {
    "developer": "Code a model writes is usually judged by whether it looks right. A language whose structure the compiler can check, and whose every error names its fix, lets the model correct itself before a person reads the result.",
    "maintainer": "Softanza has its own interface (Zayn) and its own language (Haro), both meant to be written by models. Declare measures what that buys: lines, compiler errors per build, and hidden checks passed by the first build that runs. The same three figures apply to a Zayn screen, and a diagnostic that names its fix is a form Haro can count."
  },
  "areas": ["zayn", "haro"],
  "domains": ["interfaces", "code"],
  "concerns": ["correctness", "clarity"],
  "actions": [
    {"area": "zayn", "do": "give a model one small Zayn application to build under hidden behaviour checks, as Declare's ticket-buying test does, and record the lines written, the compiler errors per build, and the checks passed by the first build that runs", "state": "routed", "dates": {"proposed": "2026-11-24", "routed": "2026-11-24"}},
    {"area": "haro", "do": "count, over a sample of agent sessions, the share of Haro's diagnostics that name the rewrite that fixes them, and give that form to the most frequent ones", "state": "routed", "dates": {"proposed": "2026-11-24", "routed": "2026-11-24"}}
  ],
  "status": "routed",
  "confidence": "claimed",
  "sources": [
    {"title": "Declare", "url": "https://davidtemkin.github.io/declarelang/", "by": "David Temkin", "read": "2026-11-24"},
    {"title": "declarelang (repository)", "url": "https://github.com/davidtemkin/declarelang", "by": "David Temkin", "read": "2026-11-24"}
  ],
  "review_by": "2027-02-24",
  "tags": ["declare", "ui-language", "declarative", "constraints", "coding-agents", "diagnostics", "openlaszlo"]
}
```

## What happened

David Temkin, co-founder of Laszlo Systems and lead of the OpenLaszlo team, publishes Declare under the MIT licence:
a declarative language for user interfaces, presented as a UI language for you and your AI. Its argument is that code
a model writes is checked by resemblance, and resemblance is not correctness; a small language whose views, state,
dependencies and layout are first-class lets the compiler check them.

```
App [ width = 400, height = 140,
    count: number = 0,
    onClick() { count = count + 1 },
    Text [ x = center, y = center,
        text = { `Clicked ${count} times` } ]
    ]
```

- **Structure and code apart.** Square brackets hold the view tree; braces hold TypeScript, type-checked. An attribute
  in braces is a constraint: the compiler extracts what it depends on, and an assignment makes its dependents
  recompute. There is no CSS, no selector, no cascade.
- **One tree, several targets.** The DOM, a single canvas, and a native Mac host; it runs in Node or the browser with
  no build step.
- **Made for models.** Declare ships an agent skill and an AGENTS.md, a six-rung verifier, an inspector that explains
  live values, and diagnostics that each name the rewrite that fixes them.

The author's figures: a calendar of 568 lines, 177 KB gzipped over the wire, built with AI; a tracker holding
1,000,000 issues in 1,508 lines; and a ticket-buying app built by a model in both languages, in single runs the author
marks as such: 1,279 lines against React's 2,666, and a first running build that passed eleven hidden checks of
eleven against React's six. Over a hundred runs of that app, build time went from 48 to 24 minutes and compiler errors
per build from 32 to 6. The project describes itself as young and moving quickly; the repository shows 906 commits.

## Why it matters to Softanza

Softanza holds the same conviction in two places: Zayn, its interface, and Haro, its language, are both meant to be
written by models and checked by tools. Declare turns that conviction into three figures a reader can compare: lines
written, compiler errors per build, and hidden checks passed by the first build that runs. A Zayn screen built by a
model under hidden checks gives Softanza the same three figures. And a diagnostic that names its own fix is the
shortest path from an agent's error to its correction; Haro can count how many of its diagnostics already have that
form and give it to the most frequent ones.

## What we do

- Route to Zayn: one small application built by a model under hidden behaviour checks, with the three figures.
- Route to Haro: the share of diagnostics that name their rewrite, over a sample of agent sessions.
- Look again by 2027-02-24.

## Sources

- David Temkin, [Declare](https://davidtemkin.github.io/declarelang/) and its
  [repository](https://github.com/davidtemkin/declarelang), read 2026-11-24. The opening of the home page and the
  README were read in full, the rest of the home page through a summary; the language reference, the tour and the
  evaluation reports were left for a second reading. All figures are the author's own.
