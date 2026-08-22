---
name: dispatch-work
description: Send a bounded, isolated worker to carry out authorised work in this repository — briefed from an active item's brief, from that item's current phase, or from the outcome and boundary established live when there is no item — returning a pull request. Use whenever the practitioner directs that work be carried out by someone other than you, in whatever words — "send a worker on it", "put someone on this", "get it built", "dispatch it", "have an agent do X", "go build <item>" — and whenever isolation, a particular model, elapsed time, or keeping this context clean makes a worker the right means. Carrying the work out yourself is equally valid and needs no dispatch.
---

# Dispatch

The practitioner has asked for work to be carried out by someone other than you. You brief one
bounded worker from the authority the work already has; it authors a working tree and returns its
result. A deterministic wrapper turns that tree into the draft pull request this convention returns
— the worker opens none. Its exploration never reaches this conversation.

A worker is a means, not a gate. You may carry out authorised work yourself: research it, design it,
write the code. Reach for a worker when isolation, a particular model or harness, elapsed time, or
keeping this context clean is worth the briefing. Either way the result goes to `evaluate-work`
before the practitioner is asked to accept it — working directly changes no evaluation rule.

## The bounded task is the authority the work already has

A dispatch carries an outcome, a boundary, constraints and proof. Where those live depends on what
the work is, and you take them from exactly one place, mechanically:

- **Live work with no item** — the outcome and boundary the practitioner established in this
  collaboration. Write them into the briefing, since there is no file for the worker to read. Do not
  create an item so the dispatch has one: an item exists because they admitted it (`capture-work`).
- **An item running no phases** — its brief has no Phases section, so `.remit/<slug>/brief.md` and
  the authoritative content it links to are the whole of it. That brief is the worker's task and
  its limit.
- **An item with a current phase** — the brief's Phases section names the phase in hand, and that
  phase's file is the task, with the item's brief as its enclosing authority. The phase narrows the
  item; it never amends it, and nothing outside the item's boundary becomes dispatchable because a
  phase says so.

Never infer a phase from filenames, choose between several phase files, or treat the newest artifact
as the authority. An item that has a Phases section but no phase in hand — no current-phase line, or
one naming a file that is not there, or one you cannot resolve to exactly one file — stops the
dispatch: hand the practitioner the smallest ruling, which phase is in hand, and wait. `capture-work`
is where their answer gets written down.

Nothing you infer, notice, or would like is part of the task. If the authority does not bound the
work well enough to send someone, ask them — never fill the gap yourself and never widen it to make
it dispatchable. Dispatch changes no state; if they are picking up parked work, activating it is
their call and `capture-work`'s job.

## An item runs in phases, and the phases are discovered

An item is not always one delivery. Phases emerge as the work goes: a research round, then a design,
then a build; two builds where the practitioner wants an A and a B; a second research round because
the first did not settle it. How many there are is not known when the item starts and is never
prescribed — one phase or ten, discovered as it goes, because not being prescriptive is how this
work surface behaves everywhere else.

The practitioner opens each phase, and it is written with the item — the brief's Phases section and
the phase's own file. That is `capture-work`'s job, and the pointer it maintains is what you
dispatch from. You may tell them a further phase looks needed; you never open one, and you never
write one so that a dispatch has something to read.

Each phase defaults to independent evaluation before the next builds on it. That is `evaluate-work`
unchanged, applied per phase rather than once at the end, and the same default: skipped only on the
practitioner's word, never on your judgment of what a phase warrants.

A next phase is not new work. `capture-work` is for an outcome the practitioner has newly admitted;
a further phase of an item already admitted stays with that item and never becomes a second item.
The item's own proof discharges when the practitioner rules the item complete — a phase landing,
however cleanly, is not that ruling.

## Settle the target before you write the briefing

A dispatch names its target deliberately: the harness, and the model. Never substituted, never
silently defaulted.

For the model, in this order, stopping at the first that applies:

1. what the practitioner said at this dispatch;
2. a standing constraint they have set;
3. otherwise the worker inherits your own coordinating model.

Absent their word, never dispatch a lesser model than the one coordinating. Say in the briefing and
in the dispatch which rule applied, so the PR can record it.

For the harness, the same rules decide: their word at this dispatch, then a standing constraint,
then this harness's own worker. A worker in another harness — `claude -p`, `codex exec`, `pi`,
`devin -p` — is briefed identically and bounded identically to a native one; changing harness
changes the means of execution and nothing else.

If they ask for a worker that cannot be provided here — a model or provider this machine cannot
reach, a CLI that is not installed — say so plainly and hand back the smallest decision: what does
exist, or waiting. Never substitute one silently. The wrapper below refuses rather than substitutes
for the checks it can make mechanically, but an absent capability you already know about is yours to
report before you dispatch at all.

## Brief the worker, and state its limits in the briefing

The briefing is written where the dispatch happens; the worker gets nothing else. Carry:

- **Its limits, in full.** It carries out exactly this bounded task and nothing else. It cannot
  widen the task, create work items, open a phase, run `bin/remit`, delegate to another worker,
  accept its own result, merge, or close the item. **It authors the working tree only: it runs no
  git — no branch, no commit, no push, no `gh` — and opens no pull request.** It returns a result;
  the practitioner accepts or rejects.
- **Repo context** — enough to orient: what this product is, what already ships, what to read
  first for voice and shape. Not your exploration of it.
- **The bounded task** — outcome, boundary (including what is explicitly out), constraints, proof —
  and where to read it in full. Where the dispatch is one phase of an item, that is the phase's own
  statement, and the item's brief goes with it as the boundary the phase sits inside. Where there is
  no item, it is the live outcome and boundary, written out in the briefing.
- **The discovery rule** — the trace-or-drop test: something with a material, traceable
  consequence for the outcome, a constraint, or the proof is resolved in scope or returned as the
  smallest decision; anything merely adjacent, useful, or improvable is dropped unrecorded and
  unbuilt.
- **How it delivers** — below.
- **The return contract** — below.
- **Model provenance** — which precedence rule chose it.

Give it isolation: its own worktree or whatever this harness's equivalent is. In Claude Code that
is the Agent tool with `isolation: "worktree"`, and the model set on the same call. A worker in
another harness gets a worktree or clone you make for it, and the wrapper is pointed at that
directory. If this harness has no isolation mechanism, say so rather than pretending the worker is
contained.

One worker per bounded task. Several may run at once when their tasks neither touch the same files
nor need one shared chain of reasoning — two different items, or two variants of the same task where
the practitioner wants an A and a B: the same briefing on two models, or two briefings that differ
by the twist they asked for. Variants are separate dispatches with separate branches and separate
evaluations, never one worker asked for two answers; when in doubt, run them one after the other.
Parallelism buys elapsed time and nothing else — it is never a reason to widen or to skip a
briefing. Fanning work out is yours alone — the worker cannot.

## The worker authors a tree; it never runs git

Every worker, in every harness, delivers by leaving its work in the working tree of the directory it
was given, and stops there. It does not branch, stage, commit, push, or open a pull request, and it
does not touch `.remit/` or another item's work.

Where the harness can hold that by mechanism rather than by instruction, let it, and say in the
dispatch which you relied on: a Codex worker's sandbox denies `.git` outright while leaving the tree
writable; a Claude worker's tool grant simply omits git; pi's tool scoping is whole-tool, so
excluding git means excluding its shell wholesale — a pi dispatch either needs no shell and
excludes bash, or keeps bash and carries the rule in the briefing as restraint by instruction,
disclosed as such; a Devin worker gets a deny rule and a pre-tool hook that the wrapper writes into
its tree for the run, because a deny rule alone does not see git reached through a shell it allows.

## The mechanics are the wrapper's — never yours, never the worker's

One deterministic step turns the authored tree into a draft pull request. Point at it; never perform
its steps by hand and never brief a worker to:

```sh
sh "$(git rev-parse --show-toplevel)/bin/remit-dispatch" \
   --harness <claude|codex|pi|devin|native> --slug <slug> --brief <briefing-file> \
   --dir <the worker's worktree> --model <id> --rule <the precedence rule that applied> \
   --session <this session's identifier>
```

It records the dispatch, invokes the worker CLI with the briefing on the channel that CLI accepts,
waits for the process to exit, captures the worker's final message, then stages the tree, commits it
with the session trailers AGENTS.md defines, pushes `work/<slug>`, and opens the pull request to
`main` as a draft — or, where that branch already has one, adds this delivery to it. The PR title is
the experience delivered, not the change made — it comes from `--title`, or from the item brief's
own heading. Each delivery's section of the body is the worker's final message plus the provenance
the wrapper records: harness, model, precedence rule, the worker's run id where its CLI prints one,
and that the tree is the worker's authorship while the git mechanics are the wrapper's.

`--slug` names *this dispatch*, not the item: it is the branch, `work/<slug>`, and it is where the
wrapper looks for `.remit/<slug>/brief.md` when you give it no `--title`. The default is **one pull
request per work item**: every dispatch for an item — its only one, or each phase of a phased item —
takes the item's slug, lands on `work/<item>`, and appears in the item's one pull request, which
accumulates the phase story and merges at closure. Each phase's delivery still gets its own
evaluation and its own verdict there; a flip to ready says the current delivery is verified, never
that the item is done. A label of its own (`<item>-a`, `<item>-b`, or a name for work with no item)
belongs only to dispatches that genuinely cannot share the item's branch: parallel A/B builds of one
item, work with no item at all, and a phase the practitioner admits after the item's pull request
has already merged — reopened work continues in a new pull request. Those take `--title`, because
the wrapper will not find an item at that label and refuses to invent a title.

A dispatch that lands on a branch already delivered to — a later phase, or a must-fix going back to
a builder — takes the same `--slug` and a tree already standing on that branch: the wrapper creates
the branch it is given and cannot create one that exists, so such a dispatch sent from a fresh
`main` tree stops at the branch step. Sent from a tree that is on the branch, it delivers as any
other dispatch does, and finds the pull request that branch already has: this delivery's section
goes on top of that pull request's body and the record already there is kept beneath it, unedited.
So the one pull request reads newest-first, the practitioner is never handed a body describing a
delivery the branch has moved past, and nothing about it is yours to compose. A must-fix is not
another delivery — it is the same one, corrected — and its pull request stays a draft until a fresh
verdict ends the loop (`evaluate-work`).

When the wrapper says **BODY NOT UPDATED** it means exactly that, and it is not a lost delivery: the
commit is pushed and on the branch, and that pull request's body still describes an earlier
delivery. The report names the stale pull request, the composed body, and the single `gh pr edit`
command that applies it. Run that command; then say plainly what happened. Never hand-write, edit or
summarise a pull request body yourself — the whole reason the wrapper composes it is that nobody
does.

Where the worker is a native sub-agent of this harness rather than a CLI, you invoke it yourself and
then point the wrapper at the tree it left, with `--harness native --final-message <file>`. The
mechanics are the same mechanics.

Its printed result is the truth of what happened, and you report it verbatim in substance. Exit 0
means those mechanics succeeded — never that the work is good. Exit 4 means the worker changed
nothing, so there is nothing to deliver and no pull request: say that, and do not dress it up. A
mechanics failure says exactly how far it got and leaves the authored tree where it is. A worker
process exiting, with any code, is completion and not success.

If this harness cannot run the wrapper, say so plainly and hand back the smallest decision, rather
than performing its steps by hand. What to do when `gh` itself is absent or cannot open a draft here
is AGENTS.md's rule, and it binds.

## The return contract

Back from the worker you want the smallest thing that lets you speak to the practitioner: a
paragraph on what now exists and how they experience it, how the proof was discharged, the evidence
for it, and any decision that genuinely requires them. It returns no pull request URL, because it
opened none — the wrapper's printed result is where the PR URL and branch come from, and that is the
pull request this dispatch hands back. No exploration, no code-reading, no logs, no test output. If a
worker returns all that anyway, take what belongs and leave the rest — it does not become durable
here, and it does not enter your summary.

Report to the practitioner in their terms: what exists, where the PR is, that no fresh context has
judged it yet, and the decision if there is one. That report is status, not the work put in front of
them — which is which, and what holds the ordering on each route a delivery can arrive by, is
`evaluate-work`'s to say.

## Check the result against what you briefed — and stop there

Read the PR against the authority you dispatched from: does it deliver that outcome, did it stay
inside that boundary, does it honour the constraints, does the proof hold. Where the dispatch was
one phase, that is the phase's outcome and the phase's proof, read inside the item's — a phase
discharging its own proof cleanly says nothing about the item's, which is the practitioner's ruling
and no one else's. Anything in it that traces to none of those is not integrated and not preserved.
You read the pull request, never the worker's diff as it worked: the wrapper staged and committed
it, so the seam that keeps a worker's exploration out of this conversation is held by mechanism and
not by your discipline.

That check is not an evaluation. Judging authored work belongs to a fresh context that did not
write it and did not watch it being written — you watched. That seam is deliberate, and nothing
here crosses it. The PR stays a draft through this check; taking it out of draft belongs to
`evaluate-work`, on a recorded verdict. Merging, acceptance, and closure are the practitioner's;
closing is `close-work`.
