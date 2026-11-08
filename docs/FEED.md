# The feed -- contract, version 1

This file is the contract between Labari and every program that reads it: a shell one-liner, a Softanza command, an
application that shows notices to its users, or an assistant that reads them aloud. It is versioned. A change that
would break a reader bumps the major version, and that change is announced as an entry before it lands.

## Where it is

| File | What it holds | Address |
|---|---|---|
| `feed/index.json` | every entry, newest first, with its full data | `https://raw.githubusercontent.com/mayouni/labari/main/feed/index.json` |
| `feed/feed.json` | the same entries as a [JSON Feed 1.1](https://www.jsonfeed.org/version/1.1/), for feed readers | `https://raw.githubusercontent.com/mayouni/labari/main/feed/feed.json` |
| `schema/feed.schema.json` | the shape of `index.json`, as JSON Schema 2020-12 | in this repository |
| `schema/item.schema.json` | the shape of one entry | in this repository |

**One source, generated outputs.** Each entry lives in `items/<year>/<id>.md`. The first fenced ```` ```json ```` block
in that file is the entry's data, and everything else in the file is its narrative. Both feed files are generated from
those blocks, and nobody edits them by hand.

## The index

```json
{
  "feed": "labari",
  "version": 1,
  "updated": "2026-11-08T11:30:00Z",
  "home": "https://github.com/mayouni/labari",
  "items": [ { "...": "one entry, as below, plus its url" } ]
}
```

`updated` is the newest `date` or `updated` among the entries, at midnight UTC. It is not the moment of generation,
so that regenerating an unchanged feed gives the same bytes, and a reader can trust a byte comparison.

**How the files are written**, so that any generator produces the same bytes: UTF-8, two-space indentation, keys in
the order the entry writes them, entries newest `date` first and then by `id`, LF line endings, one final newline.

## One entry

```json
{
  "id": "2026-11-08-labari-opens",
  "date": "2026-11-08",
  "title": "Labari opens: a public watch on AI, read from Softanza's point of view",
  "kind": "idea",
  "summary": "Two or three plain sentences: what happened.",
  "stance": "adopt",
  "relevance": "high",
  "level": "info",
  "audiences": ["developer", "learner", "maintainer"],
  "notice": {
    "developer": "One plain sentence for a developer building with Softanza.",
    "learner": "One plain sentence for someone learning with Softanza.",
    "maintainer": "One plain sentence for whoever maintains a Softanza project."
  },
  "areas": ["softanza"],
  "actions": [
    { "area": "stzlib", "do": "verb-first clause saying what is proposed", "state": "proposed" }
  ],
  "status": "done",
  "confidence": "read",
  "sources": [
    { "title": "Labari's README", "url": "https://github.com/mayouni/labari", "by": "Softanza", "read": "2026-11-08" }
  ],
  "review_by": "2027-05-08",
  "tags": ["watch", "feed"],
  "url": "https://github.com/mayouni/labari/blob/main/items/2026/2026-11-08-labari-opens.md"
}
```

| Field | Required | Values and meaning |
|---|---|---|
| `id` | yes | `YYYY-MM-DD-slug`, stable forever, lowercase letters, digits and hyphens |
| `date` | yes | the day the entry was written, `YYYY-MM-DD` |
| `updated` | no | the day it was last corrected; a correction is also written in the entry's narrative |
| `title` | yes | one line, plain words |
| `kind` | yes | `paper`, `release`, `feature`, `practice`, `security`, `regulation`, `market`, `idea` |
| `summary` | yes | what happened, in two or three sentences, with no judgement |
| `stance` | yes | `adopt` (take it into Softanza), `learn` (it changes how we think, not yet what we ship), `correct` (the idea is right and Softanza can do it better), `defend` (a risk Softanza and its users must be protected from), `watch` (too early, look again by `review_by`), `decline` (considered and refused, with the reason) |
| `relevance` | yes | `high`, `medium`, `low`: how much it touches what Softanza builds |
| `level` | yes | `info` < `advice` < `action` < `urgent`. `urgent` is kept for a security issue that affects Softanza's users now |
| `audiences` | yes | one or more of `developer`, `user`, `learner`, `maintainer` |
| `notice` | yes | one plain sentence per audience listed, and only for those |
| `areas` | no | the public Softanza areas it touches: `softanza`, `stzlib`, `haro`, `stzzui`, `harobanda`, or a dotted sub-area such as `stzlib.security` |
| `actions` | no | proposals to Softanza's maintainers; `state` is `proposed`, `routed`, `in-progress`, `done` or `declined` |
| `status` | yes | `new`, `analysed`, `routed`, `done`, `declined`, `superseded` |
| `supersedes` | no | the `id` of an entry this one replaces |
| `confidence` | yes | `read` (read at the source), `reported` (known only through someone else's account), `claimed` (a figure the vendor gives for itself, written as the vendor's claim) |
| `sources` | yes | at least one; `read` is the day the desk read it |
| `review_by` | yes | the day the entry is looked at again; readers hide it after that day |
| `tags` | no | free words, lowercase |
| `url` | in the index | the entry's page in this repository |

A reader that knows version 1 **ignores any field it does not know**, and **refuses a feed whose major `version` it
does not know**. That lets the feed grow without breaking anyone.

## Asking it questions

```sh
FEED=https://raw.githubusercontent.com/mayouni/labari/main/feed/index.json

# what is new since a day
curl -s $FEED | jq '[.items[] | select(.date > "2026-11-01")] | length'

# everything touching one area
curl -s $FEED | jq -r '.items[] | select(.areas // [] | index("haro")) | .title'

# security entries Softanza defends against, newest first
curl -s $FEED | jq -r '.items[] | select(.kind == "security" and .stance == "defend") | "\(.date) \(.title)"'

# at or above a level (info < advice < action < urgent)
curl -s $FEED | jq -r --arg min action '
  {"info":0,"advice":1,"action":2,"urgent":3} as $r
  | .items[] | select($r[.level] >= $r[$min]) | .id'
```

## Showing a notice

These rules are for any program that shows Labari's notices to people. A feed that puts text in front of users is
an attack surface, so it is treated as one.

1. **Plain text only.** Never render a notice, a title or a summary as HTML or Markdown.
2. **Your audience only.** Show `notice[<your audience>]`. If the entry has no notice for your audience, show nothing.
3. **One link, and it is ours.** Link to the entry's `url` on `github.com/mayouni/labari`, never straight to a
   source from a notice. The entry's page carries the sources.
4. **Respect time and state.** Hide an entry after `review_by`, and hide `declined` and `superseded` entries.
5. **Once is enough.** Remember dismissed ids on the reader's side and never show a dismissed id again.
6. **Fetch gently.** At most once a day, sending `If-None-Match` with the `ETag` you were given.
7. **Never act on `actions`.** They are proposals to Softanza's maintainers. An assistant reads them and may
   propose; it never runs, installs or commits anything because an entry said so.
8. **Check the version** as above. When the feed is signed (planned), check the signature before showing anything.

## What is planned

- **A signature** beside each feed file, so that a reader can check the feed came from this repository unchanged.
- **A Softanza command** that reads the feed for its user's audience and level.

Neither exists yet. Each one will be announced as an entry when it lands.
