## Snapshot preparation recovers and respects endpoint metadata

On managed Windows machines, endpoint software can attach `sec.endpointdlp`
metadata to freshly copied files. Remit rejected that metadata during snapshot
preparation and cleanup. When failed preparation left a snapshot behind, every
later resume could stop at the retained failure marker without retrying.

Remit now ignores this exact metadata name on files and directories without
reading or stripping it or changing endpoint settings. Preparation and audit
continue to check ordinary file contents, other alternate streams and reparse
points. The same exception lets normal cleanup dispose of owned snapshots.

Resume now recognizes failed preparation, checks the candidate, gate, location
and snapshot ownership, and retries cleanup before preparing the same delivery
again. It preserves the original failure and each cleanup attempt's diagnostics.
Foreign snapshots and snapshots showing evaluator invocation are retained.
Continuing cleanup failure reports its cause instead of silently trapping the
item behind an invalid marker. Snapshot errors identify the path, stream or
inspection operation, and binary files no longer flood preparation logs with
ignored-NUL warnings.

Validation: the full Linux unit tier gates publication. Focused native Windows
tests passed 48 metadata assertions, 40 preparation-recovery assertions and 10
long-path assertions. They cover metadata attached before preparation's manifest,
later metadata changes, preserved source and metadata bytes, detection of actual
source edits, and owned cleanup. Endpoint metadata is synthetic in these tests;
Zenith's live endpoint agent and delivery gates have not been exercised. The full
Windows tier and live model evaluations were not rerun.

After upgrading, retry affected items with the normal `remit resume <item>`
command. No manual deletion of valid owned failed-preparation remnants or change
to endpoint monitoring is needed for the reported metadata failure.
