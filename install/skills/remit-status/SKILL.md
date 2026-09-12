---
name: remit-status
description: 'Show the board or catch the practitioner up on an item: current outcome, state, blocker and decision owed. Use for "where are we", "what is on", "anything waiting on me", parked work, "where did we leave X", "brief me on X" or "catch me up on X".'
---

# Status

Read the current work surface; nothing here starts, ranks or revives work.

```sh
sh "$(git rev-parse --show-toplevel)/bin/remit" list
sh "$(git rev-parse --show-toplevel)/bin/remit" list --parked
```

For a board request, return the rows with their facts and order intact, then stop. Use
`--parked` when asked for parked work. If no active items exist, say so. Pass on a warning
from the error channel in its own words.

## Rehydrate

Read the item's brief and header, whole log, named current phase, linked authority, current
code and relevant pull requests. Use the locations the mechanism establishes.

Return the current outcome, stage, where it stopped and the decision owed. Include material
uncertainty, failed proof and findings that affect the next decision. Do not recount history
or every standing finding by default; do not imply omitted findings were resolved. Expand
findings and evidence on request, with record references and the limits of the proof.

Where the record does not establish a fact, say it is unknown. If a named item is absent, it
may be archived; read the archive only when asked and describe it as history.

Follow AGENTS.md's update and decision contract. Reporting authorises no state change.
