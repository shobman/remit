---
name: capture-work
description: 'Capture a new work item as a brief, open a further phase on an item already admitted, or park/activate an existing one, in this repository''s .remit/ work location. Use whenever the practitioner signals work they want kept but not started — "create a brief", "new work item", "raise an item", "an idea", "future item", "dump this new item: ...", "we should eventually ..." — or asks to park, shelve, pick up, or activate an item, or rules that an admitted item takes another phase — "next phase is the build", "open a second phase for that". Use it whenever the practitioner admits something durable; never to manufacture an item so that work can start.'
---

# Capture

The practitioner is admitting work. Your job is to help them say it well, then make it durable
and get out of the way. The item is born **parked**: kept, not started, and never raised again
unless they raise it.

An item is a thing they wanted kept, not a permission to begin. Work they keep fluid — from idea
through to finished, with no item and no worker — is entirely valid and needs nothing from this
skill. Never create an item so that something can be started, dispatched, or evaluated: a durable
item exists only because they admitted the outcome.

## Improve the brief with them, then stop

Draft the brief in the exchange and sharpen it: a real title, the outcome in their terms, the
boundary, and any constraint they stated. Ask about what is genuinely unclear.

You may sharpen, structure, and strengthen their intent. You may **not** widen it. Widening is
changing the outcome they authorised or crossing the boundary they set: added scope, capabilities,
acceptance criteria they did not sanction, adjacent work you noticed. A further phase they open
inside that outcome is not widening — it is the same outcome, narrowed to the part in hand; a phase
you write in yourself is widening whatever it is called. If you think something is missing, ask; do
not write it in on their behalf.

Show them the brief and get their agreement before writing it. Keep it short — a brief nobody
would read is not captured.

## Then make it durable

Pick a slug from the title: lower-case, hyphenated, a few words (`resume-and-choose`).

```sh
sh "$(git rev-parse --show-toplevel)/bin/remit" new <slug> <<'BRIEF'
# <Title>

<the agreed brief>
BRIEF
```

`remit` writes `.remit/<slug>/brief.md`, stamps it parked, commits it, and pushes when a remote
is configured. It prints exactly what happened.

**Report its result verbatim in substance.** If it says the push failed, tell the practitioner the
item is committed on this machine only and is not recoverable if the machine is lost — never
describe work as pushed, backed up, or safe elsewhere unless `remit` said the remote accepted it.
Exit code 3 means committed but not pushed; the work item still exists and is still valid.

To move an item between states when directed — and only when directed:

```sh
sh "$(git rev-parse --show-toplevel)/bin/remit" park <slug>
sh "$(git rev-parse --show-toplevel)/bin/remit" activate <slug>
```

An item can move either way, any number of times. The brief's `**State:**` line is the item's
own answer about its state; nothing else records it.

## When they open a phase on an item they already admitted

An admitted outcome may turn out to take more than one part, and which parts is not known when the
item starts. Opening one is theirs, exactly as admitting the item was. You may tell them a further
phase looks needed and hand them that as the smallest decision — you never open one yourself, and
you never write one so that a dispatch or an evaluation has something to read.

A phase is not a second item and never becomes one: `bin/remit new` has no part in it. Write it with
the item it belongs to, as ordinary files in one ordinary commit carrying this harness's session
trailers:

1. **the item's `brief.md` gains a `## Phases` section** — the phases in the order they were opened,
   the practitioner's ruling that opened each in their own words, and one `**Current phase:**` line
   naming the phase file in hand. Edit the brief directly for this; never touch its `**State:**`
   line, which is `bin/remit`'s alone;
2. **the phase's own file beside the brief** — `<phase>.md`, carrying that phase's outcome,
   boundary, constraints and proof exactly as a brief carries them, and stating that they sit
   inside the item's. A phase may narrow the item; it may never amend it. If what they want changes
   the item's own outcome or boundary, that is an amendment to the brief or a new item — take their
   word for which, and never let a phase file quietly become either.

Keep the pointer true, because it is the only answer to which delivery is in hand: `dispatch-work`
dispatches from it and `resume-work` reads it to tell them where the work stands. Move it when they
open the next phase — which is after the phase in hand has had its evaluation, or they have waived
it (`evaluate-work`) — and when nothing is in hand, say that on the line rather than leaving it
pointing at finished work.

Opening a phase changes nothing else. The item's state, its authorised outcome, its boundary and its
own proof are exactly what they were; a phase landing is not the item finishing, and only the
practitioner rules that.

## After it is captured

Confirm it exists, parked, and stop. Do not elaborate the brief further, propose next steps,
estimate it, rank it against other work, offer to start it, or mention it again in a later
session unasked. Capturing a thought must not create an obligation to act on it. A phase you wrote
gets the same restraint: confirm it is written, and stop there.

Never create a work item, or a phase within one, for something the practitioner did not admit. A
discovery you made is not work.
