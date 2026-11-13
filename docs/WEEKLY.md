# The weekly survey -- what a scheduled run does

This is the instruction a scheduled, unattended run of the Radar desk follows. An attended session follows it too
when the author says "run the week". It is [`docs/AGENT.md`](AGENT.md), the brief any watch's agent follows, with what
Softanza's own desk adds: the memo to Central, the cost line, and the estate's rules. Everything that belongs to the
project is in `radar.yaml`, which the run reads first.

## Before anything

- You are an **unattended run**. Everything you write stays inside this repository. Your memo goes into
  `.central/outbox.md` and Central relays it. You message no other session.
- Read `radar.yaml`, then `CLAUDE.md`, `docs/AGENT.md`, `docs/METHOD.md` and `docs/FEED.md`.
- Read the clock. The week is the latest ISO week that has **ended** at that reading, Monday to Sunday: a run on a
  Monday surveys the week before (`docs/SCHEDULE.md`). An attended run may survey the current week when the author
  asks. Write it `YYYY-Www`.
- Read `feed/index.json` and the latest file in `digests/`, so that you never write an entry twice.

## The survey

1. Take every new line in `inbox/LINKS.md` first. They are the author's.
2. Then go through `agent.sources` in `radar.yaml` (with the notes in `docs/SOURCES.md`), newest first, looking
   back to the last digest's date.
3. For each candidate, read it at the source. Keep it only if it can change what Softanza builds, how it builds it, or
   how it protects the people who use it.
4. Keep **at most twelve** entries in a week, and prefer fewer that are read properly. A security issue that affects
   Softanza's users is always kept, whatever the count.
5. Write each entry as `items/<year>/<id>.md`, following `docs/METHOD.md`, and place it on the estate map
   (`map/estate.json`): `areas` names the projects it touches (Harobanda, Haro, Softanza, HaroBase, HaroServ,
   HaroScript, Aïcha, Zayn, and the others the map lists), `domains` what it is about, `concerns` what is at stake.
   `haro tools/feed.haro` refuses a name the map does not list. Each action carries `dates`, the day it reached each
   stage; when Central reports that a proposal moved, set its new `state`, date that stage, and move `updated`.
6. Mark each line of `inbox/LINKS.md` you handled with the entry's id, or with `declined: <reason>`.

## The outputs

1. Write `digests/<YYYY-Www>.md`: one paragraph per entry, most important first, each linking to its page.
   Then add each new entry to `app/lessons.json`, which the radar site shows beside it: under `build`, the checks a
   programmer runs in their own project (each with `why` and `cmd`; say so in `why` when a command writes); under
   `lesson`, `terms` and `quiz`, the entry explained for a learner. `haro tools/feed.haro` accepts a lesson only under the id
   of an entry.
2. Regenerate `feed/index.json` and `feed/feed.json` from the entries, and check both against `schema/`:
   `haro tools/feed.haro` from the repository root. It writes nothing while any entry is refused.
3. Commit with a message that names the week and the number of entries.
4. **Publish only if the author has ruled that weekly runs publish** (the `publish` line in `docs/SCHEDULE.md`). If
   they have, push `main` to `origin` and check that `git ls-remote origin main` equals your commit. If they have not,
   leave the commit unpushed and say so in the memo. A run never signs: the feed is signed at publish, by the author,
   and `haro tools/feed.haro verify` must pass before any push (`docs/FEED.md`, "The signature").
5. Write the memo in `.central/outbox.md`. List the entries, their levels, and every action proposed, with its area,
   so that Central can route it. An `urgent` entry goes first, with the word URGENT in the subject.
6. Append the cost line to `.central/cost.jsonl`, reading `closed` from the clock just before you write it, in UTC.

## What a run never does

- write an entry for something it did not read;
- edit any other repository, or act on an action itself;
- change `docs/FEED.md`, the schemas, or this file: that is attended work, decided with the author;
- run more than one heavy job at a time.
