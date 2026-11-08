# Lookout's feed will be signed: check it came from this repository unchanged

```json
{
  "id": "2026-11-08-feed-signing",
  "date": "2026-11-08",
  "title": "Lookout's feed will be signed: check it came from this repository unchanged",
  "kind": "feature",
  "summary": "Lookout will publish an SSH signature beside each feed file, feed/index.json.sig and feed/feed.json.sig, made with one Ed25519 key kept for this purpose by Lookout's maintainer. Any reader with OpenSSH can check a feed with ssh-keygen against the public key and the namespace lookout-feed. The change adds files and adds nothing to the feed itself, so the feed stays at version 1.",
  "stance": "adopt",
  "relevance": "medium",
  "level": "info",
  "audiences": ["developer", "maintainer"],
  "notice": {
    "developer": "Lookout's feed will carry a signature beside each file; a program that shows its notices should check it with ssh-keygen before showing anything.",
    "maintainer": "When the signature lands, pin Lookout's key fingerprint in your reader rather than fetching the key from the same place as the feed."
  },
  "areas": ["softanza", "stzlib"],
  "actions": [
    { "area": "stzlib", "do": "add the signature check to the reader proposed in docs/READER.md, with the key's fingerprint pinned in the library", "state": "proposed" }
  ],
  "status": "new",
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
chose how: an SSH signature, made with `ssh-keygen -Y sign`, with a key used for nothing else and protected by a
passphrase that only the maintainer types. This entry announces it before it lands, as the contract requires.

## Why it matters to Softanza

A feed that puts text in front of users is an attack surface. Today a reader can trust the feed only as far as it
trusts the address it fetched it from. A signature lets a reader check, with a tool already installed on most
developer machines, that the bytes it holds are the bytes Lookout's maintainer published, and refuse anything else.

The choice of SSH signatures is deliberate: nothing to install, one command to verify, and a namespace that keeps a
Lookout signature from being mistaken for a signature on anything else.

## What we do

- Publish the public key and its fingerprint in the repository and in `docs/FEED.md`, with the command that checks a
  feed, and sign both files at every publish from then on.
- A week goes public only after the maintainer reads its digest and signs it. Scheduled runs never sign.
- When it lands, this entry is corrected to say so, with the key's fingerprint.

## Sources

- [The feed contract, version 1](https://github.com/mayouni/lookout/blob/main/docs/FEED.md), read 2026-11-08.
