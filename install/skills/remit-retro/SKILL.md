---
name: remit-retro
description: 'On a called retro, examine actual practitioner rulings and propose one compact batch of additions or pruning, routing each lesson to its useful home. Use for "retro", "turn that into a rule" or "should that be a rubric". Rubric changes require the practitioner’s ruling.'
---

# Retro

Read the actual rulings and their words; do not infer preferences. Consult archived rulings
only when the practitioner asks. A retro is the only convention that proposes rubric changes;
do not offer one at a verdict, closure or an unrelated turn.

## One batch

For each lesson, choose one home: a gate rubric, executable check, environment/configuration,
item authority, or no durable change. Prefer a check or environment correction for a repeated
operational failure that prose cannot prevent. An item-specific ruling stays with that item.
A lesson may remain only a field report.

Present one compact batch of proposed changes and pruning, quoting the supporting ruling and
date. Remove duplication before adding a rubric. A gate criterion must change whether future
work continues, stops, is accepted or needs repair; explanatory speaking style is not a gate.
Preserve existing IDs and compatibility. Say briefly which lessons need no durable change.

A proposal for a check or environment change does not create new work or authorise its
implementation. Ask only for the actual unresolved ruling.

## Apply the ruling

Write only the rubric changes the practitioner approves. Read `bin/remit`'s header for the
line format. Initialise the folder only when needed:

```sh
sh "$(git rev-parse --show-toplevel)/bin/remit" rules init
```

Rubrics contain their approved words, without incident history or dates; the proposal and
commit retain provenance. Validate and commit only that folder:

```sh
sh "$(git rev-parse --show-toplevel)/bin/remit" list >/dev/null
git add .remit/rules && git commit -m "remit: rubrics ruled in a retro"
```

A validation refusal names the file and line; do not commit invalid rules. Report what was
written or pruned and any failure. Do not recap the session or propose further work.
