---
name: remit-resume
description: 'Move a work item in this repository''s .remit/ work location as far as the practitioner said it may go, and report where it stopped. Use on his words for putting an item back in motion — "pick up X", "carry on with X", "resume it", "unpark it", "run it to refined", "take it to accepted", "take it all the way", "keep going" — and after it stopped or escalated and he has ruled. Use it too on his word that a run in progress is over: "stop it", "kill it", "that''s enough, end it". Also the one place an ad-hoc check is raised: "check this", "is this any good", "have someone look at this" on work in the conversation.'
---

# Resume

The practitioner has said an item may move. Run one command, report where it stopped and why,
and stop there yourself.

## Run the command

```sh
sh "$(git rev-parse --show-toplevel)/bin/remit" resume <slug> [--until refined|accepted|closed [--park]]
```

Give `--until` only when he named a stop just now; without it the item keeps the one it has.
`--park` attaches to an `--until` beside it and means run to that stop and rest there. Parking an
item outright is its own command:

```sh
sh "$(git rev-parse --show-toplevel)/bin/remit" park <slug>
```

On "stop it", "kill it" about a run that is already going, that is its own command as well:

```sh
sh "$(git rev-parse --show-toplevel)/bin/remit" kill <slug>
```

The command researches where the brief asks for it, evaluates, builds, delivers, evaluates again,
checks, flips ready, merges and closes — as far as his word and the repository's rubrics reach,
one gate at a time. None of that is yours to perform, brief, sequence or repeat, and no step of it
happens in this conversation. It raises real fresh contexts and takes minutes to hours. **Run it
in the background and report when it returns.**

It never writes a brief. The brief is his; where the gate into `refined` returns a must-fix the
item waits at `new` with that must-fix on the record, for him.

## Report what it printed

Report the row and the reason verbatim in substance. The reason is read from the item's record,
not computed, and it is the whole answer to why the work is where it is. Add nothing to it: no
reading of your own on whether it should have gone further, no summary of the diff, no account of
what a fresh context said beyond what the command printed.

- **Exit 0** — it stopped where it was told to stop. That is the design working, not a failure.
- **Exit 3** — committed on this machine only; the remote has NOT accepted it. Say so, and never
  call the work pushed, backed up or safe elsewhere.
- **Exit 4** — escalated. It tried to move the item and could not; the stage is unchanged and it
  sorts first from now on. The item's `log.md` holds the escalation entry and, beneath it, a
  proposed repair of the brief written by a fresh context. Report that proposal as what it is —
  a proposal, for him to rule on — and say that the brief is untouched until he does. Do not
  apply it, argue for it, or write a repair of your own.
- **Exit 2** — a precondition failed and nothing changed.

## The ad-hoc check on live work

When he asks for something in the conversation to be checked and there is no item to move, raise
one fresh context to judge it. **This is the only place any of these conventions runs
`bin/remit-invoke` directly.**

Write a briefing file that states the outcome the work was for, its boundary, and what would show
it delivered — his words, not your account of the work — then:

```sh
REMIT_AUTHORITY=<the briefing you wrote> \
REMIT_PROVENANCE=<a scratch file> \
  sh "$(git rev-parse --show-toplevel)/bin/remit-invoke" evaluate <name> <worktree>
```

`<name>` is a lower-case hyphenated name for this check; `<worktree>` is where the work is. The
command refuses, before anything is billed, when the harness or the model it would need is not
here — report that refusal as the answer it is.

Report its text verbatim in substance and stop. It judged; nothing here accepts, repairs, merges
or records anything, and your own reading of the work is not an independent judgement of it.
