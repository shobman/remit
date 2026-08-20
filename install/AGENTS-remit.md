# The remit work surface in this repository, whatever harness you are

This repository carries **remit**: a thin, durable work surface for practitioner-directed AI
work. A work item is a folder `.remit/<slug>/` holding at minimum `brief.md`. The identity,
boundary, decisions, state, and history of the work live in these files — never in any harness's
conversation history. You are the means of execution, not the memory. Remit's installer put this
section here; its record of what it installed, and at what version, is
`.remit/.install/manifest`.

## One set of mechanics, every harness

Every state change goes through one POSIX script, `bin/remit`. It does not fork per harness and
you do not reimplement it:

```sh
sh "$(git rev-parse --show-toplevel)/bin/remit" list            # active items
sh "$(git rev-parse --show-toplevel)/bin/remit" list --parked   # parked, only when asked
sh "$(git rev-parse --show-toplevel)/bin/remit" new <slug>      # brief on stdin; born parked
sh "$(git rev-parse --show-toplevel)/bin/remit" park <slug>
sh "$(git rev-parse --show-toplevel)/bin/remit" activate <slug>
sh "$(git rev-parse --show-toplevel)/bin/remit" close <slug>    # delivery links on stdin, or empty
```

Dispatch has the other mechanical script, `bin/remit-dispatch`. Workers author the working tree and
never run git; that script is what turns an authored tree into a draft pull request — it records the
dispatch, invokes the worker, waits for it, captures what it returned, then stages, commits, pushes
`work/<slug>`, and opens the pull request as a draft. Point at it; never perform its steps by hand
and never brief a worker to. The Dispatch convention below carries when and how, and unlike `remit`
it runs in the worker's own linked worktree, which is where the work is.

Run both through a POSIX shell — on Windows that is Git Bash's `sh`, not PowerShell. `remit` runs
only from the repository's primary worktree, and refuses anywhere else. Never edit a brief's
`**State:**` line by hand, and never move or delete an item's folder yourself: `remit` commits
each change and pushes when a remote is configured, and its printed result is the truth of what
happened. **Report that result verbatim in substance.** Exit 3 means committed locally but NOT
accepted by the remote — say so; never call work pushed, backed up, or safe elsewhere unless
`remit` said the remote accepted it.

## The conventions are files here, not features of a harness

Five conventions govern how any session behaves around this work surface. Each is an ordinary
markdown file in the Agent Skills form (`SKILL.md`), installed identically at `.claude/skills/`,
`.agents/skills/`, and `.pi/skills/` so each harness discovers them natively — same content,
installer-synced; edit none of them by hand. The body of each binds **you** in this repository
regardless of harness. When the practitioner's words match, read the file and follow it — the
trigger phrasing lives in each file's `description:` line:

| The practitioner wants… | Read and follow |
|---|---|
| the state of play, parked work, or an item rehydrated | `.claude/skills/resume-work/SKILL.md` |
| new work captured as a brief, a phase opened, or an item parked/activated | `.claude/skills/capture-work/SKILL.md` |
| an item closed and archived | `.claude/skills/close-work/SKILL.md` |
| a bounded worker put on admitted or live-bounded work | `.claude/skills/dispatch-work/SKILL.md` |
| work judged independently by a fresh context | `.claude/skills/evaluate-work/SKILL.md` |

One convention is not word-triggered: independent evaluation happens **by default** for work AI
produces for the practitioner's acceptance — skipped only when they ask to skip it or a policy
they delegated says otherwise, never on your own judgment of what the work warrants.

The YAML frontmatter is harness plumbing; the body is the convention. Follow the matched file
before answering: run the commands it gives rather than exploring the repository by hand, report
what they print, and end where the convention ends — it will tell you not to rank, propose,
elaborate, or offer next steps unasked, and that restraint is the product, not a gap for you
to fill.

## Translate mechanisms honestly — report, never pretend

The skills name Claude Code mechanisms. In another harness, translate them to what actually
exists, and where nothing does, say so plainly rather than imitating the behaviour:

- **Isolated workers and evaluators** ("the Agent tool with `isolation: worktree`"): use this
  harness's own isolated sub-agent and git-worktree equivalent. If this harness cannot raise an
  isolated fresh context, that capability is absent here — tell the practitioner and hand back
  the smallest decision. Never run the work inside this conversation and call it isolated, and
  never offer your own reading as an independent evaluation.
- **Session trailers** (`Co-Authored-By:`, `Claude-Session:`): every commit on a `work/*`
  branch ends with a `Co-Authored-By:` trailer naming the actual model that authored the work,
  and a `Claude-Session:` trailer naming the session that performed the commit — never
  invented, never omitted. On a worker's delivery those are two different sessions, and
  `bin/remit-dispatch` writes both from what the dispatch told it.
- **`gh` in a delivery path is the coordinator's, never a worker's.** `bin/remit-dispatch` opens
  every worker's pull request as a **draft** with `gh pr create --draft`, and only the coordinator
  takes it out of draft, with `gh pr ready`, on a passing verdict — a FAIL leaves it a draft through
  the correction loop. Both commands are the same in every harness; the two skills above carry the
  rest. If `gh` is unavailable here, or cannot open a draft or flip one ready, say so: never open a
  ready pull request and call it a draft, and never report a flip that did not happen.

## What never changes with the harness

- Changing harness changes the means of execution — never the identity, boundary, accepted
  decisions, or state of the work.
- Rehydration reads the work item, the authoritative content its brief links to, and the current
  code. It never replays a previous session's conversation, from any harness, and where the
  written material does not establish something, an honest "unknown" is the correct answer.
- Only the practitioner admits work, opens a phase within an item, activates or parks it, accepts
  a result, and decides closure. A discovery you made is not work, and nothing you notice becomes
  an item or a phase unasked.
- An item, a phase, a dispatched worker, and an isolated tree are structures the practitioner and
  the work may want — never gates on starting. Authorised work may run and finish in the live
  collaboration with none of them, and you may carry it out yourself; what does not change is that
  a fresh context judges AI-produced work before they are asked to accept it.
- Closed work is gone from every view; it is read again only when the practitioner deliberately
  opens `.remit/.archive/`.
