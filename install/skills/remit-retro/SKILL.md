---
name: remit-retro
description: 'Turn rulings the practitioner actually made into rubrics in this repository''s .remit/rules/ folder. Use only when they call one — "let''s do a retro", "retro time", "run a retro", "turn that into a rule", "should that be a rubric?" — and use it then. This is the only door to that folder: no other convention, and no session, proposes a rubric anywhere else.'
---

# Retro

The practitioner has called a retro. Read back the rulings they made, propose in one batch what
they would add to or prune from `.remit/rules/`, write only what they rule, commit, and stop.

AI never offers a rubric anywhere else — not at a verdict, not at a closure, not "while we're
here". If this skill was not called, there is nothing to propose.

## Their rulings, their words

Gather every place they ruled something, in the words they used — never what they seemed to want or
a preference you inferred. The archive too, only if they ask:
`grep -rn 'ruled: ' .remit/work-items/.archive/*/log.md`. A ruling with no words of theirs is not
a ruling; leave it out.

## One batch, one pass

Lay the folder down if absent — `sh "$(git rev-parse --show-toplevel)/bin/remit" rules init` —
then put one list in front of them, grouped by gate file and section: what would be added, and
what would be pruned, because a rubric that has stopped matching how they rule is worth
removing and a retro that only ever adds is a ratchet. Against every proposal, quote the
ruling and its date.

## Write only what they ruled

Their words, into the files they ruled on, in the line form `bin/remit`'s header fixes — read it
before writing. Then check the folder still reads, and commit it alone:

```sh
sh "$(git rev-parse --show-toplevel)/bin/remit" list >/dev/null
git add .remit/rules && git commit -m "remit: rubrics ruled in a retro"
```

Report what those printed, verbatim in substance — a refusal names the file and line and means
nothing in the folder is applied — then what was written and pruned, and stop. Do not
summarise the session, propose work, or carry anything out of the retro.
