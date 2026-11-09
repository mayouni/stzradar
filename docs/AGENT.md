# The agent's brief -- the weekly survey, for any project

This is what the watching agent does each week, for whichever project `lookout.yaml` describes. Any coding agent
can follow it. Everything that belongs to the project comes from `lookout.yaml`; this page never names one.

## Before anything

1. **Read `lookout.yaml` first, and keep it in view.** It says which project you serve (`project`), what you watch
   (`watch.topic`), why (`agent.goal`), what counts as news (`agent.in_scope`), what never goes in
   (`agent.out_of_scope`), where to look (`agent.sources`), who reads you (`readers`), what each stance means for
   this project (`agent.stances`), the rules you keep (`agent.rules`), and where the work you propose goes
   (`agent.proposals`).
2. **Learn the project.** Read every path and address in `agent.learn`, then the map `lookout.yaml` names (`map`):
   its layers, the parts on each, the domains and the concerns. You place every entry on that map.
3. **Read the method and the contract:** `docs/METHOD.md` (how an entry is made) and `docs/FEED.md` (its fields).
4. **Read the clock.** The week is the one `watch.schedule.week` describes, usually the latest ISO week that has ended,
   written `YYYY-Www`.
5. **Read `feed/index.json` and the newest file in `digests/`,** so that you never write an entry twice.

## The survey

1. Take every new line of `inbox/LINKS.md` first: they come from the project's owner.
2. Then go through `agent.sources`, newest first, back to the last digest's date.
3. Read each candidate **at its source**. Keep it only if it fits `agent.in_scope` and serves `agent.goal`; leave out
   anything `agent.out_of_scope` names.
4. Keep at most twelve entries a week, and prefer fewer that are read properly. A security issue that reaches the
   project's users is always kept.
5. Write each entry as `items/<year>/<id>.md`, following `docs/METHOD.md`:
   - its `stance` uses the meanings in `agent.stances`;
   - its `notice` has one plain sentence for each reader in `readers` it concerns, and only for those;
   - `areas` names the parts of the map it touches, `domains` what it is about, `concerns` what is at stake;
   - each action names its part of the map, says verb first what is proposed, and dates every stage it reaches.
6. Add each new entry to `app/lessons.json`: under `build`, the checks a programmer runs in their own project (each
   with `why` and `cmd`, saying in `why` when a command writes); under `lesson`, `terms` and `quiz`, the entry in plain
   words for a learner.
7. Mark each line of `inbox/LINKS.md` you handled with the entry's id, or with `declined: <reason>`.

## The outputs

1. Write `digests/<YYYY-Www>.md`: one paragraph per entry, most important first, each linking to its page.
2. Run `haro tools/feed.ring` from the repository root. It checks `lookout.yaml`, every entry against the schema and the
   map, the lessons and the dates, then writes the feed and `app/config.json`. It writes nothing while anything is
   refused: correct what it names and run it again.
3. Commit, with a message that names the week and the number of entries.
4. **Publishing follows `watch.publish`.** With `after-reading`, leave the commit for the owner: they read the digest,
   then sign the feed (`docs/FEED.md`, "The signature"), run `haro tools/feed.ring verify`, and push. The agent never
   signs.
5. Send the proposals the way `agent.proposals` says: to `to`, through `through`, never as `never`. List each with its
   part of the map, its level and its entry.

## What the agent never does

- write about something it did not read at the source;
- edit another project's repository, or carry out a proposal itself;
- change `lookout.yaml`, `docs/FEED.md`, the schemas or this brief: those belong to the project's owner;
- keep a key, a token or a password anywhere in the repository.
