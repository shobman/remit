---
name: evaluate-work
description: Have AI-produced work judged by a fresh context that did not author it. This happens by default for work produced for the practitioner's acceptance — skipped only when the practitioner has asked to skip it or delegated a policy saying otherwise, never on your own judgment of proportionality. Use before asking the practitioner to accept AI-produced work, when they ask for work to be checked, verified, reviewed, or assessed independently — "get it verified", "have someone check it", "is this any good", "evaluate the PR" — and to send a must-fix back to a builder and have the changed work judged again. Record the verdict with the work item where one exists.
---

# Verify

Work AI made is judged before the practitioner is asked to accept it — by default, not on request.
A context that did not write it and did not watch it being written judges it. You brief that
evaluator, record what it returns with the work item where one exists, and relay it. You do not
judge, and the evaluator does not repair.

## When work gets evaluated

Independent evaluation is the default. An outcome produced for the practitioner's acceptance — an
artifact, a product change, a worker's returned result — is evaluated before you ask them to accept
it, not after they have. It is skipped only when the practitioner has asked to skip it or has
delegated a policy saying otherwise. Their proportionality ruling is not yours to make: never skip
evaluation on your own judgment of what the work warrants.

Your own reading of a result is not this. Checking a returned result against what it was briefed
from is `dispatch-work`'s integration check: it decides what you carry forward, and you watched the
work happen, so it is not a verdict. The author cannot provide independent evaluation — a worker
cannot evaluate what it built, and neither can the conversation that briefed it, nor the
conversation that wrote the work itself when no worker was used.

**Batched where proportionate.** One evaluator may take several deliveries at once when they answer
to the same authorised outcome, boundary, and accepted inputs, and when it can still hold each one's
criteria without blurring them. Batching shapes how evaluation happens; it does not decide whether
it happens, and it is never a reason to omit a delivery due for evaluation. When in doubt, one
evaluator per delivery.

Closed work is not evaluated; `.remit/.archive/` is history. A verdict that arrives after the
practitioner has already accepted or merged is still returned and, where an item exists, recorded.
The evaluation remains part of the story, not a gate that expired.

If this harness cannot raise a fresh context, say so plainly and let the practitioner decide how to
proceed. Never substitute your own judgment for the evaluation and never call it one.

## Every route it arrives by, and what holds each

The section above says *when*. This says *by what route*, because a delivery reaches the
practitioner by more ways than a pull request, and the ordering is worth no more than the weakest of
them. **One route is held by mechanism. Every other is held by your restraint, and is named here as
that** — remit does not dress instruction up as enforcement.

One distinction decides all of them: **telling them a delivery exists is not putting it in front of
them.** What was built, that no fresh context has judged it yet, and where it will appear once one
has — that is status, and status is never withheld. The page, the file, the diff, the demo, the
account that reads as *here it is, what do you think* — that is the ask, and the ask waits for a
verdict.

- **The pull request** — a worker's authored tree, turned into one by the dispatch wrapper, with the
  worker's own returned words carried into its body. **Mechanism** — the only one. The wrapper opens
  it as a draft and the relay step below is the only thing that takes it out. Nothing else in this
  list has an equivalent, and nothing here changes what that mechanism already is.
- **A built preview, or a running thing** — a page built out of `dist/`, a command's output, an
  application on screen. **Instruction, disclosed.** No build step knows what a verdict is, and none
  is being taught one. Build it for yourself and for the evaluator; show it to the practitioner
  once the verdict exists.
- **A file handed over** — a path you name, a document you point at, an attachment. **Instruction,
  disclosed.** Their own work surface is theirs to read whenever they like: a brief, an item's
  record, the repository as it stands. It is *the delivery* — the thing AI made for their acceptance
  — that waits.
- **A summary in this conversation** — your account of what a worker returned, or of what you built
  yourself. **Instruction, disclosed.** The hardest route to notice, because nothing is opened and
  nothing changes hands; it is also the one by which this ordering has actually broken.
- **Work you carried out yourself, live, in their tree** — no worker, no branch, no pull request.
  **Instruction, disclosed, and the weakest of them.** There is no seam here at all: the change is
  already where they can see it. This route is why `dispatch-work` has to say that working directly
  changes no evaluation rule.
- **A branch, a merge, a published release** — anything reached through `main`. **Inherited, and
  only inherited.** Whatever held the route into `main` is the whole of what holds this. The push
  guards lint authorship, not verdicts, and publishing repeats what was already there; neither adds
  a gate of its own, and neither may be reported as one.

A route that is not in this list is unheld. If you meet one, say so to the practitioner in the
moment rather than deciding by yourself that it does not count.

**When they ask first.** They may ask to see something before any verdict exists. That is theirs to
ask and not yours to refuse: show them, and say plainly, in the same breath, that no fresh context
has judged it yet. Their asking is not the skip — skipping evaluation is still only on their word.

## Brief the evaluator, and state its limits in the briefing

The evaluator gets what you write and nothing else. Carry:

- **Its limits, in full.** It judges; it does not repair. No edits to the work, no commits, no
  review comments, no merging, no work items, no `bin/remit`, no accepting and no closing. It
  reports findings and returns.
- **What to judge** — the delivery itself and where to find it: pull request, branch, files,
  artifact.
- **The work's authority** — where an item exists, its brief: outcome, boundary including what was
  explicitly out, constraints, proof, and where to read it in full. Where the delivery is one phase
  of that item, its authority is the phase's own statement inside the brief's, and that is what the
  evaluator judges it against. For item-less work, carry the authorised outcome and boundary from
  the live collaboration. Do not create an item merely so the evaluation has one.
- **The applicable accepted inputs and criteria** — where an item exists, the authoritative content
  its brief links to; for item-less work, the accepted inputs established in the live collaboration.
  The criteria come from there. You author no rubric; if the accepted inputs do not establish a
  criterion, it is not one, and taste is not a finding.
- **The author's evidence, marked as claims.** Everything the author said it verified is a claim to
  be checked, not a fact to be relied on. Where a worker produced the delivery, that evidence is
  what it returned, carried into the pull request body by the dispatch wrapper — the worker itself
  opened nothing and ran no git (`dispatch-work`).
- **Verify, do not trust.** Re-run what can be re-run, in the evaluator's own scratch space, never
  against the practitioner's work. Check behaviour the author did not claim as well as behaviour it
  did. Where something cannot be checked, say so rather than assuming it.
- **The return contract** — below.

Give it isolation: a fresh context with its own worktree or scratch space. In Claude Code that is
the Agent tool with `isolation: "worktree"`. If the harness has no such mechanism, say so rather
than pretending the evaluator is fresh.

## What the evaluator must never receive

- **The author's working conversation** — its exploration, its reasoning, its account of how the
  work came to be. The evaluator judges what shipped, not the story of it.
- **Your opinion of the work** — your integration check, what you would have done, what you think
  the practitioner wants, whether you expect it to pass. A steer is contamination, and a
  contaminated verdict is worth nothing.
- **Pressure** — how long the work took, that the practitioner is waiting, that a decision hangs on
  it.

On a re-evaluation it receives the must-fix that sent the work back and the changed work. It does
not receive the earlier evaluator's other notes, or the builder's account of the repair.

## The verdict and findings it returns

One verdict:

- **PASS** — the authorised outcome is delivered, the boundary held, the constraints were honoured,
  the proof holds, and nothing was found worth writing down.
- **PASS WITH FINDINGS — no must-fix** — the same judgment, with notes recorded. A pass never
  carries a must-fix; findings on a pass are notes.
- **FAIL** — the outcome is not delivered, the boundary was crossed, a constraint was broken, the
  proof does not hold, or any must-fix stands. A must-fix means fix to get a pass; there is no
  passing verdict with one standing.

Findings come in two kinds and no others:

- **Must-fix** — the delivery does not yet stand as satisfying its authorised outcome, boundary, or
  constraints, and the evaluator names exactly what would discharge it. A standing must-fix makes
  the verdict FAIL. A must-fix is often not a code defect: in this repository the commonest has
  been a proof the author substituted for something easier, or could not discharge at all. Work may
  still be sound and mergeable while a must-fix stands against its proof; the evaluator says which,
  and the verdict is FAIL until the must-fix is discharged.
- **Note** — everything else. Real, checkable, non-blocking, numbered. A note is a fact, not a task,
  and it is never phrased as one.

Every finding carries its exact evidence: what was run or read, where, and what happened. "Feels
fragile" is not a finding, and a finding nobody else can check is not one. The evaluator also names
what it could not establish. It describes what is, not what to do — remedies are the practitioner's.

## Record it with the item when one exists

Where a work item exists, the verdict lives with it, not only in this conversation, so a future cold
session finds the whole story in the files. Write `.remit/<slug>/evaluation.md` and commit it with
this harness's session trailers. This is an ordinary file and an ordinary commit; `bin/remit` has no
part in it.

Where no work item exists, return the verdict and findings in the live collaboration. Do not create
an item solely to record an evaluation. If the practitioner later asks to suspend, park, or hand off
the work, recording the context needed for it to survive is outside this skill.

For item-backed work, use this record:

```md
# Evaluation — <slug>

**Delivered:** <what was judged — PR, merge commit, artifact — and when>.
**Phase:** <the phase this verdict judged — omit the line entirely for an item running no phases>
**Evaluator:** independent AI context (did not author the work; did not inherit the author's conversation).
**Verdict:** <PASS | PASS WITH FINDINGS — no must-fix | FAIL>.
**Accepted:** <the practitioner's word, in their words, dated — only once they have given it>

## Evidence basis

<what the evaluator actually ran and read, and what that established>

## Must-fix, and its discharge      <!-- only when there was one -->

## Notes (non-blocking, accepted)

1. <fact, with its evidence>

## Unresolved      <!-- only when something is -->
```

One file per item: every verdict on that item goes into it, in the order it happened — including
each phase's, each saying which phase it judged, so a cold session reads the item's whole story in
sequence and never has to work out which delivery a verdict was about. A phase's verdict judges that
phase's outcome and proof inside the item's, and passing one discharges nothing of the item's own
proof. A discharge is recorded in place against the must-fix it answers, and never changes the
verdict that raised the must-fix — that verdict stands as FAIL as written, and the re-evaluation of
the changed work adds its own. When a must-fix was discharged is context available on request,
never part of a verdict line. Record the evaluator as it returned
— you may cut length, never judgment, and never edit a verdict into agreement. Write the
**Accepted** line only when the practitioner has actually said it; never infer acceptance from a
merge, a passing check, or a clean verdict. Because the file lives with the item, closure archives
it and rehydration finds it.

## Relay it, then hand over

Where the delivery is a worker's work, it arrived as a draft pull request — opened by the dispatch
wrapper over the tree the worker authored — and was judged as one. On a
verdict with no standing must-fix — and, where an item exists, only once that verdict is recorded
with it — take the PR out of draft with `gh pr ready`, so the practitioner's review queue holds only
work a fresh context has passed and GitHub's own refusal to merge a draft makes that mechanical
rather than prose. The flip is yours, acting on the recorded verdict: never the evaluator's, never
the builder's. It is written down nowhere beyond the PR itself — the verdict is already the record,
and the PR's state is only a view of it. Where the two disagree, the evaluation wins and the PR is
what gets corrected. If this harness cannot flip a PR to ready, say so plainly and leave it a draft
rather than reporting a flip that did not happen.

Tell the practitioner the verdict, the must-fix if there is one, and where it was recorded when an
item exists. Then stop. Do not recommend acceptance, argue the verdict, defend the work, or raise
closing. The notes are theirs to read or ignore — a finding they do not promote dies as a finding,
creates no work and no obligation, and is never turned into a work item. If they do promote one,
that is `capture-work`'s job and their admission.

## Send a must-fix back, and evaluate what comes back

A must-fix returns to a builder with the finding and nothing else added: through `dispatch-work`,
briefed from the same item, where an item exists; or from the same live outcome, boundary, and
accepted inputs where none exists. Never the evaluator: it does not repair what it judged.

The changed work is then evaluated again by a fresh context. It may not be the builder that made the
change. Where the must-fix is a proof, the proof is executed by a context with no knowledge of the
sessions that produced the work — that is what makes it a proof. The loop ends when a fresh verdict
passes (PASS, or PASS WITH FINDINGS — no must-fix), or when the practitioner rules it ends; never
on a count of rounds. A FAIL leaves the pull request a draft, and it stays one for the whole loop:
only the verdict that ends it takes it out of draft.

## Where this stops

Nothing here accepts, merges, or closes anything, and no verdict is a threshold that does. A PASS is
information for the practitioner; acceptance is theirs, and closing is `close-work`. Taking a PR out
of draft is neither an acceptance nor a merge: it puts verified work in front of them, and what
happens to it there is theirs.

There is no evaluation ledger, register, score history, or roll-up across items. Where an item
exists, its own `evaluation.md` is the entire verdict record. Verdicts and findings do not appear in
listings. Where an item records a progress stage, the current verdict is the whole of what makes it
verified — a passing verdict with no standing must-fix establishes that stage, and a must-fix
standing against the current delivery withdraws it — and the record you just wrote is where that
reads from; you keep no second account of it. Do not carry a verdict into another item, and do not
evaluate closed work.
