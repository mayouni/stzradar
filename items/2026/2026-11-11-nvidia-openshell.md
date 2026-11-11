# NVIDIA OpenShell governs an agent from outside its process; Softanza adds that boundary to the rules it already decides in code

```json
{
  "id": "2026-11-11-nvidia-openshell",
  "date": "2026-11-11",
  "title": "NVIDIA OpenShell governs an agent from outside its process; Softanza adds that boundary to the rules it already decides in code",
  "kind": "release",
  "summary": "NVIDIA OpenShell is an open-source (Apache 2.0) runtime for AI agents, at v0.1.8 on November 10, 2026, and moving to the CNCF. Each agent runs in a sandbox whose files, system calls and network are confined by the kernel, a supervisor outside the agent checks every outbound request against a deny-by-default policy and adds real credentials only to requests bound for approved endpoints, and a prover uses formal logic to show what new access a policy change would grant before it is applied. It runs on Linux, on macOS with Apple Silicon, and on Windows through WSL 2 or Microsoft MXC.",
  "stance": "learn",
  "relevance": "high",
  "level": "advice",
  "audiences": ["developer", "maintainer"],
  "notice": {
    "developer": "An agent that never holds a real credential cannot leak it: OpenShell adds the secret only to a request bound for an approved endpoint, outside the agent's reach.",
    "maintainer": "Softanza already decides in code which functions an agent may call and under which posture; it adds the boundary OpenShell shows, enforcement outside the agent's process, for secrets first and for model-written code next."
  },
  "areas": ["softanza", "aicha", "harobanda"],
  "domains": ["agents", "security"],
  "concerns": ["trust", "sovereignty"],
  "actions": [
    { "area": "stzlib.security", "do": "broker credentials for agents: an agent's outbound call names a secret held in stzSecretStore, and the engine attaches its value only to a request bound for an endpoint the governance approves, so neither the agent's code nor the model ever holds the value", "state": "proposed", "dates": { "proposed": "2026-11-11" } },
    { "area": "stzlib.security", "do": "run model-written code and an agent's child processes inside an operating-system boundary outside the agent's process, deny by default on files and network (on Windows a job object or AppContainer, on Linux namespaces with seccomp or Landlock), and measure what each platform enforces natively", "state": "proposed", "dates": { "proposed": "2026-11-11" } },
    { "area": "stzlib.intelligence", "do": "show, before a governance change is accepted, the access it adds: the functions, postures, endpoints and secrets an agent could reach after the change and not before, computed from the rules themselves", "state": "proposed", "dates": { "proposed": "2026-11-11" } }
  ],
  "status": "analysed",
  "confidence": "read",
  "sources": [
    { "title": "NVIDIA OpenShell", "url": "https://build.nvidia.com/openshell", "by": "NVIDIA", "read": "2026-11-11" },
    { "title": "NVIDIA/OpenShell (README)", "url": "https://github.com/NVIDIA/OpenShell", "by": "NVIDIA", "read": "2026-11-11" },
    { "title": "OpenShell v0.1.8 release notes", "url": "https://github.com/NVIDIA/OpenShell/releases/tag/v0.1.8", "by": "NVIDIA", "read": "2026-11-11" }
  ],
  "review_by": "2027-01-11",
  "tags": ["nvidia", "openshell", "agents", "sandbox", "credentials", "policy"]
}
```

## What happened

NVIDIA presents OpenShell as an open, secure runtime for autonomous AI agents, the runtime layer of its Open Agent
Safety Platform. The project is open source under Apache 2.0; its latest release is v0.1.8, dated November 10, 2026,
and the repository says OpenShell has joined the CNCF and is moving its development there. It runs on Linux, on macOS
with Apple Silicon, and on Windows through WSL 2 (experimental) or natively through Microsoft MXC.

It has four parts. **Sandboxes** run each agent with kernel-level controls over the files it can reach and the system
calls it can make, and those controls stay in place when the agent runs generated code or starts child processes.
A **supervisor** outside the agent checks every outbound request against policy; for HTTP, GraphQL and MCP traffic it
can allow a read and refuse a write through the same API, and it keeps real credentials outside the workload,
adding them only after the request passes. A **gateway** manages the lifecycles and policies of many sandboxes. A
**policy prover** uses formal logic to check whether the permissions a policy grants stay within a boundary, or to
name a concrete action that exceeds it, so that a change granting new access waits for review. Access is denied by
default and granted per declared task, and the enforcement happens where the model's output cannot influence it.

## Why it matters to Softanza

Softanza governs its agents by rules decided in code. An agent file is treated as data: code names the functions an
agent may call and the most trusted posture each may run under (trusted, external, sandboxed), and a file asking for
more is refused at load. Each action carries its reversibility, an agent rehearses in a virtual workbench, and only a
committing actor changes the world. Since 2026-11-08 the estate also rules that a secret is named, never typed.

OpenShell shows the layer beneath that: the same rules enforced outside the agent's own process, by the operating
system. That matters in three places. A secret an agent holds can be written into a log, a prompt or a reply; a
secret the engine attaches at the endpoint never reaches the agent at all. Code a model writes, and any process it
starts, is safest behind a boundary the code cannot reach. And a change of rules is easiest to review when it is
shown as the access it adds. The first two belong to the engine, where Softanza's substance lives; the third follows
from rules that are already data.

## What we do

- Propose to stzlib's security plane credential brokering for agents, and an operating-system boundary for
  model-written code and child processes.
- Propose to the intelligence plane a view of the access a governance change adds, before it is accepted.
- Look again by 2027-01-11.

## Sources

- NVIDIA, [OpenShell](https://build.nvidia.com/openshell), read 2026-11-11.
- NVIDIA, [NVIDIA/OpenShell](https://github.com/NVIDIA/OpenShell) and its
  [v0.1.8 release notes](https://github.com/NVIDIA/OpenShell/releases/tag/v0.1.8), read 2026-11-11.
