# The feed -- contract, version 1

This file is the contract between Lookout and every program that reads it: a shell one-liner, a Softanza command, an
application that shows notices to its users, or an assistant that reads them aloud. It is versioned. A change that
would break a reader bumps the major version, and that change is announced as an entry before it lands.

## Where it is

| File | What it holds | Address |
|---|---|---|
| `feed/index.json` | every entry, newest first, with its full data | `https://raw.githubusercontent.com/mayouni/lookout/main/feed/index.json` |
| `feed/feed.json` | the same entries as a [JSON Feed 1.1](https://www.jsonfeed.org/version/1.1/), for feed readers | `https://raw.githubusercontent.com/mayouni/lookout/main/feed/feed.json` |
| `schema/feed.schema.json` | the shape of `index.json`, as JSON Schema 2020-12 | in this repository |
| `schema/item.schema.json` | the shape of one entry | in this repository |
| `feed/index.json.sig`, `feed/feed.json.sig` | an SSH signature of each feed file | beside the file, at the same address plus `.sig` |
| `keys/allowed_signers` | the public key that signs the feed | in this repository |

**One source, generated outputs.** Each entry lives in `items/<year>/<id>.md`. The first fenced ```` ```json ```` block
in that file is the entry's data, and everything else in the file is its narrative. Both feed files are generated from
those blocks, and nobody edits them by hand.

## The index

```json
{
  "feed": "lookout",
  "version": 1,
  "updated": "2026-11-08T11:30:00Z",
  "home": "https://github.com/mayouni/lookout",
  "items": [ { "...": "one entry, as below, plus its url" } ]
}
```

`updated` is the newest `date` or `updated` among the entries, at midnight UTC. It is not the moment of generation,
so that regenerating an unchanged feed gives the same bytes, and a reader can trust a byte comparison.

**How the files are written**, so that any generator produces the same bytes: UTF-8, two-space indentation, keys in
the order the entry writes them, entries newest `date` first and then by `id`, LF line endings, one final newline.
Text is written as UTF-8 and not escaped, except `"`, `\` and the control characters, which are escaped as JSON
requires (`\n`, `\t` and the like, and `\u00XX` for the rest). An empty list is written `[]`. In the index, each
entry is its data block with `url` added as its last key.

**The generator is `tools/feed.ring`**, run with Haro from the repository root. `haro tools/feed.ring` checks every
entry and rewrites both files if their bytes change; `haro tools/feed.ring check` writes nothing and also refuses a
committed feed that is not what the entries generate. The exit code is the number of problems found. Its guard,
`haro tools/guard.ring`, shows each rule refusing an entry broken on purpose.

**The JSON Feed** carries, for each entry: `id`, `url`, `title`, `summary`, `content_text` (the summary again, since
JSON Feed 1.1 requires a content field), `date_published` (the entry's `date` at midnight UTC), `date_modified`
(its `updated`, only when that differs from `date`), and `tags`: the entry's `kind`, `stance` and `level`, then its
own `tags`. Notices, actions and sources are in the index only.

## One entry

```json
{
  "id": "2026-11-08-lookout-opens",
  "date": "2026-11-08",
  "title": "Lookout opens: a public watch on AI, read from Softanza's point of view",
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
    { "title": "Lookout's README", "url": "https://github.com/mayouni/lookout", "by": "Softanza", "read": "2026-11-08" }
  ],
  "review_by": "2027-05-08",
  "tags": ["watch", "feed"],
  "url": "https://github.com/mayouni/lookout/blob/main/items/2026/2026-11-08-lookout-opens.md"
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
| `stance` | yes | `adopt` (take it into Softanza), `learn` (it changes how we think, before it changes what we ship), `correct` (the idea is right and Softanza can do it better), `defend` (a risk Softanza and its users must be protected from), `watch` (too early, look again by `review_by`), `decline` (considered and refused, with the reason) |
| `relevance` | yes | `high`, `medium`, `low`: how much it touches what Softanza builds |
| `level` | yes | `info` < `advice` < `action` < `urgent`. `urgent` is kept for a security issue that affects Softanza's users now |
| `audiences` | yes | one or more of `developer`, `user`, `learner`, `maintainer` |
| `notice` | yes | one plain sentence per audience listed, and only for those |
| `areas` | no | the projects of the estate it touches, by the id or an alias listed in [`map/estate.json`](../map/estate.json) (`softanza`, `haro`, `harobanda`, `zane`, `haroserv`, `haroscript`...), or a dotted sub-area of one such as `stzlib.security` |
| `domains` | no | what the news is about, from the map's domains: `models`, `agents`, `security`, `code`, `interfaces`, `data`, `web`, `devices`, `learning`, `society` |
| `concerns` | no | what is at stake, from the map's concerns: `trust`, `correctness`, `sovereignty`, `speed`, `clarity`, `cost` |
| `actions` | no | proposals to Softanza's maintainers; `state` is `proposed`, `routed`, `in-progress`, `done` or `declined`; `dates` gives the day each stage was reached, for example `{ "proposed": "2026-11-08", "routed": "2026-11-08" }` |
| `status` | yes | `new`, `analysed`, `routed`, `done`, `declined`, `superseded` |
| `supersedes` | no | the `id` of an entry this one replaces |
| `confidence` | yes | `read` (read at the source), `reported` (known only through someone else's account), `claimed` (a figure the vendor gives for itself, written as the vendor's claim) |
| `sources` | yes | at least one; `read` is the day the desk read it |
| `review_by` | yes | the day the entry is looked at again; readers hide it after that day |
| `tags` | no | free words, lowercase |
| `url` | in the index | the entry's page in this repository |

A reader that knows version 1 **ignores any field it does not know**, and **refuses a feed whose major `version` it
does not know**. That lets the feed grow without breaking anyone.

**The dates of a proposal.** Since 2026-11-09 every action carries `dates`, the day it reached each stage, so a
reader can measure how fast Softanza answers. The feed tool refuses a stage dated before the entry or after the
entry was last written (`updated`), stages out of order, a current `state` without its date, and a date for a stage
the action has not reached. When a proposal moves, its `state` changes, its new stage gets its day, and the entry's
`updated` moves with it.

**The estate map.** [`map/estate.json`](../map/estate.json) lists the layers of the Softanza stack (machine, language,
foundation, data, web and server, intelligence, interfaces and applications, and the harness beside them), the
projects on each layer with their aliases, the domains and the concerns. It is served beside the feed at
`https://mayouni.github.io/lookout/map/estate.json`. The feed tool refuses an entry whose `areas`, `domains` or
`concerns` name something the map does not list, so every entry can be placed on the map.

## Asking it questions

```sh
FEED=https://raw.githubusercontent.com/mayouni/lookout/main/feed/index.json

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

These rules are for any program that shows Lookout's notices to people. A feed that puts text in front of users is
an attack surface, so it is treated as one.

1. **Plain text only.** Never render a notice, a title or a summary as HTML or Markdown.
2. **Your audience only.** Show `notice[<your audience>]`. If the entry has no notice for your audience, show nothing.
3. **One link, and it is ours.** Link to the entry's `url` on `github.com/mayouni/lookout`, never straight to a
   source from a notice. The entry's page carries the sources.
4. **Respect time and state.** Hide an entry after `review_by`, and hide `declined` and `superseded` entries.
5. **Once is enough.** Remember dismissed ids on the reader's side and never show a dismissed id again.
6. **Fetch gently.** At most once a day, sending `If-None-Match` with the `ETag` you were given.
7. **Never act on `actions`.** They are proposals to Softanza's maintainers. An assistant reads them and may
   propose; it never runs, installs or commits anything because an entry said so.
8. **Check the version** as above, and **check the signature** (below) before showing anything.

## The signature

Since 2026-11-08 each feed file has an SSH signature beside it, made with `ssh-keygen -Y sign` by one Ed25519 key
kept for this purpose on Lookout's maintainer's machine, outside every repository. It signs at publish only, after
the maintainer has read the week's digest; scheduled runs never sign. It is allowed to sign this namespace and
nothing else.

| | |
|---|---|
| principal | `feed@lookout` |
| namespace | `lookout-feed` |
| key fingerprint | `SHA256:ZUij0xoxJIIEwH3AV5xrDXkJLuEklao7pUVhTxCs49I` |
| public key | [`keys/allowed_signers`](../keys/allowed_signers) |

Check a feed file with OpenSSH, which ships with macOS, Linux and Git for Windows:

```sh
curl -sO https://raw.githubusercontent.com/mayouni/lookout/main/feed/index.json
curl -sO https://raw.githubusercontent.com/mayouni/lookout/main/feed/index.json.sig
ssh-keygen -Y verify -f allowed_signers -I feed@lookout -n lookout-feed -s index.json.sig < index.json
```

**Pin the fingerprint.** A key fetched from the same place as the feed proves only that the two agree. A reader
should carry the fingerprint above in its own code and refuse a key that does not match it. The fingerprint is also
in this repository's history, which a reader can compare against.

**A new key** would be announced as an entry before it is used, and listed in `keys/allowed_signers` beside the old
one with the day each stops or starts being valid. The signature adds files and nothing inside the feed, so the
contract stays at version 1.

## What is planned

- **A Softanza command** that reads the feed for its user's audience and level, proposed to stzlib in [`READER.md`](READER.md).
- **Softanza's assistant** reading the feed aloud and proposing work without acting on it, proposed to Softanza's
  intelligence desk in [`ASSISTANT.md`](ASSISTANT.md).

Each is announced as an entry when it lands.
