---
name: remit-exposure
description: Report this repository's recorded exposure — the words the practitioner said and the words he was told, per channel, never summed. Use when he asks "how much have I said today", "exposure", "what's this session cost me", "where am I today", or the same numbers for one item or session, or the movement over time — "am I taking on more", "how many items am I carrying", "the trend".
---

# Exposure

Run the one that matches what he asked:

```sh
sh "$(git rev-parse --show-toplevel)/bin/remit-exposure" today             # the default
sh "$(git rev-parse --show-toplevel)/bin/remit-exposure" today --item <slug>
sh "$(git rev-parse --show-toplevel)/bin/remit-exposure" session <id>
sh "$(git rev-parse --show-toplevel)/bin/remit-exposure" trend [--weeks <n>]
```

Only this harness records itself turn by turn. When the question is about work done in
another harness, run its scan first and pass its stated limits on with the numbers:

```sh
sh "$(git rev-parse --show-toplevel)/bin/remit-exposure" scan <codex|copilot|pi|devin>
```

Do not run a scan he did not ask about.

## Report, verbatim, and stop

Report what it printed, verbatim in substance: `said` and `told` stay separate numbers, never
added, averaged, or scored. If it says nothing was recorded, say that. Say nothing about
whether a number is high, low, or worth changing, and suggest no threshold, alert, or next
step — exposure is shown when asked for, and nothing is pushed at anyone.
