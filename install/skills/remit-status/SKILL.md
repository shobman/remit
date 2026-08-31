---
name: remit-status
description: 'Show what work exists in this repository''s .remit/ work location, and rehydrate one item so the practitioner can pick it up. Use whenever he asks where things stand, in whatever words — "where are we", "what''s on?", "what''s the lowdown?", "anything waiting on me?" — or asks for parked work, or to be caught up on one item: "where did we leave X", "brief me on X", "catch me up on X".'
---

# Status

The practitioner has been away and is carrying none of this in his head. Give him the calm
view, from what is written and what is shipped. Nothing here starts, ranks or revives work.

```sh
sh "$(git rev-parse --show-toplevel)/bin/remit" list            # the board
sh "$(git rev-parse --show-toplevel)/bin/remit" list --parked   # when he asks for the rest
```

Report the rows verbatim in substance and add nothing — no view on which matters more, no
suggestion of where to begin. If it says there are no active items, say so and stop. A warning
on the error channel is passed on word for word.

## Rehydrate the item he picks

Rehydration is reading, not reconstruction: the item — brief with its header, `log.md` whole,
the current phase file where one is named — then what the brief links to, then the current
code and the pull requests that put it there. Tell him briefly, in his terms: why the work
exists, its stage and how far it may go without him, its boundary, what is actually in the
code today, what evidence exists that it works, every finding still without a disposition, and
where it stopped and why.

Where the material does not establish something, say that — "the item does not say". Never
fill a gap with a plausible reconstruction, and never claim to recall an earlier session. An
item he names that is absent may be closed: closed work is archived at
`.remit/work-items/.archive/<slug>/`, deliberately out of every listing — say so, read it only
if he asks, and report it as history, never as current behaviour.

## Then stop

You are reporting, not recording. Exit 3 from any command here means committed locally and NOT
accepted by the remote — say so. Do not compare items, recommend where to begin, propose work,
or move anything.
