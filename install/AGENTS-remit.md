# The remit work surface in this repository, whatever harness you are

This repository carries **remit**: a thin, durable work surface for practitioner-directed AI
work. A work item is a folder `.remit/work-items/<slug>/` holding two files a script owns —
`brief.md`, the practitioner's words with a three-line header, and `log.md`, the append-only
record of every verdict, finding, delivery, escalation and ruling. The identity, boundary,
decisions, state and history of the work live in those files — never in any harness's
conversation history. You are the means of execution, not the memory. Remit's installer put this
section here; its record of what it installed, and at what version, is `.remit/.install/manifest`.

## Two mechanics, every harness

Every state change goes through one POSIX script, `bin/remit`. It does not fork per harness and
you do not reimplement it:

```sh
sh "$(git rev-parse --show-toplevel)/bin/remit" new <slug> [--until <stop>] [--park]
sh "$(git rev-parse --show-toplevel)/bin/remit" resume <slug> [--until <stop> [--park]]
sh "$(git rev-parse --show-toplevel)/bin/remit" park <slug>
sh "$(git rev-parse --show-toplevel)/bin/remit" close <slug>      # delivery links on stdin, or empty
sh "$(git rev-parse --show-toplevel)/bin/remit" list [--parked]
sh "$(git rev-parse --show-toplevel)/bin/remit" report new|close <name>
sh "$(git rev-parse --show-toplevel)/bin/remit" rules init
sh "$(git rev-parse --show-toplevel)/bin/remit" setup [--write]  # proposes .remit/settings.json on stdout; --write saves it
sh "$(git rev-parse --show-toplevel)/bin/remit" migrate
```

`resume` is the whole chain: it researches where the brief asks for it, evaluates, builds,
delivers, evaluates again, checks, flips the pull request ready, merges and closes — as far as the
practitioner's word and this repository's rubrics reach — then prints where it stopped and why.
`new` runs that same chain itself, in the one command, when he said how far the item may go.
**Nothing in remit writes or rewrites a brief.** The brief is his words; a gate that returns a
must-fix on one leaves the item at `new` for him; a repair proposed at an escalation is text in
`log.md` for him to rule on, never an edit. Every step of the chain that needs a model is a fresh
context the script raises through the other mechanic, `bin/remit-invoke`: one primitive, one role,
one briefing, one worktree, its text back on stdout. That is the only place in remit a model is
started, and no step of an item's work ever happens in the conversation you are in.

Run both through a POSIX shell — on Windows that is Git Bash's `sh`, not PowerShell. `bin/remit`
runs only from the repository's primary worktree and refuses anywhere else. Never edit the
`**Attention:**`, `**Stage:**` or `**Until:**` lines of a brief by hand, never write in
`.remit/rules/` outside a retro, and never move or delete an item's folder yourself: `bin/remit`
commits each change and pushes when a remote is configured, and its printed result is the truth
of what happened. **Report that result verbatim in substance.** Exit 3 means committed locally
but NOT accepted by the remote — say so; never call work pushed, backed up or safe elsewhere
unless the script said the remote accepted it. Exit 4 means the chain escalated: the stage is
unchanged and the item's `log.md` carries the reason and a proposed repair for the practitioner
to rule on.

## How far work goes without him

One word, given at `new` or at any `resume`, and the whole of it is this:

| He said | With no rubrics | A `promote` rubric | A `hold` rubric |
|---|---|---|---|
| nothing | sits at `new` until resumed | may carry it on, even to closed | may stop it earlier |
| `--until X` | runs to X and waits for him | may carry it past X | may stop it earlier |
| `--until X --park` | runs to X and parks there | cannot carry it past X | may stop it earlier |
| `--park` alone | a backlog idea; nothing moves | cannot move it | — |

"File it" means `--park`. "Nothing" means he has not said; `--park` means he has said no, and it
is the only thing that stops a rubric moving work.

## The rubrics folder

`.remit/rules/` holds his rubrics — `refined.md`, `accepted.md`, `closed.md`, one per gate.
`bin/remit`'s header is the law of that folder: what each section does, the shape of a line, which
of them a gate's evaluator is handed and which the roles that author are, and what an empty folder
means. Read it there. **Only the practitioner writes that folder, and only through a retro he
calls** — no session proposes a rubric anywhere else, at any moment, for any reason.

## Every sub-agent comes from the registry, and you never raise one yourself

`.remit/settings.json` is the registry: which harnesses and which model ids this repository may
raise a context on, and the seat each role takes. It is his file. `bin/remit-invoke` resolves every
seat through it and refuses — loudly, before anything is billed — anything it does not carry and
anything it carries that this host does not have. Nothing falls back and nothing is substituted;
`bin/remit-invoke`'s header is the law of that file; `sh bin/remit setup` proposes one from
what a host actually has, and `setup --write` saves that proposal. Never redirect `setup` over
the registry: that file is the one it reads.

**So the only way to a sub-agent here is `bin/remit-invoke`. Never your own agent, task or
sub-agent tool** — not to explore, not to review, not to get a second opinion, and not because the
seam refused. A context this harness raised by itself sits on a seat nobody registered, and its
model, its containment and its cost are outside every record remit keeps.

That rule holds identically for all five harnesses. What differs is only what enforces it:

| Harness | Enforced by |
|---|---|
| Claude Code | a hook — `PreToolUse` on its agent tool, in `.claude/settings.json` |
| Copilot CLI | a hook — `preToolUse`, in `.github/hooks/` |
| Codex, Pi, Devin | this instruction, and nothing mechanical |

Both hooks run the one script, `.remit/hooks/no-agent-tool.sh`, and refuse with one line. Disclosed
as such: for the three without a pre-tool hook there is no mechanism at all, only this paragraph;
and for Copilot CLI, whether that CLI exposes a sub-agent tool, and what it would be called, is not
something remit has probed — its hook guards the names Claude Code uses, which is a guard and not
an attestation. The rule binds all five whatever enforces it.

## The conventions are files here, not features of a harness

Five conventions govern how any session behaves around this work surface. Each is an ordinary
markdown file in the Agent Skills form (`SKILL.md`), installed identically at `.claude/skills/`,
`.agents/skills/` and `.pi/skills/` so each harness discovers them natively — same content,
installer-synced; edit none of them by hand. Each is three clauses and no more: on these words of
his, run this command; report what it printed, verbatim in substance; stop where it said. The
trigger phrasing lives in each file's `description:` line.

| The practitioner wants… | Read and follow |
|---|---|
| work admitted, parked, or a further part of an item opened | `.claude/skills/remit-new/SKILL.md` |
| an item moved as far as he said, or work checked ad hoc | `.claude/skills/remit-resume/SKILL.md` |
| an item closed and archived | `.claude/skills/remit-close/SKILL.md` |
| the state of play, parked work, or an item rehydrated | `.claude/skills/remit-status/SKILL.md` |
| rulings he has made turned into rubrics | `.claude/skills/remit-retro/SKILL.md` |

Evaluation is not one of them, because it is not word-triggered and is not yours to run: a fresh
context judges AI-produced work before he is asked to accept it, by default, and `bin/remit`
raises it at every gate. Only he skips that, by direct request.

The YAML frontmatter is harness plumbing; the body is the convention. Follow the matched file
before answering: run the commands it gives rather than exploring the repository by hand, report
what they print, and end where the convention ends — none of them ranks, proposes, elaborates or
offers next steps, and that restraint is the product, not a gap for you to fill.

## Translate mechanisms honestly — report, never pretend

Where a mechanism named here does not exist in this harness, say so plainly rather than imitating
the behaviour:

- **Isolation is not your sub-agent feature.** Which tool may raise a context, and where its seat
  comes from, is the registry section above. What belongs here is the honesty half: when the seam
  refuses, that refusal IS the answer. Never run the work inside this conversation and call it
  isolated, and never offer your own reading of work as an independent judgement of it.
- **`gh` in a delivery path is the seam's, never a builder's or yours.** `bin/remit` opens every
  delivery's pull request as a draft, adds a later delivery on top of the body already there,
  flips it ready on a passing verdict, and merges only with the required checks green. Do not
  perform any of those by hand and do not brief a context to. If `gh` is unavailable here, the
  script says so and stops; never open a ready pull request and call it a draft, and never report
  a flip or a merge that did not happen.
- **Commit trailers.** Every commit on a `work/*` branch ends with a `Co-Authored-By:` trailer
  naming the model that actually authored the tree — the sub-agent that did the work, never the
  session coordinating it — and a `Claude-Session:` trailer naming the session that performed the
  commit. Both are written by the seam from what the raise reported, and an absent one is
  recorded as absent rather than invented.

## What never changes with the harness

- Changing harness changes the means of execution — never the identity, boundary, accepted
  decisions or state of the work.
- Rehydration reads the item, the authoritative content its brief links to and the current code.
  It never replays a previous session's conversation, from any harness, and where the written
  material does not establish something, an honest "unknown" is the correct answer.
- Only the practitioner admits work, opens a part within an item, parks or resumes it, writes a
  rubric, skips an evaluation and decides closure. A discovery you made is not work, and nothing
  you notice becomes an item or a part of one unasked.
- An item, a part, a fresh context and an isolated tree are structures the work may want — never
  gates on starting. Authorised work may run and finish in the live collaboration with none of
  them; what does not change is that a fresh context judges AI-produced work before he is asked
  to accept it.
- Closed work is gone from every view; it is read again only when he deliberately opens
  `.remit/work-items/.archive/`.
