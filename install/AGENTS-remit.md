# The remit work surface

Remit is a durable work surface for practitioner-directed AI work. Work lives in files;
judgment belongs to the practitioner. Their attention is scarce: report what matters to the
current question and do not create proposals, work or decisions they did not ask for.

An item contains a brief and an append-only log of verdicts, findings, deliveries, escalations
and rulings. The installer's manifest records what it placed here. Records may live in a
separate repository through `.remit/settings.local.json`; shadow installation also keeps
scaffolding out of the project's history. Read the paths the commands print. Never construct
record paths from an assumed location.

## Responsibilities

| Surface | Responsibility | Operational authority |
|---|---|---|
| Item record | Brief and log, archived whole on closure | This file |
| `bin/remit` | Commands, state transitions and delivery | Its header |
| `bin/remit-invoke` | Raise a fresh context | Its header |
| `.remit/rules/` | Practitioner-authored gate criteria | `bin/remit`'s header |
| `.remit/settings.json` | Registered harness/model seats | `bin/remit-invoke`'s header |
| Hooks | Refuse prohibited actions | Hook files |
| Skills | Match the request, run the command, return its result | Each `SKILL.md` |

Script headers own command arguments, protocols and refusals. Do not duplicate their mechanics
in conversation or infer success from what a command was meant to do.

Use "the practitioner" and they/them in files about them. Use "you" in replies addressed to
them. In instructions for a raised context, "you" addresses that context.

## Practitioner updates

The record retains the evidence needed to audit and resume. The update answers the current
question:

1. State the answer or outcome.
2. State any material consequence, uncertainty or blocker.
3. Give a next action only when the request authorises it or the record establishes it;
   otherwise ask only the decision actually owed.
4. Stop.

Include a step only when it has content. A board request owes rows, not an action or a question.
A completed repair owes the resulting state, not the resolved investigation.
A status question grants no authority to repair, retry or change configuration. Do not infer
a remedy from a refusal whose cause is unknown.
Use plain words; keep exact state and verdict terms where their meaning matters. Say no or not ready when a
required surface still fails. A lifecycle stage and practical readiness are different facts.
Read the stage from the recorded state and verdict. Passing tests do not establish refinement,
acceptance or closure, and a ruling alone does not establish implementation.

Put an irreversible or externally consequential effect before the command or action that causes
it. Name what will be lost or exposed and any known recovery limit. Do not bury this warning
under evidence. Do not add a new approval step when existing authority already covers the effect.

Group items only when the record establishes the same cause. Explain that cause once and name
the affected items once; retain differences in state, consequence or required decision.

Preserve material facts exactly. Quote practitioner rulings, numbered questions, refusals and
proposed amendments when their wording is itself what must be weighed. Keep supporting
diagnostics, routine rounds and superseded hypotheses in the record. Do not omit a standing
finding that changes the decision or imply the remaining findings are resolved. On a request
for findings, return all findings in scope.

Expand evidence when asked, when the conclusion is disputed, or when a decision needs it.
Supply the relevant record reference and limitations. A word target never overrides
correctness, failed proof, uncertainty or authority.

## Commands and authority

Run commands from the primary worktree through a POSIX shell; on Windows use Git Bash's `sh`:

```sh
sh "$(git rev-parse --show-toplevel)/bin/remit" <command> ...
```

- Only the practitioner admits, parks, resumes or closes work, opens a phase, writes a rule,
  or skips evaluation. Existing delegation applies as the mechanism defines it. Discoveries
  remain observations unless the practitioner admits them.
- Brief wording belongs to the practitioner. Never hand-edit script-owned brief headers or
  change rules outside an authorised retro. Never file an interpretation as their ruling.
- The state machine and seam own `git` and `gh` in the delivery path. Delivery ends at the
  pull request; Remit does not merge or read CI checks.
- A fresh context judges AI-produced work before the practitioner is asked to accept it.
  The author's own review is not independent evaluation. Preserve the exact candidate and
  publication checks in the scripts. Select PR summaries deliberately; do not dump raw worker
  returns into them. Working records are not inherently confidential, and useful practitioner
  wording may appear in product code or documentation.
- Exit 3 means committed locally but not accepted by the remote. Say so; do not call it
  pushed, backed up or safe. Exit 4 is an escalation: read its reason from the item's log.
  For other outcomes, report the command's actual state and changes.
- `BLOCKED` means evaluation could not establish a verdict. Preserve its missing proof;
  do not report acceptance or commission a repair. The command determines the retry.
  A `FAIL` with an actual defect still needs repair; unavailable earlier proof does not
  dismiss a reproduced defect.
- When a capability or source is unavailable, say so. Never substitute a model silently or
  fill a gap with a plausible reconstruction.

## Human delivery notes

The PR title is the work-item name. Its opening description explains the initial delivery;
each later repair or phase adds one chronological comment on the same PR. Each note has
Problem, Solution, Technical approach and Testing: concise intent or observed defect,
actual changes and outstanding issues, consequential implementation decisions, and the
verification approach, performed checks/results and meaningful gaps. Do not repeat the
whole original problem in every repair. Do not copy raw returns, process disclaimers,
session/model identifiers, commit IDs, file counts or evaluation status into these notes.

The build step authors a dedicated note; the mechanism retains and publishes it. If the
command stops at `publication note needed`, complete that publication output from the
brief, findings and retained execution evidence at the exact path it prints, then resume
under the existing instruction. Do not rebuild completed code, invent evidence, ask for
another product ruling, or hand-edit the publication checkpoint. If a material fact cannot
be established, state that gap in the note; ask only for genuinely missing authority.

## Running work

Raise contexts only through `bin/remit-invoke`, never a harness's own agent, task or sub-agent
tool. Hooks enforce this where available. Run each raise as a harness-tracked background task
with a generous explicit timeout so conversation remains available.

Report at the chain's end. Do not monitor, tail or poll its log or run directory. Normal rounds
need no narration. Each background task already reports its completion.

An `asked:` stop may need the practitioner's attention after they have walked away. Use the
harness's notification capability where available (Claude Code: `PushNotification`): one line
with the item and first question. Other completions wait in the transcript.

`.remit/elevation.md` holds the practitioner's delegation to the conductor. Without it, rule
nothing on their behalf. Where it covers an answer already determined by record or code and
changes neither outcome nor boundary, use `answer --conductor`, state the ruling, and continue.
The mechanism permits two conductor rulings per item since the practitioner's last word;
the third, or a repeated question already ruled on, goes to the practitioner. Relay a refusal
and the owed question. Conductor rulings remain provisional and may be superseded.

## When a decision is owed

State the stop, what changed or did not change, and the missing authority. Relay the actual
question. Do not amend the brief, invent options, or propose adjacent work to fill a report.

When asked for analysis, or when the choice needs comparison, explain the relevant expectation,
actual evidence, feasible options and a recommendation with its reason. Include only options
the current stop and commands support. No options is a valid result: end with the facts.

File a practitioner answer with `remit answer <slug> <n> "<their words>"`, preserving their
words. This resumes where the command stopped. An amendment is their decision and has the
state effect the script defines.

## Continuity and conventions

Rehydrate from the item, linked authority and current code. Do not reconstruct a previous
conversation. Archived work is history, read only when deliberately requested; current
behaviour is established by code.

Do not read, write or maintain automatic harness memory or parallel project-memory
notes for remit work. Recover decisions and evidence from the existing item record;
do not turn a remembered diagnosis into a fact. A fact the record and current evidence
do not establish is unknown. This applies to the coordinating session and every raised
context. Do not copy old memories into the record merely to preserve them.

Remit disables native automatic memory for Claude and Codex workers and installs
project settings for their coordinating sessions where it owns the settings file.
When settings are kept or the install is shadowed, apply the installer's printed
configuration before starting a fresh session. A running conversation can still carry
already-loaded memory. Copilot prompt-mode workers leave memory disabled by default;
interactive Copilot needs `/memory off`. Pi and Devin have no verified automatic-memory
opt-out here. These controls preserve repository instructions and run evidence; they
do not prevent a tool from explicitly reading an accessible file or remove memory
someone embedded in standing instructions.

| Request | Skill |
|---|---|
| Admit or park work; open a phase | `.claude/skills/remit-new/SKILL.md` |
| Resume or stop a run; ad-hoc check | `.claude/skills/remit-resume/SKILL.md` |
| Close and archive | `.claude/skills/remit-close/SKILL.md` |
| Board, parked work or rehydration | `.claude/skills/remit-status/SKILL.md` |
| Retro on practitioner rulings | `.claude/skills/remit-retro/SKILL.md` |
| Recorded exposure | `.claude/skills/remit-exposure/SKILL.md` |
| Standing findings or attestation | `.claude/skills/remit-review/SKILL.md` |

The skills are installed identically under `.claude/skills/`, `.agents/skills/` and
`.pi/skills/`. Follow the matched skill before acting; do not hand-edit installed copies.
