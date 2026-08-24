---
name: remit-status
description: 'Show what work exists in this repository''s .remit/ work location, and rehydrate one item so the practitioner can pick it up. Use whenever he asks where things stand, in whatever words — "where are we", "where are things at?", "what''s on?", "what''s the lowdown?", "what''s happening in here?", "anything waiting on me?" — or asks for parked work, or to be caught up on one item: "where did we leave X", "brief me on X", "catch me up on X", "what''s the story with X".'
---

# Status

The practitioner has been away and is carrying none of this in his head. Give him the calm view,
from what is written and what is shipped. Nothing here starts, ranks or revives work.

## Show him the view

```sh
sh "$(git rev-parse --show-toplevel)/bin/remit" list
```

Each row is attention, stage, the one-word reason it stopped, slug, title. Escalated items sort
first; that ordering is the command's and carries no judgement about value or priority. Report
the rows verbatim in substance and add nothing — no view on which matters more, no suggestion of
where to begin. If it says there are no active items, say so and stop; do not go looking for
something to fill the silence.

Parked work is dormant and hidden. Show it only when he asks for parked, shelved or "the rest":

```sh
sh "$(git rev-parse --show-toplevel)/bin/remit" list --parked
```

If the command warns on the error channel that an item could not be read, pass that on word for
word. An unreadable item is something he needs to know about, not something to quietly fix.

## Rehydrate the item he picks

Rehydration is reading, not reconstruction. Read these and nothing else:

1. the item — `.remit/work-items/<slug>/brief.md` with its header, `log.md` whole, and the phase
   file its `**Current phase:**` pointer names where it has one;
2. the authoritative content the brief links to — the linked files, or a URL if this harness can
   actually reach one;
3. the current code, and the history and pull requests that put it there.

Then tell him, briefly and in his terms: why the work exists and what outcome it was authorised
to reach; its attention, its stage and how far it may go without him; its boundary, including
what was ruled out; what has been delivered — what is in the code today, not what a brief hoped
for; what evidence exists that it works, and where; every finding on the record that still has no
disposition; and where it stopped and why.

Where the material does not establish something, **say that.** "The item does not say." "There is
nothing in the repository showing this was verified." Never fill a gap with a plausible
reconstruction, never claim to recall an earlier session — no record of one exists and none may
be made — and never write a file to make a gap go away. An honest "unknown" is the correct
answer; an invented one is a defect.

An item he names that is not there may have been closed. Closed work is archived at
`.remit/work-items/.archive/<slug>/` and is deliberately absent from every listing. Say it is
closed, and read it only if he asks — then report it as history, never as current behaviour or as
something outstanding.

## Then stop

Nothing you read during rehydration becomes durable: you are reporting, not recording. Stop there,
on the report. Do not compare or rank the items, recommend what to attend to first, ask what to
begin, propose work, or move anything.
