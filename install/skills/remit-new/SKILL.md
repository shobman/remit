---
name: remit-new
description: 'Admit a work item in this repository''s .remit/ work location, and say how far it may go without the practitioner. Use on their words for putting something on the durable surface — "file it", "park this", "an idea", "for the backlog", "new work item", "raise an item", "create a brief for X", "take it to refined", "take it to accepted", "take it all the way" — and on their word that an admitted item takes a further phase. Never to manufacture an item so that something can be started.'
---

# New

The practitioner is admitting work. Help them say it well, run one command, report what it
printed, and stop.

The brief is their words: sharpen and structure them, never widen them, and never fill a gap they
left with something plausible. A sentence that is your reading of their words is marked as a
reading before the brief is filed, never left standing as theirs. Write the `**Depends on:**` line yourself, from the mechanical
facts — a contract this work builds on, named by slug, or `none`. Sequencing is theirs; they volunteer it, and they are not asked for it.

**Parked — "file it", "park it", an idea, for the backlog:** file what they wrote, verbatim, with
`--park`. Ask one thing only, once — is there enough here to evaluate, an outcome a stranger
could judge delivered or not? — and take their answer as it stands.

**Refined — "create a brief", "take it to refined" or further:** read this repository's own bar
first — `cat .remit/rules/refined.md` — and ask them, once each, every criterion under `## fix`
that what they said does not already satisfy. When they ask for research, ask what it should
establish and what it should hand back, and write their answer as a `**Research:**` line.

## The command

```sh
sh "$(git rev-parse --show-toplevel)/bin/remit" new <slug> [--until refined|accepted|closed] [--park] < <brief-file>
```

| They said | The command |
|---|---|
| "file it", "park it", an idea, for the backlog | `--park` |
| nothing about how far | no flag |
| a stop they named | `--until <that stop>` |
| a stop they named, and to rest there | `--until <stop> --park` |

With `--until`, the command runs the chain itself — it raises real fresh contexts and takes
minutes to hours, so run it backgrounded and report when it returns.

## A further phase

A phase is theirs to open, exactly as the item was: `phase-<n>.md` beside the brief, that part's
own outcome and proof inside the item's. Write it and commit it; the script does the rest. A
part that changes the item's outcome or boundary is an amendment or a new item — their word says
which.

## Report it, and stop

Report what it printed, verbatim in substance. Exit 3: committed here, NOT accepted by the
remote — say so, and never call it pushed or safe. Exit 2: nothing changed. Exit 4: the chain
escalated at admission — the item's `log.md` carries the reason, and that turn asks them to
rule, so give it in the shape AGENTS.md fixes for a turn that asks them to rule; what the brief
needs is theirs to work out, never yours to propose. Otherwise stop: no elaborating, ranking,
estimating, or raising it later unasked.
