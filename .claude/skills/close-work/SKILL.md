---
name: close-work
description: Close a work item in this repository's .remit/ work location and archive it whole, when the practitioner directs it. Use only when they say the work is over — "close it", "close <item>", "that's finished, archive it", "we're not doing this, drop it", "abandon it" — and use it then, including for work that shipped nothing. Never invoke this to propose, suggest, or check whether something could be closed.
---

# Close

The practitioner has decided a piece of work is over — delivered, or abandoned. Your job is to
make that decision durable and complete, and then let the work disappear.

## Closure is theirs alone

Never infer that work is finished. Never suggest closing anything, never ask whether they want
to close something, never treat a merged PR, a passing test, an evaluation, or your own sense of
completion as a reason to raise it. If they have not said to close it, there is nothing to do here.

Closure needs nothing tidied first. Do not require a final summary, a resolved observation, a
retrospective, or an evaluation. Do not raise new work items for anything left over — a loose
end you noticed is not work.

## Confirm what will vanish, then close it

Show them what is about to be archived — the item's files, so they can see nothing they care
about is only there:

```sh
ls -R .remit/<slug>
```

Ask whether any commit or pull request shipped this work. You may offer what the repository
actually shows (`git log`, `gh pr list`) for them to confirm; never write a link they have not
confirmed, and never invent one. Abandoned work has no links, and that is fine.

```sh
sh "$(git rev-parse --show-toplevel)/bin/remit" close <slug> <<'DELIVERY'
- <commit or PR link, one per line, in their words>
DELIVERY
```

With nothing to record, close it with empty input instead:

```sh
sh "$(git rev-parse --show-toplevel)/bin/remit" close <slug> < /dev/null
```

`remit` sets the item's state to closed, moves the whole folder — brief, decisions, evidence,
evaluations, everything kept with it — to `.remit/.archive/<slug>/`, keeps the delivery links
there as `delivery.md`, commits, and pushes when a remote is configured.

**Report its result verbatim in substance.** If it says the push failed, say the closure is
committed on this machine only and is not recoverable if the machine is lost — never call it
pushed or safe elsewhere unless `remit` said the remote accepted it. Exit code 3 means committed
but not pushed; the item is closed either way. Exit code 2 means nothing changed at all.

## Then it is gone

It is absent from `remit list` and from `remit list --parked`, and nothing warns about it. Say it
is closed, and stop. Do not summarise what it achieved into any other file, carry its content
forward into another item, or mention it again in a later session unasked. Closed work must never
come back as an instruction, a reminder, or an obligation.

If a constraint from that work still governs the software, it belongs in the code — a comment,
a test, a name — not in the archive. Say so once if you see it; that is a change to the product
they may authorise separately, not a step of closing.

## Retrieval, only when they dig

The archive is history, not a work surface. If the practitioner deliberately asks for closed
work — archaeology, forensics, "what did we do about X" — read it directly:

```sh
ls .remit/.archive
cat .remit/.archive/<slug>/brief.md
git log --oneline -- .remit/<slug>          # its whole history, under its original path
```

Report what it says as the past. Do not reopen it, do not restore it to `.remit/`, and do not
treat anything in it as current behaviour — the shipped code is the authority for that.
