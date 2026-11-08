# SPILLWAY: an agent may act only on targets that came from a trusted, typed field

```json
{
  "id": "2026-11-08-spillway-target-admission",
  "date": "2026-11-08",
  "title": "SPILLWAY: an agent may act only on targets that came from a trusted, typed field",
  "kind": "paper",
  "summary": "A paper submitted on November 4, 2026 proposes a defence for tool-using agents against prompt injection that does not rely on a model: a call with side effects is admitted only if every target it names that is not in the user's request was returned in a typed identity field, such as an email address or a channel, by a read-only tool. A rule-based sanitizer removes instruction-like text, and a local model reviews only the calls the rule refused. The authors report no successful in-scope attack across twelve benchmark settings.",
  "stance": "learn",
  "relevance": "high",
  "level": "advice",
  "audiences": ["developer", "maintainer"],
  "notice": {
    "developer": "A strong defence against prompt injection is a plain rule, not a smarter model: let an agent send or pay only to a target that came from the user or from a trusted, typed field.",
    "maintainer": "Compare Softanza's tool governance with SPILLWAY's admission rule: where a side effect's target comes from matters as much as which tool is allowed."
  },
  "areas": ["stzlib.intelligence", "stzlib.security"],
  "actions": [
    { "area": "stzlib.security", "do": "study whether Softanza's agent governance can check the provenance of a side effect's target, not only the tool's name, and report what it would take", "state": "routed" }
  ],
  "status": "routed",
  "confidence": "read",
  "sources": [
    { "title": "SPILLWAY: Separating Target Admission from Sanitization to Defend Tool-Using Agents against Prompt Injection", "url": "https://arxiv.org/abs/2611.07222", "by": "Woosang Lim et al.", "read": "2026-11-08" },
    { "title": "SPILLWAY, full text (HTML)", "url": "https://arxiv.org/html/2611.07222v1", "by": "Woosang Lim et al.", "read": "2026-11-08" }
  ],
  "review_by": "2027-05-08",
  "tags": ["prompt-injection", "agents", "governance", "paper"]
}
```

## What happened

The paper separates two questions that defences usually mix: **may this target receive an action**, and **is this
text trying to instruct the agent**. The first is answered by a deterministic rule with no model in it. A tool call
with side effects is admitted when each target value it uses either appears in the user's task or was returned by a
read-only tool in a typed identity field (an email address, a URI, an identifier, a host, or a field whose role is
recipient, sender, participant or channel), and does not also appear in untrusted free text. Bodies, subjects and
descriptions never count. The second question is handled by a rule-based sanitizer that replaces forged chat turns
and instruction-like text with placeholders and keeps what it removed as evidence. A local model, run fail-closed,
reviews only the calls the rule refused.

The authors evaluate it on AgentDojo with three models, two of them open-weight and run locally, across four suites,
and under several stronger attackers, including one trained by reinforcement learning. They report no in-scope
attack success on any of the twelve settings, a mean in-scope success of 0.007 under the trained attacker, and benign
utility near that of an undefended agent (all the authors' reported results). Their code and per-setting results are
published.

The paper is plain about its edges: the guarantee covers where an action goes, not what it carries. Content sent to a
legitimate target, an injection steering an effect toward a contact that already exists, and an attacker able to
write into a trusted typed field are outside it, and the role vocabulary must be written once per setting. We read
the abstract, the introduction, the threat model and the design in full; parts of the results and limitations come
from a summary of the rest of the paper made while reading it, and are written here only as far as they agree with
the abstract.

## Why it matters to Softanza

Softanza governs its agents with deterministic rules: doors that open or stay shut, permissions checked before a run.
That is the same bet this paper makes, and it is good to see it win a benchmark against defences built on models.
The paper adds a question Softanza's rules do not yet ask, as far as this desk knows: not only **which tool** may run,
but **where its target came from**. The answer is a set lookup and costs nothing at run time.

## What we do

- Propose to stzlib's security plane, through Central, a study of target provenance in its agent governance.

## Sources

- Woosang Lim et al., [SPILLWAY](https://arxiv.org/abs/2611.07222), arXiv 2611.07222, submitted November 4, 2026, and
  its [HTML full text](https://arxiv.org/html/2611.07222v1), read 2026-11-08.
