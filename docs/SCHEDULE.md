# Schedule

The weekly survey (`docs/WEEKLY.md`) runs on the author's word. This file records what the author ruled, and when.

    schedule:  Monday 07:00, Niamey time (UTC+1) -- ruled by the author 2026-11-08 13:44
    publish:   no -- a scheduled run stops at a local commit; it is pushed after the author reads the digest
               -- ruled by the author 2026-11-08 13:44

**What a Monday run surveys.** The ISO week that ended the night before, Monday to Sunday, so that the week is read
whole. Its digest is named after that week: the run on Monday 2026-11-16 writes `digests/2026-W46.md`.

**How a week reaches the public.** The scheduled run commits on `main` and does not push. The author reads the
digest; when they approve it, an attended session records their verdict in the digest, signs both feed
files with the key kept on the author's machine, checks the signatures with `haro tools/feed.ring verify`, commits them,
pushes, and checks that `git ls-remote origin main` equals the commit. A feed is never pushed with a stale signature. Until then the feed on GitHub still shows the previous week.

**Where it runs.** On the author's machine, as a scheduled task of the desktop app, in this repository's folder. The
task runs only while the app is open; a run missed while it was closed starts when the app is next opened.
