#!/bin/sh
# remit installer — one deterministic, mechanical step. Point an agent (or a
# human) at this script; nobody installs remit by hand.
#
#   sh /path/to/remit/install.sh /path/to/target-repo
#
# What it installs, and where each harness expects it (researched, not
# invented):
#
#   bin/remit                      the work-item state machine, including the
#                                  delivery seam — it does not fork per harness
#   bin/remit-invoke               the one AI seam: a fresh context, in a named
#                                  harness, with a briefing, in a worktree,
#                                  returning its text
#   .claude/skills/<name>/         the five conventions, where Claude Code
#                                  discovers project skills
#   .agents/skills/<name>/         the same five files, where Codex, Devin and
#                                  Copilot CLI discover project skills — the last
#                                  two need no path of their own, which is why
#                                  there are three of these for five harnesses
#                                  ($REPO_ROOT/.agents/skills)
#   .pi/skills/<name>/             the same five files, where Pi discovers
#                                  project skills
#   AGENTS.md                      a marker-delimited remit section — Codex, Pi,
#                                  Devin and Copilot CLI all read the repo-root
#                                  AGENTS.md; an existing AGENTS.md is appended
#                                  to, never replaced
#   CONTRIBUTING.md                how the repository takes a contribution. The
#                                  file itself is where that is stated; nothing
#                                  here repeats it. It is MANAGED — see the
#                                  outcome `restored` below
#   <git>/hooks/pre-push           the push guards, in the shared hooks dir so
#                                  every linked worktree inherits them
#   .remit/hooks/no-agent-tool.sh  the agent-tool guard: ONE script, registered
#                                  by every harness here that has a pre-tool hook
#   .github/hooks/remit-no-agent-tool.json
#                                  Copilot CLI's registration of it
#   .claude/settings.json          Claude Code's registration of it AND the one
#                                  setting remit needs from that harness —
#                                  env.BASH_MAX_TIMEOUT_MS, which raises Claude
#                                  Code's own 600 000 ms ceiling on a shell call
#                                  so a long raise is not killed mid-run. What
#                                  that setting is for is stated once in the
#                                  AGENTS.md section this script installs,
#                                  because JSON carries no comment. OFFERED, not imposed: the file is
#                                  created when absent, updated when it is still
#                                  exactly what remit wrote, and when it is yours
#                                  the block to merge is printed and nothing is
#                                  touched
#   .remit/work-items/             the work location, empty
#   .remit/field-reports/          observations from real use, empty
#   .remit/rules/                  the practitioner's rubrics — the empty shape
#                                  and the ONE rubric remit ships, and nothing
#                                  else, ever
#
# And what it does NOT install, deliberately: `.remit/settings.json`, the
# registry of which harnesses and models a repository may raise a context on.
# Nothing here can know a host's seats, and a template registering seats a target
# does not have would be a file that could only refuse. `sh bin/remit setup`
# proposes one from what a host actually has, and `sh bin/remit setup --write`
# saves that proposal — the save is the script's, never a redirection over the
# file setup reads. Until there is one, `bin/remit-invoke` refuses every raise
# and says so.
#   .remit/.install/manifest       the record: what was installed, at what
#                                  version — the seam the upgrade uses
#
# The payload's single source for each of those is one file in this checkout:
# `bin/`, `install/skills/<name>/SKILL.md`, `install/AGENTS-remit.md`,
# `install/hooks/`. This repository's own `.claude/`, `.agents/` and
# `.pi/` are INSTALLED COPIES, written by running this script against itself,
# exactly as in any other target — including `.claude/settings.json`, whose
# single source is `install/hooks/claude-settings.json`.
#
# `.remit/rules/` is the one thing here this script does not author. Its content
# is `bin/remit`'s to write — `remit rules init` lays down the empty shape and
# the one universal rubric, and only a retro the practitioner calls writes
# anything more. So this script RUNS that command, in a throwaway repository of
# its own in a temp directory, and installs what it produced as ordinary payload.
# Two reasons it is not run in the target: `remit` commits AND PUSHES what it
# writes, and this script never pushes a repository you own; and treating the
# seed as payload is what gives a rubrics file the same four honest outcomes as
# every other file, so a `refined.md` a retro has since written into is KEPT
# rather than overwritten by an upgrade. (In its scratch repository `rules init`
# has no remote, commits, and says it is durable on that machine only — that
# report is about the scratch repository and is discarded with it.)
#
# Git tracks no empty directory, so `work-items/` and `field-reports/` are
# created on disk here and enter the target's history with its first item and
# its first report. `.remit/rules/` and the manifest are files and are committed.
#
# It never installs this repository's own law documents (.remit/problem.md,
# solution.md, tech-design.md, testing.md) — those are remit's, not the target's.
#
# Re-running IS the upgrade: against a newer payload it rewrites only files
# whose current content matches what the manifest says remit installed.
# Anything the target repository already had, and anything a person edited
# since install, is kept and reported — never overwritten.
#
# RETIRED PAYLOAD is removed on the same terms. A file remit installed once and
# no longer ships — the five prose conventions that preceded the five skills,
# and the dispatch wrapper whose two halves are now `bin/remit` and
# `bin/remit-invoke` — is deleted when it still matches what the manifest says
# remit put there, and KEPT WITH A NOTICE when it does not, because a file
# somebody edited is theirs whatever its name used to mean here.
#
# One file, one honest outcome:
#   installed  it was absent; it is now remit's payload
#   updated    it was exactly what remit last installed; now the new payload
#   unchanged  it already equals the payload
#   kept       it is the target's own, or locally edited since install —
#              remit does not overwrite it, and does not delete it
#   removed    remit installed it, remit no longer ships it, and it is still
#              exactly what remit put there
# ONE FILE IS THE EXCEPTION, and it is deliberate: CONTRIBUTING.md is MANAGED.
# A local edit to it is reported `restored` and put back to the payload on the
# next upgrade, because what it describes is remit's own mechanic and a stale
# copy of it sends a contributor somewhere that no longer works. Which file
# that reaches — and which it deliberately does not, a CONTRIBUTING.md the
# target already had when remit arrived — is stated once, at install_file below.
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

SKILLS="remit-new remit-resume remit-close remit-status remit-retro"

# What remit used to ship and does not any more. Named here because the only way
# to retire an installed file honestly is to know it was ours.
RETIRED_FILES="bin/remit-dispatch"
# `.remit/rules/roles.md` retired into `.remit/settings.json` on 2026-08-23.
# `remit rules init` no longer writes it, so it is removed from targets remit
# installed it into — on the same terms as any other retired payload.
RETIRED_RULEFILES=".remit/rules/roles.md"
RETIRED_SKILLS="capture-work resume-work dispatch-work evaluate-work close-work"

RULEFILES="refined accepted closed"
ADAPTER="$SRC/install/AGENTS-remit.md"
HOOK_SRC="$SRC/install/hooks/pre-push"
GUARD_SRC="$SRC/install/hooks/no-agent-tool.sh"
GUARD_COPILOT="$SRC/install/hooks/copilot-no-agent-tool.json"
GUARD_CLAUDE="$SRC/install/hooks/claude-settings.json"
# remit's own CONTRIBUTING.md IS the payload — there is no second copy under
# install/ the way the AGENTS.md section and the skills have one, so the file
# this repository shows a contributor and the file an adopter is given cannot
# drift apart.
CONTRIB_SRC="$SRC/CONTRIBUTING.md"

[ -f "$SRC/bin/remit" ] || die "payload missing: $SRC/bin/remit"
[ -f "$SRC/bin/remit-invoke" ] || die "payload missing: $SRC/bin/remit-invoke"
[ -f "$ADAPTER" ] || die "payload missing: $ADAPTER"
[ -f "$HOOK_SRC" ] || die "payload missing: $HOOK_SRC"
for f in "$GUARD_SRC" "$GUARD_COPILOT" "$GUARD_CLAUDE"; do
	[ -f "$f" ] || die "payload missing: $f"
done
for s in $SKILLS; do
	[ -f "$SRC/install/skills/$s/SKILL.md" ] || die "payload missing: $SRC/install/skills/$s/SKILL.md"
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

SCRATCH=$(mktemp -d 2>/dev/null) || SCRATCH=${TMPDIR:-/tmp}/remit-install-$$
mkdir -p "$SCRATCH" || die "cannot make a scratch directory"
trap 'rm -rf "$SCRATCH"' EXIT INT TERM

printf 'remit install v%s -> %s\n' "$VERSION" "$TGT"

# --- helpers ------------------------------------------------------------------
# Every outcome below is decided by comparing these ids, so where the id is
# computed FROM decides what the installer does. It is computed from the TARGET,
# and never from wherever the person happened to be standing when they ran this.
#
# Git resolves a repository from the current directory, so a bare
# `git hash-object` reads whichever repository the caller's shell was in. Two
# things follow from that, and one of them is silent.
#
# THE LOUD ONE: if the caller's repository cannot be opened, the command does
# not fall back to hashing the file — it dies:
#
#   $ cd /a/linked/worktree/whose/gitdir/is/unreachable
#   $ sh install.sh /some/other/repo
#   fatal: not a git repository: ...
#
# which is an installer failing over a directory it was never asked about.
#
# THE SILENT ONE: `hash-object` applies the line-ending conversion of whichever
# repository it resolved. With the caller's deciding, a target that checks its
# files out with CRLF has every one of them read as edited, and is told its own
# untouched files were `kept` from an upgrade — an outcome that is wrong and
# reads as careful. Anchored to the target, the payload and the file it is
# compared against are converted by one set of rules: that target's own.
hash_of() { git -C "$TGT" hash-object -- "$1"; }

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
#   restored   MANAGED FILES ONLY: it was remit's and someone edited it; it is
#              the payload again. A managed file is one whose content is a
#              mechanic remit maintains, where a stale local edit misdirects
#              whoever reads it — so the file is remit's to keep current and
#              the third argument says so at the call site.
#
# `restored` reaches only a file the manifest already records as remit's. A file
# the target had before remit arrived has no record, is not remit's to manage,
# and is `kept` whatever the third argument says — and whatever its BYTES say.
# A target's own file that happens to be identical to the payload is still the
# target's: adopting it on identity would write a manifest record for a file
# remit never installed, and the takeover is silent until the upgrade after it,
# when the payload moves and the file the target owns is `updated` out from
# under them, or they edit it and get it back `restored`.
install_file() { # $1 src-abs  $2 dst-rel  [$3 managed]
	src=$1 dst=$2 managed=${3:-}
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
	# No manifest record means the file is the target's own, and this is where
	# that is decided — BEFORE the bytes are compared, because for a managed
	# file the comparison is a trap. An unmanaged file may be adopted on
	# identity: the worst that follows is that remit keeps current a file the
	# target could not tell from remit's own, and a later local edit is still
	# `kept`. A managed file may not, because `restored` follows the record: one
	# adoption and every edit the target makes afterwards is overwritten by an
	# installer that was never given the file.
	if [ -z "$old_id" ] && { [ -n "$managed" ] || [ "$cur_id" != "$new_id" ]; }; then
		report kept "$dst" "already present and not remit's; left alone"
	elif [ "$cur_id" = "$new_id" ]; then
		record file "$new_id" "$dst"
		report unchanged "$dst"
	elif [ "$cur_id" = "$old_id" ]; then
		cp "$src" "$TGT/$dst"
		record file "$new_id" "$dst"
		report updated "$dst"
		TOUCHED="$TOUCHED $dst"
	elif [ -n "$managed" ]; then
		cp "$src" "$TGT/$dst"
		record file "$new_id" "$dst"
		report restored "$dst" "edited since install; this file is remit's and is put back"
		TOUCHED="$TOUCHED $dst"
	else
		record file "$old_id" "$dst"
		report kept "$dst" "modified locally since install; left alone"
	fi
}

# The mirror of install_file, for payload remit no longer ships. It deletes only
# what it can prove it wrote, and says so; anything else is the target's and
# stays. A removed file's record is dropped from the manifest, so a later run
# has nothing to say about it at all.
retire_file() { # $1 dst-rel  $2 what replaced it, in words
	dst=$1 why=$2
	[ -e "$TGT/$dst" ] || return 0
	old_id=$(manifest_id file "$dst")
	cur_id=$(hash_of "$TGT/$dst")
	if [ -z "$old_id" ]; then
		report kept "$dst" "retired from remit's payload, but this copy is not remit's; left alone — $why"
		return 0
	fi
	if [ "$cur_id" != "$old_id" ]; then
		record file "$old_id" "$dst"
		report kept "$dst" "retired from remit's payload, but edited locally since install; left alone — $why"
		return 0
	fi
	rm -f "$TGT/$dst"
	rmdir "$(dirname "$TGT/$dst")" 2>/dev/null || true
	report removed "$dst" "$why"
	TOUCHED="$TOUCHED $dst"
}

# --- the mechanics and the five conventions, where each harness looks ---------
# Three copies, five harnesses: Devin and Copilot CLI both discover project
# skills at .agents/skills too, so neither needs a copy of its own. Copilot CLI's
# own discovery set — probed, not assumed — is .github/skills/, .agents/skills/
# and .claude/skills/, so the copy written here is the one it reads, and adding a
# fourth location for it would be a second home for content that already has one.
install_file "$SRC/bin/remit" "bin/remit"
install_file "$SRC/bin/remit-invoke" "bin/remit-invoke"
for s in $SKILLS; do
	for loc in .claude .agents .pi; do
		install_file "$SRC/install/skills/$s/SKILL.md" "$loc/skills/$s/SKILL.md"
	done
done

# --- the agent-tool guard: one script, registered where a harness has hooks ---
# The rule it enforces is stated ONCE, in the managed AGENTS.md section above,
# for every harness. What is installed here is the enforcement, and only two of
# the five harnesses have a pre-tool hook to register it with; for the other
# three that section says plainly that it holds by instruction.
install_file "$GUARD_SRC" ".remit/hooks/no-agent-tool.sh"
install_file "$GUARD_COPILOT" ".github/hooks/remit-no-agent-tool.json"

# Claude Code's registration is an OFFER, not an install, and the file carries
# TWO things now: the agent-tool guard's PreToolUse entry, and
# `env.BASH_MAX_TIMEOUT_MS`. Why a raise needs that ceiling raised is stated once
# in the AGENTS.md section this script installs — read it there; what concerns
# this file is only that Claude Code cuts a shell call's requested timeout to
# `max(BASH_MAX_TIMEOUT_MS, BASH_DEFAULT_TIMEOUT_MS)`, so 600 000 ms unless this
# file says otherwise, and a raise past ten minutes dies mid-run without it. It
# serves one of the five harnesses; the other four need nothing, and that same
# section says which and why.
#
# `.claude/settings.json` is a file people keep their own settings in and it is
# not remit's to rewrite, so it gets install_file's four outcomes and no fifth:
# absent, it is created carrying remit's block; still exactly what remit wrote,
# it is updated; equal to the payload already, unchanged; ANYTHING ELSE IS KEPT —
# no merge, no sed into somebody's JSON — and the block to merge is printed with
# the setting to add named in words. An installer that half-parses a settings
# file to insert a key is how a settings file gets corrupted. That is the same
# restraint the pre-push hook shows a repository with its own core.hooksPath.
#
# It is recorded in the manifest like any other file, which is what makes the
# `updated` outcome possible at all: without a record there is nothing to prove
# the current content is remit's rather than a person's.
SETTINGS_REL=".claude/settings.json"
SETTINGS_KEY="BASH_MAX_TIMEOUT_MS"
SETTINGS_MS=$(grep -o "\"$SETTINGS_KEY\"[^0-9]*[0-9]*" "$GUARD_CLAUDE" | grep -o '[0-9][0-9]*$' | sed -n 1p)
[ -n "$SETTINGS_MS" ] || die "payload $GUARD_CLAUDE does not carry $SETTINGS_KEY — the offer below would name no value"
claude_settings="$TGT/$SETTINGS_REL"
new_id=$(hash_of "$GUARD_CLAUDE")
old_id=$(manifest_id file "$SETTINGS_REL")
if [ ! -e "$claude_settings" ]; then
	mkdir -p "$TGT/.claude"
	cp "$GUARD_CLAUDE" "$claude_settings"
	record file "$new_id" "$SETTINGS_REL"
	report installed "$SETTINGS_REL" "the agent-tool guard's PreToolUse registration, and $SETTINGS_KEY so a raise longer than ten minutes is not killed on Claude Code"
	TOUCHED="$TOUCHED $SETTINGS_REL"
else
	cur_id=$(hash_of "$claude_settings")
	if [ "$cur_id" = "$new_id" ]; then
		record file "$new_id" "$SETTINGS_REL"
		report unchanged "$SETTINGS_REL"
	elif [ -n "$old_id" ] && [ "$cur_id" = "$old_id" ]; then
		cp "$GUARD_CLAUDE" "$claude_settings"
		record file "$new_id" "$SETTINGS_REL"
		report updated "$SETTINGS_REL"
		TOUCHED="$TOUCHED $SETTINGS_REL"
	else
		if [ -n "$old_id" ]; then record file "$old_id" "$SETTINGS_REL"; fi
		if grep -q "$SETTINGS_KEY" "$claude_settings" 2>/dev/null; then
			report kept "$SETTINGS_REL" "it is yours and remit does not rewrite it; it already sets $SETTINGS_KEY, and that value is yours too. To make Claude Code enforce the guard, merge the \"hooks\" object below into it deliberately"
		else
			report kept "$SETTINGS_REL" "it is yours and remit does not rewrite it; merge the block below into it deliberately — the \"hooks\" object to enforce the guard, and \"$SETTINGS_KEY\": \"$SETTINGS_MS\" under \"env\", without which Claude Code kills any raise past its own 600000 ms ceiling"
		fi
		sed 's/^/               /' "$GUARD_CLAUDE"
	fi
fi

# --- what remit no longer ships ----------------------------------------------
for f in $RETIRED_FILES; do
	retire_file "$f" "its harness adapters are bin/remit-invoke's and its delivery half is bin/remit's"
done
for f in $RETIRED_RULEFILES; do
	retire_file "$f" "which harness and model a role sits on lives in .remit/settings.json now; \`sh bin/remit setup\` proposes one from what this host has"
done
for s in $RETIRED_SKILLS; do
	for loc in .claude .agents .pi; do
		retire_file "$loc/skills/$s/SKILL.md" "replaced by the five remit-* conventions"
	done
done

# --- CONTRIBUTING.md: the one managed file ------------------------------------
install_file "$CONTRIB_SRC" "CONTRIBUTING.md" managed

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
	cur_block="$SCRATCH/agents-block"
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

# --- the work location --------------------------------------------------------
mkdir -p "$TGT/.remit/.install" "$TGT/.remit/work-items" "$TGT/.remit/field-reports"

# `.remit/rules/` is bin/remit's to write. Produced in a throwaway repository of
# its own — for the two reasons in this script's header — and installed from
# there as payload.
seed="$SCRATCH/rules-seed"
mkdir -p "$seed"
if git init -q "$seed" >/dev/null 2>&1 &&
	git -C "$seed" config user.email remit-install@localhost &&
	git -C "$seed" config user.name "remit install" &&
	git -C "$seed" config commit.gpgsign false &&
	(cd "$seed" && sh "$SRC/bin/remit" rules init) >/dev/null 2>&1 &&
	[ -f "$seed/.remit/rules/refined.md" ]; then
	for f in $RULEFILES; do
		[ -f "$seed/.remit/rules/$f.md" ] || die "\`remit rules init\` did not write $f.md — the rubrics seed is not what this script expects"
		install_file "$seed/.remit/rules/$f.md" ".remit/rules/$f.md"
	done
else
	die "could not lay down .remit/rules/: \`sh $SRC/bin/remit rules init\` did not produce it in a throwaway repository. Nothing about the rubrics folder is written by this script itself, so there is nothing to fall back to."
fi

# --- the record ---------------------------------------------------------------
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
	if git -C "$TGT" add -A -- "$p" 2>/dev/null; then
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
