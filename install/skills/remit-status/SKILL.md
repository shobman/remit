---
name: remit-status
description: 'Show what work exists in this repository''s .remit/ work location, and rehydrate one item so the practitioner can pick it up. Use whenever they ask where things stand, in whatever words — "where are we", "what''s on?", "what''s the lowdown?", "anything waiting on me?" — or asks for parked work, or to be caught up on one item: "where did we leave X", "brief me on X", "catch me up on X".'
---

# Status

The practitioner has been away and is carrying none of this in their head. Give them the calm
view, from what is written and what is shipped. Nothing here starts, ranks or revives work.

```sh
sh "$(git rev-parse --show-toplevel)/bin/remit" list            # the board
sh "$(git rev-parse --show-toplevel)/bin/remit" list --parked   # when they ask for the rest
```

Report the rows verbatim in substance and add nothing — no view on which matters more, no
suggestion of where to begin. If it says there are no active items, say so and stop. A warning
on the error channel is passed on word for word.

## Rehydrate the item they pick

Rehydration is reading, not reconstruction: the item — brief with its header, `log.md` whole,
the current phase file where one is named — then what the brief links to, then the current
code and the pull requests that put it there. Tell them briefly, in their terms: why the work
exists, its stage and how far it may go without them, its boundary, what is actually in the
code today, what evidence exists that it works, every finding still without a disposition, and
where it stopped and why.

Where the material does not establish something, say that — "the item does not say". Never
fill a gap with a plausible reconstruction, and never claim to recall an earlier session. An
item they name that is absent may be closed: closed work is archived at
`.remit/work-items/.archive/<slug>/`, deliberately out of every listing — say so, read it only
if they ask, and report it as history, never as current behaviour.

Where the item is waiting on them — escalated, or stopped where only they can take it further —
end the rehydration with what they are waiting to rule on, in the shape AGENTS.md fixes for a turn
that asks them to rule. Where nothing is waiting on them, end where the reading ends.

## Then stop

You are reporting, not recording. Exit 3 from any command here means committed locally and NOT
accepted by the remote — say so. The board asks them nothing: do not compare items, recommend
where to begin, propose work, or move anything.
