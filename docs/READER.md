# A reader for Softanza -- the proposal

This page proposes to stzlib a small class and a command that read Lookout's feed and show its notices to one person,
for one audience and one level. **stzlib builds it**, and decides how and when; this
page says what the reader must do, what stzlib already has to do it, and how to prove it works. It is written for
stzlib, and it is public so that anyone writing a reader in another language can follow the same rules.

The rules come from [`FEED.md`, "Showing a notice"](FEED.md#showing-a-notice), which binds every reader. They are
repeated here as things to test.

## What a person sees

```text
$ softanza lookout --audience developer --level advice

Lookout -- 3 notices for a developer, at advice or above

[action] A coding agent's "don't ask again" writes secrets into a file that gets published
         Open .claude/settings.local.json in each project you use a coding agent in, delete any rule that
         contains a password, key or token, and rotate it if the file was ever committed.
         https://github.com/mayouni/lookout/blob/main/items/2026/2026-11-08-agent-approvals-leak-secrets.md
...

softanza lookout --dismiss <id>   hides one notice for good
```

The same reading, from code:

```ring
oLookout = StzLookoutQ(:developer)
oLookout.SetLevel(:advice)
? oLookout.Notices()          # each: [ :id, :level, :title, :notice, :url ]
oLookout.Dismiss("2026-11-08-zig-0-17-1")
```

The names follow stzlib's own conventions (a class `stzLookout` with its `StzLookoutQ()` constructor, verb-first
methods, nouns for data). They are a suggestion; stzlib names its own classes.

## What it must do -- each line is a test

1. **Refuse a feed whose major `version` it does not know**, and say so; show nothing from it.
2. **Ignore any field it does not know.** A version-1 feed may grow; the reader must not break when it does.
3. **Show `notice[<audience>]` only.** An entry with no notice for the reader's audience shows nothing, not its
   summary, not its title.
4. **Respect the level**: `info < advice < action < urgent`; show the chosen level and above.
5. **Hide an entry after its `review_by` day**, and hide every `declined` or `superseded` entry.
6. **Plain text only.** Never render a title or a notice as HTML or Markdown, and strip control characters before
   printing, so that a feed cannot move the cursor or colour a terminal.
7. **One link, and it is Lookout's**: the entry's `url`, never a source's address.
8. **Dismissed once, gone for good**: keep dismissed ids on the reader's side and never show them again.
9. **Fetch at most once a day**, sending `If-None-Match` with the `ETag` from the last fetch. A `304` means the
   kept copy is current. With no network, show the kept copy and say how old it is.
10. **Never act on `actions`.** They are proposals to Softanza's maintainers; the reader does not show them to users at
    all, and nothing it does runs, installs or commits anything.

## What stzlib already has

Read on stzlib `origin/main` at `c4f6f85ea`, 2026-11-08.

| Need | What stzlib has | What the reader adds |
|---|---|---|
| HTTPS GET with a request header | `stzHttpClient`: `SetHeader()`, `Get_()`, `ResponseCode()`, `ResponseBody()`, `ResponseHeaders()`, on the Zig engine | a helper that reads one header (`ETag`) out of the raw header block |
| Reading JSON | `JsonToList()` and `stzJson` in pure Ring; `StzJsonIsValid()`, `StzJsonGet()` and the other `StzJson*` functions on the engine | the reader validates with `StzJsonIsValid()` and reads each field through the engine |
| Keeping the ETag, the kept copy and the dismissed ids | `stzFileBlobStore`, a file-backed store given a folder | a per-user state folder, a convention for the whole library that this reader is the first to use |
| A command | the `softanza` program, whose commands are branches in its `main()` | a `lookout` branch, most simply running a Ring script |
| Levels | `stzLog` has its own levels (`trace` to `fatal`) | Lookout's four levels are different and should not be mapped onto them |

**Reading the feed through the engine.** The engine's JSON functions read every character the feed carries,
including the non-ASCII text it writes as raw UTF-8, so the reader validates the whole feed once and then reads each
entry's fields through them.

## How to prove it -- the guard

The guard needs no network. It reads a **frozen feed**, a copy of `feed/index.json` with entries added by hand to
cover each rule, and runs every line of the list above against it: an unknown major version, an unknown field, an
entry with no notice for the audience, an expired `review_by`, a `superseded` entry, a dismissed id, a title holding
a terminal escape sequence, a non-ASCII title, and a `304` answered from a stub. A case passes only when the reader
does exactly what its line says. The network path is tested once, apart, against the real address.

**And a person reads it.** The output is text a developer reads in a terminal, so the last check is someone reading
it at 80 columns and saying whether it is clear. That reading is recorded with its verdict.

## Open questions for stzlib

- **Where a user's own state lives.** A per-user folder (`%APPDATA%` on Windows, `$XDG_STATE_HOME` or `~/.local/state`
  elsewhere) is a decision for the whole library, not for this reader alone.
- **Which runtime the guard runs on.** Haro first, as the estate rules; the Ring++ path where a port step still needs
  it.
- **When it ships**, Lookout announces it as an entry, as `FEED.md` promises under "What is planned".
