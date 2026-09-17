## Completed evaluations no longer wedge while saving evidence

An evaluation that wrote a result directly under `results/` could finish, then
fail while Remit saved its evidence. Remit created `results`, tried to create
`results/.` again, and stopped with "File exists". An invalid snapshot audit then
left a prepared locator that every resume revisited without completing recovery.

Remit now creates the results destination before copying either top-level or
nested files. The existing recovery path can finalize a retained invalid attempt
and safely clean up its owned snapshot. Each finalization attempt keeps its stderr,
exit status and failed operation outside temporary coordinator files. Audit errors
now identify the actual rejection; Windows diagnostic diffs preserve line endings
and explicitly mark truncation.

New disposable snapshot repositories disable automatic Git maintenance and
object packing before recording their baseline. This prevents Git housekeeping
from changing the pinned internal files during normal inspection. Host Git
settings are untouched, and source changes, altered Git controls and explicit
packing remain detectable. Maintenance is a reproduced failure mechanism; the
exact command that changed Zenith's original snapshot was not established.

Validation: focused Windows and Linux checks cover clean and invalid evidence
with top-level and nested results, interrupted recovery, copy-error diagnostics,
Windows line endings and bounded diffs. A real Git maintenance trigger stays clean
with the new setting; an explicitly enabled control packs objects and fails audit.
Coordinator tests recreate the old wedge, recover without another evaluator, and
then retry the same delivery without rebuilding. Full Linux tests gate release;
the full Windows tier and live model evaluations were not run.

For an already-retained invalid evaluation, the first `remit resume <item>` can
finish saving the rejected attempt and remove its locator while still reporting
that old evaluation as invalid. A subsequent resume starts a fresh evaluation of
the same delivery. Do not delete evidence or alter snapshot metadata manually.
