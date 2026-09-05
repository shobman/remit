# remit

Keep practitioner-directed AI work in Git. You decide what starts, what stops, who builds it, who
judges it, and when it leaves your attention.

AI can produce work faster than you can judge it. remit makes restraint part of the work: every
admitted outcome gets a durable place, its boundary travels between sessions, and the decisions
stay with the person who owns their consequences. It is three POSIX scripts and seven conventions —
no service, no database, no daemon. Why it exists, in the practitioner's own words:
[MANIFESTO.md](MANIFESTO.md).

**Version 0.3.18. Early, and in use.**

## One piece of work, start to finish

A true story from remit's own development, condensed. During an evaluation of an unrelated
delivery, a reviewer noted in passing that the dispatch script parsed under `sh` but failed under
`bash`. Real, small, and nobody's job that day. It was recorded with the item it surfaced in, and
nothing nagged about it afterwards.

Days later the practitioner wanted a small, real task to prove a newly added harness. They said: fix
it. One builder got one brief — the defect, the boundary, the proof required — and found five
broken sites where the note recorded one. It fixed all five and stopped, running no Git commands;
builders never do. `bin/remit` committed its tree, named the authoring model in the
commit itself, pushed a branch and opened a draft pull request. An evaluator that had not written
the fix reproduced the failure, verified the repair under three shells, and recorded a passing
verdict; only then did the draft become ready.

Merging was the practitioner's decision, and so was closing the item; nothing in the chain accepted
anything on their behalf. That is the whole shape of remit: an observation became a record, the
record waited without urgency, work began on the owner's word, one bounded builder built it, a
fresh context judged it, and the owner decided the ending.

## What it asks of you, and what it never does

It asks for a word at three moments. One to start: the brief, in your words, and how far the work
may go without you. One at each stop that is genuinely yours: a question only you can answer, a
rule you wrote that said hold, a run that failed four times. One to end: closing is yours alone.
Everything between those is housekeeping, and it happens without you.

It never starts work, merges a pull request, reads a check, edits your brief, or closes an item on
your behalf. It never raises a context on a seat you did not register, and it never falls back to
another when that seat refuses. It never runs a builder through a harness's own sub-agent tool.
And it never pushes anything at you: work waits on the record until you ask where things stand.

## How an item moves

You say: **"I have an idea I want to add to our backlog."** The admission convention settles a
short brief with you — a title, the outcome, the boundary, what would count as proof — and
`bin/remit new` files it under `.remit/work-items/<slug>/` exactly as you said it, commits that
change, and pushes when a remote is configured. A work item is an ordinary folder:

```text
.remit/work-items/<slug>/
|-- brief.md        # your words, under a script-owned header: stage, attention, until
|-- log.md          # append-only: every verdict, delivery, stop, escalation and ruling
|-- research.md     # when the brief asked for research; machine-authored, judged like a build
`-- runs/           # kept output — test runs, fetch manifests, the proof a reader needs
```

Git records every change to it. Sessions can end and models can change without becoming the
memory for the work; closed items are archived whole to `.remit/work-items/.archive/`, out of
every current view. Weeks later, in a new session, in the harness of your choice, ask for the
state of play: active work is listed without ranking, and rehydrating an item reads its files and
the current code, never a previous conversation.

An item is born active at **`new`**. `bin/remit resume <slug> --until <stage>` runs the chain —
research if the brief asked for it, then evaluate, build, deliver, evaluate, close — as far as the
stage you named and no further. Each step is a fresh context raised through `bin/remit-invoke`,
briefed with the item's authority and nothing else, on a harness and model your registry seats
it on.

| Into | What the gate judges | Who authors the fix |
|---|---|---|
| `refined` | the brief — and the research, when there is one | the brief: you. The research: a fresh researcher |
| `accepted` | a delivery: a builder's tree, turned into a draft pull request by the mechanism | a fresh builder, four rounds at most |
| `closed` | the record — every verdict and note on it | a fresh builder, if anything |

A gate is a fresh context that did not author the work, judging it against the item's own brief
and against **rubrics you wrote** in `.remit/rules/<gate>.md`: a rubric can carry the item past
the gate whatever `until` said, hold it for your eyes, name the standard a delivery missed, or
dispose of a finding. Seat the judge on a different model family from the builder — a model
favours its own output, and a judge from another family decorrelates that bias
([Panickssery et al., 2024](https://arxiv.org/abs/2404.13076)). Agreement is never verification,
so the proof a builder ran is kept in `runs/` where the next gate can read it.

The loop has stops, and every stop is a line on the record: four failed rounds, the same must-fix
twice, a must-fix that returns after being displaced, a verdict with nothing a builder can act on,
or a question only you can answer. An escalation raises nothing and proposes nothing — the
verdicts above it are the analysis, and what the brief needs is worked out by you from the record.

When an evaluator's judgement is that a decision is yours, it asks, and the item stops with the
questions numbered on the record. `bin/remit answer <slug> <n> "<your words>"` files your answer
verbatim under `## Rulings` in the brief and resumes the chain where it stopped. A conductor may
answer on your behalf only under `.remit/elevation.md` — your words on what it may decide, and
nothing rules for you until you have written it — and the mechanism bounds it without reading the
question: two such rulings per item since your last word, then the third is yours, and a question
the conductor already ruled on is yours when it returns. Its rulings are filed as provisional and
yours to supersede.

A builder authors files in its own worktree — `<repo>-remit-worktrees/<slug>`, a sibling of your
repository — and runs no Git commands; `bin/remit` turns the tree it leaves into a draft pull
request, naming in the commit the model that actually served the run. A delivery that pushed is on
the record whatever became of its pull request, so a resume evaluates it rather than building the
round again. A delivery past 2,000 files or 100 MB is not committed at all.

Findings outlive the item. `bin/remit review` projects what the last verdict at each gate left
standing, across every item, open or archived, with no ranking and no proposal. `--attest` raises
one fresh context at HEAD to say of each whether it still stands, is fixed — naming the commit or
file, a fix made outside the loop included — or is moot, and records that on every item. A finding
attested fixed is not judged again; the rest are yours to admit as an item or leave. Where the
standing count is high, the cause is usually a gate file whose `accept` section is empty: no
evaluator can dispose of a finding it has no rubric to cite.

## The boundary, before you install

**What a raised context inherits.** Every context starts with an emptied environment and an
allow-list: your `PATH`, a scratch `HOME` that is removed after the run, a scratch temp inside its
own worktree, and the one configuration directory its CLI needs to log in as you. No API key, no
token and no `~/.ssh` crosses. A context never runs `git` or `gh`; the mechanism does, as you.

**What holds it there, per harness.** Codex is the one seat with an enforced sandbox: its own
workspace and nothing else, read back from the run's own header after every run and refused on a
downgrade. Claude Code, Pi, Devin and Copilot CLI have no enforced read boundary: a context there
runs on your machine under your own login and can read what you can. What each of them gets
instead is a per-run containment the mechanism writes and removes: Claude Code's sub-agent tool
denied by flag and by hook; Pi's built-in tools only, with extensions off; Devin's allow list,
which ends the run on anything outside it; Copilot's hook against `git` and `gh` in any wrapping,
tested by a throwaway run before the real one. Every pull request records which applied.

**What it costs.** Each gate is one judging context, and each round after a failure is one
authoring context and one judging context, four rounds at most per gate. Every raise is recorded
on the item with its harness, its model and, where the harness reports one, its cost. Your own
attention has a number too: `bin/remit-exposure` counts the words you typed and the words said
back to you, per session and per item, and never adds them into a score.

**How you stop it.** `bin/remit stop <slug>` ends the chain and every context it raised, discards
the worktree's in-flight changes, records one line, and leaves the item at the stage it last
stopped at. A chain that crashes leaves a marker the board shows first; only your `resume`
continues it.

**What a failure leaves.** The record, with the reason as its last entry. The item's worktree
beside your repository. The branch `work/<slug>` and its draft pull request, if a delivery got that
far. Nothing is merged and nothing is deleted; `resume` reads the record and continues from the
step it stopped at.

**What install changes.** Three scripts under `bin/`, the conventions in three discovery paths, one
marker-delimited section of `AGENTS.md`, a `.remit/` folder, a pre-push guard where no hook exists,
and the hook registrations listed in the reference below; every file is recorded in
`.remit/.install/manifest`. An upgrade touches only what still matches that manifest. There is no
uninstaller yet: removing remit is removing what the manifest names.

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

To pin the bootstrap to this release, place `REMIT_REF=v0.3.18` immediately before `sh`, the
last command in the pipeline, so `get-remit.sh` receives the variable:

```sh
curl -fsSL https://raw.githubusercontent.com/shobman/remit/main/get-remit.sh | REMIT_REF=v0.3.18 sh -s -- /path/to/your-repository
```

If you already have a remit clone, run its installer directly:

```sh
sh /path/to/remit/install.sh /path/to/your-repository
```

The target argument must point inside your repository's primary worktree; the installer refuses a
linked worktree. Do not hand-install remit: the installer is the fixed, inspectable operation, and
it requires only Git and a POSIX shell. On Windows, use Git Bash's `sh`, not PowerShell. Re-run
`install.sh` to upgrade — it updates content that still matches the prior install, preserves local
edits save in the one file it manages, reports each result, commits touched paths in the target
repository, and never pushes them.

It does not install `.remit/elevation.md`, your words on what a conductor may rule on your
behalf; without it nothing rules for you. Nor `.remit/settings.json`, the registry of which
harnesses and models a repository may raise a context on: `sh bin/remit setup` reads the host and
proposes one on stdout for you to accept or edit, and `sh bin/remit setup --write` saves that
proposal itself. Never redirect `setup` over the registry — that file is the one it reads.

## Use your harness

remit is built for five harnesses. The installer places the same seven conventions in the discovery
path each one reads, and `bin/remit-invoke` raises a context on any of the five, so you use the
agents you already pay for without moving the item or reconstructing its history. Which harness and
which model a role sits on is your registry's: nothing is raised on a seat you did not register,
nothing falls back, and every refusal happens before anything is billed. A seat that refuses —
out of credits, a quota, not authenticated — marks the host for thirty minutes, and no chain
raises into it while the mark is fresh.

| Harness | Conventions land at | What it does with a model id it does not know |
|---|---|---|
| Claude Code | `.claude/skills/` | no catalogue to check; the run's own report names what served it |
| Codex | `.agents/skills/` | no catalogue; the run header names what served it |
| Pi | `.pi/skills/` | refused unless `pi --list-models` carries the exact id |
| Devin | reads `AGENTS.md` and `.agents/skills/` natively | rejected before the run starts |
| GitHub Copilot CLI | reads `AGENTS.md` and `.agents/skills/` natively | refused before the run starts, and so is a reasoning effort the model does not offer |

## Reference

Everything below is detail a first read can skip.

### What the installer places

| Path | Purpose |
|---|---|
| `bin/remit` | Lists items and performs state changes. |
| `bin/remit-invoke` | The seam: raises a fresh context in a registered seat and returns its text. The only thing in remit that raises one. |
| `bin/remit-exposure` | Counts the words you typed and the words said back, so attention can be read as a number. |
| `.claude/skills/`, `.agents/skills/`, `.pi/skills/` | The seven conventions — admit, resume, close, status, retro, exposure, review — in the discovery path each harness reads. |
| `AGENTS.md` | One marker-delimited, shared section, without replacing existing content. |
| `CONTRIBUTING.md` | How this repository takes a contribution. The one file remit manages: a local edit to it is restored on the next upgrade, while a `CONTRIBUTING.md` the repository already had is kept. |
| `<git>/hooks/pre-push` | The guard, when no hook exists; on re-run remit's own hook is updated or reported unchanged, and any other hook or custom hooks path is kept and reported. |
| `.remit/hooks/no-agent-tool.sh` | The agent-tool guard: one script, registered by every harness here that has a pre-tool hook. |
| `.github/hooks/remit-no-agent-tool.json` | Copilot CLI's registration of that guard. |
| `.claude/settings.json` | Claude Code's registration of it, **offered**: created when absent; when the file is yours it is kept and the block to merge is printed. |
| `.remit/` | The work location, with no work item in it: `work-items/`, `field-reports/`, and `rules/` holding the rubrics remit ships. An upgrade migrates those rubric by rubric: it adds, changes and removes only its own, keeps every rubric you wrote or edited, and reports what it did to each. |
| `.remit/.install/manifest` | A record of the installed content and version. |

### Host notes

- **Windows.** A raised context's `USERPROFILE`, `APPDATA` and `LOCALAPPDATA` point at the raise's
  scratch, so a tool that installs itself lands there and goes with the run. A worktree that opens a
  listener trips Windows Defender Firewall's prompt once per path; `Set-NetFirewallProfile -All
  -NotifyOnListen False` in an elevated PowerShell ends that. WSL on a clone kept on the Linux
  filesystem avoids both and runs the test suite in minutes.
- **Linux.** `ssh` inside a raise has none of your keys, known hosts or config; a host a build must
  reach gets a `Host` stanza in `/etc/ssh/ssh_config` naming `IdentityFile` and
  `UserKnownHostsFile` under your real home. Ubuntu 24.04's `gh` (2.45) cannot `gh pr edit`;
  remit writes the pull request body over REST when that call fails.

### Where each CLI lists its models

Model lists are perishable and depend on your subscription, so none is printed here. Ask the CLI:
Claude Code exposes no catalogue and the run's own report names what served it; Codex has no
`models` subcommand and caches its visible ids in `~/.codex/models_cache.json`; Pi answers
`pi --list-models` from the providers configured on the machine; Devin answers
`devin models list`; Copilot CLI lists the ids its configuration accepts under `copilot help
config`. The pull request records which model actually served each run.

### Contributions, positioning, licence

A repository running remit takes contributions the way remit does: the installed
[`CONTRIBUTING.md`](CONTRIBUTING.md) states the route, not this page. remit is not a project
management system: it ensures no scope, timeline or deliverable and decides nothing about whether
a result is good; it makes each state change and authority decision a Git record with a named
decision-maker. [AIDOS](https://github.com/shobman/aidos) is a separate, complementary system for
teams establishing that work is warranted before development starts; remit sits on the
engineering side, bounded by it or adjacent to it. remit is MIT licensed: see
[`LICENSE`](LICENSE).
