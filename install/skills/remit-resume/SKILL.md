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

## Before a run that will take minutes — the leave line

Nothing in this section starts work. It governs what you say once the practitioner has set you
going and the command that does it — `remit resume`, or any run of the mechanics that will hold
them for minutes rather than seconds — is about to take you away from the conversation. This
section is the whole of that convention: nothing else in remit states what the line says or where
its band comes from, and anything that touches the leave line points here.

Say **one** line before you start, in your own words, and then nothing at all until the run comes
back. No progress note, no second reassurance, no notification. The line carries exactly two
facts: that you have what you need, and how long you expect to be.

Write it fresh every time. The rules below are the shape; the sentence is yours.

1. First person, about the work. Never about them.
2. One plain declarative of commitment, unhedged — no "I think", "should be able to",
   "hopefully".
3. Name the work in a few words, so the wait has something attached to it.
4. Give the duration as one of the four bands below, under *Where the band comes from* — never a
   precise number, and never a vague phrase that is not one of them.
5. Round the estimate up. Running under is forgiven; running over is not.
6. No instruction about their time — no "take a break", "go for a walk", "relax", "sit tight".
   Handing over the **work** is not an instruction about them: "leave it with me" is fine.
7. Never name, guess at, or diagnose how they are, and never tell them they are not needed.
8. No apology, no repeated punctuation, no minimiser — not "just", "only", "real quick".
9. Vary the wording every time. The two facts stay; the sentence does not.

You are the sidekick here, not the one in control: you are saying what you will do and how long it
will take, and what they do with that time is theirs. The shape, not the words to reuse — *"I've
got this. This one's pretty quick — under ten minutes on the migration, then I'll have the answer."*

### Where the band comes from

Read it out of the record; never invent it, and never derive it from a date, a commit, a file or
how long something felt last time. Every entry in an item's `log.md` that records a raise carries
one `- raise:` line saying which role ran, on which harness, and how many seconds it took — and
one is written for every raise that ran to completion, whether the round it belonged to went on
to succeed or fail. `bin/remit`'s header fixes that line's fields, under *log.md — THE ENTRY
SHAPES*.

Read those lines across the items — the closed ones under `.remit/work-items/.archive/` as much as the
active ones — and use judgement to find work of the same kind as the run you are about to start:
a build compared only with a build, research only with research, and among those, something of a
similar size and effort. There is no arithmetic here: no median, no sum, no minute figure to round
off. The seconds on those lines are the evidence; what you do with them is place the run in one of
four bands.

Then say the band. Each carries two things — a plain phrase for the size of the wait and the bound
that goes with it — and the line carries both, because a phrase with no bound is the vagueness
rule 4 refuses and a bound on its own drifts back towards the precise number it also refuses:

- **pretty quick** — under ten minutes.
- **a bit longer** — no bound you can honestly put on it, and you will say when it is done. That
  is what this band offers in place of a bound, and it is honest only because you will: they do
  not have to come back and check. What it promises is the run coming back and saying so, never
  a progress note along the way — the silence above holds until it does.
- **this could take a while** — more than an hour.
- **we're in for a long one** — more than two hours.

Say the band and stop there — both halves of it, and no more. They are the shape and not a
script to reuse — rule 9 still holds and the sentence is written fresh every time — and rule 6
holds hardest at the far end: the long band says how long it will be and says nothing whatever
about what they should do with the time. Not "you might want to go out for a while", not
"don't wait on it", not "there's no point sitting here".

Where the run falls between two bands, rule 5 decides it: take the longer one. Where the record
holds nothing you can honestly compare this run to — nothing of the same kind, or every match says
it was not timed — the second band is the honest place to land, because it is the one that claims
no bound. Never reach for a band the record does not support.

### What is not kept

Nothing about the leave line is written down: no timer, no streak, no count, no note in the record
that they went away or came back. The `- raise:` lines are there because the chain records what it
did, and this convention only reads them.

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
