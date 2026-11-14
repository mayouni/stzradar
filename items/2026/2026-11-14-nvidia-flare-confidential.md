# NVIDIA FLARE 2.9.1 admits a site to shared training only after its hardware and software match what all parties approved; Softanza's federation learns the admission rule

```json
{
  "id": "2026-11-14-nvidia-flare-confidential",
  "date": "2026-11-14",
  "title": "NVIDIA FLARE 2.9.1 admits a site to shared training only after its hardware and software match what all parties approved; Softanza's federation learns the admission rule",
  "kind": "release",
  "summary": "NVIDIA FLARE 2.9.1, released on November 12, 2026 under Apache-2.0, adds confidential computing as an optional technical preview to its federated-learning framework. Training runs inside confidential virtual machines or confidential containers on Intel TDX or AMD SEV-SNP, with or without NVIDIA confidential GPUs, on a site's own servers, on Kubernetes or on Azure, all in one federation. The application's image, code, configuration and secrets sit in an encrypted vault whose key the Trustee key broker releases only after the machine's measured boot matches approved reference values. Sites then check each other's evidence at registration and periodically; a site that fails is refused or quarantined.",
  "stance": "learn",
  "relevance": "low",
  "level": "advice",
  "audiences": ["developer", "maintainer"],
  "notice": {
    "developer": "Two decisions protect a shared computation: the key that opens the workload is released only to a machine whose measurements match an approved list, and each participant checks the others' evidence when they join and again while they run. A valid proof says which code runs; it says nothing about whether that code is safe.",
    "maintainer": "Softanza's compute federation admits a host by name, endpoint and facets, then governs, signs and encrypts each call. The admission rule adds what the host runs: its engine build and model hashes compared with a list every party approved, checked at joining and on a period, with each refusal written to the security ledger."
  },
  "areas": ["softanza"],
  "domains": ["security", "models"],
  "concerns": ["trust", "sovereignty"],
  "actions": [
    { "area": "stzlib.security", "do": "give the compute federation an admission rule: a joining host presents a signed statement of the engine build and model hashes it runs, the federation compares it with an approved reference list, repeats the check on a period, retires a host whose statement stops matching, and writes each refusal to the security ledger; state in the rule's own text that a statement is declared by the host and that hardware evidence is the stronger form", "state": "routed", "dates": { "proposed": "2026-11-14", "routed": "2026-11-14" } }
  ],
  "status": "routed",
  "confidence": "claimed",
  "sources": [
    { "title": "NVIDIA FLARE 2.9.1 release notes", "url": "https://nvflare.readthedocs.io/en/2.9.1/release_notes/flare_291.html", "by": "NVIDIA", "read": "2026-11-14" },
    { "title": "NVIDIA FLARE: confidential computing architecture", "url": "https://nvflare.readthedocs.io/en/2.9.1/user_guide/confidential_computing/architecture.html", "by": "NVIDIA", "read": "2026-11-14" },
    { "title": "Release 2.9.1: Confidential computing and security enhancements", "url": "https://github.com/NVIDIA/NVFlare/releases/tag/2.9.1", "by": "NVIDIA", "read": "2026-11-14" },
    { "title": "NVIDIA Confidential Computing", "url": "https://www.nvidia.com/en-us/data-center/solutions/confidential-computing/", "by": "NVIDIA", "read": "2026-11-14" }
  ],
  "review_by": "2027-02-14",
  "tags": ["nvidia", "flare", "federated-learning", "confidential-computing", "attestation", "trustee"]
}
```

## What happened

NVIDIA released FLARE 2.9.1 on November 12, 2026. FLARE is an Apache-2.0 framework for federated learning: several
organisations train one model together while each keeps its own data. Two questions slow such projects: is my model
safe at a partner's site, and does every site run the code we agreed on. Version 2.9.1 answers both with confidential
computing, offered as an optional technical preview.

Training runs inside a confidential virtual machine or a confidential container, on Intel TDX or AMD SEV-SNP
processors, with a processor alone or with NVIDIA confidential GPUs. One provisioning interface covers three ways to
deploy: a site's own servers, Kubernetes, and Azure; one federation can mix them.

The design separates two decisions. The first is the release of a key. The application's image, code, configuration
and secrets are sealed in an encrypted vault, apart from a generic virtual machine that is measured once for each
processor and GPU profile. The Trustee services, an open-source verifier and key broker, hold the approved reference
values and release the vault's key only when the machine's measured boot matches them. The second is the check
between participants: the server refuses a client whose evidence fails at registration, a client that rejects the
server's evidence exits, and workloads are checked again periodically and quarantined on failure.

The documentation states the bounds of the guarantee in its own words: confidential computing shows which code runs,
and the safety of that code, the privacy of a model's outputs and availability are separate questions. The release
gives no performance figure. NVIDIA's own page on confidential computing names its Rubin, Blackwell and Hopper GPUs
and reports up to 98% of the performance of an unsecured deployment; that figure is NVIDIA's.

The same release binds each administrative request to its caller, route and job, and keeps model checkpoint paths
inside the application's directory.

## Why it matters to Softanza

Softanza has a compute federation: hosts join a named constellation with an endpoint and the facets they offer, and
each call is discovered, cleared by a bond and by governance, signed, carried over mutual TLS, and noted in the
security ledger when refused. It also has an attestation that seals a ledger so that an auditor can verify who
exported it and that no record changed.

FLARE shows the rule that sits at the door of such a federation: a host is admitted for what it runs as well as for
who it is. The approved list is a shared, signed object; the check is made at joining and repeated; a failure has one
defined outcome. Softanza's parts already name each of these: a model is known by the hash of its file, a host is
retired and revived by the federation, and a refusal is a ledger line. Joined together they give a designer a
federation whose members can show each other which engine and which models answer a call.

## What we do

- Route to the security side an admission rule for the compute federation: a signed statement of what a host runs,
  compared with an approved list at joining and on a period.
- Look again by 2027-02-14.

## Sources

- NVIDIA, [FLARE 2.9.1 release notes](https://nvflare.readthedocs.io/en/2.9.1/release_notes/flare_291.html) and
  [confidential computing architecture](https://nvflare.readthedocs.io/en/2.9.1/user_guide/confidential_computing/architecture.html),
  read 2026-11-14.
- NVIDIA, [Release 2.9.1 on GitHub](https://github.com/NVIDIA/NVFlare/releases/tag/2.9.1), November 12, 2026.
- NVIDIA, [Confidential Computing](https://www.nvidia.com/en-us/data-center/solutions/confidential-computing/),
  read 2026-11-14. The 98% figure is NVIDIA's own.
