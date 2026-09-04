# The remit work surface in this repository, whatever harness you are

This repository carries **remit**: a thin, durable work surface for practitioner-directed AI
work. Work lives in files. Judgement lives with the practitioner. Execution is disposable —
you are the means of execution, never the memory. His attention is the scarce resource here:
anything that farms it — proposals, offers, doors, agenda-setting — works against this
surface, whatever it is dressed as.

A work item is `.remit/work-items/<slug>/`: `brief.md`, his words under a script-owned header,
and `log.md`, the append-only record of every verdict, finding, delivery, escalation and
ruling. The installer's record of what it placed here is `.remit/.install/manifest`.

WHERE that record lives is not always this repository, and never assume that it is. A
`.remit/settings.local.json` may point it at a records repository of his own, and then every
work item, its archive and its kept run output are committed and pushed there and nothing
record-shaped reaches this repository at all — `bin/remit`'s header is the whole of that rule,
under WHERE THE RECORD LIVES. Remit may also be installed in SHADOW, with none of its
scaffolding in this repository's history; `install.sh`'s header is that law. Neither changes
anything you do — the commands, the authority and the stops are identical — and both change
where you would be wrong to go looking by hand. Read the paths the script prints. Never
construct one.

## The boxes

| Box | The one thing it does | Its law |
|---|---|---|
| the record | work items, archived whole on close | this file |
| the state machine | `bin/remit` — the only thing that moves state | its header |
| the seam | `bin/remit-invoke` — the only thing that raises a context | its header |
| the rules | `.remit/rules/` — the practitioner's, through a retro alone | `bin/remit`'s header |
| the registry | `.remit/settings.json` — the seats a raise may take | `bin/remit-invoke`'s header |
| the guards | hooks that refuse with one line | the hook files |
| the conventions | the skills: trigger → command → relay → stop | each `SKILL.md` |

Each box does its one thing, and no box explains another: a script's header is the law of that
script, and nothing here restates what a script prints, asks or refuses. A sentence that can go
false on its own — a count, a version, a date, a status — belongs in no instruction file.

## The commands

```sh
sh "$(git rev-parse --show-toplevel)/bin/remit" \
   new|resume|answer|park|stop|close|list|report|rules|setup|migrate|version ...
```

Run through a POSIX shell — on Windows, Git Bash's `sh` — from the primary worktree only.
`new` and `resume` run the chain — research, evaluate, build, deliver, evaluate, close
— as far as his word and the rules reach, each step a fresh context raised through
`bin/remit-invoke`. Delivery ends at the pull request: remit never merges one and never
reads a check. `report` is the intake for observations from outside this repository;
`CONTRIBUTING.md` at the root states the whole of that. The script's header states every
argument, and its printed result is the truth of what happened.

## What binds every session

- Only the practitioner admits, parks, resumes and closes work, opens a phase, writes a rule,
  and skips an evaluation. A discovery you made is not work: it rests in a field note or dies.
  Nothing you notice becomes an item — or an ask — unprompted.
- Report what a command printed, verbatim in substance, and stop: no ranking, proposing,
  elaborating or next steps. **Verbatim in substance binds the facts, not the prose.** The
  facts cross over exactly — counts, ids, slugs, stages, dates, exit codes, and the reasons the
  record gives — and so does any wording that is itself the thing he must weigh: his own
  rulings, a refusal line, a proposed amendment he has to rule on, each given as a quote. The
  rest is retold in plain words. A raised context's private vocabulary — cells, halves,
  clauses, gate shorthand — is either said in ordinary English or left out; it never reaches
  him unexplained. Exit 3 means committed locally and NOT accepted by the remote — never call
  that pushed, backed up or safe. Exit 4 means the chain escalated; the item's `log.md` carries
  the reason, and that turn takes the shape below.
- Nothing writes or rewrites a brief but him. Script-owned lines in a brief, and everything in
  `.remit/rules/`, are never edited by hand.
- A context is raised only through `bin/remit-invoke` — never your own agent, task or
  sub-agent tool, whatever this harness offers; a hook enforces this where the harness has
  one. Run a raise as a backgrounded task of your own harness with a generous explicit
  timeout — blocking the conversation on one is the failure.
- A chain's end is its only event, and the backgrounded task already reports it. Nothing
  watches the record while a chain runs: no monitor, tail or poll on `log.md` or the run
  directory — every line it emits wakes you for a turn to learn that a commit happened. Five
  chains are five backgrounded tasks and five completions, each at the one moment that
  needs you.
- When a chain ends at an `asked:` stop and he may have walked away, reach him where he is,
  by whatever this harness has for that (Claude Code: `PushNotification`) — one line, the
  item and the first question, nothing else. That is the one stop worth pulling him back
  for; every other completion waits in the transcript. Where he has elevated you to judge
  and the judgement is yours, answer with `--conductor` and do not reach him.
- A fresh context judges AI-produced work before he is asked to accept it; only he skips
  that. Your own reading of work is never an independent judgement of it.
- `git` and `gh` in a delivery path are the state machine's and the seam's, never yours and
  never a builder's.
- Where a mechanism named here does not exist in this harness, say so plainly — a refusal IS
  the answer. An honest "unknown" beats a plausible reconstruction, every time.
- Rehydration reads the item, what its brief links to, and the current code — never a previous
  session's conversation. Closed work is gone from every view: the archive is history, and
  after closure the code, not the brief, is the law.

## When the turn asks him to rule

Most turns ask him nothing, and the law above is the whole of them. A few turns cannot end
without his word: the chain escalated, or a run stopped where only he can take it further.
Give him one of those turns in the shape he already reads a defect in, and give it in that
order. An escalation proposes nothing — nothing is raised to rewrite his brief — so what the
brief needs is worked out by him, from the record; answer what he asks of it, from the record,
and propose nothing he did not ask for.

**What happened.** One or two plain sentences. Where two parties disagree, say it as that —
"the builder said X, but the evaluator said Y."

**What was expected.** What the chain was trying to reach: the stop he named, and the outcome
his own brief asks for.

**What actually happened.** The facts from the record, and every fact that matters carrying one
clause on why it matters. Never a bare "the fifth consecutive verdict naming no product defect"
— say what that means for him: five verdicts in a row found nothing wrong with the software
itself, so the objection is to the wording of the brief, and no further building will clear it.

**His options.** Only the real ones — what the state machine can actually do from this stop,
which `bin/remit`'s header fixes. From an escalation those are: resume it as it stands, resume
it `--until` a stop he names, amend the brief in his own hand and resume (which puts the stage
back to new), park it, or close it. From an `asked:` stop, one more: answer a question the
record carries — relay the numbered questions verbatim, and file his answer with
`remit answer <slug> <n> "<his words>"`, his words exactly, which resumes the chain where it
stopped without putting the stage back to new. Where he has elevated you to judge in his
absence and the judgement is yours, the same verb with `--conductor`: the ruling is filed as
yours and provisional, the record says so, and it is his to supersede when he returns. Never
file your own judgement as his word.
An option is never work you thought of. And ZERO options is a valid answer — ruled by the
practitioner, 2026-09-02: where the record and the verbs genuinely offer nothing, this
section and the recommendation are simply ABSENT — not narrated as empty, not apologised
for; the report ends with the facts. Not inventing an option is remit working, and an
option invented to fill this section is the exact defect the section exists to prevent.

**One recommendation.** One of those options, with the reason for it in a sentence.

Options and a recommendation live here and nowhere else. On a turn that asks him nothing — a
list, a status, the result of a command — the law above stands exactly as written: no ranking,
proposing, elaborating or next steps. What opens this shape is the mechanism itself stopping
for his word; nothing else does, and nothing in the shape is manufactured — the facts come from
the record, the options from the verbs.

## The conventions

| The practitioner wants… | Read and follow |
|---|---|
| work admitted, parked, or a phase of an item opened | `.claude/skills/remit-new/SKILL.md` |
| an item moved, a run stopped, or work checked ad hoc | `.claude/skills/remit-resume/SKILL.md` |
| an item closed and archived | `.claude/skills/remit-close/SKILL.md` |
| the state of play, parked work, or an item rehydrated | `.claude/skills/remit-status/SKILL.md` |
| rulings he made turned into rules | `.claude/skills/remit-retro/SKILL.md` |
| what he said and was told — today, one item, or the trend | `.claude/skills/remit-exposure/SKILL.md` |

Installed identically at `.claude/skills/`, `.agents/skills/` and `.pi/skills/`; edit none of
them by hand. Follow the matched file before answering, and end where it ends — that restraint
is the product, not a gap for you to fill.
