# remit

Keep practitioner-directed AI work in Git. You decide what starts, what stops, who builds it, who
judges it, and when it leaves your attention.

AI can produce work faster than you can judge it. remit records every piece of work you admit, in
your words, with the boundary you gave it, and lets it continue or wait without you. A separate
context judges the result before you read it. remit asks for your judgement only where it is
genuinely yours, and it does not nag you for it. It is three POSIX scripts and seven conventions;
there is no service to operate. Why it exists, in the practitioner's own words:
[MANIFESTO.md](MANIFESTO.md).

**Version 0.3.20.**

## Start by talking to your agent

You do not learn a command set. You say what you want in your own words to the agent you already
use, and the installed conventions do the rest: each one recognises a kind of request, runs the
command, reports what it printed, and stops. It does not rank, propose, elaborate, or raise
anything later unasked.

| You say something like | The convention | What it does |
|---|---|---|
| "file it", "park this", "create a brief for X", "take it to refined" | admit | settles a short brief with you and records it |
| "pick up X", "take it to accepted", "stop it" | resume | moves an item as far as you said, or ends a running chain |
| "where are we", "catch me up on X" | status | the board, or one item read from its record and the code |
| "close it", "we're not doing this" | close | archives the item on your word |
| "what's standing", "did we fix X", "attest" | review | the findings still standing, and one context's word on the code now |
| "let's do a retro" | retro | turns rulings you made into rubrics |
| "how much have I said today" | exposure | the words you typed and the words said back |

## Your first work item

Tell your agent: "Create a work item for retrying failed uploads and take it to refined." It
follows the admit convention: reads the bar for `refined` in your repository's own rules, asks you
once for anything the brief is missing, and runs

```sh
sh bin/remit new retry-failed-upload --until refined
```

That records your brief under `.remit/work-items/retry-failed-upload/`, commits it, runs the chain
in the background as far as `refined`, and reports where it stopped. If you only wanted it written
down, say "park it": the brief is filed and nothing runs.

Later, say "Catch me up on retry-failed-upload." The status convention reads the item, its record
and the current code, and moves nothing. Then say "Take it to accepted." The resume convention
runs

```sh
sh bin/remit resume retry-failed-upload --until accepted
```

A builder authors the change in its own worktree, the mechanism turns that into a draft pull
request, and an evaluator that did not write it judges the delivery. If the evaluator asks you a
question, the item stops and waits. Answer in the conversation; your agent records your exact
words and resumes:

```sh
sh bin/remit answer retry-failed-upload 1 "Show the second failure to the user."
```

Your words go verbatim under `## Rulings` in the brief, beside the question, and the chain resumes
at the stage it is at. If it asked two questions, answer both in the one command, each number with
its words; every ruling is filed and the chain resumes once, after the last. A ruling is not an amendment: editing the brief by hand puts the stage back
to `new` so the first gate judges it again; an answer adds the decision the brief was missing and
costs nothing else. Every later context is told the rulings are settled ground. The agent driving
remit for you is the conductor, and it may answer some questions itself, under a file you write;
a section below says when.

Merging the pull request is yours. When you decide the work is over, say "close it." The close
convention shows you every finding still standing, asks which links shipped the work, and runs
`sh bin/remit close retry-failed-upload`. The item leaves the board and its folder moves to the
archive. From then on remit treats the code, not the brief, as the law: the brief was a means to
that end, and it does not return as context in a future session unless you ask for the history.

## How far to take it

An item has four stages and three approval gates. One word on the brief, `until`, says how far it
may travel without you; the chain stops at that stage, or earlier where it needs your judgement.

| You said | What happens |
|---|---|
| "park it" | the brief is filed; nothing runs until you resume it |
| nothing about how far | it runs only if a rubric of yours can carry it past the first gate |
| "take it to refined" | the brief is judged, and the research if it asked for one |
| "take it to accepted" | a delivery is built, judged, and its pull request taken out of draft |
| "take it all the way" | the closing gate judges the record; if it passes, the item closes |
| "... and rest there" | it runs to that stop and parks; no rubric carries it further |

"Pick it up" with no stop recorded on the item, and no rubric that could carry it, is refused:
`remit resume` exits 2 and names `--until`. Your agent relays that refusal and asks how far; it
never invents a stop.

`remit close` is different: it is your word that the item is over, at whatever stage it reached. It
does not take the item through the closing gate.

| Into | What the gate judges | Who fixes what it finds |
|---|---|---|
| `refined` | the brief, and the research when there is one | the brief: you. The research: a fresh researcher |
| `accepted` | a delivery: a builder's tree, as a draft pull request | a fresh builder, four rounds at most |
| `closed` | the record, every verdict and note on it | a fresh builder, if anything |

A gate is a fresh context that did not author the work, judging it against your brief and the
rubrics in `.remit/rules/<gate>.md`. Put the evaluator on a different model family from the builder:
a model favours its own output ([Panickssery et al., 2024](https://arxiv.org/abs/2404.13076)), and
a judge from another family does not share that bias. Agreement is never verification,
so the proof a builder ran is kept in the item's `runs/` folder where the next gate can read it.

The loop is bounded. A builder gets four rounds at a gate. The same must-fix twice stops it. A
must-fix that comes back after being displaced stops it, because the brief is arguing with itself.
A delivery past 2,000 files or 100 MB is not committed at all. Every stop is one entry on the
record, and an escalation raises nothing and proposes nothing: the verdicts above it are the
analysis, and what the brief needs is yours to work out.

## What reaches you, and when

Almost nothing. A chain runs as a backgrounded task and its end is its only event; nothing watches
the record while it runs. Ordinary completions wait in your transcript. One stop reaches you where
you are: when an evaluator asks a question only you can answer, your agent sends one line by
whatever its harness has for that, naming the item and the first question. Everything else waits
on the record until you ask where things stand:

```sh
sh bin/remit list            # the board: attention, stage, why it stopped, item, title
sh bin/remit list --parked   # the parked work
```

When a turn does need your word, your agent gives it to you in one fixed shape: what happened,
what was expected, what actually happened, your options from the verbs, and one recommendation.
Where the record and the verbs offer nothing, the options are simply absent.

## When your agent may answer for you

The agent driving remit for you is the conductor. It may answer a question for you only when
`.remit/elevation.md`, a file you write in your own words, allows it; without that file it rules
nothing. The file is for answers the record or the code already determines, and rulings that change
neither the item's outcome nor its boundary.

The mechanism bounds the conductor without reading the question: two conductor rulings on an item
since your last word, and the third is refused as yours; a question it already ruled on is refused
to it when it returns. Every conductor ruling is recorded as provisional and remains yours to
supersede.

## What a verdict leaves behind

A verdict passes, passes with findings, or fails with a must-fix. A must-fix goes back to a fresh
author with the finding and nothing else. Within a gate, a finding is disposed of only by a rubric
the evaluator cites: one in the gate file's `accept` section accepts it, one in `fix` makes it the
must-fix. A finding no rubric disposes of stands. Closing an item seals every finding its last verdict at each
gate still carried as pre-authorised, and says how many: that is what the closure did, never a
ruling you made on each one.

## Review what passed, then improve the rules

remit can take work all the way to closed when it passes your rubrics, so some of it passes
without your attention. remit is fix-forward: work that passed can be corrected later, and that is
fine. `review` is how you see what passed you by.

```sh
sh bin/remit review                       # every standing finding, every item, open or archived
sh bin/remit review today
sh bin/remit review week
sh bin/remit review since 2026-09-01
sh bin/remit review <slug> ...
```

One row per finding: item, stage, gate, verdict date, number, first line, and the delivery it stood
against. No ranking and no proposal. Add `--attest` and one fresh context is raised in your
repository at HEAD to say of each finding whether it still stands, is fixed, naming the commit or
file, or is moot because the code it was about is gone. The attestations are written to every
item's record, the archive included, and the counts printed. A finding attested fixed leaves the
set; the rest are yours to admit as an item or leave.

Then rule on what you saw, in the conversation: what should not have passed, what should have
continued without you. Those rulings, and the ones you made where work held your attention, are
what a retro gathers. It proposes what they would add to `.remit/rules/` and what they would
prune, because a rubric that has stopped matching how you rule is worth removing. It writes only what you rule, commits the folder alone, and stops. No
convention proposes a rubric anywhere else, not at a verdict and not at a closure.

A rubric is one line under one of four headings in a gate file: `promote` carries an item past the
gate whatever `until` said; `hold` stops it for your eyes whatever else was cited; `fix` names the
standard a delivery missed; `accept` disposes of a finding. An evaluator cites a rubric by its id
and the evidence; a citation of a rubric the file does not carry changes nothing. A rubric must
reach past the item it came from, and it carries no date and no account of the incident: a rule
is a rule, and git holds the history.

Try one session in this order: review what shipped without you, make your rulings, then call a
retro and let your conductor advise you on the rubrics.

## The boundary

remit never starts work, merges a pull request, decides on your CI's result, rewrites your brief,
or declares work over for you. It never raises a context on a seat you did not register, never
falls back to another when that seat refuses, and never lets a builder raise sub-agents of its own.

It runs fresh agent contexts on your repository using the agent accounts already logged in on
your machine. It passes through none of your API keys, tokens or SSH material, and gives each
context a scratch home; a scratch home is not isolation. Only Codex supplies an enforced
filesystem sandbox; Claude Code, Devin, Copilot CLI and Pi run as your user and can read what you
can read. remit applies the containment each agent exposes and
records on every pull request which applied; a sandbox for every agent is the direction, and the
reference below says exactly what holds today.

`sh bin/remit stop <slug>` ends a running chain and every context it raised, discards the
worktree's in-flight changes, and leaves the item at the stage it last stopped at. A failure leaves
the record with the reason as its last entry, the item's worktree beside your repository, and the
branch and draft pull request if a delivery got that far; nothing is merged, and only your own
`stop` discards anything.

**What remit records.** Every raised context, with its agent, its model and its cost where the
agent reports one. And the cost of holding your attention: `sh bin/remit-exposure today` reports
the words you said and the words you were told, kept separate and never turned into a score.

## Install and upgrade

Fetch the published installer without cloning remit:

```sh
curl -fsSL https://raw.githubusercontent.com/shobman/remit/main/get-remit.sh | sh -s -- /path/to/your-repository
```

To read the script before you run it, fetch it and run it separately:

```sh
curl -fsSL https://raw.githubusercontent.com/shobman/remit/main/get-remit.sh -o /tmp/get-remit.sh
sh /tmp/get-remit.sh /path/to/your-repository
```

To pin the bootstrap to this release, place `REMIT_REF=v0.3.20` immediately before `sh`, the
last command in the pipeline, so `get-remit.sh` receives the variable:

```sh
curl -fsSL https://raw.githubusercontent.com/shobman/remit/main/get-remit.sh | REMIT_REF=v0.3.20 sh -s -- /path/to/your-repository
```

If you already have a remit clone, run its installer directly:

```sh
sh /path/to/remit/install.sh /path/to/your-repository
```

The target must be inside your repository's primary worktree; a linked worktree is refused. The
installer needs only Git and a POSIX shell; on Windows, use Git Bash's `sh`. Run every remit
command through `sh` the same way.

Then seat your agents. `sh bin/remit setup` reads the host and proposes `.remit/settings.json`,
the registry of which agents and models each role may use, for you to accept or edit;
`sh bin/remit setup --write` saves it. Never redirect `setup` over the registry; it reads that
file first. Write `.remit/elevation.md` yourself if you want the conductor to rule for you;
nothing installs it.

Re-run the installer to upgrade. It replaces content that still matches any copy remit ever
installed, keeps your local edits, and reports each result. It also runs the seam's own check of
`.remit/settings.json` and reports the registry line, so an unknown seat is named at install, not
at the first chain. Two files have their own rule: `CONTRIBUTING.md` is
the one file remit manages, so a local edit to it is restored, while a `CONTRIBUTING.md` the
repository already had is kept; and the shipped rubrics are migrated one rubric at a time, adding,
changing and removing only remit's own and keeping every rubric you wrote. Every installed file is
listed in `.remit/.install/manifest`. There is no uninstaller: removing remit is removing what the
manifest names.

## Reference

### Commands and exit codes

You do not run these yourself: the installed skills choose and run them from your words, then
relay what happened. remit is mechanical where it can be, with skills that use the mechanics. It
is not vibes, it is discipline.

```text
sh bin/remit new <slug> [--until refined|accepted|closed] [--park]   admit, from the brief on stdin
sh bin/remit resume <slug> [--until <stage> [--park]]                 run the chain as far as you said
sh bin/remit answer <slug> <n> "<words>" [<n> "<words>"...] [--conductor]   rule on every question given, then resume once
sh bin/remit park <slug> | stop <slug> | close <slug>                 rest it; end its chain; archive it
sh bin/remit list [--parked]                                          the board
sh bin/remit review [today|yesterday|week|since <date>|<slug>...] [--attest]
sh bin/remit report new|close <name>                                  a field report, in or out
sh bin/remit rules init                                               the gate files remit ships
sh bin/remit setup [--write]                                          propose or save the registry
sh bin/remit migrate | version                                        move a pre-work-items layout; the installed version
sh bin/remit-exposure today | session <id> | trend | scan <agent>     the words said and told
```

Exit 0: done, committed, and pushed where a remote exists; a chain that stopped where it was told
to is 0. Exit 2: usage or precondition error, nothing changed. Exit 3: committed locally, push
failed. Exit 4: escalated; the stage is unchanged and the record says why. Exit 130: a running
chain was ended.

### What the installer places

| Path | Purpose |
|---|---|
| `bin/remit` | Lists items and performs state changes. |
| `bin/remit-invoke` | Raises a fresh context in a registered seat and returns its text. The only thing in remit that raises one. |
| `bin/remit-exposure` | Counts the words you typed and the words said back. |
| `.claude/skills/`, `.agents/skills/`, `.pi/skills/` | The seven conventions, in the discovery path each agent reads. |
| `AGENTS.md` | One marker-delimited section, without replacing existing content. |
| `CONTRIBUTING.md` | How this repository takes a contribution. |
| `<git>/hooks/pre-push` | The guard, when no hook exists; any other hook is kept and reported. |
| `.remit/hooks/no-agent-tool.sh`, `.github/hooks/remit-no-agent-tool.json`, `.claude/settings.json` | The sub-agent guard and its registrations; the Claude Code one is offered, never overwritten. |
| `.remit/` | `work-items/`, `field-reports/`, and `rules/` with the rubrics remit ships. |
| `.remit/.install/manifest` | What was installed, at what version. |

### The five agents remit runs on

| Agent | Conventions land at | An unknown model id |
|---|---|---|
| Claude Code | `.claude/skills/` | no catalogue to check; the run's own report names what served it |
| Codex | `.agents/skills/` | no catalogue; the run header names what served it |
| Devin | reads `AGENTS.md` and `.agents/skills/` natively | rejected before the run starts |
| GitHub Copilot CLI | reads `AGENTS.md` and `.agents/skills/` natively | refused before the run, as is a reasoning effort the model lacks |
| Pi | `.pi/skills/` | refused unless `pi --list-models` carries it; runs local models too |

Model lists are perishable, so none is printed here. Codex caches its visible ids in
`~/.codex/models_cache.json`; Pi answers `pi --list-models`; Devin answers `devin models list`;
Copilot CLI lists the ids it accepts under `copilot help config`; Claude Code exposes no
catalogue. A seat that refuses, out of credits or not authenticated, marks the host for thirty
minutes and no chain raises into it while the mark is fresh.

### Agent containment, as it holds today

Codex: an enforced sandbox, its own files and nothing else, read back from the run's own header
after every run and refused on a downgrade. Claude Code: its sub-agent tool denied by flag and by a
hook written for the run. Devin: an allow list written for the run, which ends the run on anything
outside it. Copilot CLI: a hook against `git` and `gh` in any wrapping, tested by a throwaway run
before the real one. Pi: built-in tools only, extensions off. Every context starts with an emptied
environment and an allow-list: your `PATH`, a scratch `HOME` removed after the run, a scratch temp
inside its own worktree, and the one configuration directory its CLI needs to log in as you. A
context never runs `git` or `gh`; the mechanism does, as you.

### Host notes

- **Windows.** A raised context's `USERPROFILE`, `APPDATA` and `LOCALAPPDATA` point at the raise's
  scratch, so a tool that installs itself lands there and goes with the run. A worktree that opens a
  listener trips Windows Defender Firewall's prompt once per path; `Set-NetFirewallProfile -All
  -NotifyOnListen False` in an elevated PowerShell ends that. WSL on a clone kept on the Linux
  filesystem avoids both.
- **Linux.** `ssh` inside a raise has none of your keys, known hosts or config; a host a build must
  reach gets a `Host` stanza in `/etc/ssh/ssh_config` naming `IdentityFile` and
  `UserKnownHostsFile` under your real home. Ubuntu 24.04's `gh` (2.45) cannot `gh pr edit`;
  remit writes the pull request body over REST when that call fails.

### Contributions and licence

A repository running remit takes contributions the way remit does: the installed
[`CONTRIBUTING.md`](CONTRIBUTING.md) states the route. remit is not a project management system:
it ensures no scope, timeline or deliverable and decides nothing about whether a result is good;
it makes each state change and authority decision a Git record with a named decision-maker. remit
is MIT licensed: see [`LICENSE`](LICENSE).
