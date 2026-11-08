# GitHub will block pull_request_target in public repositories from December 2

```json
{
  "id": "2026-11-08-github-blocks-pull-request-target",
  "date": "2026-11-08",
  "title": "GitHub will block pull_request_target in public repositories from December 2",
  "kind": "practice",
  "summary": "GitHub announced on November 2, 2026 that from December 2, 2026, GitHub Actions blocks pull_request_target events by default in every public repository unless an Actions event policy allows them. Enforcement is tried in two windows, November 9 and November 16, 16:00 to 18:00 UTC. Private and internal repositories are not affected.",
  "stance": "adopt",
  "relevance": "low",
  "level": "info",
  "audiences": ["developer", "maintainer"],
  "notice": {
    "developer": "If your public project's workflows use pull_request_target, expect them to fail on November 9 and 16 between 16:00 and 18:00 UTC, and to stop from December 2 unless you allow them.",
    "maintainer": "Check your public repositories for pull_request_target before December 2; Softanza's own repositories do not use it."
  },
  "areas": ["softanza"],
  "status": "done",
  "confidence": "read",
  "sources": [
    { "title": "pull_request_target blocked by default December 2", "url": "https://github.blog/changelog/2026-11-02-pull_request_target-blocked-by-default-december-2", "by": "GitHub", "read": "2026-11-08" }
  ],
  "review_by": "2026-12-03",
  "tags": ["ci", "github-actions", "supply-chain"]
}
```

## What happened

`pull_request_target` runs a workflow in the context of the base repository, with access to its secrets, when a pull
request arrives, including one from a fork. If such a workflow runs the fork's code, that code can steal the secrets
or tamper with the pipeline. GitHub's changelog of November 2, 2026 says that from December 2 the event is blocked by
default in public repositories on GitHub Free, Team and Enterprise Cloud, unless an Actions event policy explicitly
allows it. Until then the rule runs in an evaluate mode that shows what it would block, and it is enforced during two
trial windows: November 9 and November 16, 2026, from 16:00 to 18:00 UTC. Enforcement had first been planned for
November 2.

## Why it matters to Softanza

Softanza's own repositories are not affected: on 2026-11-08 we checked six of them, and none has a workflow using
`pull_request_target`. The entry is kept for the people who build their own public projects with Softanza and for
the date it carries: a workflow that fails for two hours on November 9 is easier to understand when someone said it
would.

The practice is one Softanza already follows: code from outside never runs where the secrets are.

## What we do

- Nothing to route. The entry is a notice.

## Sources

- GitHub changelog, [pull_request_target blocked by default December 2](https://github.blog/changelog/2026-11-02-pull_request_target-blocked-by-default-december-2),
  November 2, 2026, read 2026-11-08.
