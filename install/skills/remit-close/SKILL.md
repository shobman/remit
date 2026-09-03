---
name: remit-close
description: 'Close a work item in this repository''s .remit/ work location and archive it whole. Use only on the practitioner''s word that the work is over — "close it", "close X", "that''s finished, archive it", "we''re not doing this, drop it", "abandon it" — and use it then, including for work that shipped nothing. Never to propose, suggest, or check whether something could be closed.'
---

# Close

The practitioner has ruled a piece of work over. Closure is his alone: never infer it, never
raise it, and never read a merged pull request or a green suite as a reason to.

Show him what his ruling covers first — every finding still without a disposition is sealed by
closure as pre-authorised:

```sh
grep -n '^- finding ' .remit/work-items/<slug>/log.md
```

Read that list to him plainly, with no recommendation. Then ask whether any commit or pull
request shipped the work, offering what the repository actually shows — never a link he has
not confirmed. Abandoned work has no links, and that is fine.

## The command

```sh
sh "$(git rev-parse --show-toplevel)/bin/remit" close <slug> <<'DELIVERY'
- <a link he confirmed, one per line>
DELIVERY
```

With nothing to record, close with empty input: `... close <slug> < /dev/null`.

## Report it, and then it is gone

Report what it printed, verbatim in substance. Exit 3: committed here, NOT accepted by the
remote — say so; the item is closed either way. Exit 2: nothing changed. Exit 4: the close
escalated; the item's `log.md` carries the reason, and that turn asks him to rule.

Closure is final: the item leaves every listing and nothing about it returns as an
instruction, a reminder, or an account of current behaviour. If a constraint from the work
still governs the software, it belongs in the code — a test, a name, a comment; say that once.
When he deliberately asks for closed work, read it from `.remit/work-items/.archive/<slug>/`
and report it as the past — after closure the code, not the brief, is the law. Then stop.
