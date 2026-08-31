---
name: remit-resume
description: 'Move a work item in this repository''s .remit/ work location as far as the practitioner said it may go, and report where it stopped. Use on his words for putting an item back in motion — "pick up X", "carry on with X", "resume it", "unpark it", "run it to refined", "take it to accepted", "take it all the way", "keep going" — and after it stopped or escalated and he has ruled. Use it too on "stop it", "kill it" about a run in progress. Also the one place an ad-hoc check is raised: "check this", "is this any good", "have someone look at this" on work in the conversation.'
---

# Resume

The practitioner has said an item may move. Run one command, report where it stopped and why,
and stop there yourself.

```sh
sh "$(git rev-parse --show-toplevel)/bin/remit" resume <slug> [--until refined|accepted|closed [--park]]
```

Give `--until` only when he named a stop just now. Parking outright and ending a running chain
are their own commands — `park <slug>` and `stop <slug>`. `resume` is also the one verb that
continues a `crashed` row.

The command runs the chain — nothing in it is yours to perform, brief, sequence or repeat, and
no step of it happens in this conversation. It raises real fresh contexts and takes minutes to
hours: run it backgrounded, the way AGENTS.md's session rules say every raise is run.

## The leave line

Before the run takes you away, say one line, written fresh in your own words: that you have
what you need, the work in a few words, and a rounded-up duration — then nothing at all until
the run comes back. Read the estimate from the record, never invent it: the `- raise:` lines
in items' `log.md` files (`bin/remit`'s header fixes that line's fields) say what runs of the
same kind actually took. Round up; where the record holds nothing comparable, say plainly that
you will report when it is done.

## Report what it printed

Report the row and the reason verbatim in substance, and add nothing — no reading of your own
on whether it should have gone further. Exit 0: it stopped where it was told to; that is the
design working. Exit 3: committed here, NOT accepted by the remote — say so. Exit 2: a
precondition failed; nothing changed. Exit 4: escalated — the stage is unchanged and the
item's `log.md` holds the reason and any proposal, which you report as a proposal for him to
rule on, never apply, argue for, or replace with your own.

## The ad-hoc check on live work

When he asks for work in the conversation to be checked and there is no item to move, raise
one fresh context to judge it. This is the only place any of these conventions runs
`bin/remit-invoke` directly. Write a briefing that states, in his words, the outcome the work
was for, its boundary, and what would show it delivered — then:

```sh
REMIT_AUTHORITY=<briefing> REMIT_PROVENANCE=<scratch file> \
  sh "$(git rev-parse --show-toplevel)/bin/remit-invoke" evaluate <name> <worktree>
```

A refusal, before anything is billed, is the answer it is. Report its text verbatim in
substance and stop: it judged, and nothing here accepts, repairs, merges or records anything.
