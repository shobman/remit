# remit

Keep practitioner-directed AI work in Git. You decide what starts, what stops, who builds it, who
judges it, and when it leaves your attention.

AI can produce work faster than you can judge it. remit makes restraint part of the work: every
admitted outcome gets a durable place, its boundary travels between sessions, and the decisions
stay with the person who owns their consequences. It is three POSIX scripts and seven conventions —
no service, no database, no daemon. Why it exists, in the practitioner's own words:
[MANIFESTO.md](MANIFESTO.md).

**Version 0.3.14. Early, and in use.**

## One piece of work, start to finish

A true story from remit's own development, condensed. During an evaluation of an unrelated
delivery, a reviewer noted in passing that the dispatch script parsed under `sh` but failed under
`bash`. Real, small, and nobody's job that day. It was recorded with the item it surfaced in, and
nothing nagged about it afterwards.

Days later the practitioner wanted a small, real task to prove a newly added harness. He said: fix
it. One builder got one brief — the defect, the boundary, the proof required — and found five
broken sites where the note recorded one. It fixed all five and stopped, running no Git commands;
builders never do. `bin/remit` committed its tree, named the authoring model in the
commit itself, pushed a branch and opened a draft pull request. An evaluator that had not written
the fix reproduced the failure, verified the repair under three shells, and recorded a passing
verdict; only then did the draft become ready.

Merging was the practitioner's decision, and so was closing the item; nothing in the chain accepted
anything on his behalf. That is the whole shape of remit: an observation became a record, the
record waited without urgency, work began on the owner's word, one bounded builder built it, a
fresh context judged it, and the owner decided the ending.

## Work is admitted in your words

You say: **"I have an idea I want to add to our backlog."** The admission convention settles a
short brief with you — a title, the outcome, the boundary, what would count as proof — and
`bin/remit new` files it under `.remit/work-items/<slug>/` exactly as you said it, commits that
change, and pushes when a remote is configured. Nothing but you ever writes a brief: no context
raised by remit edits it, proposes a rewrite of it, or fills in what you left out.

A work item is an ordinary folder:

```text
.remit/work-items/<slug>/
|-- brief.md        # your words, under a script-owned header: stage, attention, until
|-- log.md          # append-only: every verdict, delivery, stop, escalation and ruling
|-- research.md     # when the brief asked for research; machine-authored, judged like a build
`-- runs/           # kept output — test runs, fetch manifests, the proof a reader needs
```

Git records every change to it. Sessions can end and models can change without becoming the
memory for the work; closed items are archived whole to `.remit/work-items/.archive/`, out of
every current view. Where the record lives is yours too: by default in the repository, or — with
one local setting — in a records repository of your own, so nothing work-shaped reaches a project
remote. A shadow install keeps remit itself out of the project's history entirely.

## Work moves through four stages, and stops when it should

An item is born active at **`new`**. `bin/remit resume <slug> --until <stage>` runs the chain —
research if the brief asked for it, then evaluate, build, deliver, evaluate, close — as far as the
stage you named and no further. Each step is a fresh context raised through `bin/remit-invoke`,
briefed with the item's authority and nothing else, on a harness and model your registry seats
it on. The one word `until` is how far the work may travel without you.

| Into | What the gate judges | Who authors the fix |
|---|---|---|
| `refined` | the brief — and the research, when there is one | the brief: you. The research: a fresh researcher |
| `accepted` | a delivery: a builder's tree, turned into a draft pull request by the mechanism | a fresh builder, four rounds at most |
| `closed` | the record — every verdict and note on it | a fresh builder, if anything |

A gate is a fresh context that did not author the work, judging it against the item's own brief
and against **rubrics you wrote** in `.remit/rules/<gate>.md`. A rubric can carry the item past
the gate whatever `until` said (`promote`), hold it for your eyes whatever else was cited
(`hold`), name the standard a delivery missed (`fix`), or dispose of a finding (`accept`). The
rubrics are yours alone, written through a retro; remit ships a few and migrates only its own on
upgrade. A must-fix goes back to a fresh author with the finding and nothing else; a verdict that
fails the work with findings and no must-fix has its findings handed to a builder as the must-fix,
once. The loop has stops, and every stop is a line on the record: four failed rounds, the same
must-fix twice, a must-fix that returns after being displaced (the brief is arguing with itself),
a second verdict with nothing a builder can act on, or a question only you can answer. An
escalation raises nothing and proposes nothing — the verdicts above it are the analysis, and what
the brief needs is worked out by you from the record.

A delivery is measured before it is committed: files added and megabytes staged are recorded on
the record, and past 2,000 files or 100 MB (`REMIT_DELIVERY_FILES`, `REMIT_DELIVERY_MB`) it is
not committed at all — what a builder authored is never that large, and what is that large is
never what it authored.

When an evaluator's judgement is that a decision is yours — which of two shapes, whether a thing is
in scope — it asks, and the item stops with the questions numbered on the record.
`bin/remit answer <slug> <n> "<your words>"` files your answer verbatim under `## Rulings` in the
brief, beside the question, and resumes the chain where it stopped; every later context is told a
ruling is settled ground. A conductor you have elevated to judge in your absence may answer with
`--conductor`, and the line and the record say so.

Merging a pull request is your decision and so is closing an item: nothing in the chain merges
anything, reads a check, or accepts anything on your behalf. Closure is final, and it is an
attention boundary — not acceptance, not a merge, not proof that the work succeeded.

## Work resumes in a fresh session

Weeks later, in a new session, in the harness of your choice, ask for the state of play. Active
work is listed without ranking; parked work appears only when you ask for it. Rehydrating an item
reads its files, their authoritative links and the current code. There is no previous conversation
to reconstruct and none is invented: where the record says nothing, the agent says so.

## Work is built and judged by bounded contexts

One bounded task goes to one isolated context — research, build, evaluate — carrying the
outcome, boundary, constraints and proof in its briefing. A builder authors files in its own
worktree and runs no Git commands; `bin/remit` turns the tree it leaves into a draft pull request,
naming in the commit the model that actually served the run. A failing verdict leaves the pull
request in draft; a passing verdict is recorded with the item before the draft becomes ready.

Seat the judge on a different model family from the builder — the registry lets one harness build
and another judge — because a model favours its own output and a judge from another family
decorrelates that bias
([Panickssery et al., 2024](https://arxiv.org/abs/2404.13076)). Agreement is never verification, so
tests, linters and your own reading still carry evidence a second model cannot supply — and the
proof a builder ran is kept in `runs/`, where the next gate can read it.

## Let code carry the result

The work item helps you get the work done. Once written, the code is the law and remains malleable:
closing the item removes no constraint from the product and adds no document that fights later
change. A rule that must survive belongs in code, a test, a name or a comment.

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

To pin the bootstrap to this release, place `REMIT_REF=v0.3.14` immediately before `sh`, the
last command in the pipeline, so `get-remit.sh` receives the variable:

```sh
curl -fsSL https://raw.githubusercontent.com/shobman/remit/main/get-remit.sh | REMIT_REF=v0.3.14 sh -s -- /path/to/your-repository
```

If you already have a remit clone, run its installer directly:

```sh
sh /path/to/remit/install.sh /path/to/your-repository
```

The target argument must point inside your repository's primary worktree; the installer refuses a
linked worktree. Do not hand-install remit: the installer is the fixed, inspectable operation, and
it requires only Git and a POSIX shell. On Windows, use Git Bash's `sh`, not PowerShell. Re-run
`install.sh` to upgrade — it updates content that still matches the prior install, preserves local
edits save in the one file it manages below, reports each result, commits touched paths in the
target repository, and never pushes them.

On Windows, two things a first day there taught: a raised context's `USERPROFILE`, `APPDATA` and
`LOCALAPPDATA` point at that raise's scratch, so a tool that installs itself (Python's install
manager, NuGet's caches) lands there and goes with the run rather than into your tree; and every
worktree that builds a listener will trip Windows Defender Firewall's prompt once per path —
`Set-NetFirewallProfile -All -NotifyOnListen False` in an elevated PowerShell ends that. Running
remit from WSL on a clone kept on the Linux filesystem avoids both, and runs the test suite in
minutes rather than most of an hour.

The installer adds:

| Path | Purpose |
|---|---|
| `bin/remit` | Lists items and performs state changes. |
| `bin/remit-invoke` | The seam: raises a fresh context in a registered seat and returns its text. The only thing in remit that raises one. |
| `bin/remit-exposure` | Counts the words you typed and the words said back, so attention can be read as a number. |
| `.claude/skills/`, `.agents/skills/`, `.pi/skills/` | The seven conventions — admit, resume, close, status, retro, exposure, review — in the discovery path each harness reads; see [Use your harness](#use-your-harness). |
| `AGENTS.md` | One marker-delimited, shared section, without replacing existing content. |
| `CONTRIBUTING.md` | How this repository takes a contribution — the file states that, and nothing here repeats it. The one file remit manages: a local edit to it is restored on the next upgrade, while a `CONTRIBUTING.md` the repository already had is not remit's and is kept. |
| `<git>/hooks/pre-push` | The guard, when no hook exists; on re-run remit's own hook is updated or reported unchanged, and any other hook or custom hooks path is kept and reported. |
| `.remit/hooks/no-agent-tool.sh` | The agent-tool guard: one script, registered by every harness here that has a pre-tool hook. |
| `.github/hooks/remit-no-agent-tool.json` | Copilot CLI's registration of that guard. |
| `.claude/settings.json` | Claude Code's registration of it, **offered**: created when absent; when the file is yours it is kept and the block to merge is printed. |
| `.remit/` | The work location, with no work item in it: `work-items/`, `field-reports/`, and `rules/` holding the rubrics remit ships. An upgrade migrates those rubric by rubric rather than file by file: it adds, changes and removes only its own, keeps every rubric you wrote or edited, and reports what it did to each. Where you and remit have both changed the same shipped rubric, remit's wording wins. |
| `.remit/.install/manifest` | A record of the installed content and version. |

It does not install `.remit/settings.json`, the registry of which harnesses and models a
repository may raise a context on. No installer can know a host's seats, and a template
registering seats a target does not have would be a file that could only refuse. `sh bin/remit
setup` reads the host and proposes one on stdout for you to accept or edit; `sh bin/remit setup
--write` saves that proposal itself. Never redirect `setup` over the registry — that file is the
one it reads, to carry your seats forward and report drift against them.

## Use your harness

remit is built for five harnesses, one to each heading below. The installer places the seven
conventions in the discovery path each one reads, and `bin/remit-invoke` raises a context on
any of the five. Change the harness without changing the item's identity, boundary,
decisions, state or history; where one lacks an isolation or pull-request capability, the agent
reports the absence and stops at what that harness can actually do.

Which harness and which model a role sits on is `.remit/settings.json`'s, and yours: nothing is
raised on a seat you did not register there, nothing falls back and nothing is substituted, and
every refusal happens before anything is billed. `bin/remit-invoke`'s header is the law of that
file — what its shape is, how a `--harness` or `--model` is resolved against it, and what each
refusal means. The pull request names the model that actually served the run, read back from the
run's own report where the harness prints one; where that report is silent it records the model as
unconfirmed rather than assuming the dispatch got what it asked for.

A chain refuses to start without a registry, naming `setup`. And a seat that refuses — out of
credits, a quota, not authenticated — marks the host for thirty minutes, and no chain raises
into that seat while the mark is fresh: one refusal is a fact about the host, not the item, and
five chains queued behind it should not each spend a build round finding out. A run that
completes on that seat clears the mark; so does `setup --write`.

Each heading gives where that harness's conventions land, what it does with a model id it does not
know, and what its own command or local source said when I read it on 21 August 2026.

### Claude Code

Conventions at `.claude/skills/`. Every context is raised through the CLI by `bin/remit-invoke`,
never through Claude Code's own sub-agent tool — a shipped hook refuses that, so the registry
decides every seat. The CLI does not expose an account catalogue: its
top-level help and full command list offer no model query, `claude --help` documents only the
selectors `fable`, `opus`, `sonnet` and the full-name example `claude-fable-5`, and the local
account cache adds no list of what the account can use. So there is no honest list to print here.

### Codex

Conventions at `.agents/skills/`. The CLI has no `models` subcommand; `codex doctor` reports the
model in effect and provider counts, not the ids. The installation's fetched
`~/.codex/models_cache.json` is the source that does enumerate its visible choices. It marks six
entries `visibility: list`: `gpt-5.6-sol`, `gpt-5.6-terra`, `gpt-5.6-luna`, `gpt-5.5`, `gpt-5.4`
and `gpt-5.4-mini`. Two other entries in that source are marked hidden, so I have not presented
them as choices.

### Pi

Conventions at `.pi/skills/`. A dispatch must name a model, and it is refused unless the exact id
appears in `pi --list-models`, because an unknown id is otherwise accepted silently and answered
anyway. That command reads the providers configured on the machine. Here it printed one row,
provider `llamacpp`, model `qwen3.6-35b`; the same id is carried in `~/.pi/agent/models.json`.

### Devin

No path of its own: it reads the installed `AGENTS.md` section and discovers the installed
`.agents/skills/` natively. An unknown id is rejected before a run starts. `devin models list`
printed 22 model families, ordered here for reading: `claude-opus-5`, `claude-fable-5`,
`claude-sonnet-5`, `claude-opus-4.8`, `claude-opus-4.7`, `claude-sonnet-4.6`, `claude-haiku-4.5`,
`gpt-5.6-sol`, `gpt-5.6-luna`, `gpt-5.5`, `gemini-3.6-flash`, `gemini-3.1-pro`, `gemini-3-flash`,
`kimi-k3`, `kimi-k2.7`, `kimi-k2.6`, `glm-5.2`, `swe-1.7`, `swe-1.7-lightning`, `swe-1.6`,
`swe-1.6-fast` and `adaptive`.

### GitHub Copilot CLI

No path of its own either: it reads the installed `AGENTS.md` section and discovers the installed
`.agents/skills/` natively. An unknown id is refused before the run starts, and so is a reasoning
effort the named model does not offer — the one harness here that checks both before anything is
billed. Its containment is a hook written into the builder's tree for the run, keeping the builder
off `git` and `gh` in any wrapping, and a throwaway probe run tests that before the builder is
invoked; a dispatch that cannot show its builder was contained is refused rather than run. That is
the whole of what it enforces: a Copilot builder runs on your own machine under your own
credentials with no enforced read boundary — treat it as you would any process you run — and every
pull request it delivers says so. `copilot help
config` lists the 27 ids its configuration accepts: `claude-sonnet-5`, `claude-fable-5`,
`claude-opus-5`, `claude-opus-4.8`, `claude-opus-4.8-fast`, `claude-opus-4.7`, `claude-sonnet-4.6`,
`claude-opus-4.6`, `claude-sonnet-4.5`, `claude-opus-4.5`, `claude-haiku-4.5`, `gpt-5.6-sol`,
`gpt-5.6-terra`, `gpt-5.6-luna`, `gpt-5.5`, `gpt-5.4`, `gpt-5.4-mini`, `gpt-5.3-codex`,
`gpt-5-mini`, `mai-code-1-flash-picker`, `gemini-3.7-flash`, `gemini-3.6-flash`,
`gemini-3.5-flash`, `gemini-3.1-pro-preview`, `grok-4.5`, `kimi-k3` and `kimi-k2.7-code`.

Those lists were read on 21 August 2026. What is available to you depends on your subscription, and
vendors change their offerings often. remit maintains no compatibility matrix, so check the sources
above for what your subscription includes today.

## Take a contribution

A repository running remit accepts contributions the way remit does: the installer lays down
`CONTRIBUTING.md` and keeps it current, and that file — not this page — is where the route is
stated, including which of your own gate files it sends a contributor to read.

remit takes its own contributions that way. Read the file it installs:
[`CONTRIBUTING.md`](CONTRIBUTING.md).

## Know the boundary

remit is not a project management system. Nothing in it ensures scope, timelines or deliverables.
It does not prioritise work or decide whether the result is good. It makes each state change and
authority decision a Git record with a named decision-maker.

## Place remit beside AIDOS

[AIDOS](https://github.com/shobman/aidos) is a separate system, complementary by design. It suits
organisations that start, park and resume work as teams, helping them define work, collaborate with
discipline, and establish that work is warranted before development starts. remit sits on the
engineering side. AIDOS can bound it, or the two can operate completely adjacent to each other.

## Read the licence

remit is MIT licensed. See [`LICENSE`](LICENSE).
