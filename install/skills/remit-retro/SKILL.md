---
name: remit-retro
description: 'Turn rulings the practitioner actually made into rubrics in this repository''s .remit/rules/ folder. Use only when he calls one — "let''s do a retro", "retro time", "run a retro", "let''s look at what we learned", "turn that into a rule", "should that be a rubric?" — and use it then. This is the only door to that folder: no other convention, and no session, proposes a rubric anywhere else.'
---

# Retro

The practitioner has called a retro. Read back the rulings he made, propose in one batch what
they would add to or prune from `.remit/rules/`, write only what he rules, commit, and stop.

**AI never offers a rubric anywhere else.** Not at a verdict, not at a closure, not when
something looks like it keeps recurring, not "while we're here". An offer is cheap to make and
expensive to judge, and protecting him from that is the whole point of putting the door here. If
this skill was not called, there is nothing to propose.

## Read his rulings — his words, never your inference

The session you are in: every place he ruled something, in the words he used. Not what he seemed
to want, not what a pattern in the work suggests he would want, not a preference you inferred
from what he accepted.

The archive too, but only if he asks for it. Rulings recorded there sit in each item's `log.md`
as `ruled: <his words, dated>`:

```sh
grep -rn 'ruled: ' .remit/work-items/.archive/*/log.md
```

A ruling with no words of his is not a ruling. Leave it out.

## Propose the whole batch at once

Lay the folder down first if it is not there — this writes the empty shape and one rubric, and
never overwrites a file that exists:

```sh
sh "$(git rev-parse --show-toplevel)/bin/remit" rules init
```

Then put one list in front of him, grouped by gate file and by section within it: what would be
added, and what would be pruned — a rubric that has stopped matching how he actually rules is
worth removing, and a retro that only ever adds is a ratchet. Against every proposal, quote the
ruling it came from and its date. A proposal with no ruling behind it does not go on the list.

One batch, one pass. Do not walk him through them one at a time.

## Write only what he ruled

Write his words into the files he ruled on, and nothing else — not the ones he passed over, and
not a tidier version of what he said. The line form and what each section does are in
`bin/remit`'s header; read it before writing and follow it exactly, because `bin/remit` refuses
the whole folder when one line in it cannot be read.

Check that it can be read, then commit the folder alone:

```sh
sh "$(git rev-parse --show-toplevel)/bin/remit" list >/dev/null   # refuses, naming file and line, if one cannot be read
git add .remit/rules && git commit -m "remit: rubrics ruled in a retro"
```

Report what those printed, verbatim in substance — a refusal names the file and the line and
means nothing in the folder is being applied — then what was written and what was pruned, and
stop. Do not summarise the session, propose work, or carry anything out of the retro.
