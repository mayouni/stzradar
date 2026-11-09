# Your own Lookout

Lookout is Softanza's watch on AI, and it is built so that any project can run its own. An agent reads the news
of your field each week at its source, places every piece on your project's map, writes one sentence for each of
your readers, and proposes the work it calls for. You get the same signed feed, the same site with its trends
dashboard, and the same bar for your pages. One file says everything about your project: `lookout.yaml`.

The site walks through it with a form that writes your first file: [Make your own](https://mayouni.github.io/lookout/#/yours).

## The five steps

1. **Copy this repository.** Keep `tools/`, `schema/`, `bar/`, `index.html` and `.nojekyll`. Empty `items/` and
   `digests/`, start `app/lessons.json` as `{"about": "...", "entries": {}}`, and write your first entry: the one that
   says your watch has opened.
2. **Describe your project in `lookout.yaml`** (below), and draw your map in the file it names.
3. **Make the key that signs your feed**, kept outside the repository and used for nothing else:
   `ssh-keygen -t ed25519 -f ~/.ssh/watch_feed -C feed@your-watch`. Put the public key in `keys/allowed_signers` as
   `feed@your-watch namespaces="your-watch-feed" ssh-ed25519 AAAA...`, and the same key, its fingerprint, the signer
   and the namespace in `lookout.yaml`.
4. **Give your agent its brief:** [`docs/AGENT.md`](AGENT.md). Schedule it on the day `watch.schedule` names.
5. **Publish:** run `haro tools/feed.ring`, sign both feed files, run `haro tools/feed.ring verify`, push, and turn on
   GitHub Pages for the main branch. Put [the bar](BAR.md) on your own pages with `data-feed` and `data-key`.

## The file, key by key

| Key | What it says | What uses it |
|---|---|---|
| `lookout` | the version of the file's shape: `1` | the check |
| `project.name`, `site`, `owner`, `licence`, `licence_url`, `pitch` | the project the watch serves | the site's titles, the In view, the footer credit, the feed's description |
| `watch.name`, `topic`, `repository`, `pages`, `language` | the watch itself | every URL the feed writes, the site's name |
| `watch.tagline`, `watch.intro` | the first words a visitor reads | the This week view |
| `watch.schedule` | the day, the hour, the timezone and the week surveyed | the agent, and the task that wakes it |
| `watch.publish` | `after-reading` (the owner reads, then signs and pushes) or `at-once` | the agent |
| `feed.signer`, `namespace`, `fingerprint`, `key` | who signs the feed | the check, the site and the bar check the signature with them |
| `map` | the path of the map file | the check, the site |
| `readers` | who the notices are for (`developer`, `maintainer`, `learner`, `user`), with a label and what each reads first | the site's reader choice, the agent's notices |
| `agent.goal` | why the agent watches | the agent, and the Make your own view |
| `agent.learn` | what the agent reads about the project before every survey | the agent |
| `agent.in_scope`, `agent.out_of_scope` | what counts as news, and what never goes in | the agent |
| `agent.sources` | where it looks, each with a `name` and a `url` | the agent |
| `agent.stances` | what `adopt`, `learn`, `correct`, `defend`, `watch` and `decline` mean for this project | the agent, the Trends view |
| `agent.rules` | the rules the agent keeps | the agent |
| `agent.proposals` | where the work it proposes goes: `to`, `through`, `never` | the agent, each signal's page |
| `checks.affirm` | `true` to keep every public page affirmative: each line says what the project is and does | the check, with `tools/affirm-allow.txt` |

The file is read with a small, strict part of YAML: maps, lists, `"quoted"` or plain text, `[a, b]` lists, and `|` or
`>` blocks for long text, indented with spaces. The check names the line of anything else.

## The map

The map is a JSON file with four lists: `layers` (each with `id`, `name`, `line`, and `beside: true` for a layer
drawn beside the stack), `projects` (each with `id`, `name`, `layer`, `line`, and optionally `link` and `aliases`),
`domains` and `concerns` (each with `id`, `name`, `line`). Softanza's is [`map/estate.json`](../map/estate.json).

## What every watch shares

The feed contract, [`docs/FEED.md`](FEED.md), is the same for every watch: the fields of an entry, the four levels
(`info`, `advice`, `action`, `urgent`), the four readers, and the signature. So one reader, one bar and one site
serve them all, and a program that reads one watch reads every other.

## The check

`haro tools/feed.ring` reads `lookout.yaml` before anything else and refuses, by name and line, a file that misses a
key, adds one it does not define, names a reader the feed does not know, or carries a key that does not match
`keys/allowed_signers`. Then it checks every entry, writes the feed, and writes `app/config.json`, the same file as
JSON, which the site reads. `tools/guard.ring` shows each of these refusals.
