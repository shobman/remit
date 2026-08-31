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
   new|resume|park|stop|close|list|report|rules|setup|migrate ...
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
  elaborating or next steps. Exit 3 means committed locally and NOT accepted by the remote —
  never call that pushed, backed up or safe. Exit 4 means the chain escalated; the item's
  `log.md` carries the reason.
- Nothing writes or rewrites a brief but him. Script-owned lines in a brief, and everything in
  `.remit/rules/`, are never edited by hand.
- A context is raised only through `bin/remit-invoke` — never your own agent, task or
  sub-agent tool, whatever this harness offers; a hook enforces this where the harness has
  one. Run a raise as a backgrounded task of your own harness with a generous explicit
  timeout — blocking the conversation on one is the failure.
- A fresh context judges AI-produced work before he is asked to accept it; only he skips
  that. Your own reading of work is never an independent judgement of it.
- `git` and `gh` in a delivery path are the state machine's and the seam's, never yours and
  never a builder's.
- Where a mechanism named here does not exist in this harness, say so plainly — a refusal IS
  the answer. An honest "unknown" beats a plausible reconstruction, every time.
- Rehydration reads the item, what its brief links to, and the current code — never a previous
  session's conversation. Closed work is gone from every view: the archive is history, and
  after closure the code, not the brief, is the law.

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
