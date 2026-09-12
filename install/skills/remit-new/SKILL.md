---
name: remit-new
description: 'Admit or park practitioner-directed work, or open a phase they authorise. Use for "file it", "park this", "new item", "create a brief", "take it to refined", "take it to accepted" or "take it all the way". Keep intake problem-first and ask only what is missing to make the outcome judgeable.'
---

# New

The brief preserves the practitioner's words and boundary. Structure them without widening
them; mark interpretations before filing. Do not fill an unknown with plausible authority.
If supplied wording would defeat the stated outcome or leave a material contradiction, explain
that consequence and ask for the specific missing decision before filing it. Do not silently
correct it or treat an unexplained contradiction as a settled ruling. Missing earlier answers
do not establish the intended choice.
Write `**Depends on:**` from mechanical facts: a required contract's item slug, or `none`.
Do not ask for scheduling or invent work to enable a start.

For "file it", "park it", an idea or backlog, use `--park`. If the supplied words already
establish a judgeable outcome, ask nothing more. Otherwise ask once what would show it
delivered, and take the answer as it stands.

For a brief or refinement, read `.remit/rules/refined.md`. Ask only about unmet `fix`
criteria, once each. Reuse answers and authority already supplied. When research is requested,
establish what it should answer and return; record that in a `**Research:**` line without
re-asking what the practitioner already specified.

## Proportionate preparation

Establish the problem before selecting a solution. For consequential or uncertain work, use
research to describe valuable outcomes without prematurely choosing technology, then research
the technical approach and define how the outcome will be judged before build. Reuse existing
authority by reference. Small work may express all needed outcome and proof in one brief;
legacy work stays valid. This guidance adds no state, mandatory document or automatic phase.
A choice about value, scope, risk or taste remains the practitioner's.

## Command

```sh
sh "$(git rev-parse --show-toplevel)/bin/remit" new <slug> [--until refined|accepted|closed] [--park] [--seat <role>=<harness>/<model>]... < <brief-file>
```

Use `--until` only for a named stop; add `--park` when asked to rest there. If no stop was
named, pass no `--until`. Use `--seat` only for a seat the practitioner named, and only a
registered pair. Relay any refusal.

With `--until`, the command runs the chain. Run it backgrounded under AGENTS.md's contract.

## Further phase and return

A phase is opened only by the practitioner. Write and commit `phase-<n>.md` beside the brief
with its bounded outcome and proof inside the item's existing authority. A changed outcome or
boundary needs their amendment or new item; the script owns the resulting state transition.

Return the command's actual outcome under AGENTS.md's update contract. An escalated admission
owes its recorded cause and missing authority. Do not propose a brief amendment unasked or
revive parked work.
