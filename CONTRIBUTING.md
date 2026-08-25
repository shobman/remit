# Contributing

Thank you for using this repository closely enough to have something to say about it.

A contribution here starts as a **field report**: a written observation of what you did, what
happened, and what you expected instead. A report is not a change request and it authorises
nothing — it is honest input that this repository's maintainer rules on. Work exists here only
once they admit it.

You need no write access to this repository, and you are not asked to open a pull request.

## Send a field report

1. Write the report as a single Markdown file. What it should hold is below.
2. Send it to this repository's maintainer, by whatever route this repository already offers for
   reaching them.
3. That is the whole of your part. The maintainer files it with `remit report new <name>`, which
   places it at `.remit/field-reports/<name>.md` here, and rules on it there.

Filing admits no work. A finding sitting in a report unruled is its normal resting state, and it
carries no obligation on anyone to act. If the maintainer does admit one as work, the item that
results points back at your report rather than restating it — your words stay yours.

## What a report holds

- **What you did**, in enough detail that someone else can do it: the commands, the versions, the
  platform.
- **What happened**, quoted rather than described — output, exit codes, the file as it was left.
- **What you expected instead**, and what you are reading that expectation from.
- **Whether you checked it against the code**, and how far you got. An unchecked observation is
  still worth sending; say that it is unchecked rather than leaving that to be assumed.
- **Nothing you cannot publish.** Assume anything you send is read by more than one person.

Your words are kept verbatim, so write in your own.

## The standard your report is held to

No rubric is applied to your report when it arrives — nothing is evaluated at intake. The standard
matters earlier than that. It is what a report has to carry for a maintainer to be able to rule on
it at all, and it is what the work is held to afterwards if they admit it.

Those standards belong to this repository, and they are files you can read:

- [`.remit/rules/refined.md`](.remit/rules/refined.md), the `fix` section — what it takes for a
  piece of work to be stated well enough to be judged at all. A report that meets it is one a
  maintainer can act on.
- [`.remit/rules/accepted.md`](.remit/rules/accepted.md), the `fix` section — what a delivery in
  this repository is held to once the work is under way.

Read them before you write. They are written by this repository's maintainer rather than by remit,
and they differ from one repository to the next, so what you read there is the bar here and
nowhere else.

## This file is remit's

`CONTRIBUTING.md` is installed and kept current by [remit](https://github.com/shobman/remit), the
work surface this repository runs. Its content is remit's rather than this repository's, which is
why the route above reads the same wherever remit runs and only the standards it points you at
differ. A repository wanting a contribution route of its own builds it beside this file rather
than editing this one.
