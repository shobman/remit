---
name: remit-review
description: 'Show the findings still standing against this repository''s work items — open or archived — from the record, and on his word have one fresh context attest which of them the code has since fixed. Use when he asks what is standing, in whatever words — "what''s standing", "review today''s findings", "what did the evaluators leave", "anything still open from last week" — or whether a finding is fixed: "did we fix X", "is that cache header thing still there", "attest".'
---

# Review

The standing findings are what the last verdict at each gate still carried with no
disposition — read from the verdicts, so a closed item's seal changes nothing. Run the one that
matches what he asked:

```sh
sh "$(git rev-parse --show-toplevel)/bin/remit" review                  # every item
sh "$(git rev-parse --show-toplevel)/bin/remit" review today            # or yesterday, week
sh "$(git rev-parse --show-toplevel)/bin/remit" review since <YYYY-MM-DD>
sh "$(git rev-parse --show-toplevel)/bin/remit" review <slug> [<slug>...]
```

Report the rows verbatim in substance — item, stage, gate, verdict date, finding number, the
finding's first line, and the delivery it stood against — and stop. If it prints nothing, say
nothing is standing in that window. No ranking, no triage, no proposal: a standing finding is
a fact the record holds, and what becomes of it is his.

## When he says "attest"

Only on his word. This raises ONE fresh context, in the primary worktree at HEAD, to say of
each standing finding whether it still stands, is fixed, or is moot — and records what it said
on every item's `log.md`, the archive included. Run it as a backgrounded task of your own
harness with a generous explicit timeout, exactly as a resume is run:

```sh
sh "$(git rev-parse --show-toplevel)/bin/remit" review [<window> | <slug>...] --attest
```

Its stdout is the rows, then the count per category. Give him that turn in the shape
`AGENTS.md` fixes for a turn that asks him to rule:

- **What happened.** One context attested the standing findings against the tree at the HEAD
  the command named.
- **What was expected.** The window or items he named, and how many findings stood in it.
- **What actually happened.** The three-way result with its counts — how many stand, how many
  are fixed, how many are moot, and how many the context did not attest — each finding's
  attestation given as the record has it, the evidence after the dash quoted. A finding
  attested fixed will not be re-judged; one attested moot or standing is still standing.
- **His options.** From the verbs, and only these: admit a standing finding as a work item in
  his own words, or leave it. Nothing here re-opens a closed item and nothing here moves one.
- **One recommendation.** One of those, with the reason in a sentence.

## Then stop

You are reporting, not recording. Exit 3 means committed locally and NOT accepted by the
remote — say so. Exit 2 means nothing was raised and nothing was recorded; pass the reason on
word for word. Do not attest without his word, do not attest twice, and do not turn a finding
into work he did not admit.
