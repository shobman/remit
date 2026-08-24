---
name: remit-new
description: 'Admit a work item in this repository''s .remit/ work location, and say how far it may go without the practitioner. Use on his words for putting something on the durable surface — "file it", "park this", "an idea", "for the backlog", "new work item", "raise an item", "we should eventually ...", "create a brief for X", "take it to refined", "take it to accepted", "take it all the way" — and on his word that an admitted item takes a further part: "next phase is the build", "open a second phase for that". Never to manufacture an item so that something can be started.'
---

# New

The practitioner is admitting work. Help him say it well, run one command, report what it
printed, and stop.

## Ask him first, in the conversation — a brief has two sides

**Every brief is asked what it depends on, whichever side it is.** Ask him once — **does
this depend on any other work item finishing first?** — and write his answer into the brief
as a `**Depends on:**` line, naming those items **by their slugs**, comma-separated. If he
says it depends on nothing, write `**Depends on:** none`; write that only because he said
so, never to fill the gap yourself, and never answer the question for him.

Two things to say back to him when the answer is not a plain slug:

- **A pull request is not an answer.** He may reach for one — "it needs #35". A PR is a
  partial delivery vehicle; the work item behind it is what has to finish. Ask which item
  that is and write the slug.
- **Depending on PART of an item is the smell.** If what he needs is one piece of another
  item rather than the whole of it, that piece belongs inside a work item as a phase — his
  own words, "i'd add it as a phase inside a work item". Say so and take his answer.

`bin/remit` reads that line again before every build and stops the item where it is until
every item it names has closed; what satisfies a name, and what it refuses, are that
script's header to state and are not restated here.

**"File it", "park it", "an idea", "for the backlog"** — file what he wrote, verbatim, with
`--park`. Besides the line above, the only thing you may ask is the universal one, **is there
enough here to evaluate — an outcome a stranger could judge delivered or not?**, and you ask
it once: if he sharpens it, use what he gave you; if he leaves it as it is, that is his answer
and it stands. Nothing else is asked. A parked item moves for nothing, and an idea nobody
could yet judge delivered is allowed to sit at `new`; that is the design working, not a gap
to close.

**"Create a brief", "take it to refined", "with research"** — that side requires him. Read this
repository's own bar before asking anything:

```sh
cat .remit/rules/refined.md
```

Ask him **every** criterion under that file's `## fix` heading that what he has already said does
not satisfy — one question per criterion, in his own words back, here in the conversation. The
universal one above is the criterion every repository ships; a retro he called may have put others
beside it, and each of those is a question too, asked the same way.

When he asks for research, ask two more: **what should the research establish?** and **what should
it hand back?** Write his answer into the brief as a `**Research:**` line — that line, in his
words, is the whole of what makes research run.

Write only what he answered. Never invent an outcome, a boundary, a proof, an acceptance
criterion or a research question, and never fill a gap he left with something plausible: an
unanswered criterion is a question for him, not a blank for you. You may sharpen and structure
his words; you may not widen them, and never invent phrasing he did not use for how far the work
may go — that is his word, from the table below, and nothing else.

Keep it short. A brief nobody would read is not captured.

## Then run the command

Pick a slug from the title: lower-case, hyphenated, a few words.

```sh
sh "$(git rev-parse --show-toplevel)/bin/remit" new <slug> [--until refined|accepted|closed] [--park] <<'BRIEF'
# <Title>

**Depends on:** <the slugs he named, comma-separated, or none>

<the brief, in his words>
BRIEF
```

Which flag comes from what he said, and only from what he said:

| He said | The command |
|---|---|
| "file it", "park it", an idea, for the backlog | `--park` |
| nothing about how far | no flag |
| a stop he named — refined, accepted, closed | `--until <that stop>` |
| a stop he named, and to rest there | `--until <that stop> --park` |

What each of those then does is the item's, not yours: `.remit/rules/` and the header decide it,
and `bin/remit` prints where it stopped.

With `--until`, that command runs the chain itself in the same invocation — it raises real fresh
contexts and takes minutes to hours. **Run it in the background and report when it returns.**
With `--park`, and with nothing said where no rubric could carry it, nothing is raised and it
returns at once.

## When he opens a further part of an item already admitted

An admitted outcome may turn out to take more than one part. Opening one is his, exactly as
admitting the item was. Write the phase file beside the brief — `<phase>.md`, carrying that
part's own outcome, boundary, constraints and proof inside the item's — and point the brief's
`**Current phase:**` line at it. Never touch the `**Attention:**`, `**Stage:**` or `**Until:**`
lines: those are `bin/remit`'s. Commit both together.

A part that changes the item's own outcome or boundary is not a part; take his word on whether
that is an amendment to the brief or a separate item.

## Report it, and stop

Report what the command printed, verbatim in substance — the row it wrote and nothing added to
it. Exit 3 means committed on this machine only and NOT accepted by the remote: say so, and never
describe the item as pushed, backed up or safe elsewhere. Exit 2 means nothing changed at all.
Exit 4 means the chain it ran escalated: it tried to move the item and could not, the stage is
unchanged, and the item's `log.md` carries the reason and, where a gate past the brief raised it,
a proposed repair written by a fresh context. Report that as the proposal it is, for him to rule
on, and say the brief is untouched until he does. Do not apply it or write one of your own.

Then stop. Do not elaborate the brief further, rank it against other work, estimate it, or raise
it again in a later session unasked.
