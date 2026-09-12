---
name: remit-close
description: 'Close and archive an item on the practitioner’s word: "close it", "archive it", "drop it" or "abandon it", including work that shipped nothing. Explain material closure consequences and act on existing authority.'
---

# Close

Closure belongs to the practitioner. A merged pull request or green suite does not authorise
it; an explicit instruction to close or abandon does.

Before the command, read the record and explain any material consequence: work remains
undelivered, a pull request is unmerged, required proof is absent, or a consequential finding
is unresolved. Closing seals unresolved findings as pre-authorised and archives the item;
it does not merge a pull request or deliver unfinished work. Keep this disclosure compact.
Do not make closure a new review, require each finding to be ruled separately, or ask for
confirmation already supplied.

Record delivery links the practitioner has confirmed. Links are optional; their absence
does not block closure or require another question.

```sh
sh "$(git rev-parse --show-toplevel)/bin/remit" close <slug> <<'DELIVERY'
- <confirmed delivery link>
DELIVERY
```

With no confirmed links, use empty input: `... close <slug> < /dev/null`.

Report the command's actual result under AGENTS.md's contract. Exit 3 still means the item
closed locally, with the remote not accepting the record. A refusal is not closure.

The archived item leaves the current-work view. Read it only on a deliberate request and
report it as history; current behaviour comes from code. No reminders or new work follow.
