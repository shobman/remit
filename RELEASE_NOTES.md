## Claude workers no longer restrict other sessions in the checkout

A Claude worker could temporarily create `.claude/settings.local.json` in its
working folder with Remit's Git, GitHub, Agent and destructive Docker denies.
When that folder was the main checkout, the practitioner's interactive Claude
session inherited those restrictions. Concurrent workers also shared the file,
and cleanup could delete settings the practitioner saved while a worker ran.

Worker deny rules now travel only through that Claude invocation's
`--disallowedTools` and `--settings` arguments. Both command and agent-tool hook
scripts live in the individual run directory. Worker startup and completion
no longer create, overwrite or delete project Claude settings or hook files.
The existing worker restrictions remain in force, including the separate
permission for exact evaluators to inspect their snapshot with Git.

Validation covers overlapping workers in one checkout, restrictions during and
after another worker exits, settings created during a run, existing settings,
and a failing worker. The regression executes the registered hook commands;
it reproduces the shared-file leak and cleanup deletion on v0.4.14. Focused
Linux and native Windows checks and the existing invocation suite were run;
the full Linux suite gates publication. These tests use synthetic Claude
responses and do not claim a live-model evaluation or the full Windows tier.

Upgrade before starting new workers. Already-running old invocations retain
their old behaviour and can recreate the shared file. Existing project settings
are not automatically deleted on upgrade: they may contain your own rules.
