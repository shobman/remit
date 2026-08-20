#!/bin/sh
# remit installer — one deterministic, mechanical step. Point an agent (or a
# human) at this script; nobody installs remit by hand.
#
#   sh /path/to/remit/install.sh /path/to/target-repo
#
# What it installs, and where each harness expects it (researched, not
# invented):
#
#   bin/remit                      the one POSIX mechanic — it does not fork
#   bin/remit-dispatch             the dispatch wrapper: a worker's authored tree
#                                  becomes a draft pull request, mechanically
#   .claude/skills/<name>/         the five conventions, where Claude Code
#                                  discovers project skills
#   .agents/skills/<name>/         the same five files, where Codex and Devin
#                                  discover project skills — Devin needs no path
#                                  of its own, which is why there are three of
#                                  these for four harnesses
#                                  ($REPO_ROOT/.agents/skills)
#   .pi/skills/<name>/             the same five files, where Pi discovers
#                                  project skills
#   AGENTS.md                      a marker-delimited remit section — Codex, Pi
#                                  and Devin all read the repo-root AGENTS.md;
#                                  an existing AGENTS.md is appended to, never
#                                  replaced
#   <git>/hooks/pre-push           the push guards, in the shared hooks dir so
#                                  every linked worktree inherits them
#   .remit/                        an empty work location
#   .remit/.install/manifest       the record: what was installed, at what
#                                  version — the seam the upgrade uses
#
# It never installs this repository's own law documents (.remit/problem.md,
# solution.md, tech-design.md) — those are remit's, not the target's.
#
# Re-running IS the upgrade: against a newer payload it rewrites only files
# whose current content matches what the manifest says remit installed.
# Anything the target repository already had, and anything a person edited
# since install, is kept and reported — never overwritten.
#
# The result is committed in the target (only the paths this install touched)
# and never pushed: pushing a repository you own is your act, not an
# installer's.
#
# Exit codes: 0 installed/upgraded (skips are reported, not fatal)
#             2 usage or environment error; nothing was changed

set -eu

die() { printf 'remit install: %s\n' "$1" >&2; exit 2; }

[ $# -eq 1 ] || { printf 'usage: sh install.sh <target-repo-dir>\n' >&2; exit 2; }

# --- source: the remit checkout this script sits in ---------------------------
SRC=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd -P)
VERSION=$(cat "$SRC/VERSION" 2>/dev/null) || die "no VERSION file at $SRC — is this a complete remit checkout?"

SKILLS="capture-work resume-work dispatch-work evaluate-work close-work"
ADAPTER="$SRC/install/AGENTS-remit.md"
HOOK_SRC="$SRC/install/hooks/pre-push"

[ -f "$SRC/bin/remit" ] || die "payload missing: $SRC/bin/remit"
[ -f "$SRC/bin/remit-dispatch" ] || die "payload missing: $SRC/bin/remit-dispatch"
[ -f "$ADAPTER" ] || die "payload missing: $ADAPTER"
[ -f "$HOOK_SRC" ] || die "payload missing: $HOOK_SRC"
for s in $SKILLS; do
	[ -f "$SRC/.claude/skills/$s/SKILL.md" ] || die "payload missing: $SRC/.claude/skills/$s/SKILL.md"
done

# --- target: a Git repository's primary worktree ------------------------------
[ -d "$1" ] || die "no such directory: $1"
TGT=$(CDPATH= cd -- "$1" && pwd -P)
TGT=$(git -C "$TGT" rev-parse --show-toplevel 2>/dev/null) || die "$1 is not inside a Git repository"

# rev-parse may answer with paths relative to the target — resolve from there.
git_dir=$(CDPATH= cd -- "$TGT" && CDPATH= cd -- "$(git rev-parse --git-dir)" && pwd -P)
common_dir=$(CDPATH= cd -- "$TGT" && CDPATH= cd -- "$(git rev-parse --git-common-dir)" && pwd -P)
[ "$git_dir" = "$common_dir" ] || die "$TGT is a linked worktree — install into the primary worktree at $(dirname "$common_dir")"

MANIFEST=".remit/.install/manifest"
MANIFEST_ABS="$TGT/$MANIFEST"

printf 'remit install v%s -> %s\n' "$VERSION" "$TGT"

# --- helpers ------------------------------------------------------------------
hash_of() { git hash-object -- "$1"; }

# What the manifest says remit installed there last time. Empty if never.
manifest_id() { # $1 record-type  $2 path
	[ -f "$MANIFEST_ABS" ] || return 0
	awk -v t="$1" -v p="$2" '$1==t && $3==p {print $2; exit}' "$MANIFEST_ABS"
}

RECORDS=''
record() { # $1 type  $2 id  $3 path
	RECORDS="$RECORDS$1 $2 $3
"
}

TOUCHED=''    # tracked paths this run changed (to stage and commit)
report() { printf '  %-10s %s%s\n' "$1" "$2" "${3:+ — $3}"; }

# One file, one honest outcome:
#   installed  it was absent; it is now remit's payload
#   updated    it was exactly what remit last installed; now the new payload
#   unchanged  it already equals the payload
#   kept       it is the target's own, or locally edited since install —
#              remit does not overwrite it
install_file() { # $1 src-abs  $2 dst-rel
	src=$1 dst=$2
	new_id=$(hash_of "$src")
	old_id=$(manifest_id file "$dst")
	if [ ! -e "$TGT/$dst" ]; then
		mkdir -p "$(dirname "$TGT/$dst")"
		cp "$src" "$TGT/$dst"
		record file "$new_id" "$dst"
		report installed "$dst"
		TOUCHED="$TOUCHED $dst"
		return 0
	fi
	cur_id=$(hash_of "$TGT/$dst")
	if [ "$cur_id" = "$new_id" ]; then
		record file "$new_id" "$dst"
		report unchanged "$dst"
	elif [ -z "$old_id" ]; then
		report kept "$dst" "already present and not remit's; left alone"
	elif [ "$cur_id" = "$old_id" ]; then
		cp "$src" "$TGT/$dst"
		record file "$new_id" "$dst"
		report updated "$dst"
		TOUCHED="$TOUCHED $dst"
	else
		record file "$old_id" "$dst"
		report kept "$dst" "modified locally since install; left alone"
	fi
}

# --- the mechanics and the five conventions, where each harness looks ---------
# Three copies, four harnesses: Devin discovers project skills at .agents/skills
# too, so it needs no copy of its own.
install_file "$SRC/bin/remit" "bin/remit"
install_file "$SRC/bin/remit-dispatch" "bin/remit-dispatch"
for s in $SKILLS; do
	for loc in .claude .agents .pi; do
		install_file "$SRC/.claude/skills/$s/SKILL.md" "$loc/skills/$s/SKILL.md"
	done
done

# --- AGENTS.md: a managed, marker-delimited section — additive, never a clobber
AGENTS="$TGT/AGENTS.md"
MARK_BEGIN='<!-- remit:begin — this section is managed by remit'\''s installer and is replaced on upgrade -->'
MARK_END='<!-- remit:end -->'

write_block() { # appends the managed section to $1
	{
		printf '%s\n' "$MARK_BEGIN"
		cat "$ADAPTER"
		printf '%s\n' "$MARK_END"
	} >>"$1"
}

new_id=$(hash_of "$ADAPTER")
old_id=$(manifest_id block AGENTS.md)
if [ ! -e "$AGENTS" ]; then
	write_block "$AGENTS"
	record block "$new_id" AGENTS.md
	report installed "AGENTS.md" "created with the remit section"
	TOUCHED="$TOUCHED AGENTS.md"
elif ! grep -q '^<!-- remit:begin' "$AGENTS"; then
	printf '\n' >>"$AGENTS"
	write_block "$AGENTS"
	record block "$new_id" AGENTS.md
	report updated "AGENTS.md" "remit section appended; existing content untouched"
	TOUCHED="$TOUCHED AGENTS.md"
else
	cur_block="$TGT/.remit/.install/agents-block.tmp"
	mkdir -p "$(dirname "$cur_block")"
	awk '/^<!-- remit:begin/{b=1;next} /^<!-- remit:end/{b=0;next} b' "$AGENTS" >"$cur_block"
	cur_id=$(hash_of "$cur_block")
	if [ "$cur_id" = "$new_id" ]; then
		record block "$new_id" AGENTS.md
		report unchanged "AGENTS.md" "remit section"
	elif [ -z "$old_id" ]; then
		record block "$cur_id" AGENTS.md
		report kept "AGENTS.md" "a remit section is present but not in the manifest; left alone as found"
	elif [ "$cur_id" != "$old_id" ]; then
		record block "$old_id" AGENTS.md
		report kept "AGENTS.md" "remit section edited locally; left alone"
	else
		awk -v adapter="$ADAPTER" '
			/^<!-- remit:begin/ {print; while ((getline line < adapter) > 0) print line; skip=1; next}
			/^<!-- remit:end/   {skip=0; print; next}
			!skip
		' "$AGENTS" >"$AGENTS.remit-tmp"
		mv "$AGENTS.remit-tmp" "$AGENTS"
		record block "$new_id" AGENTS.md
		report updated "AGENTS.md" "remit section"
		TOUCHED="$TOUCHED AGENTS.md"
	fi
	rm -f "$cur_block"
fi

# --- the push guards, in the shared hooks dir so every worktree inherits them -
hookspath=$(git -C "$TGT" config core.hooksPath 2>/dev/null || true)
if [ -n "$hookspath" ]; then
	report skipped "pre-push guard" "core.hooksPath is set to '$hookspath'; that hook system is yours — merge $HOOK_SRC into it deliberately"
else
	hook_dst="$common_dir/hooks/pre-push"
	new_id=$(hash_of "$HOOK_SRC")
	old_id=$(manifest_id hook pre-push)
	if [ ! -e "$hook_dst" ]; then
		mkdir -p "$common_dir/hooks"
		cp "$HOOK_SRC" "$hook_dst"
		chmod +x "$hook_dst"
		record hook "$new_id" pre-push
		report installed "pre-push guard" "$hook_dst"
	else
		cur_id=$(hash_of "$hook_dst")
		if [ "$cur_id" = "$new_id" ]; then
			record hook "$new_id" pre-push
			report unchanged "pre-push guard"
		elif [ -z "$old_id" ]; then
			report kept "pre-push guard" "a pre-push hook already exists and is not remit's; left alone — merge $HOOK_SRC into it deliberately"
		elif [ "$cur_id" = "$old_id" ]; then
			cp "$HOOK_SRC" "$hook_dst"
			chmod +x "$hook_dst"
			record hook "$new_id" pre-push
			report updated "pre-push guard"
		else
			record hook "$old_id" pre-push
			report kept "pre-push guard" "modified locally since install; left alone"
		fi
	fi
fi

# --- the work location and the record -----------------------------------------
mkdir -p "$TGT/.remit/.install"

new_manifest="$MANIFEST_ABS.tmp"
{
	printf 'remit install manifest v1\n'
	printf 'version %s\n' "$VERSION"
	printf '%s' "$RECORDS"
} >"$new_manifest"
if [ -f "$MANIFEST_ABS" ] && [ "$(hash_of "$MANIFEST_ABS")" = "$(hash_of "$new_manifest")" ]; then
	rm -f "$new_manifest"
	report unchanged "$MANIFEST"
else
	mv "$new_manifest" "$MANIFEST_ABS"
	report recorded "$MANIFEST" "v$VERSION"
	TOUCHED="$TOUCHED $MANIFEST"
fi

# --- commit exactly what this install touched, in the target ------------------
staged=''
ignored=''
for p in $TOUCHED; do
	if git -C "$TGT" add -- "$p" 2>/dev/null; then
		staged="$staged $p"
	else
		ignored="$ignored $p"
	fi
done
[ -z "$ignored" ] || printf 'note: installed but NOT tracked — ignored by the target'\''s .gitignore:%s\n' "$ignored"

if [ -n "$staged" ] && [ -n "$(git -C "$TGT" status --porcelain -- $staged)" ]; then
	git -C "$TGT" commit -q -m "remit: install v$VERSION" -- $staged
	printf 'committed in %s: %s\n' "$TGT" "$(git -C "$TGT" log -1 --format='%h %s')"
	printf 'not pushed — pushing this repository is yours to do.\n'
else
	printf 'nothing to commit — the target already matches remit v%s.\n' "$VERSION"
fi
