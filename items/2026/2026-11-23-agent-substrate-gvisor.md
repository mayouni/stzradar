# Google gives Agent Substrate 1.0 and gVisor to the CNCF: an agent holds no credential, and the gateway adds it outside the sandbox; Softanza reads its credential broker against that line

```json
{
  "id": "2026-11-23-agent-substrate-gvisor",
  "date": "2026-11-23",
  "title": "Google gives Agent Substrate 1.0 and gVisor to the CNCF: an agent holds no credential, and the gateway adds it outside the sandbox; Softanza reads its credential broker against that line",
  "kind": "release",
  "summary": "On November 5, 2026 Google Cloud announced the donation of Agent Substrate and gVisor to the Cloud Native Computing Foundation, with Agent Substrate at version 1.0 under Apache-2.0. Each agent session, called an actor, runs in its own gVisor sandbox or Cloud Hypervisor microVM on Kubernetes, with its own files, memory and network rules; plain Linux containers are refused. Networking is deny by default, and an actor holds no API key or cloud token: an egress gateway outside the sandbox adds the credential to each approved outbound request. An idle actor is snapshotted and its slot freed; the project reports a resume in under 500 ms and more than 500 activations per second. The figures are the project's own.",
  "stance": "learn",
  "relevance": "medium",
  "level": "advice",
  "audiences": ["developer", "maintainer"],
  "notice": {
    "developer": "The safest place for a secret is outside the process that could be tricked. An agent that never holds its credential cannot leak it: a gateway it cannot change adds the credential to the requests a policy approved.",
    "maintainer": "Softanza brokers a credential by name inside the agent's process. Agent Substrate draws the line one step further out, at the outbound request, and Softanza's own boundary outside the process is the place to state which side each guarantee stands on."
  },
  "areas": ["security", "agents", "harobanda"],
  "domains": ["agents", "security"],
  "concerns": ["trust", "sovereignty"],
  "actions": [
    {"area": "stzlib.security", "do": "state in the threat model which guarantees of the credential broker hold when the agent's own process is hostile, and measure one governed outbound call whose credential is added by a process outside the agent, so that the agent's memory never holds it", "state": "routed", "dates": {"proposed": "2026-11-23", "routed": "2026-11-23"}}
  ],
  "status": "routed",
  "confidence": "claimed",
  "sources": [
    {"title": "Sandboxing untrusted AI agents at scale", "url": "https://opensource.googleblog.com/2026/11/sandboxing-untrusted-ai-agents-at-scale.html", "by": "Mofi Rahman, Brandon Royal (Google Cloud)", "read": "2026-11-23"},
    {"title": "Agent Substrate (repository)", "url": "https://github.com/agent-substrate/substrate", "by": "Agent Substrate project", "read": "2026-11-23"}
  ],
  "review_by": "2027-02-23",
  "tags": ["google", "gvisor", "sandbox", "agents", "credentials", "kubernetes", "cncf"]
}
```

## What happened

Google Cloud announced on November 5, 2026 that it gives Agent Substrate and gVisor to the Cloud Native Computing
Foundation. Agent Substrate, at version 1.0 under Apache-2.0, runs agent sessions on Kubernetes. A session is an
actor: it has its own files, environment, memory and network rules. Each actor runs in a dedicated gVisor sandbox,
which answers the program's system calls in user space, or in a Cloud Hypervisor microVM; the project refuses plain
containers.

Three rules of its design stand out:

- **An actor holds no credential.** A gateway outside the sandbox adds the API key or token to each outbound request
  the policy approved. Each actor has a short-lived identity certificate.
- **The network is closed by default.** An actor has a private network stack, one way in through a router, and no
  path to another actor or to the control plane.
- **An idle actor costs a snapshot.** Its memory and files are saved and its slot is freed; the project reports a
  resume in under 500 ms, more than 500 activations per second, and ten times the density of standard containers.
  The conditions of these figures are the project's to state.

The repository describes the project as young, with a promise of stable interfaces from version 1.0.

## Why it matters to Softanza

Softanza governs an agent by rules decided in code, keeps secrets by name, and has a boundary outside the agent's
process for files, commands and the network. Agent Substrate gives a clear rule for one question on that boundary:
where a credential is used. Inside the agent's process, a broker protects the secret from the agent's code that runs
after it; outside, at the outbound request, the secret is beyond the reach of everything the agent runs. Softanza's
parts already stand on both sides, and the rule says which guarantee each side can give.

## What we do

- Route to the security side a statement of which broker guarantees hold against a hostile agent process, and one
  measured call with the credential added outside it.
- Look again by 2027-02-23.

## Sources

- Mofi Rahman and Brandon Royal, Google Cloud,
  [Sandboxing untrusted AI agents at scale](https://opensource.googleblog.com/2026/11/sandboxing-untrusted-ai-agents-at-scale.html),
  November 5, 2026, and the project's [repository](https://github.com/agent-substrate/substrate), read 2026-11-23.
  Figures are the project's own.
