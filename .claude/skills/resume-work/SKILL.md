---
name: resume-work
description: Show what work exists in this repository's .remit/ work location, and rehydrate one item so the practitioner can resume it. Use whenever they ask where things stand, in whatever words — "where are things at?", "what's happening in here?", "what's the status of my work items?", "where are we at?", "what's the lowdown?", "what's on?" — or ask to see parked work, or to rehydrate, restore, or be caught up on an item — "rehydrate it", "where did we leave X", "brief me on X", "catch me up on X".
---

# Resume

The practitioner has been away, possibly for weeks, and is carrying none of this in their head.
Give them the calm view. When they pick an item, tell them where it stands from what is written
and what is shipped — then ask what they want to do. Nothing here starts, ranks, or revives work.

## Show them the view

```sh
sh "$(git rev-parse --show-toplevel)/bin/remit" list
```

That is active work only, one line per item: slug, then title. Report it plainly — no commentary
on which matters more, no suggestion of where to begin. If it says there are no active items, say
so and stop there; do not go looking for something to fill the silence.

Parked work exists but is dormant. Show it **only** when they ask for parked, shelved, or "the
rest":

```sh
sh "$(git rev-parse --show-toplevel)/bin/remit" list --parked
```

If `remit` warns on stderr that an item was not listed, pass that on — an unreadable item is a
thing they need to know about, not a thing to quietly fix.

## Rehydrate the item they pick

Rehydration is reading, not reconstruction. Read three things and nothing else:

1. **the work item** — `.remit/<slug>/brief.md`, including its Phases section and current-phase
   line where it runs in phases, and every other file kept with it: the phase files, the
   evaluation record, whatever else is there;
2. **the authoritative content the brief links to** — the linked files, or a URL if this harness
   can reach it;
3. **the current code** — what is actually in the repository now, and the history and pull
   requests that put it there (`git log`, `gh pr list`).

If they name an item that is not there, it may have been closed: closed work is archived at
`.remit/.archive/<slug>/` and is deliberately absent from every listing. Say that it is closed,
and read it only if they ask for the closed work — then report it as history, never as current
behaviour or as something outstanding. That is `close-work`'s territory.

Then tell them, briefly and in their terms:

- why the work exists and what outcome it was authorised to achieve;
- its state, and its boundary — including what was explicitly ruled out;
- where it runs in phases, the phase story: which phases have run, how each was judged, and which
  phase the work is in now — read from the brief's Phases section and the item's evaluation record,
  never guessed from which files exist or which looks newest;
- what has been delivered: what exists in the code today, not what a brief hoped for;
- what evidence exists that it works, and where that evidence is;
- what is unresolved.

Where the material does not establish something, **say that**. "The item does not say." "There is
nothing in the repository showing this was verified." Never fill a gap with a plausible
reconstruction, never claim to recall an earlier session — no record of one exists, and none may
be created — and never write a new file to make a gap go away. An honest "unknown" is the correct
answer; an invented answer is a defect.

Nothing you read during rehydration becomes durable. You are reporting, not recording.

## Then stop and ask

End on the practitioner's move: ask what they want to do next. Do not propose new work, compare or
rank the items, recommend what to attend to first, activate anything, or offer to start. If they
decide to activate or park an item, or to open a further phase on one, that is `capture-work`'s job.
