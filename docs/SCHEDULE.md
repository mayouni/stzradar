# Schedule

The weekly survey (`docs/WEEKLY.md`) runs on the author's word. This file records what the author ruled, and when.

    schedule:  Sunday 20:00, Niamey time (UTC+1) -- ruled by the author 2026-11-23 08:18
               (it was Monday 07:00, ruled 2026-11-08 13:44)
    publish:   no -- a scheduled run stops at a local commit; it is pushed after the author reads the digest
               -- ruled by the author 2026-11-08 13:44

**What a Sunday run surveys.** The ISO week that ends that night, Monday to Sunday. An entry carries the day it was
written, so a survey written on the week's last day stands in the week it describes, and its digest carries that
week's name: the run on Sunday 2026-11-29 writes into `digests/2026-W48.md`.

**A digest that already exists.** Entries reach a week before its survey, from the links the author sends. The run
then adds to the digest: it surveys what the digest has left to cover, writes a paragraph for each new entry, and
extends "How this week was read". The run records each week it surveyed in `.central/surveyed.txt`, and a week
listed there is complete.

**A run that starts late.** The task runs only while the app is open. A run that starts on Monday surveys the week
that ended the night before; its entries carry Monday's date and open the new week's digest.

**How a week reaches the public.** The scheduled run commits on `main` and does not push. The author reads the
digest; when they approve it, an attended session records their verdict in the digest, signs both feed
files with the key kept on the author's machine, checks the signatures with `haro tools/feed.haro verify`, commits them,
pushes, and checks that `git ls-remote origin main` equals the commit. A feed is never pushed with a stale signature. Until then the feed on GitHub still shows the previous week.

**Where it runs.** On the author's machine, as a scheduled task of the desktop app, in this repository's folder. The
task runs only while the app is open; a run missed while it was closed starts when the app is next opened.
