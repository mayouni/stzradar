# Lookout's feed is signed: check it came from this repository unchanged

```json
{
  "id": "2026-11-08-feed-signing",
  "date": "2026-11-08",
  "updated": "2026-11-09",
  "title": "Lookout's feed is signed: check it came from this repository unchanged",
  "kind": "feature",
  "summary": "Lookout publishes an SSH signature beside each feed file, feed/index.json.sig and feed/feed.json.sig, made with one Ed25519 key kept for this purpose by Lookout's maintainer. Any reader with OpenSSH can check a feed with ssh-keygen against the public key and the namespace lookout-feed. The change adds files and adds nothing to the feed itself, so the feed stays at version 1; docs/FEED.md gives the key, its fingerprint and the command.",
  "stance": "adopt",
  "relevance": "medium",
  "level": "info",
  "audiences": ["developer", "maintainer"],
  "notice": {
    "developer": "Lookout's feed carries a signature beside each file; a program that shows its notices should check it with ssh-keygen before showing anything.",
    "maintainer": "Pin Lookout's key fingerprint in your reader rather than fetching the key from the same place as the feed."
  },
  "areas": ["softanza", "stzlib", "lookout"],
  "domains": ["security"],
  "concerns": ["trust"],
  "actions": [
    { "area": "stzlib", "do": "add the signature check to the reader proposed in docs/READER.md, with the key's fingerprint pinned in the library", "state": "proposed", "dates": { "proposed": "2026-11-08" } }
  ],
  "status": "done",
  "confidence": "read",
  "sources": [
    { "title": "The feed contract, version 1", "url": "https://github.com/mayouni/lookout/blob/main/docs/FEED.md", "by": "Softanza", "read": "2026-11-08" }
  ],
  "review_by": "2027-05-08",
  "tags": ["feed", "signature", "supply-chain"]
}
```

## What happened

`docs/FEED.md` has promised, since the feed opened, a signature beside each feed file. On 2026-11-08 the maintainer
chose how: an SSH signature, made with `ssh-keygen -Y sign`, with a key used for nothing else. The key lives on the
maintainer's machine, outside every repository, and is allowed to sign Lookout's feed and nothing else. This entry
announced it before it landed, as the contract requires.

## Why it matters to Softanza

A feed that puts text in front of users is an attack surface. Today a reader can trust the feed only as far as it
trusts the address it fetched it from. A signature lets a reader check, with a tool already installed on most
developer machines, that the bytes it holds are the bytes Lookout's maintainer published, and refuse anything else.

The choice of SSH signatures is deliberate: nothing to install, one command to verify, and a namespace that keeps a
Lookout signature from being mistaken for a signature on anything else.

## What we do

- Publish the public key and its fingerprint in the repository and in `docs/FEED.md`, with the command that checks a
  feed, and sign both files at every publish from then on.
- A week goes public only after the maintainer reads its digest; the feed is signed at that moment, never by a
  scheduled run.
- When it lands, this entry is corrected to say so, with the key's fingerprint.

## Sources

- [The feed contract, version 1](https://github.com/mayouni/lookout/blob/main/docs/FEED.md), read 2026-11-08.

## Corrections

- 2026-11-08: signing landed the same day. The key, its fingerprint and the command that checks a feed are in
  `docs/FEED.md`, under "The signature"; the public key is `keys/allowed_signers`. The title and the notices now speak
  of the signature as present. The key was first meant to carry a passphrase; the maintainer chose instead a key with
  none, kept on their machine and used only at publish, so that no secret has to be remembered. The text above says
  so.
- 2026-11-09: placed on the estate map, with the domains and concerns it touches and Lookout among its areas; the facts are unchanged.
- 2026-11-09: each proposal now carries the day it reached each stage, read from this repository's history; the facts are unchanged.
