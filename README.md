# remit

Keep practitioner-directed AI work in Git. Decide what starts, what stops, who builds it,
who judges it, and when it leaves your attention.

AI can produce work faster than you can judge it. DORA reports that AI adoption is associated
with higher throughput and lower delivery stability when code generation outruns review and
deployment capacity ([DORA](https://dora.dev/insights/balancing-ai-tensions/)). That is an
industry-wide measurement of the volume problem; remit sits downstream of it, unmeasured.
remit makes restraint part of the work. It gives each admitted outcome a durable place,
carries its boundary between sessions, and keeps the decisions with the person who owns
their consequences.

remit has two POSIX scripts and five conventions. It has no service or database. No daemon
runs. Why it exists, in the practitioner's own words: [MANIFESTO.md](MANIFESTO.md).

**Version 0.1.0. Early, and in use.**

## One piece of work, start to finish

A true story from remit's own development, condensed.

During an evaluation of an unrelated delivery, a reviewer noted a defect in passing: the
dispatch script parsed cleanly under `sh`, its own shell, but failed under `bash` with an
unmatched quote. Real, small, and nobody's job that day. The note was recorded with the item
it surfaced in, and the work in flight carried on. Nothing nagged about it afterwards. It sat
there, costing nothing.

Days of work later, the practitioner wanted a small, real task to prove a newly added harness.
The note was waiting. He said: fix it.

One worker, the first ever dispatched through that harness, received one brief: the defect, the
boundary, the proof required. It read the tree and found the truth was slightly bigger than the
note: where one broken site was recorded, five existed. It fixed all five from a single source
and stopped. It ran no Git commands; workers never do.

The dispatch wrapper committed the worker's tree, named the authoring model in the commit
itself, pushed a branch, and opened a draft pull request. Then an evaluator that had not
written the fix and had not watched it being written reproduced the original failure,
verified the repair under three different shells, and compared every rendered message byte
for byte. Its passing verdict was recorded with the item, and only then did the draft become
ready for review.

The pull request waits for the practitioner. Merging is his decision. Closing the work is his
decision. Nothing in the chain accepted anything on his behalf.

That is the whole shape of remit. An observation became a record, the record waited without
urgency, work began on the owner's word, one bounded worker built it, a fresh judge checked
it, and the owner decides the ending.

## Work is captured without starting

You say: **"I have an idea I want to add to our backlog."**

The capture convention helps you settle a short brief: title, outcome, boundary, stated
constraints. Then `bin/remit new` writes it under `.remit/` with `**State:** parked`, commits
that change, and pushes when a remote is configured. The agent reports exactly what Git
accepted.

A work item is an ordinary folder:

```text
.remit/<slug>/
|-- brief.md
|-- evaluation.md     # when the item has been evaluated
`-- ...               # decisions and evidence kept with this item
```

The brief records the outcome, boundary, state, and history. Git records every mechanical
state change. Sessions can end and models can change without becoming the memory for the
work.

Only the practitioner admits an item, activates or parks it, opens a phase, accepts a result,
and decides closure. Anthropic documents that Opus 5 can expand a task's scope, add
unrequested steps, and decide what the task should be
([Anthropic](https://platform.claude.com/docs/en/build-with-claude/prompt-engineering/prompting-claude-opus-5)).
Under remit, a worker may observe that more seems needed. An observation is not scope. The
scope changes only when you change it.

An item can run in phases when you open them. Each phase narrows the admitted outcome and
stays inside it; the item remains one item.

## Work resumes in a fresh session

Weeks later, in a new session, in the AI harness of your choice, ask for the state of play.
The agent lists active work without ranking it. Parked work appears only when you ask for it.

Choose an item to rehydrate it. The agent reads the item's files, their authoritative links,
and the current code. There is no previous conversation to reconstruct; no record of one
exists, and the agent works from what is written. Where the record says nothing, the agent
says so. The answer is never invented.

## Work is dispatched to bounded workers

Send one bounded task to one isolated worker: research, documentation, wireframing, coding.
The brief carries the outcome, boundary, constraints, and proof. The worker authors files and
runs no Git commands. `bin/remit-dispatch` records the dispatch, commits the authored tree,
pushes `work/<slug>`, and opens a draft pull request.

Workers run in separate worktrees, so parallel work does not collide. While they run, the
coordinator stays available: it can capture a new idea, progress another item, or talk with
you. Parallel work saves elapsed time. It grants no wider authority.

## Work is evaluated before it reaches you

Evaluation happens by default. A fresh context that did not author the work and did not
watch it being written judges the result against the item's own brief. It receives the
work's authority and the artifact, without the author's conversation or the coordinator's
opinion. It judges, it reports, and it leaves every repair to the loop that follows.

The gate prefers a different model family, and the claim for that is precise. Models favour
their own output, intrinsic self-correction is unreliable, and panels from disjoint model
families reduce judge bias
([Panickssery et al., NeurIPS 2024](https://arxiv.org/abs/2404.13076),
[Huang et al., ICLR 2024](https://arxiv.org/abs/2310.01798),
[Verga et al., 2024](https://arxiv.org/abs/2404.18796)). The claim is decorrelation.
Cross-family agreement is never verification: models still agree on wrong answers above
chance ([Kim et al., ICML 2025](https://arxiv.org/abs/2506.07962)). Tests, linters, and your
own review still carry evidence that another model cannot supply.

A failing verdict leaves the pull request in draft. A passing verdict is recorded with the
item before the draft becomes ready. Acceptance and merging stay with you in both cases.

## Work closes on your word

Close an item only on the practitioner's instruction. Delivered and abandoned work can both
close. The archive keeps the brief, decisions, evidence, evaluation record, and confirmed
delivery links. Normal listings do not read it back.

Closure is an attention boundary. It is not acceptance, a merge, or proof that the work
succeeded.

## Plan for a big start and a long tail

AI's first pass is genuinely large and getting larger, and it runs out: METR measured
near-100% agent success on tasks taking people under four minutes, about 50% around 50
minutes, and under 10% past four hours
([METR](https://metr.org/blog/2025-03-19-measuring-ai-ability-to-complete-long-tasks/)). METR
receives support from frontier labs and evaluates for them; the long end of that curve cuts
against their interest.

The tail is older than AI. People learn from the thing they can see: Brooks says clients
cannot completely specify a product before trying versions
([No Silver Bullet](https://www.cin.ufpe.br/~phmb/ip/MaterialDeEnsino/BrooksNoSilverBullet.html)),
and in current production data, Google found 1.92 times as many review-blocking comments on
AI-authored changes, yet 0.9 times the human revert rate
([Tran et al., 2026](https://arxiv.org/html/2608.06640)). Google is a model vendor studying
its own monorepo. The result says the work was reviewed harder and reverted less; the study
found no generally worse code.

So remit plans for the pivot. Specify each pass in full, judge it with fresh eyes, and bring
what the finished thing taught you to the next decision. Human judgment is the input that can
accept risk and own the result, and it degrades under volume: reviewer defect detection falls
after roughly 200–400 lines or 60 minutes, and automation bias makes people over-accept
machine suggestions
([SmartBear](https://smartbear.com/learn/code-review/best-practices-for-peer-code-review/),
[Automation Bias in the AI Act](https://arxiv.org/pdf/2502.10036)). Felt progress is
unreliable evidence, your own included: in METR's 2025 trial, experienced developers were 19%
slower with AI while estimating they were 20% faster; METR itself now labels that result
historical ([METR](https://metr.org/blog/2025-07-10-early-2025-ai-experienced-os-dev-study/)). No study
has yet shown that judgment gates like remit's improve delivery outcomes. The design joins
measured failure mechanisms to a practitioner-owned review discipline, and says so plainly.

## Let code carry the result

The work item helps you get the work done. Once written, the code is the law and remains
malleable. Closing the item removes no constraint from the product and adds no document that
fights later change. A rule that must survive belongs in code, a test, a name, or a comment.

This holds in a small repository with one parked idea and in a large repository with
concurrent workers. The size of an item and the number of phases are yours.

## Install remit

Fetch the published installer without cloning remit:

```sh
curl -fsSL https://raw.githubusercontent.com/shobman/remit/main/get-remit.sh | sh -s -- /path/to/your-repository
```

To read the script before you run it, fetch it and run it separately:

```sh
curl -fsSL https://raw.githubusercontent.com/shobman/remit/main/get-remit.sh -o /tmp/get-remit.sh
sh /tmp/get-remit.sh /path/to/your-repository
```

Pin the bootstrap to this release when you need a repeatable install:

```sh
curl -fsSL https://raw.githubusercontent.com/shobman/remit/main/get-remit.sh | REMIT_REF=v0.1.0 sh -s -- /path/to/your-repository
```

Place `REMIT_REF=v0.1.0` immediately before `sh`, the last command in the pipeline, so
`get-remit.sh` receives the variable. If you already have a remit clone, run its installer directly:

```sh
sh /path/to/remit/install.sh /path/to/your-repository
```

The target argument must point inside your repository's primary worktree; the installer refuses a
linked worktree. Do not hand-install remit. The installer is the fixed, inspectable operation. It
requires Git and a POSIX shell. On Windows, use Git Bash's `sh`, not PowerShell.

Re-run `install.sh` to upgrade. It updates content that still matches the prior install,
preserves local edits, and reports each result. It commits touched paths in the target
repository and never pushes them.

The installer adds:

| Path | Purpose |
|---|---|
| `bin/remit` | Lists items and performs state changes. |
| `bin/remit-dispatch` | Turns a worker's authored tree into a draft pull request. |
| `.claude/skills/` | Installs the five conventions for Claude Code. |
| `.agents/skills/` | Installs the same conventions for Codex. |
| `.pi/skills/` | Installs the same conventions for Pi. |
| `AGENTS.md` | Adds one marker-delimited, shared section without replacing existing content. |
| `<git>/hooks/pre-push` | Installs the guard when none exists; on re-run, remit's own hook is updated or reported unchanged; any other hook or custom hooks path is kept and reported. |
| `.remit/` | Creates the empty work location. |
| `.remit/.install/manifest` | Records the installed content and version. |

## Use your harness

remit is built for Claude Code, Codex, Pi, and Devin. The installer places conventions in the
discovery paths for Claude Code, Codex, and Pi; Devin reads the installed `AGENTS.md` section
and discovers the installed `.agents/skills/` natively, so it needs no path of its own.
remit's state is Git, its mechanics are POSIX shell, and its conventions are Markdown.

`bin/remit-dispatch` demonstrates CLI invocation for all four harnesses.

Change the harness without changing the item's identity, boundary, decisions, state, or
history. When a harness lacks an isolation or pull-request capability, the agent reports the absence
and stops at what the harness can actually do.

## Know the boundary

remit is not a project management system. Nothing in it ensures scope, timelines, or
deliverables. It does not prioritise work or decide whether the result is good. It makes each
state change and authority decision a Git record with a named decision-maker.

## Place remit beside AIDOS

AIDOS is a separate system, complementary by design. It is best suited to organisations that
start, park, and resume work as teams. AIDOS helps teams define work, collaborate with
discipline, and establish that work is warranted before development starts.

remit sits on the engineering side. AIDOS can bound it, or the two can operate completely
adjacent to each other.

## Read the licence

remit is MIT licensed. See [`LICENSE`](LICENSE).
