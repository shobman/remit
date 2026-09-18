## Empty fetch bookkeeping no longer invalidates evaluations

An ordinary `git fetch --all` in Remit's snapshot repository can create an empty
`.git/FETCH_HEAD` even though that repository has no remotes. Because the file
was absent when Remit recorded its baseline, the audit rejected the evaluation
as changed Git controls despite the file containing no fetched references.

Preparation now creates the empty file before recording the baseline. Ordinary
and repeated empty fetches leave the audit clean. Changed contents, removal,
directory replacement, source edits and other Git-control changes remain checked.
There is no new command restriction or general exclusion of FETCH_HEAD contents.

Validation: the regression invokes real Git with its default FETCH_HEAD writing
on Linux and native Windows. It checks initial state, ordinary and repeated
fetches, nonempty fetched references, removal, directory replacement and source
mutation. The previous release fails the ordinary-fetch checks. The existing
Linux snapshot suite also passes, and the full Linux tier gates publication.
The full Windows tier and Zenith's live evaluation have not been run.

Upgrade before retrying the affected items. New evaluations get the corrected
baseline. Existing retained invalid attempts follow the recovery added in
v0.4.13: a resume may first finalize and clear the old rejected attempt; a
subsequent resume starts a fresh evaluation of the same delivery. Existing
snapshots and saved verdicts are not rewritten or retroactively accepted.
