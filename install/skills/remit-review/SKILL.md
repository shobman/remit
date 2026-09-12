---
name: remit-review
description: 'Show standing findings and their present disposition, or on request attest whether code has fixed them. Use for "what is standing", "review today’s findings", "anything still open", "did we fix X", "is that still there" or "attest".'
---

# Review

Read the requested window from the record, including archived items when in scope:

```sh
sh "$(git rev-parse --show-toplevel)/bin/remit" review
sh "$(git rev-parse --show-toplevel)/bin/remit" review today
sh "$(git rev-parse --show-toplevel)/bin/remit" review since <YYYY-MM-DD>
sh "$(git rev-parse --show-toplevel)/bin/remit" review <slug> [<slug>...]
```

The command also supports `yesterday` and `week`. Return all rows in scope: item, stage,
gate, verdict date, finding number, its first line and the delivery it stood against. If no
rows exist, say nothing is standing in that window. Do not rank findings or turn them into work.

## Attest on request

```sh
sh "$(git rev-parse --show-toplevel)/bin/remit" review [<window> | <slug>...] --attest
```

Run backgrounded as AGENTS.md requires. It raises a fresh context against the named HEAD and
records its attestation in the item logs, including archives.

For a full attestation report, return the counts and each finding's present disposition:
standing, fixed, moot or unattested. For a question about one finding, answer that finding first;
include other results only when they affect that answer.
A fixed finding will not be re-judged; moot remains standing. Name the candidate and include
evidence where it affects the conclusion or a requested recommendation. Expand evidence on
request. Attestation itself creates no decision, item or automatic recommendation.

Report failures and local-only durability under AGENTS.md's contract. Do not attest without
the practitioner's request or repeat an attestation unasked.
