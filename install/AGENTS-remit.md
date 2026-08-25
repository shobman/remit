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
sh "$(git rev-parse --show-toplevel)/bin/remit" kill <slug>       # end the chain running on this item
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

`report new` is the intake for an observation from outside this repository. What a contributor
sends, and what a maintainer does with it, is stated once — in `CONTRIBUTING.md` at the repository
root, which the installer lays down and keeps current. Point a contributor there, and point there
yourself: do not restate it here or anywhere else, and leave the file to the installer.

Run both through a POSIX shell — on Windows that is Git Bash's `sh`, not PowerShell. `bin/remit`
runs only from the repository's primary worktree and refuses anywhere else. Never edit the
`**Attention:**`, `**Stage:**` or `**Until:**` lines of a brief by hand, nor its `## Phases`
section — every one of those is the script's — never write in
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

## A raised context is visible while it runs

Raising a fresh context — `bin/remit-invoke` directly, or `bin/remit resume`, which raises one at
every gate — takes minutes, and sometimes tens of them. **Run it as a BACKGROUNDED task of your own
harness: non-blocking, so the practitioner keeps the conversation while it runs, and registered with
the harness, so the task's lifespan is the harness's own to show and its end the harness's own to
notify.** A raise run in the foreground is the failure this rule exists to stop, and it is a failure
that looks like success — it shows a clock and takes the conversation away with it. Messages sent to
a session blocked on a foreground raise go unread until the raise ends.

What each harness gives you, established by driving these CLIs on 2026-08-23 and naming the version,
because a future version may differ. Which road is taken on each is not chosen per raise: the agent
road is closed everywhere by the rule above, whatever a harness offers, so what follows is what each
harness gives a raise that runs as an ordinary task of its own.

- **Claude Code** (2.1.241) — the road is a **backgrounded shell task**: its own shell tool with
  `run_in_background`, and the command it runs is the `bin/remit-invoke` or `bin/remit` call itself.
  Nothing wraps it — no agent, no task tool, no sub-agent of your own; that is the road the rule
  above forbids, and here a `PreToolUse` hook refuses it. The harness registers the backgrounded call
  in its own background-task list, so the raise has a tracked lifespan in the place the practitioner
  already looks for running work, writes its output to a file it names, and notifies when it ends —
  while the next turn is already free. It costs no second context: nothing is spent on being
  watchable. Two conditions bind it:
  - The call carries an **explicit timeout** generous enough for the role. With none asked for, the
    shell tool's bound is 120 000 ms, and a call that reaches its bound is killed with SIGTERM. The
    timeout you may ask for is itself capped at `max(BASH_MAX_TIMEOUT_MS, BASH_DEFAULT_TIMEOUT_MS)`,
    and so at 600 000 ms when neither is set — which is what the `env.BASH_MAX_TIMEOUT_MS` remit's
    installer offers in `.claude/settings.json` is for, alongside the agent-tool guard's registration
    named above. Both bounds were established against a call the session waits on and were not
    re-driven against a backgrounded one, so ask for the timeout rather than find out.
  - `CLAUDE_AUTO_BACKGROUND_TASKS` and `CLAUDE_CODE_AUTO_BACKGROUND_TIMEOUT_MS` stay unset. Read out
    of the shipped build, the first auto-backgrounds a sub-agent's own work at two minutes, which is
    nothing to a call that is backgrounded already, and the second shortens any requested timeout to
    itself for a main-agent call that can background — which is exactly this call. What either does
    to a raise on this road was not driven, and unset is the state everything here was established
    under.

  Two things this road does not give, said rather than promised. There is no step sentence: the
  progress channel that carries a derived "what it is doing now" belongs to the harness's own
  sub-agent tasks, and a shell task has none. And the one ticking elapsed in 2.1.241's shipped
  renderer belongs to the active turn's activity row, which closes the moment a backgrounded call
  returns its id — so what a person has in front of them on that version is the background task and
  its notification, which is the lifespan, and not a second-by-second count inside the turn. The two
  channels below are what a watcher tails for more than that.
- **Pi** (0.84.2) — **there is no background road here.** Pi's shell tool takes a command and a
  timeout and nothing else, and pi has no sub-agent at all, so there is nothing here that could hold
  a raise while the session goes on, and a raise blocks the session for its whole length. What pi
  gives instead, for free and with nothing built, is the other half: a live `Elapsed` on the call,
  the command's output streamed as it arrives, and no default timeout to be killed by. Say that this
  is a limit of the harness. Do not present a blocking raise as the answer.
- **Codex** (codex-cli 0.148.0) brackets a raise as one command-execution item, open from the moment
  it starts until it exits, and blocks the thread on it; its own "run in background" offer means exit
  codex and leave the task running, which is not a watched task. It has native sub-agents, and they
  are not a road here — the agent road is closed on every harness. So a raise on codex today is
  visible and blocking, as on pi, and that is said rather than dressed up. What would change it is a
  non-blocking shell road: drive `codex exec --json` through a turn whose work is a long shell
  command, and read whether the thread takes another turn while that command is still open.
- **GitHub Copilot CLI** — **unestablished.** Nothing here describes how it surfaces a long shell
  call, backgrounded or not, because the CLI was not available to drive. What would establish it:
  install it, run a long shell command in prompt mode under `--output-format json`, and read whether
  the event stream brackets that command's whole life and whether anything can be left running while
  the session takes another turn. Until someone does, say it is unknown rather than assuming it
  behaves like the three above.
- **Devin** — **unestablished**, for the same reason and on the same terms. Its ATIF export
  (`--export`) carries per-step data and is the likely channel to read, and that is a lead, not a
  finding.

Two channels make a raise say something while it runs, rather than only at its end. Both are
`bin/remit-invoke`'s, both are optional, and its own header states exactly what each does: set
`REMIT_PROGRESS=<path>` to be told where the run directory is the moment it exists (the path is
otherwise unguessable), and `REMIT_HEARTBEAT=<seconds>` to change or silence the pulse it prints
while the CLI runs. Neither changes what the seam returns, and neither puts the raised context's own
exploration in front of you — that boundary is unchanged. Where a harness leaves you blind, those two
are what a watcher tails; they are not a substitute for the harness registering the task.

Nothing here writes into a harness's private task store, and nothing should. A raise is visible
because it is an ordinary task of the harness that raised it, or it is not visible — those are the
only two honest states, and the second one gets said out loud.

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
