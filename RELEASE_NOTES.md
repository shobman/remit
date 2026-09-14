## Windows evaluations start with intact arguments

Exact evaluations on Windows could fail before Codex started, reporting that
`hooks.state` was a string instead of a map. Remit constructed the correct value,
but the Windows Job worker passed it through .NET argument quoting to MSYS
`env.exe`, which consumed backslashes inside quoted arguments.

The shared worker now writes each argument as a literal in a temporary POSIX
launcher. The shell handles the MSYS transition, preserving configuration values
for every harness using this path. The existing Windows Job still supervises and
reaps the process tree; hook trust and command restrictions remain in place.

Validation: native Windows regression checks exact arguments, environment, stdin,
exit status and termination of a started descendant. The v0.4.10 negative control
fails on corrupted arguments. A native Codex 0.154.0 probe through the full exact
evaluation path reproduces the reported startup error on v0.4.10 and succeeds
with this change. It uses a local synthetic provider and an explicit read-only
sandbox: it proves startup and cleanup, not a product verdict or workspace-write
sandbox execution. The full Linux unit suite gates publication; the full Windows
tier and other native harnesses were not rerun for this transport correction.

After upgrading, the blocked evaluation can be retried through Remit's normal
resume command. No Codex downgrade or shared configuration edit is required for
this startup defect.
