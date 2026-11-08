# The weekly survey -- what a scheduled run does

This is the instruction a scheduled, unattended run of the Labari desk follows. An attended session follows it too
when the author says "run the week".

## Before anything

- You are an **unattended run**. Everything you write stays inside this repository. Your memo goes into
  `.central/outbox.md` and Central relays it. You message no other session.
- Read `CLAUDE.md`, `docs/METHOD.md` and `docs/FEED.md`.
- Read the clock. The week is the ISO week of that reading: `YYYY-Www`.
- Read `feed/index.json` and the latest file in `digests/`, so that you never write an entry twice.

## The survey

1. Take every new line in `inbox/LINKS.md` first. They are the author's.
2. Then go through `docs/SOURCES.md`, newest first, looking back to the last digest's date.
3. For each candidate, read it at the source. Keep it only if it can change what Softanza builds, how it builds it, or
   how it protects the people who use it.
4. Keep **at most twelve** entries in a week, and prefer fewer that are read properly. A security issue that affects
   Softanza's users is always kept, whatever the count.
5. Write each entry as `items/<year>/<id>.md`, following `docs/METHOD.md`.
6. Mark each line of `inbox/LINKS.md` you handled with the entry's id, or with `declined: <reason>`.

## The outputs

1. Write `digests/<YYYY-Www>.md`: one paragraph per entry, most important first, each linking to its page.
2. Regenerate `feed/index.json` and `feed/feed.json` from the entries, and check both against `schema/`.
3. Commit with a message that names the week and the number of entries.
4. **Publish only if the author has ruled that weekly runs publish** (the `publish` line in `docs/SCHEDULE.md`). If
   they have, push `main` to `origin` and check that `git ls-remote origin main` equals your commit. If they have not,
   leave the commit unpushed and say so in the memo.
5. Write the memo in `.central/outbox.md`. List the entries, their levels, and every action proposed, with its area,
   so that Central can route it. An `urgent` entry goes first, with the word URGENT in the subject.
6. Append the cost line to `.central/cost.jsonl`, reading `closed` from the clock just before you write it, in UTC.

## What a run never does

- write an entry for something it did not read;
- edit any other repository, or act on an action itself;
- change `docs/FEED.md`, the schemas, or this file: that is attended work, decided with the author;
- run more than one heavy job at a time.
