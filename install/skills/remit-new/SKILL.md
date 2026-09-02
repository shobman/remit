---
name: remit-new
description: 'Admit a work item in this repository''s .remit/ work location, and say how far it may go without the practitioner. Use on his words for putting something on the durable surface — "file it", "park this", "an idea", "for the backlog", "new work item", "raise an item", "create a brief for X", "take it to refined", "take it to accepted", "take it all the way" — and on his word that an admitted item takes a further phase. Never to manufacture an item so that something can be started.'
---

# New

The practitioner is admitting work. Help him say it well, run one command, report what it
printed, and stop.

The brief is his words: sharpen and structure them, never widen them, and never fill a gap he
left with something plausible. A sentence that is your reading of his words is marked as a
reading before the brief is filed, never left standing as his. Write the `**Depends on:**` line yourself, from the mechanical
facts — a contract this work builds on, named by slug, or `none`. Sequencing is his; he
volunteers it, and he is not asked for it.

**Parked — "file it", "park it", an idea, for the backlog:** file what he wrote, verbatim, with
`--park`. Ask one thing only, once — is there enough here to evaluate, an outcome a stranger
could judge delivered or not? — and take his answer as it stands.

**Refined — "create a brief", "take it to refined" or further:** read this repository's own bar
first — `cat .remit/rules/refined.md` — and ask him, once each, every criterion under `## fix`
that what he said does not already satisfy. When he asks for research, ask what it should
establish and what it should hand back, and write his answer as a `**Research:**` line.

## The command

```sh
sh "$(git rev-parse --show-toplevel)/bin/remit" new <slug> [--until refined|accepted|closed] [--park] < <brief-file>
```

| He said | The command |
|---|---|
| "file it", "park it", an idea, for the backlog | `--park` |
| nothing about how far | no flag |
| a stop he named | `--until <that stop>` |
| a stop he named, and to rest there | `--until <stop> --park` |

With `--until`, the command runs the chain itself — it raises real fresh contexts and takes
minutes to hours, so run it backgrounded and report when it returns.

## A further phase

A phase is his to open, exactly as the item was: `phase-<n>.md` beside the brief, that part's
own outcome and proof inside the item's. Write it and commit it; the script does the rest. A
part that changes the item's outcome or boundary is an amendment or a new item — his word says
which.

## Report it, and stop

Report what it printed, verbatim in substance. Exit 3: committed here, NOT accepted by the
remote — say so, and never call it pushed or safe. Exit 2: nothing changed. Exit 4: the chain
escalated at admission — the item's `log.md` carries the reason and any proposal, and that turn
asks him to rule, so give it in the shape AGENTS.md fixes for a turn that asks him to rule; the
proposal is his to rule on, never to apply. Otherwise stop: no elaborating, ranking,
estimating, or raising it later unasked.
