---
name: remit-close
description: 'Close a work item in this repository''s .remit/ work location and archive it whole. Use only on the practitioner''s word that the work is over — "close it", "close X", "that''s finished, archive it", "we''re not doing this, drop it", "abandon it", "it''s done, get rid of it" — and use it then, including for work that shipped nothing. Never to propose, suggest, or check whether something could be closed.'
---

# Close

The practitioner has ruled a piece of work over. Show him what his ruling covers, run one
command, report, and let the work disappear.

Closure is his alone. Never infer that work is finished, never raise closing something, and never
read a merged pull request, a green suite or your own sense of completion as a reason to. If he
has not said to close it, there is nothing here to run.

## Show him what he is ruling on

Closure is his ruling on everything the record shows at that moment, and every finding still
carrying no disposition is sealed by it as pre-authorised — recorded as the closure's doing,
never as a ruling he made one by one. So show him those first:

```sh
grep -n '^- finding ' .remit/work-items/<slug>/log.md
ls -R .remit/work-items/<slug>
```

Read the list to him plainly: the findings, and which of them already have a disposition. Add no
recommendation about any of them.

Then ask whether any commit or pull request shipped this work. Offer what the repository actually
shows — `git log`, `gh pr list` — for him to confirm. Never write a link he has not confirmed and
never invent one. Abandoned work has no links, and that is fine.

## Run the command

```sh
sh "$(git rev-parse --show-toplevel)/bin/remit" close <slug> <<'DELIVERY'
- <a link he confirmed, one per line>
DELIVERY
```

With nothing to record, close it with empty input:

```sh
sh "$(git rev-parse --show-toplevel)/bin/remit" close <slug> < /dev/null
```

## Report it, and then it is gone

Report what it printed, verbatim in substance. Exit 3 means committed on this machine only and
NOT accepted by the remote — say so; the item is closed either way. Exit 2 means nothing changed
at all.

Closure is final. Say it is closed, and stop there. The item is absent from every listing,
nothing warns about it, and nothing about it comes back as an instruction, a reminder or an
account of current behaviour. Do not summarise what it achieved into another file, carry its
content into another item, or raise it in a later session unasked.

If a constraint from that work still governs the software, it belongs in the code — a test, a
name, a comment. Say that once if you see it. It is a change he may authorise separately, not a
step of closing.

## Retrieval, only when he digs

The archive is history, not a work surface. When he deliberately asks for closed work, read it:

```sh
ls .remit/work-items/.archive
cat .remit/work-items/.archive/<slug>/brief.md
```

Report it as the past. Do not reopen it, do not restore it, and do not treat anything in it as
current behaviour — the shipped code is the authority for that.
