## Safe record-push recovery

When another writer advances the remote branch, Remit now replays its record commit
without leaving the primary checkout on old product files. Incoming additions,
changes and deletions reach both the index and working tree. Unrelated staged,
unstaged and untracked practitioner work is preserved and stays out of the push.
Overlapping changes refuse replay while retaining the local record and local work.

## Complete public releases

A published artifact tag now triggers the public repository's GitHub Release entry,
using these authored notes. Retries preserve existing release text, and rerunning an
older tag does not mark it Latest. This uses the public repository's own workflow
token; no additional private-repository credential is required.

Validation: the checkout regression passes nine checks on both Linux and native
Windows, including staged/unstaged preservation and conflict recovery. Eleven
release-helper checks pass with a simulated GitHub API; the artifact installation
suite passes 115 checks, including preserving the project's own release content.
The full Linux suite gates publication. Real tag-trigger and Release-entry behavior
is verified separately on the public repository when this version is published.

Upgrade using your repository's existing installation mode. This fixes future
record-push retries; it does not automatically clean up stale changes left by an
earlier version, because those may be mixed with your own edits.
