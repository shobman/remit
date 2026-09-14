---
name: remit-resume
description: 'Resume an item as far as authorised and report its terminal state, cause and next required action. Use for "pick up X", "carry on", "resume", "unpark", "run it to refined", "take it to accepted", "take it all the way" or a ruling after a stop. Also use for stopping a running chain and for an explicitly requested ad-hoc check.'
---

# Resume

```sh
sh "$(git rev-parse --show-toplevel)/bin/remit" resume <slug> [--until refined|accepted|closed [--park]] [--seat <role>=<harness>/<model>]...
```

Give `--seat` only when the practitioner names a seat for this item, using a registered pair.
Give `--until` only for a stop they name. Preserve existing recorded authority when neither is
given. If the command refuses for a missing stop, relay the refusal and ask how far it may go.
An ambiguous or unavailable seat needs clarification, not substitution.

Use `park <slug>` to park outright and `stop <slug>` to end a running chain. Resume also
continues a `crashed` row. The command owns the chain; do not perform or repeat its steps
in this conversation.

Run backgrounded as AGENTS.md requires. Before starting, give one brief update naming the work.
Use a rounded-up duration only when comparable `- raise:` entries in the record support it;
otherwise say that completion will be reported.

## Return

Report the terminal row, shared cause and any next required action under AGENTS.md's contract.
Normal rounds need no narration. A stop at the authorised stage is a complete result.
Keep unchanged stage, changed work and remote durability distinct.

`publication note needed` leaves a completed candidate waiting for its human summary.
Follow AGENTS.md's Human delivery notes contract: prepare the four-part note from retained
evidence at the command's printed path and resume the same candidate within the existing
delegation. This is publication work, not another product build or an evaluation failure.

For an `asked:` stop, use `answer --conductor` only within the recorded elevation and its
mechanical bound; state the provisional ruling and continue. Otherwise relay the question.
An escalation needs its recorded cause and missing authority, not an automatic menu of every
verb. Read the log when needed; never repair or amend the brief on an inferred ruling.

## Ad-hoc check

Only when asked to check live work without an item, raise a fresh evaluator directly through
the seam. Brief it with the practitioner's outcome, boundary and required proof:

```sh
REMIT_AUTHORITY=<briefing> REMIT_PROVENANCE=<scratch-file> \
  sh "$(git rev-parse --show-toplevel)/bin/remit-invoke" evaluate <name> <worktree>
```

Run backgrounded. Return the verdict, consequential findings and proof limits. A refusal is
the result; nothing here accepts, repairs, merges or records work.
