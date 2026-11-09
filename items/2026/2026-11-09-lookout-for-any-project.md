# Lookout runs for any project: one file says what its agent learns and watches

```json
{
  "id": "2026-11-09-lookout-for-any-project",
  "date": "2026-11-09",
  "title": "Lookout runs for any project: one file says what its agent learns and watches",
  "kind": "feature",
  "summary": "Lookout now reads everything that belongs to its project from one file, lookout.yaml: the project, the watch, its readers, its map, and what the watching agent learns before each survey. The feed, the site with its trends, and the bar take their names and texts from it, and version 1.1.0 of the bar reads any watch's feed with the key the page gives it.",
  "stance": "adopt",
  "relevance": "medium",
  "level": "info",
  "audiences": ["developer", "maintainer"],
  "notice": {
    "developer": "Any project can run its own Lookout: copy the repository, write lookout.yaml, and point the bar at your feed with data-feed and data-key.",
    "maintainer": "Lookout's project-specific values now live in lookout.yaml, checked before every run; bar 1.1.0 is the version to pin, and 1.0.0 keeps working."
  },
  "areas": ["lookout"],
  "domains": ["agents", "security"],
  "concerns": ["sovereignty", "clarity"],
  "status": "done",
  "confidence": "read",
  "sources": [
    { "title": "Your own Lookout (docs/ADOPT.md)", "url": "https://github.com/mayouni/lookout/blob/main/docs/ADOPT.md", "by": "Lookout", "read": "2026-11-09" },
    { "title": "The agent's brief (docs/AGENT.md)", "url": "https://github.com/mayouni/lookout/blob/main/docs/AGENT.md", "by": "Lookout", "read": "2026-11-09" }
  ],
  "review_by": "2027-05-09",
  "tags": ["watch", "configuration", "bar"]
}
```

## What happened

Lookout separated what belongs to Softanza from what any watch needs. One file at the root of the repository,
`lookout.yaml`, now says which project the watch serves, what it watches, who reads it, which map it places news on,
who signs the feed, and what the watching agent must learn first: its goal, the project's own documents, what counts
as news and what never goes in, the sources to read, what each stance means, the rules it keeps, and where the work it
proposes goes.

`haro tools/feed.ring` reads that file before anything else, checks it against `schema/config.schema.json`, and
publishes it as `app/config.json`. Lookout Radar takes its names, taglines, introductions, readers and stances from
it. A view of the site, Make your own, explains the steps and writes a first `lookout.yaml` with its reader. Version
1.1.0 of the bar takes `data-feed`, `data-key` and `data-namespace`, so one script serves every watch, and the page
that includes it pins the key it trusts.

## Why it matters to Softanza

Softanza is a platform of platforms, and its tools are meant to serve other projects as well as its own. A watch that
only one project could run would be a tool for that project; a watch any project runs from one file is a platform
piece, with Softanza's own configuration as its first example.

## What we do

- Keep Softanza's watch on the same file as everyone else's: `lookout.yaml` at the root of this repository.
- Keep the feed contract, the levels and the readers shared, so that one reader, one bar and one site serve every
  watch.

## Sources

- Lookout, [Your own Lookout](https://github.com/mayouni/lookout/blob/main/docs/ADOPT.md) and
  [the agent's brief](https://github.com/mayouni/lookout/blob/main/docs/AGENT.md), read 2026-11-09.
