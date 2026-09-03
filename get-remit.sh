#!/bin/sh
# remit bootstrap — fetch this published dist and run its installer, in one
# mechanical step. Nobody installs remit by hand; point an agent (or yourself)
# at a script, never at a recipe.
#
#   sh -c "$(curl -fsSL https://raw.githubusercontent.com/shobman/remit/main/get-remit.sh)" -- <target-repo>
#   curl -fsSL https://raw.githubusercontent.com/shobman/remit/main/get-remit.sh | sh -s -- <target-repo>
#
# Already have a clone of this repository? Then this script is not needed:
#
#   sh /path/to/remit/install.sh <target-repo>
#
# Shipped by remit v0.3.8. It fetches the CURRENT published dist, which may
# be newer. To pin an exact version, set REMIT_REF — but take the command from
# README.md's Install section rather than composing one from the two forms above:
# where the assignment goes differs between them, and the wrong placement pins
# nothing and says nothing. The working commands are written there, once.
#
# Environment: REMIT_REPO  clone URL      (default https://github.com/shobman/remit.git)
#              REMIT_REF   tag/branch/sha (default: the repository's default branch)
#
# Exit codes: whatever install.sh returns — 0 installed/upgraded, 2 usage or
#             environment error; 2 also if the fetch itself failed.

set -eu

die() { printf 'get-remit: %s\n' "$1" >&2; exit 2; }

# The flags are `install.sh`'s and are passed straight through — this script
# fetches remit and hands over, and what an option MEANS is stated in that
# script's header rather than a second time here.
SHADOW=''
TARGET=''
while [ $# -gt 0 ]; do
	case "$1" in
	--shadow) SHADOW=--shadow ;;
	-*) printf 'unknown option: %s\nusage: get-remit.sh [--shadow] <target-repo-dir>\n' "$1" >&2; exit 2 ;;
	*)
		[ -z "$TARGET" ] || { printf 'usage: get-remit.sh [--shadow] <target-repo-dir>\n' >&2; exit 2; }
		TARGET=$1
		;;
	esac
	shift
done
[ -n "$TARGET" ] || { printf 'usage: get-remit.sh [--shadow] <target-repo-dir>\n' >&2; exit 2; }
[ -d "$TARGET" ] || die "no such directory: $TARGET"
command -v git >/dev/null 2>&1 || die "git is required (both to fetch remit and to install it)"

REPO=${REMIT_REPO:-https://github.com/shobman/remit.git}
REF=${REMIT_REF:-}

TMP=$(mktemp -d 2>/dev/null) || die "could not create a temporary directory"
cleanup() { rm -rf "$TMP"; }
trap cleanup EXIT HUP INT TERM

printf 'get-remit: fetching %s%s\n' "$REPO" "${REF:+ @ $REF}"
if [ -n "$REF" ]; then
	git clone --quiet --depth 1 --branch "$REF" -- "$REPO" "$TMP/remit" 2>/dev/null ||
		{ git clone --quiet -- "$REPO" "$TMP/remit" && git -C "$TMP/remit" checkout --quiet "$REF"; } ||
		die "could not fetch $REPO at $REF"
else
	git clone --quiet --depth 1 -- "$REPO" "$TMP/remit" || die "could not fetch $REPO"
fi

[ -f "$TMP/remit/install.sh" ] || die "$REPO is not a remit dist — no install.sh at its root"
printf 'get-remit: fetched remit v%s\n' "$(cat "$TMP/remit/VERSION" 2>/dev/null || echo '?')"

sh "$TMP/remit/install.sh" ${SHADOW:+"$SHADOW"} "$TARGET"
