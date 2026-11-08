# Lookout opens: a public watch on AI, read from Softanza's point of view

```json
{
  "id": "2026-11-08-lookout-opens",
  "date": "2026-11-08",
  "updated": "2026-11-09",
  "title": "Lookout opens: a public watch on AI, read from Softanza's point of view",
  "kind": "idea",
  "summary": "Softanza opened Lookout, a public repository that reads developments in AI at their source and judges each one against what Softanza builds. Every entry is written twice in one file, as a page for people and as data for programs, and a feed is generated from the data.",
  "stance": "adopt",
  "relevance": "high",
  "level": "info",
  "audiences": [
    "developer",
    "learner",
    "maintainer"
  ],
  "notice": {
    "developer": "Softanza now keeps a public watch on AI developments: read it on GitHub, or fetch feed/index.json to show its notices in your own tools.",
    "learner": "There is now one place that explains, in plain words, what changes in AI mean for what you learn with Softanza.",
    "maintainer": "Lookout is open: send it the AI developments that touch your project, and expect the tasks it proposes to reach you through Bangalo."
  },
  "areas": [
    "softanza"
  ],
  "actions": [
    {
      "area": "softanza",
      "do": "run the first weekly survey and publish its digest",
      "state": "proposed"
    },
    {
      "area": "stzlib",
      "do": "propose a command that reads this feed for its user's audience and level",
      "state": "proposed"
    }
  ],
  "status": "done",
  "confidence": "read",
  "sources": [
    {
      "title": "Lookout's README",
      "url": "https://github.com/mayouni/lookout",
      "by": "Softanza",
      "read": "2026-11-08"
    },
    {
      "title": "The feed contract, version 1",
      "url": "https://github.com/mayouni/lookout/blob/main/docs/FEED.md",
      "by": "Softanza",
      "read": "2026-11-08"
    }
  ],
  "review_by": "2027-05-08",
  "tags": [
    "watch",
    "feed",
    "notices"
  ]
}
```

## What happened

The author of Softanza had long been reading what changes in AI and relating it to Softanza's work, in the course of
other sessions. On 2026-11-08 that work got its own repository and its own desk, and it was made public, so that the
reading is useful to anyone and not only to Softanza.

## Why it matters to Softanza

Softanza is a platform for building software, and the ground under it changes every week. A watch that only lived in
conversations was lost when the conversation ended. Here it is kept: each development is read once, judged once, and
handed to the project it concerns.

The second reason is the notices. One day an assistant in the Softanza stack, such as Aicha, should be able to say:
*something changed in the world that you should know about, and here is what it means for you.* The feed is the
first form of that feature. Because it is open, any program can do the same today.

## What we do

- The desk runs a survey once a week and writes a digest (`docs/WEEKLY.md`).
- The feed contract is at version 1 (`docs/FEED.md`). Applications that show notices follow its rules.
- A Softanza command that reads the feed is proposed to stzlib in `docs/READER.md`.

## Sources

- [Lookout's README](https://github.com/mayouni/lookout), read 2026-11-08.
- [The feed contract, version 1](https://github.com/mayouni/lookout/blob/main/docs/FEED.md), read 2026-11-08.

## Corrections

- 2026-11-08: the repository was renamed on the day it opened, before the feed had any reader, so that its name is
  plain English like the rest of Softanza's internal names. This entry's id and addresses changed with it.
- 2026-11-09: the paragraph on Softanza now says what holds and what is proposed, in affirmative sentences; the facts are unchanged.
