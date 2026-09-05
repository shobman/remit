#!/bin/sh
# remit installer — one deterministic, mechanical step. Point an agent (or a
# human) at this script; nobody installs remit by hand.
#
#   sh /path/to/remit/install.sh [--shadow] /path/to/target-repo
#
# What it installs, and where each harness expects it (researched, not
# invented):
#
#   bin/remit                      the work-item state machine, including the
#                                  delivery seam — it does not fork per harness
#   bin/remit-invoke               the one AI seam: a fresh context, in a named
#                                  harness, with a briefing, in a worktree,
#                                  returning its text
#   bin/remit-exposure             the exposure record — what the work put on the
#                                  practitioner, in words, per session. Its own
#                                  header states what it writes; the two settings
#                                  lines it can be wired into are OFFERED at the
#                                  end of this install and written by nobody here
#   .claude/skills/<name>/         the seven conventions, where Claude Code
#                                  discovers project skills
#   .agents/skills/<name>/         the same seven files, where Codex, Devin and
#                                  Copilot CLI discover project skills — the last
#                                  two need no path of their own, which is why
#                                  there are three of these for five harnesses
#                                  ($REPO_ROOT/.agents/skills)
#   .pi/skills/<name>/             the same seven files, where Pi discovers
#                                  project skills
#   AGENTS.md                      a marker-delimited remit section — Codex, Pi,
#                                  Devin and Copilot CLI all read the repo-root
#                                  AGENTS.md; an existing AGENTS.md is appended
#                                  to, never replaced
#   CONTRIBUTING.md                how the repository takes a contribution. The
#                                  file itself is where that is stated; nothing
#                                  here repeats it. It is MANAGED — see the
#                                  outcome `restored` below
#   .gitignore                     two lines — `.remit/exposure/`, so the
#                                  exposure record stays on the machine that made
#                                  it (ruled by the practitioner), and
#                                  `.remit/settings.local.json`, which names one
#                                  person's own records repository and is theirs
#                                  and not the project's. Reported with the same
#                                  installed/unchanged/kept outcomes as any other
#                                  write. A line he has since taken out is not put
#                                  back. Not written at all under `--shadow`
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
#                                  so a long raise is not killed mid-run. Why
#                                  the ceiling must rise is stated once, at this
#                                  script's registration step below, because
#                                  JSON carries no comment. OFFERED, not imposed: the file is
#                                  created when absent, updated when it is still
#                                  exactly what remit wrote, and when it is yours
#                                  the block to merge is printed and nothing is
#                                  touched
#   .remit/work-items/             the work location, empty
#   .remit/field-reports/          observations from real use, empty
#   .remit/rules/                  the practitioner's rubrics — the gate-file
#                                  shape and the rubrics remit ships, and nothing
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
# is `bin/remit`'s — the shipped rubric text has one home there and this script
# reads it from there rather than carrying a copy — and only a retro the
# practitioner calls writes anything more.
#
# It is also the one thing here NOT migrated file by file, and that is the point
# of this item: a gate file holds both remit's rubrics and the practitioner's, so
# an upgrade that judged the file whole would either overwrite what he wrote or
# never reach what remit changed. It is migrated RUBRIC BY RUBRIC instead, with
# the same honest outcomes read per rubric. What that decides, and why, is at
# "the rubrics" below and nowhere else.
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
# since install, is kept and reported — never overwritten. The rubrics are the
# one thing migrated RUBRIC BY RUBRIC rather than file by file, for the reason
# above; the outcomes they take are at "the rubrics" below.
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
# ==============================================================================
# WHAT `--shadow` DOES DIFFERENTLY
# ==============================================================================
#
# A repository can be worked in with remit without adopting it. `--shadow`
# installs the whole payload above with ZERO FOOTPRINT IN THE REPOSITORY'S
# HISTORY: nothing is staged, nothing is committed, and every clone but this one
# sees a repository nobody has touched. One practitioner, or several
# independently, can then work where the project has decided nothing.
#
# It changes five things and nothing else:
#
#   exclusions      everything laid down is written to `.git/info/exclude` —
#                   git's PER-CLONE ignore file, never committed and never
#                   pushed — inside a marker-delimited block a re-install
#                   replaces. That block is the only thing this mode writes to
#                   git, and `.gitignore` is not touched at all, being committed
#   the block       the managed instruction section goes to the LOCAL,
#                   UNCOMMITTED per-repository instruction file of each harness
#                   established to read one — `CLAUDE.local.md`,
#                   `AGENTS.local.md`, `.pi/APPEND_SYSTEM.md`,
#                   `.github/instructions/remit.instructions.md` and, on the one
#                   condition stated below, `AGENTS.override.md` — and not to the
#                   committed `AGENTS.md`.
#                   Which harness reads which, and how that was established, is
#                   under WHAT IS ESTABLISHED ABOUT THE INSTRUCTION BLOCK below
#   settings        `.claude/settings.json` is NOT written, at all, in any of the
#                   states it takes above. The block to merge is printed and
#                   named for `.claude/settings.local.json`, which is the local
#                   file — the same restraint the pre-push hook shows a
#                   repository with its own `core.hooksPath`
#   CONTRIBUTING.md skipped: a repository that has not adopted remit has no remit
#                   contributor surface, and one telling contributors otherwise
#                   would be one practitioner's tooling speaking for a project
#   the commit      there is none. The manifest is still written, so an upgrade
#                   still knows what was placed
#
# Skills install to disk and are discovered from it exactly as in any other
# install; nothing about discovery changes.
#
# PERSONAL RECORDS ARE REQUIRED, and a shadow install without them is refused
# naming the reason: with no records pointer `bin/remit` keeps the record in this
# repository and commits and pushes it here, which is the footprint this mode
# exists to prevent. What the pointer is, what it may carry and where the clone
# goes is `bin/remit`'s header under WHERE THE RECORD LIVES, and is not restated
# here.
#
# WHAT STAYS VISIBLE is deliberate, unchanged, and stated rather than hidden:
# work branches, pull requests, and the `Co-Authored-By` trailers on them. Shadow
# hides remit's scaffolding, not the fact that AI authored code.
#
# WHAT IS ESTABLISHED ABOUT THE INSTRUCTION BLOCK, per harness. ALL FIVE are
# established, each against its own real CLI and each through a channel that
# reaches no model:
#
#   Claude Code   `CLAUDE.local.md`, its per-repository local instruction file.
#
#   Devin CLI     `AGENTS.local.md`, its per-repository local instruction file,
#                 loaded alongside `AGENTS.md` with the same always-on behaviour
#                 and documented as the personal file to keep out of git.
#                 Established on 2026-08-31 against the real CLI in a throwaway
#                 repository where `AGENTS.local.md` was untracked and excluded
#                 in `.git/info/exclude`: `devin rules list` answered
#                 `AGENTS.local [Standard] always-on`. TRACKEDNESS IS IRRELEVANT
#                 TO IT — the same run listed a skill discovered from an
#                 untracked, excluded `.agents/skills/`, which is why the payload
#                 laid down by this mode is discovered normally.
#                 The negative was stated too narrowly and is corrected here.
#                 Devin does not read `CLAUDE.local.md` — the same fixture, the
#                 file present and absent, no rule either way — but it DOES read
#                 `CLAUDE.md`, through a Claude configuration importer that is on
#                 by default and that also pulls in `~/.claude/CLAUDE.md`,
#                 `.claude/skills/`, `.claude/commands/` and every MCP server a
#                 Claude config names. Established 2026-09-01 on devin 3000.6.7
#                 with `devin rules list`, `devin skills list` and `devin mcp
#                 list` in a throwaway fixture, and documented in the CLI's own
#                 `share/devin/docs/reference/configuration/read-config-from.mdx`.
#                 SO THE TWO FILES ARE TWO SURFACES FOR TWO TOOLS, not one
#                 written twice: `CLAUDE.local.md` reaches Claude Code alone, and
#                 a devin raise under remit has that importer turned OFF —
#                 `devin_write_containment` in `bin/remit-invoke`, which owns
#                 that law and states what the switch was measured to do and what
#                 it does not reach — leaving `AGENTS.local.md` as the surface
#                 that gets there.
#
#   Codex CLI     `AGENTS.override.md`, AND ONLY WHERE IT DISPLACES NOTHING —
#                 which, because Pi reads the same file off a LONGER candidate
#                 list, means no `AGENTS.md` and no `CLAUDE.md`, in either case
#                 spelling. See Pi below for why the condition is that wide.
#                 Established on 2026-08-31 against codex-cli
#                 0.151.0 with `codex debug prompt-input`, which renders the
#                 model-visible prompt as JSON without spending a token, in a
#                 throwaway repository carrying a distinct marker in each
#                 candidate file. What that answered:
#                   * it reads `AGENTS.md` and NOT `AGENTS.local.md`, and not
#                     `CLAUDE.local.md` — neither marker ever appeared;
#                   * TRACKEDNESS IS IRRELEVANT TO IT, the same as Devin: the
#                     fixture's `AGENTS.md` was untracked throughout, and a
#                     convention in an untracked, excluded `.agents/skills/`
#                     was listed in the prompt's own skill roots, which is why
#                     the payload laid down by this mode is discovered normally;
#                   * `AGENTS.override.md` IS read, and it REPLACES `AGENTS.md`
#                     rather than joining it — with both present only the
#                     override's marker reached the prompt. The binary states
#                     the rule itself: "`AGENTS.override.md`, `AGENTS.md`, then
#                     configured fallback filenames", first found wins;
#                   * the config key `project_doc_fallback_filenames` is a
#                     FALLBACK and nothing more: with `AGENTS.md` present it
#                     changed nothing, and only with `AGENTS.md` moved away did
#                     the named file load. It cannot add a local file alongside
#                     a committed one.
#                 SO THE OVERRIDE IS TAKEN ONLY WHEN IT DISPLACES NOTHING. A
#                 repository with an instruction file of its own keeps it:
#                 writing the override there would take the project's
#                 instructions away from every Codex OR PI session in this clone,
#                 which is one practitioner's tooling silencing a project that
#                 decided nothing — the same restraint `CONTRIBUTING.md` and
#                 `.claude/settings.json` get above. The block is printed instead
#                 and nothing is written. And the reverse is mechanical too: if a
#                 repository that had none gains one, the next install REMOVES
#                 the override remit wrote, because from that moment it would be
#                 hiding a file that is the project's.
#
#   Pi            `.pi/APPEND_SYSTEM.md`, its project-local APPEND to the system
#                 prompt — additive by construction, so it displaces nothing and
#                 needs no restraint. Established on 2026-08-31 against pi 0.84.4
#                 through pi's own free channel: an extension loaded with `-e`
#                 that handles `before_agent_start`, prints
#                 `event.systemPromptOptions` and `process.exit(0)`s. That event
#                 fires after the prompt is submitted and BEFORE the agent loop,
#                 so the run reaches no model and spends no token — pi's
#                 equivalent of `codex debug prompt-input`. The fixture carried a
#                 distinct marker in every candidate file. What it answered:
#                   * PI READS `AGENTS.override.md`, and reads it INSTEAD OF both
#                     `AGENTS.md` and `CLAUDE.md`: with all three present the
#                     only context file loaded was the override. Its candidate
#                     list, read off `dist/core/resource-loader.js`, is
#                     `AGENTS.override.md`, `AGENTS.md`, `AGENTS.MD`,
#                     `CLAUDE.md`, `CLAUDE.MD`, first found in a directory wins.
#                     With the override moved away, `AGENTS.md` loaded. THIS IS
#                     WHY THE CODEX CONDITION ABOVE IS WIDER THAN CODEX NEEDS: a
#                     repository with a `CLAUDE.md` and no `AGENTS.md` has
#                     decided something, and remit's override would hide it from
#                     Pi.
#                   * it does NOT read `CLAUDE.local.md` or `AGENTS.local.md` —
#                     neither marker ever appeared, in any run;
#                   * `.pi/APPEND_SYSTEM.md` IS read, and it lands in the system
#                     prompt while the context file stays whatever it was: in the
#                     same run the override's marker was the loaded context file
#                     AND the append's marker was in the system prompt. Nothing
#                     was replaced. (`.pi/SYSTEM.md` REPLACES the default system
#                     prompt; this script does not write it and never will.)
#                   * TRACKEDNESS IS IRRELEVANT TO IT, as on Devin and Codex —
#                     every file in that fixture was untracked and listed in
#                     `.git/info/exclude`, and each was still read. PROJECT TRUST
#                     IS NOT irrelevant, and it is the one caveat this mode
#                     carries on Pi: `.pi/APPEND_SYSTEM.md`, `.pi/skills/` and
#                     `.agents/skills/` are project resources that pi loads ONLY
#                     after the project is trusted. The same fixture run with
#                     `--no-approve` loaded none of the three; with `--approve`
#                     it loaded all three, both project skill roots included.
#                     Trust is answered once, interactively or with
#                     `--approve`/`defaultProjectTrust`, and is saved in
#                     `~/.pi/agent/trust.json` — OUTSIDE the repository, so
#                     answering it adds no footprint. The install says this in
#                     its own output rather than leaving it to be discovered.
#
#   Copilot CLI   `.github/instructions/remit.instructions.md`, ONE FILE in the
#                 directory of per-repository instruction files Copilot reads
#                 whole — additive by construction, like Pi's append and for a
#                 stronger reason, so it displaces nothing and needs no
#                 restraint. Established on 2026-08-31 against copilot 1.0.80
#                 through a free channel of the same class as
#                 `codex debug prompt-input`: the CLI ships its Node bundle
#                 extracted on disk under `$LOCALAPPDATA/copilot/pkg/`, and the
#                 discovery and prompt-assembly functions it calls —
#                 `repoDiscoverInstructionSources`, `repoReadCustomInstructions`
#                 and `promptsCustomInstructions`, all in the bundled native
#                 module — load and answer standalone, so the model-visible
#                 custom-instruction section can be rendered exactly as a session
#                 would build it without a session running. The fixture carried a
#                 distinct marker in every candidate file, every file untracked
#                 and listed in `.git/info/exclude`, `git status` empty. What it
#                 answered:
#                   * THERE IS NO FIRST-FOUND-WINS LIST. Copilot loads every
#                     source it finds TOGETHER:
#                     `.github/copilot-instructions.md`, `AGENTS.md`, `CLAUDE.md`
#                     and `GEMINI.md` are concatenated into one run of
#                     `<custom_instruction>` blocks — all four markers present at
#                     once — and each `.github/instructions/*.instructions.md` is
#                     appended to that section verbatim. This is the one harness
#                     of the five where nothing can displace anything, which is
#                     why remit's file here carries no condition;
#                   * so the surface written is one file in
#                     `.github/instructions/`, NEVER the directory and never
#                     `.github/` itself: almost every repository already has
#                     `.github/`, the instructions directory may already carry the
#                     project's own files, and remit owns exactly the one name it
#                     writes. Written in the marker-delimited shape this script
#                     uses everywhere, with no frontmatter — the `applyTo` header
#                     is not required for discovery and could not parse as
#                     frontmatter under a marker comment anyway. Proven in that
#                     fixture: the block reached the rendered custom-instruction
#                     section while the repository's own `AGENTS.md`, `CLAUDE.md`
#                     and `.github/copilot-instructions.md` all stayed in it;
#                   * it does NOT read `CLAUDE.local.md` or `AGENTS.local.md`.
#                     This is stronger than a fixture negative: neither name
#                     occurs ANYWHERE in the shipped build, JS or native. The
#                     files this mode lays down for Claude Code and Devin are
#                     invisible to Copilot, and nothing here pretends otherwise;
#                   * TRACKEDNESS IS IRRELEVANT TO IT, as on Devin, Codex and Pi
#                     — the whole fixture was untracked and excluded, and every
#                     file was read. PROJECT TRUST IS IRRELEVANT TOO, and this is
#                     where Copilot differs from Pi: the fixture folder was
#                     untrusted throughout, and instruction sources and skills
#                     alike loaded with no prompt, no warning and no gate.
#                     `copilot skill list --json` — free, and the CLI's own
#                     read-back — listed conventions from `.agents/skills/`,
#                     `.claude/skills/` AND `.github/skills/` as
#                     `"source":"project"`, all untracked and excluded, in that
#                     untrusted folder. Trust gates repository HOOKS on this CLI
#                     and nothing else, which is remit's containment's business
#                     and not this script's. No new skill path is installed for
#                     Copilot: the `.agents/skills/` copy this script already
#                     lays down is the one it reads.
#
# THERE IS NO USER-GLOBAL FALLBACK, and this was checked rather than assumed. On
# Devin, global rules (`%APPDATA%\devin\AGENTS.md`, `~/.claude/CLAUDE.md`,
# `~/.devin/rules/*.md`) are documented as loaded "at the start of every session,
# regardless of which project you're working in"; the only conditional frontmatter
# a rule carries — `trigger: glob`, or Cursor's `globs:` — matches PATHS WITHIN
# the workspace, never which repository the workspace is. On Codex the same was
# driven rather than read: `$CODEX_HOME/AGENTS.md` loaded in the fixture on top
# of everything the repository had, in every run, and `config.toml`'s per-project
# section is `[projects.'<path>']` carrying `trust_level` — a
# `project_doc_fallback_filenames` placed inside one parsed without complaint and
# had NO effect, while the same key at the top level worked. Profiles are chosen
# by `profile`/`--profile`, by name and never by repository. On Pi it was read off
# the shipped build rather than driven, and it is not ambiguous:
# `dist/core/resource-loader.js` loads `$PI_CODING_AGENT_DIR/AGENTS.md`
# unconditionally, from the agent directory, BEFORE it walks the tree at all —
# there is no repository in the expression. Settings come in exactly two scopes,
# global `~/.pi/agent/settings.json`
# and project `.pi/settings.json`, with no per-repository section in the global
# one; the only directory-keyed global state pi has is `trust.json`, which
# carries a trust decision and cannot carry an instruction. On Copilot it was
# driven, through the same free channel as above:
# `$HOME/.copilot/copilot-instructions.md` loaded IDENTICALLY in two different
# repositories, and the one route that looked like scoping is not one — a
# `$HOME/.copilot/instructions/*.instructions.md` whose `applyTo` was an ABSOLUTE
# path glob naming one repository was listed, with that same pattern, in the
# OTHER repository's prompt too. `applyTo` is passed to the model as a hint, not
# applied as a load-time filter, and those user files are named to the model
# rather than inlined at all. Copilot's config carries exactly one
# directory-keyed key, `trustedFolders` — a trust decision, the same shape as
# pi's `trust.json`, and it cannot carry an instruction. Nothing scopes a
# user-global instruction to one repository, so this script offers no such
# fallback to any harness: it would bind every repository on the machine to one
# repository's remit, which is worse than the honest gap.
#
# MIGRATION BETWEEN THE MODES IS NOT HERE. A shadow install over a committed one,
# and a committed install over a shadow one, each REFUSE and name which install
# is present. Which one a repository carries is read off the manifest without a
# new field: a committed install has it tracked, a shadow one has it untracked.
#
# Exit codes: 0 installed/upgraded (skips are reported, not fatal)
#             2 usage or environment error; nothing was changed

set -eu

die() { printf 'remit install: %s\n' "$1" >&2; exit 2; }

# Make a directory, creating ONLY the components of it that are missing.
#
# Deliberately not `mkdir -p`: that walks the whole path from the root and
# attempts every ancestor, including the ones far above the target that no
# installer has any business creating. Where such an ancestor cannot be created
# — a Windows drive root, a per-user home directory, anything a sandbox holds
# read-only —
# `mkdir -p` reports `cannot create directory ...: Permission denied` and the
# install dies before it has written a byte, even though the directory it was
# asked for was perfectly creatable. bin/remit carries the same helper for the
# same reason: the two are separate programs and neither can source the other.
ensure_dir() { # $1 a directory
	[ -d "$1" ] && return 0
	_parent=$(dirname "$1")
	[ "$_parent" = "$1" ] || ensure_dir "$_parent" || return 1
	mkdir "$1"
}

USAGE='usage: sh install.sh [--shadow] <target-repo-dir>'
SHADOW=no
TARGET=''
while [ $# -gt 0 ]; do
	case "$1" in
	--shadow) SHADOW=yes ;;
	-*) printf 'unknown option: %s\n%s\n' "$1" "$USAGE" >&2; exit 2 ;;
	*)
		[ -z "$TARGET" ] || { printf '%s\n' "$USAGE" >&2; exit 2; }
		TARGET=$1
		;;
	esac
	shift
done
[ -n "$TARGET" ] || { printf '%s\n' "$USAGE" >&2; exit 2; }
set -- "$TARGET"

# --- source: the remit checkout this script sits in ---------------------------
SRC=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd -P)
VERSION=$(cat "$SRC/VERSION" 2>/dev/null) || die "no VERSION file at $SRC — is this a complete remit checkout?"

SKILLS="remit-new remit-resume remit-close remit-status remit-retro remit-exposure remit-review"

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
[ -f "$SRC/bin/remit-exposure" ] || die "payload missing: $SRC/bin/remit-exposure"
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
TOP=$(git -C "$TGT" rev-parse --show-toplevel 2>/dev/null) || die "$1 is not inside a Git repository"

# ONE PATH NAMESPACE — the caller's here, and DELIBERATELY not the one
# `bin/remit` picks. The rule, the two spellings and what breaks are stated once
# under that heading in `bin/remit` and not restated here; what belongs here is
# only which side of it this script takes, and why it is the other one.
#
# `bin/remit` hands paths to a raised context that is not an MSYS program, so it
# converts to the drive-lettered name everything can resolve. Nothing here
# crosses that seam: this script writes files, records them in
# `.remit/.install/manifest` REPO-RELATIVE, and every absolute path it holds dies
# with the install. So the target it reports and writes through is the one the
# caller named, in the namespace the caller named it in.
TGT=$(CDPATH= cd -- "$TOP" 2>/dev/null && pwd -P) || die "cannot resolve the repository root at $TOP"

# rev-parse may answer with paths relative to the target — resolve from there.
git_dir=$(CDPATH= cd -- "$TGT" && CDPATH= cd -- "$(git rev-parse --git-dir)" && pwd -P)
common_dir=$(CDPATH= cd -- "$TGT" && CDPATH= cd -- "$(git rev-parse --git-common-dir)" && pwd -P)
[ "$git_dir" = "$common_dir" ] || die "$TGT is a linked worktree — install into the primary worktree at $(dirname "$common_dir")"

MANIFEST=".remit/.install/manifest"
MANIFEST_ABS="$TGT/$MANIFEST"

# ==============================================================================
# SHADOW — the same install, with nothing of it in the repository's history
# ==============================================================================
#
# What `--shadow` changes is stated at the head of this script under WHAT
# `--shadow` DOES DIFFERENTLY and nowhere else; this is the decision, the two
# refusals and the exclusion file.
#
# WHICH INSTALL IS ALREADY HERE is read off the manifest, and it needs no new
# field to answer: a committed install has the manifest IN THE TREE, a shadow one
# has it on disk and untracked. That distinction is a fact about the repository
# rather than a claim the manifest makes about itself, so it is also right for
# every install made before this flag existed.
EXCLUDE_FILE="$common_dir/info/exclude"
INSTALLED_MODE=none
if [ -f "$MANIFEST_ABS" ]; then
	if git -C "$TGT" ls-files --error-unmatch -- "$MANIFEST" >/dev/null 2>&1; then
		INSTALLED_MODE=committed
	else
		INSTALLED_MODE=shadow
	fi
fi

# MIGRATION BETWEEN THE TWO IS NOT THIS SCRIPT'S, and pretending otherwise is
# what would hurt: a shadow install laid over a committed one would leave the
# committed files tracked and the exclusions unable to hide them, and a committed
# install over a shadow one would commit into the history the whole point of the
# shadow was to keep out of it. Each refuses, naming which install is there.
if [ "$SHADOW" = yes ] && [ "$INSTALLED_MODE" = committed ]; then
	die "$TGT already carries a COMMITTED remit install — $MANIFEST is tracked in its history. A shadow install over it would leave those files committed and the exclusions powerless to hide them. Remove the committed install and commit that removal first."
fi
if [ "$SHADOW" = no ] && [ "$INSTALLED_MODE" = shadow ]; then
	die "$TGT already carries a SHADOW remit install — $MANIFEST is on disk and untracked. A committed install over it would put into this repository's history exactly what the shadow install exists to keep out of it. Re-run with --shadow, or take the shadow install away first."
fi

if [ "$SHADOW" = yes ]; then
	# PERSONAL RECORDS ARE REQUIRED HERE, and the reason is not tidiness: with no
	# pointer, `bin/remit` keeps the record in the project repository and commits
	# and pushes it there, which is a footprint in the history — the one thing a
	# shadow install promises there will not be. What the pointer is and what it
	# may carry is `bin/remit`'s header, under WHERE THE RECORD LIVES; this reads
	# it only to establish that a records remote is named.
	_lsettings="$TGT/.remit/settings.local.json"
	_lremote=''
	[ -f "$_lsettings" ] && _lremote=$(tr -d '\n\r\t' <"$_lsettings" |
		sed -n 's/.*"records"[[:space:]]*:[[:space:]]*{\([^}]*\)}.*/\1/p' |
		sed -n 's/.*"remote"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/p' | sed -n 1p)
	[ -n "$_lremote" ] ||
		die "--shadow needs personal records and this repository has none: no records remote is named in .remit/settings.local.json. Without one the record is kept, committed and pushed in THIS repository, which is the footprint --shadow exists to prevent. Write that file first — its shape is in bin/remit's header, under WHERE THE RECORD LIVES."
	[ -d "$common_dir/info" ] || ensure_dir "$common_dir/info" ||
		die "cannot make $common_dir/info, where the per-clone exclusions go"
fi

# THE ONE WRITE A SHADOW INSTALL MAKES TO GIT, and it is to a file git never
# commits and never pushes: `.git/info/exclude`, this clone's own ignore list.
# The block is marker-delimited so a re-install replaces exactly what the last
# one wrote and nothing a person put there themselves.
EX_BEGIN='# remit:begin — this clone only. Written by remit --shadow; never committed, never pushed.'
EX_END='# remit:end'
exclude_write() { # every path to exclude, one per argument
	[ "$SHADOW" = yes ] || return 0
	_ex_new="$SCRATCH/exclude.new"
	if [ -f "$EXCLUDE_FILE" ]; then
		awk -v b="$EX_BEGIN" -v e="$EX_END" '
			$0 == b { skip = 1; next }
			$0 == e { skip = 0; next }
			!skip
		' "$EXCLUDE_FILE" >"$_ex_new" || return 1
	else
		: >"$_ex_new" || return 1
	fi
	{
		printf '%s\n' "$EX_BEGIN"
		for _exp in "$@"; do printf '/%s\n' "${_exp#/}"; done
		printf '%s\n' "$EX_END"
	} >>"$_ex_new" || return 1
	mv "$_ex_new" "$EXCLUDE_FILE" || return 1
	return 0
}

SCRATCH=$(mktemp -d 2>/dev/null) || SCRATCH=${TMPDIR:-/tmp}/remit-install-$$
ensure_dir "$SCRATCH" || die "cannot make a scratch directory"
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
		ensure_dir "$(dirname "$TGT/$dst")"
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

# --- the mechanics and the seven conventions, where each harness looks --------
# Three copies, five harnesses: Devin and Copilot CLI both discover project
# skills at .agents/skills too, so neither needs a copy of its own. Copilot CLI's
# own discovery set — probed, not assumed — is .github/skills/, .agents/skills/
# and .claude/skills/, so the copy written here is the one it reads, and adding a
# fourth location for it would be a second home for content that already has one.
install_file "$SRC/bin/remit" "bin/remit"
install_file "$SRC/bin/remit-invoke" "bin/remit-invoke"
install_file "$SRC/bin/remit-exposure" "bin/remit-exposure"
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
# `env.BASH_MAX_TIMEOUT_MS`. Why a raise needs that ceiling raised is stated
# HERE, its one home: Claude Code cuts a shell call's requested timeout to
# `max(BASH_MAX_TIMEOUT_MS, BASH_DEFAULT_TIMEOUT_MS)`, so 600 000 ms unless this
# file says otherwise, and a raise past ten minutes dies mid-run without it. It
# serves this one harness; the others need nothing here.
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
if [ "$SHADOW" = yes ]; then
	# GUIDANCE, AND NOT ONE BYTE WRITTEN. `.claude/settings.json` is a committed
	# file: a shadow install writing one would be laying a settings file into a
	# repository that decided nothing, and excluding it afterwards would only hide
	# a decision it had no business making. The local file `.claude/settings.local.json`
	# is the surface that IS a shadow install's to suggest — and suggesting is all
	# this does, here as everywhere else settings are concerned.
	report skipped "$SETTINGS_REL" "--shadow: remit writes no settings file here. Merge the block below into .claude/settings.local.json yourself — the \"hooks\" object to enforce the agent-tool guard, and \"$SETTINGS_KEY\": \"$SETTINGS_MS\" under \"env\", without which Claude Code kills any raise past its own 600000 ms ceiling"
	sed 's/^/               /' "$GUARD_CLAUDE"
elif [ ! -e "$claude_settings" ]; then
	ensure_dir "$TGT/.claude"
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
		retire_file "$loc/skills/$s/SKILL.md" "replaced by the remit-* conventions"
	done
done

# --- CONTRIBUTING.md: the one managed file ------------------------------------
# A shadow repository has no contributor surface to describe: the project has
# decided nothing about remit, and a CONTRIBUTING.md telling contributors how
# this repository takes work would be one practitioner's tooling speaking for a
# project that never adopted it.
if [ "$SHADOW" = yes ]; then
	report skipped "CONTRIBUTING.md" "--shadow: a repository that has not adopted remit has no remit contributor surface"
else
	install_file "$CONTRIB_SRC" "CONTRIBUTING.md" managed
fi

# --- the managed, marker-delimited instruction section ------------------------
# Additive, never a clobber. WHICH FILES it goes in is the one thing `--shadow`
# changes here: a committed install writes the single committed `AGENTS.md` the
# harnesses read, and a shadow install writes the LOCAL, UNCOMMITTED per-repo
# instruction file of each harness established to read one — `CLAUDE.local.md`
# for Claude Code, `AGENTS.local.md` for Devin, `.pi/APPEND_SYSTEM.md` for Pi,
# `.github/instructions/remit.instructions.md` for Copilot CLI, and
# `AGENTS.override.md` for Codex on the one condition below. All five harnesses
# are established; how each was, and on what condition, is stated at the head of
# this script under WHAT `--shadow` DOES DIFFERENTLY, and is disclosed in this
# script's own output below rather than left for a reader to discover.
#
# The same section goes in each: it has one source (`$ADAPTER`), so there is no
# per-harness wording that could drift.
if [ "$SHADOW" = yes ]; then
	BLOCK_TARGETS='CLAUDE.local.md AGENTS.local.md'
else
	BLOCK_TARGETS='AGENTS.md'
fi
CODEX_LOCAL='AGENTS.override.md'
PI_LOCAL='.pi/APPEND_SYSTEM.md'
COPILOT_LOCAL='.github/instructions/remit.instructions.md'
MARK_BEGIN='<!-- remit:begin — this section is managed by remit'\''s installer and is replaced on upgrade -->'
MARK_END='<!-- remit:end -->'

write_block() { # appends the managed section to $1
	{
		printf '%s\n' "$MARK_BEGIN"
		cat "$ADAPTER"
		printf '%s\n' "$MARK_END"
	} >>"$1"
}

# One file, one honest outcome — the same outcomes this script reports
# everywhere else, read per instruction file rather than once for all of them,
# because each is separately the target's to edit.
install_block() { # $1 a path, relative to the target, to carry the managed section
	_b_rel=$1
	_b_abs="$TGT/$_b_rel"
	_b_new=$(hash_of "$ADAPTER")
	_b_old=$(manifest_id block "$_b_rel")
	if [ ! -e "$_b_abs" ]; then
		write_block "$_b_abs"
		record block "$_b_new" "$_b_rel"
		report installed "$_b_rel" "created with the remit section"
		TOUCHED="$TOUCHED $_b_rel"
	elif ! grep -q '^<!-- remit:begin' "$_b_abs"; then
		printf '\n' >>"$_b_abs"
		write_block "$_b_abs"
		record block "$_b_new" "$_b_rel"
		report updated "$_b_rel" "remit section appended; existing content untouched"
		TOUCHED="$TOUCHED $_b_rel"
	else
		_b_cur="$SCRATCH/block-current"
		awk '/^<!-- remit:begin/{b=1;next} /^<!-- remit:end/{b=0;next} b' "$_b_abs" >"$_b_cur"
		_b_curid=$(hash_of "$_b_cur")
		if [ "$_b_curid" = "$_b_new" ]; then
			record block "$_b_new" "$_b_rel"
			report unchanged "$_b_rel" "remit section"
		elif [ -z "$_b_old" ]; then
			record block "$_b_curid" "$_b_rel"
			report kept "$_b_rel" "a remit section is present but not in the manifest; left alone as found"
		elif [ "$_b_curid" != "$_b_old" ]; then
			record block "$_b_old" "$_b_rel"
			report kept "$_b_rel" "remit section edited locally; left alone"
		else
			awk -v adapter="$ADAPTER" '
				/^<!-- remit:begin/ {print; while ((getline line < adapter) > 0) print line; skip=1; next}
				/^<!-- remit:end/   {skip=0; print; next}
				!skip
			' "$_b_abs" >"$_b_abs.remit-tmp"
			mv "$_b_abs.remit-tmp" "$_b_abs"
			record block "$_b_new" "$_b_rel"
			report updated "$_b_rel" "remit section"
			TOUCHED="$TOUCHED $_b_rel"
		fi
		rm -f "$_b_cur"
	fi
}

# THE OVERRIDE IS AN OVERRIDE, NOT AN ADDITION, and that one fact decides
# everything below. Two harnesses read `AGENTS.override.md` and BOTH take the
# first file they find rather than joining them: Codex reads
# `AGENTS.override.md`, `AGENTS.md`, then whatever `project_doc_fallback_filenames`
# names; Pi reads `AGENTS.override.md`, `AGENTS.md`, `AGENTS.MD`, `CLAUDE.md`,
# `CLAUDE.MD`. So the override does not sit beside a repository's own instruction
# file, it silences it — and the file it can silence is whichever of the union of
# those candidates the repository actually has. How both were established is at
# the head of this script and not restated here.
#
# The rule this script follows from it is the one it follows for CONTRIBUTING.md
# and `.claude/settings.json`: where a write would speak for a project that
# decided nothing, print the block and touch nothing.
#
#   no candidate    the override displaces nothing and is written, excluded
#                   per-clone with everything else, and reported like any other
#                   instruction file
#   a candidate     not written. The install says which file it would have hidden
#                   and prints the section
#   both, and the   the override remit itself wrote is now hiding a file that is
#   override is     the project's. It is REMOVED — and only when it is remit's
#   remit's alone   whole content, so a file a person added anything to is theirs
#                   and is kept with the warning instead
#
# $CX_DISPLACED is the candidate found, or empty. It is read once here and used
# again by this script's own disclosure at the end, so the two cannot disagree.
CX_DISPLACED=''
for _cx_c in AGENTS.md AGENTS.MD CLAUDE.md CLAUDE.MD; do
	if [ -e "$TGT/$_cx_c" ]; then
		CX_DISPLACED=$_cx_c
		break
	fi
done
if [ "$SHADOW" = yes ]; then
	_cx_abs="$TGT/$CODEX_LOCAL"
	if [ -z "$CX_DISPLACED" ]; then
		BLOCK_TARGETS="$BLOCK_TARGETS $CODEX_LOCAL"
	elif [ ! -e "$_cx_abs" ]; then
		report skipped "$CODEX_LOCAL" "--shadow: Codex and Pi both read it INSTEAD OF the repository's own instruction file, not alongside it, and this repository has a $CX_DISPLACED. Writing it would take the project's own instructions away from every Codex and Pi session in this clone, which is not an installer's call. Put the section below into $CODEX_LOCAL yourself, above your $CX_DISPLACED content, if you want it in front of Codex here — Pi already has it in $PI_LOCAL"
		printf '%s\n' "$MARK_BEGIN" | sed 's/^/               /'
		sed 's/^/               /' "$ADAPTER"
		printf '%s\n' "$MARK_END" | sed 's/^/               /'
	else
		# Is this file remit's whole doing, or does it carry something of theirs?
		# Two conditions, and both must hold: nothing outside the markers, and a
		# section that is either the payload or exactly what the manifest says
		# remit last wrote there.
		_cx_out="$SCRATCH/codex-outside"
		_cx_in="$SCRATCH/codex-inside"
		awk '/^<!-- remit:begin/{b=1;next} /^<!-- remit:end/{b=0;next} !b' "$_cx_abs" >"$_cx_out"
		awk '/^<!-- remit:begin/{b=1;next} /^<!-- remit:end/{b=0;next} b' "$_cx_abs" >"$_cx_in"
		_cx_inid=$(hash_of "$_cx_in")
		_cx_old=$(manifest_id block "$CODEX_LOCAL")
		_cx_new=$(hash_of "$ADAPTER")
		if [ ! -s "$_cx_out" ] && { [ "$_cx_inid" = "$_cx_new" ] ||
			{ [ -n "$_cx_old" ] && [ "$_cx_inid" = "$_cx_old" ]; }; }; then
			rm -f "$_cx_abs"
			report removed "$CODEX_LOCAL" "this repository now has a $CX_DISPLACED, and remit's override was hiding it from Codex and Pi. It was remit's whole content, so it is gone"
		else
			report kept "$CODEX_LOCAL" "it is yours, and remit does not rewrite or delete your files — but be aware Codex and Pi read it INSTEAD OF this repository's $CX_DISPLACED, which it is currently hiding"
		fi
		rm -f "$_cx_out" "$_cx_in"
	fi
fi

# PI'S LOCAL SURFACE IS AN ADDITION, and needs no restraint of its own: pi
# APPENDS `.pi/APPEND_SYSTEM.md` to its default system prompt and replaces
# nothing, which is why this script writes it and never writes `.pi/SYSTEM.md`,
# the sibling that WOULD replace. Established at the head of this script.
#
# The one thing that could still put a footprint in the repository is a project
# that TRACKS the file: appending to a tracked file is a modification `git
# status` shows to the practitioner and `git diff` shows to anyone they hand the
# tree to, and `.git/info/exclude` cannot hide a tracked path. So a tracked
# `.pi/APPEND_SYSTEM.md` is left alone and the section is printed, the same
# restraint every other surface here gets.
if [ "$SHADOW" = yes ]; then
	if git -C "$TGT" ls-files --error-unmatch -- "$PI_LOCAL" >/dev/null 2>&1; then
		report skipped "$PI_LOCAL" "--shadow: this repository TRACKS it. Appending here would be a modification git shows in every status and diff, and an exclude file cannot hide a tracked path — which is the one thing this mode promises. Put the section below into it yourself if you want it in front of Pi here"
		printf '%s\n' "$MARK_BEGIN" | sed 's/^/               /'
		sed 's/^/               /' "$ADAPTER"
		printf '%s\n' "$MARK_END" | sed 's/^/               /'
		PI_TRACKED=yes
	else
		ensure_dir "$TGT/.pi"
		BLOCK_TARGETS="$BLOCK_TARGETS $PI_LOCAL"
		PI_TRACKED=no
	fi
fi

# COPILOT'S LOCAL SURFACE IS AN ADDITION TOO, and for a stronger reason than
# Pi's: on Copilot CLI there is no first-found-wins list at all. Every
# instruction source it finds is loaded TOGETHER — `.github/copilot-instructions.md`,
# `AGENTS.md`, `CLAUDE.md` and `GEMINI.md` are concatenated into one
# `<custom_instruction>` run, and every `.github/instructions/*.instructions.md`
# is appended to it verbatim. So one file in that directory displaces nothing,
# whatever else the repository has, and needs none of the restraint
# `AGENTS.override.md` needs. How that was established is at the head of this
# script and not restated here.
#
# ONE FILE IN THE DIRECTORY, never the directory: `.github/` is a directory
# almost every repository already has, `.github/instructions/` may already carry
# the project's own instruction files, and remit owns exactly the one name it
# writes. The tracked guard is Pi's, for Pi's reason — an exclude file cannot
# hide a tracked path, so appending to one would be a modification git shows to
# everyone.
if [ "$SHADOW" = yes ]; then
	if git -C "$TGT" ls-files --error-unmatch -- "$COPILOT_LOCAL" >/dev/null 2>&1; then
		report skipped "$COPILOT_LOCAL" "--shadow: this repository TRACKS it. Appending here would be a modification git shows in every status and diff, and an exclude file cannot hide a tracked path — which is the one thing this mode promises. Put the section below into it yourself, or into another file in .github/instructions/, if you want it in front of Copilot CLI here"
		printf '%s\n' "$MARK_BEGIN" | sed 's/^/               /'
		sed 's/^/               /' "$ADAPTER"
		printf '%s\n' "$MARK_END" | sed 's/^/               /'
		COPILOT_TRACKED=yes
	else
		ensure_dir "$TGT/.github/instructions"
		BLOCK_TARGETS="$BLOCK_TARGETS $COPILOT_LOCAL"
		COPILOT_TRACKED=no
	fi
fi

for b in $BLOCK_TARGETS; do
	install_block "$b"
done

# --- the push guards, in the shared hooks dir so every worktree inherits them -
hookspath=$(git -C "$TGT" config core.hooksPath 2>/dev/null || true)
if [ -n "$hookspath" ]; then
	report skipped "pre-push guard" "core.hooksPath is set to '$hookspath'; that hook system is yours — merge $HOOK_SRC into it deliberately"
else
	hook_dst="$common_dir/hooks/pre-push"
	new_id=$(hash_of "$HOOK_SRC")
	old_id=$(manifest_id hook pre-push)
	if [ ! -e "$hook_dst" ]; then
		ensure_dir "$common_dir/hooks"
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

# --- the exposure record stays local ------------------------------------------
# Ruled by the practitioner, 2026-08-23, on seeing his own sessions recorded:
# "perhaps it is git-ignore, or else it's a bit like spying is it? if my team all
# had it, i sort of have this new thing i can do to check in on my team — so git
# ignore for now." So this is a write, not an offer, and it takes the same four
# outcomes as every other write here.
#
# The line is matched EXACTLY and on its own, so the comment above it can be
# reworded, moved or deleted without this installer deciding the line is gone.
# And the manifest is what tells a first install from a line he has since taken
# out: absent from the manifest means remit never wrote it and this is the first
# time; present in the manifest with the line gone means he removed it, and a
# decision he made is not undone by re-running an installer.
# TWO LINES, and the SET is the unit. `.remit/settings.local.json` joined the
# exposure record here because it is per-user by definition — it names the
# practitioner's own records repository, and committing it would publish where
# one person keeps their working state and hand it to everybody else's clone as
# though it were the project's. The outcomes below read the set: all present is
# `unchanged`, any missing on a first install is `updated` with only those
# appended, and any missing where the manifest says remit wrote them is a
# decision he made and is not undone by re-running an installer.
IGNORE_PATHS=".remit/exposure/ .remit/settings.local.json"
IGNORE_ABS="$TGT/.gitignore"
# ANCHORED, like every other hash here — see `hash_of` above. An unanchored
# `git hash-object` runs in whatever directory the installer was invoked from,
# and a caller whose cwd is a repository git cannot open (a Windows worktree
# read from WSL, most easily) makes this line exit 128 mid-install.
ignore_id=$(for _ip in $IGNORE_PATHS; do printf '%s\n' "$_ip"; done | git -C "$TGT" hash-object --stdin)
ignore_old=$(manifest_id ignore .gitignore)

# The lines of the set that the target's .gitignore does not already carry, each
# matched EXACTLY and on its own so the comment above them can be reworded,
# moved or deleted without this installer deciding a line is gone.
ignore_missing() {
	for _ip in $IGNORE_PATHS; do
		grep -Fqx -- "$_ip" "$IGNORE_ABS" 2>/dev/null || printf '%s\n' "$_ip"
	done
}
IGNORE_COMMENT='# remit: one machine'\''s own — the exposure record, and the pointer to a personal records repository'

if [ "$SHADOW" = yes ]; then
	# `.gitignore` IS COMMITTED, so a shadow install must not touch it: pushing a
	# line to it would be a footprint in the history of exactly the kind this mode
	# exists to prevent, and would tell everyone else's clone about one
	# practitioner's tooling. The exposure record is excluded per-clone with
	# everything else remit lays down — see the exclusions written at the end.
	report skipped ".gitignore" "--shadow: it is committed. Everything this install laid down, these lines included, is excluded per-clone in .git/info/exclude instead"
elif [ ! -e "$IGNORE_ABS" ]; then
	{
		printf '%s\n' "$IGNORE_COMMENT"
		for _ip in $IGNORE_PATHS; do printf '%s\n' "$_ip"; done
	} >"$IGNORE_ABS"
	record ignore "$ignore_id" .gitignore
	report installed ".gitignore" "created, ignoring $IGNORE_PATHS"
	TOUCHED="$TOUCHED .gitignore"
elif [ -z "$(ignore_missing)" ]; then
	record ignore "$ignore_id" .gitignore
	report unchanged ".gitignore" "already ignores $IGNORE_PATHS"
# A LINE THAT WAS NEVER OFFERED IS NOT A LINE HE REMOVED, and the manifest tells
# the two apart without a second field. `$ignore_old` is what the last install
# recorded for this file: when it is the id of the set as it stands TODAY, every
# line in that set was written and anything missing now went out on purpose. When
# it is anything else — an older remit that offered fewer lines, which is exactly
# the upgrade this two-line set creates — the missing lines are new payload and
# are appended, the same as on a first install.
elif [ -z "$ignore_old" ] || [ "$ignore_old" != "$ignore_id" ]; then
	missing=$(ignore_missing)
	{
		printf '\n%s\n' "$IGNORE_COMMENT"
		printf '%s\n' "$missing"
	} >>"$IGNORE_ABS"
	record ignore "$ignore_id" .gitignore
	report updated ".gitignore" "$(printf '%s' "$missing" | tr '\n' ' ')appended; existing content untouched"
	TOUCHED="$TOUCHED .gitignore"
else
	record ignore "$ignore_old" .gitignore
	report kept ".gitignore" "$(printf '%s' "$(ignore_missing)" | tr '\n' ' ')was removed since install; left out — that is your call, not this installer's"
fi

# --- the work location --------------------------------------------------------
ensure_dir "$TGT/.remit/.install"
ensure_dir "$TGT/.remit/work-items"
ensure_dir "$TGT/.remit/field-reports"

# --- the rubrics: laid down at install, migrated rubric by rubric at upgrade ---
# The shipped rubric text has ONE home — `rubrics_shipped` in bin/remit — and
# this installer reads it from there rather than carrying a copy. bin/remit owns
# the file format too: `rules seed` lays the shape down, `rules read` parses a
# target's gate files with the same parser that judges them, and `rules apply`
# edits a rubric line and touches nothing else. What is decided HERE is the
# policy, and it is the per-file policy above read per RUBRIC:
#
#   installed  we ship it and this repository has never had it
#   updated    we changed it and nobody here had — or we BOTH changed it, and
#              we shipped it, so ours wins
#   unchanged  it already reads exactly as we ship it
#   deleted    we no longer ship it and nobody here had changed it
#   kept       it is theirs: they wrote it, or they changed it and we did not,
#              or they removed one of ours, or it was already here before any
#              manifest recorded a rubric and does not read as we ship it
#
# The manifest carries one `rubric <blob-id> <gate>/<section>/<id>` record per
# rubric we ship, so "did they change ours" is a comparison and not a guess. A
# rubric of ours they DELETED keeps its record: that is how the next upgrade
# knows not to put it back.
#
# Where no rubric was ever recorded — every repository installed before this
# version — there is no evidence of what we shipped last time, so one rule
# stands in for the record: a rubric that reads exactly as we ship it now is
# ours, and everything else in the file is theirs and is kept. It is the only
# thing here decided without a record.
#
# A gate file with no `## <section>` heading to put a new rubric under does not
# get one invented: `rules apply` reports the rubric unapplied and it is reported
# kept. A gate file bin/remit cannot parse is not migrated at all — half a file
# is worse than none — and that is reported too; its records are carried into the
# new manifest unchanged, because a run that could not read the file learned
# nothing that could justify forgetting them.
#
# None of it runs `remit` in the target: the four verbs it drives need no
# repository, write no work surface and commit nothing, which is why they exist.
RULES=".remit/rules"
INSTALLDIR="$TGT/.remit/.install"
TABC=$(printf '\t')

rub_ship="$INSTALLDIR/rub-shipped.tmp"
rub_seeded="$INSTALLDIR/rub-seeded.tmp"
rub_cur="$INSTALLDIR/rub-current.tmp"
rub_ops="$INSTALLDIR/rub-ops.tmp"
rub_pend="$INSTALLDIR/rub-pending.tmp"
rub_unp="$INSTALLDIR/rub-unplaced.tmp"
rub_gship="$INSTALLDIR/rub-gate-shipped.tmp"
rub_gcur="$INSTALLDIR/rub-gate-current.tmp"
rub_grec="$INSTALLDIR/rub-gate-recorded.tmp"

hash_str() { printf '%s' "$1" | git -C "$TGT" hash-object --stdin; }

# <section> <id> <text> for one gate, out of a four-column table
gate_rows() { # $1 table  $2 gate
	awk -F"$TABC" -v g="$2" '$1 == g { print $2 "\t" $3 "\t" $4 }' "$1"
}
# the text one rubric carries in such a table — empty means it is not there,
# which is unambiguous because bin/remit refuses a rubric with no criterion
row_text() { # $1 table  $2 section  $3 id
	awk -F"$TABC" -v s="$2" -v i="$3" '$1 == s && $2 == i { print $3; exit }' "$1"
}
rub_op() { # $1 gate  $2 section  $3 id  $4 add|set|del  $5 text
	printf '%s\t%s\t%s\t%s\t%s\n' "$1" "$2" "$3" "$4" "$5" >>"$rub_ops"
}
# An outcome that depends on the edit landing is held until it has. `-` is "no
# reason to give": an empty field would be eaten by `read`, which folds runs of
# tabs the way it folds runs of spaces.
rub_pending() { # $1 key  $2 outcome  $3 reason or -  $4 blob id to record
	printf '%s\t%s\t%s\t%s\n' "$1" "$2" "$3" "$4" >>"$rub_pend"
}

sh "$SRC/bin/remit" rules ship >"$rub_ship" ||
	die "could not read the shipped rubrics from $SRC/bin/remit"
sh "$SRC/bin/remit" rules seed "$TGT/$RULES" >"$rub_seeded" ||
	die "could not lay down $RULES"
seeded=$(tr '\n' ' ' <"$rub_seeded")
for f in $seeded; do
	report installed "$RULES/$f"
	TOUCHED="$TOUCHED $RULES/$f"
done
sh "$SRC/bin/remit" rules read "$TGT/$RULES" >"$rub_cur" ||
	die "could not read the rubrics in $RULES"
bad_gates=" $(awk -F"$TABC" '$1 == "!" { print $2 }' "$rub_cur" | sort -u | tr '\n' ' ')"

: >"$rub_ops"
: >"$rub_pend"

for g in $RULEFILES; do
	gate_rows "$rub_ship" "$g" >"$rub_gship"

	# Just laid down: it holds exactly what we ship and the line above said so.
	# Record each, so the next upgrade knows which of its rubrics are ours.
	case " $seeded " in
	*" $g.md "*)
		while IFS="$TABC" read -r sec id text; do
			record rubric "$(hash_str "$text")" "$g/$sec/$id"
		done <"$rub_gship"
		continue
		;;
	esac

	case "$bad_gates" in
	*" $g "*)
		# Nothing in this file was read, so nothing in it can be judged — and a
		# record this run cannot re-derive is carried forward rather than
		# dropped. A manifest that forgot what remit shipped here would hand the
		# NEXT upgrade one of remit's own rubrics with no evidence it is remit's,
		# and the no-record rule at the head of this section would then call it
		# the practitioner's forever — over a bad line they fixed the same
		# afternoon.
		if [ -f "$MANIFEST_ABS" ]; then
			awk -v pfx="$g/" '$1 == "rubric" && index($3, pfx) == 1 { print $3 "\t" $2 }' \
				"$MANIFEST_ABS" >"$rub_grec"
			while IFS="$TABC" read -r key rid; do
				record rubric "$rid" "$key"
			done <"$rub_grec"
		fi
		report kept "$RULES/$g.md" "it has lines bin/remit cannot read; no rubric in it was touched"
		continue
		;;
	esac

	gate_rows "$rub_cur" "$g" >"$rub_gcur"
	if [ -f "$MANIFEST_ABS" ]; then
		awk -v pfx="$g/" '$1 == "rubric" && index($3, pfx) == 1 { print $3 "\t" $2 }' \
			"$MANIFEST_ABS" >"$rub_grec"
	else
		: >"$rub_grec"
	fi

	# 1. every rubric this version ships for this gate
	while IFS="$TABC" read -r sec id text; do
		key="$g/$sec/$id"
		new_id=$(hash_str "$text")
		old_id=$(manifest_id rubric "$key")
		cur_text=$(row_text "$rub_gcur" "$sec" "$id")
		if [ -z "$cur_text" ]; then
			if [ -n "$old_id" ]; then
				record rubric "$new_id" "$key"
				report kept "$key" "you removed it; an upgrade does not put it back"
			else
				rub_op "$g" "$sec" "$id" add "$text"
				rub_pending "$key" installed - "$new_id"
			fi
			continue
		fi
		cur_id=$(hash_str "$cur_text")
		if [ "$cur_id" = "$new_id" ]; then
			record rubric "$new_id" "$key"
			report unchanged "$key"
		elif [ -z "$old_id" ]; then
			report kept "$key" "already here before any manifest recorded a rubric, and not what remit ships; left alone as yours"
		elif [ "$cur_id" = "$old_id" ]; then
			rub_op "$g" "$sec" "$id" set "$text"
			rub_pending "$key" updated - "$new_id"
		elif [ "$old_id" = "$new_id" ]; then
			record rubric "$old_id" "$key"
			report kept "$key" "modified locally since install; left alone"
		else
			rub_op "$g" "$sec" "$id" set "$text"
			rub_pending "$key" updated "you changed it and so did remit; remit shipped it, so remit's wins" "$new_id"
		fi
	done <"$rub_gship"

	# 2. every rubric the manifest records that this version no longer ships.
	#    Either way the record goes: it is deleted, or it is theirs now.
	while IFS="$TABC" read -r key rid; do
		rest=${key#"$g/"}
		sec=${rest%%/*}
		id=${rest#*/}
		if [ -n "$(row_text "$rub_gship" "$sec" "$id")" ]; then
			continue
		fi
		cur_text=$(row_text "$rub_gcur" "$sec" "$id")
		if [ -z "$cur_text" ]; then
			continue
		fi
		if [ "$(hash_str "$cur_text")" = "$rid" ]; then
			rub_op "$g" "$sec" "$id" del ''
			report deleted "$key" "remit no longer ships it"
		else
			report kept "$key" "remit no longer ships it and you had changed it; it is yours now"
		fi
	done <"$rub_grec"

	# 3. everything else in the file is theirs, and is said to be
	while IFS="$TABC" read -r sec id text; do
		key="$g/$sec/$id"
		if [ -n "$(row_text "$rub_gship" "$sec" "$id")" ]; then
			continue
		fi
		if [ -n "$(manifest_id rubric "$key")" ]; then
			continue
		fi
		report kept "$key" "yours; remit does not ship it"
	done <"$rub_gcur"
done

: >"$rub_unp"
if [ -s "$rub_ops" ]; then
	sh "$SRC/bin/remit" rules apply "$TGT/$RULES" <"$rub_ops" >"$rub_unp" ||
		die "could not migrate the rubrics in $RULES"
	for g in $RULEFILES; do
		if awk -F"$TABC" -v g="$g" '$1 == g { hit = 1 } END { exit !hit }' "$rub_ops"; then
			TOUCHED="$TOUCHED $RULES/$g.md"
		fi
	done
fi

unplaced=" $(awk -F"$TABC" '$1 == "unplaced" { print $2 "/" $3 "/" $4 }' "$rub_unp" | tr '\n' ' ')"
while IFS="$TABC" read -r key outcome reason blob; do
	case "$unplaced" in
	*" $key "*)
		report kept "$key" "its section heading is not in the file; nothing was inserted"
		continue
		;;
	esac
	record rubric "$blob" "$key"
	if [ "$reason" = - ]; then
		reason=''
	fi
	report "$outcome" "$key" "$reason"
done <"$rub_pend"

rm -f "$rub_ship" "$rub_seeded" "$rub_cur" "$rub_ops" "$rub_pend" "$rub_unp" \
	"$rub_gship" "$rub_gcur" "$rub_grec"

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

# --- a shadow install ends here: excluded, and never staged -------------------
# The exclusions cover EVERYTHING this install laid down — read off `$RECORDS`,
# the manifest's own account of what was placed, so the list cannot drift from
# the payload — plus `.remit/` whole, which carries the work location, the
# rubrics, the registry and the manifest itself, and `bin/`, which exists only
# because remit was put there. Writing them is the ONLY thing this mode does to
# git, and `.git/info/exclude` is neither committed nor pushed.
#
# There is no `git add` and no commit: a shadow install that staged anything
# would have failed at the one thing it promises.
if [ "$SHADOW" = yes ]; then
	ex_paths='.remit/ bin/remit bin/remit-invoke bin/remit-exposure .claude/skills/ .agents/skills/ .pi/skills/ .github/hooks/remit-no-agent-tool.json CLAUDE.local.md AGENTS.local.md'
	# Anything the manifest records that the fixed list above does not already
	# cover — so a payload path added later is excluded without this line being
	# remembered. ONLY the record types whose third column is a path in the
	# target: a `hook` records `pre-push`, which lives in the git dir and is never
	# in the working tree, and a `rubric` records `<gate>/<section>/<id>`, which is
	# not a path at all. Excluding either would put a meaningless pattern in a
	# person's exclude file — `/pre-push` would hide a real file of theirs.
	for p in $(printf '%s' "$RECORDS" | awk '$1 == "file" || $1 == "block" { print $3 }'); do
		case " $ex_paths " in *" $p "*) continue ;; esac
		_covered=no
		for q in $ex_paths; do
			case "$q" in */) case "$p" in "$q"*) _covered=yes ;; esac ;; esac
		done
		[ "$_covered" = yes ] || ex_paths="$ex_paths $p"
	done
	# shellcheck disable=SC2086
	exclude_write $ex_paths ||
		die "could not write the per-clone exclusions to $EXCLUDE_FILE — without them this install is NOT invisible, and the files it laid down are sitting untracked in your working tree"
	printf 'excluded in %s (never committed, never pushed):\n' "$EXCLUDE_FILE"
	for p in $ex_paths; do printf '  /%s\n' "$p"; done
	printf 'nothing was staged and nothing was committed — that is what --shadow means.\n'
	printf 'what stays VISIBLE is deliberate and unchanged: work branches, pull requests,\n'
	printf 'and the Co-Authored-By trailers on them. Shadow hides remit'\''s scaffolding,\n'
	printf 'not the fact that AI authored code.\n'
	printf 'the managed instruction block went to the local, uncommitted per-repo\n'
	printf 'instruction file of each harness established to read one —\n'
	printf '  CLAUDE.local.md   Claude Code reads it per repository.\n'
	printf '  AGENTS.local.md   Devin CLI reads it per repository, alongside AGENTS.md —\n'
	printf '                    verified with `devin rules list`, which lists it always-on\n'
	printf '                    while the file is untracked and excluded. Devin DOES read\n'
	printf '                    CLAUDE.md too, through a Claude importer that is on by\n'
	printf '                    default; a remit raise turns that importer off, so under\n'
	printf '                    remit AGENTS.local.md is the surface that reaches it. The\n'
	printf '                    two files are two surfaces for two tools, not one written\n'
	printf '                    twice.\n'
	if [ "${PI_TRACKED:-no}" = no ]; then
		printf '  .pi/APPEND_SYSTEM.md\n'
		printf '                    Pi APPENDS it to its system prompt, replacing nothing —\n'
		printf '                    verified on pi 0.84.4 with an extension on\n'
		printf '                    before_agent_start, which renders the prompt pi built\n'
		printf '                    before the agent loop runs and so spends no token. Pi\n'
		printf '                    does NOT read CLAUDE.local.md or AGENTS.local.md.\n'
		printf '                    ONE CAVEAT, and it is pi'\''s, not remit'\''s: .pi/ and\n'
		printf '                    .agents/skills/ are project resources pi loads only\n'
		printf '                    after you TRUST this project — answer its prompt, or\n'
		printf '                    pass --approve. Untrusted, pi loads neither this file\n'
		printf '                    nor remit'\''s conventions. The answer is saved in\n'
		printf '                    ~/.pi/agent/trust.json, outside this repository.\n'
	else
		printf '  .pi/APPEND_SYSTEM.md is Pi'\''s additive local surface and it was NOT\n'
		printf '                    written: this repository TRACKS it, and appending would\n'
		printf '                    be a modification git shows to everyone. The section to\n'
		printf '                    place there yourself is in the report above.\n'
	fi
	if [ -z "$CX_DISPLACED" ]; then
		printf '  AGENTS.override.md\n'
		printf '                    Codex CLI reads it INSTEAD OF AGENTS.md — verified with\n'
		printf '                    `codex debug prompt-input`, which renders the prompt\n'
		printf '                    without spending a token. Pi reads it too, and instead\n'
		printf '                    of AGENTS.md AND CLAUDE.md. This repository has neither,\n'
		printf '                    so it displaces nothing. If one is ever added here this\n'
		printf '                    file would hide it: re-run this installer and it will be\n'
		printf '                    removed. Codex does NOT read AGENTS.local.md.\n'
	else
		printf '  AGENTS.override.md is Codex CLI'\''s only local surface and it was NOT\n'
		printf '                    written: Codex and Pi read it INSTEAD OF this\n'
		printf '                    repository'\''s %s, and silencing that is not an\n' "$CX_DISPLACED"
		printf '                    installer'\''s call. The section to place there yourself is\n'
		printf '                    in the report above. Codex does NOT read AGENTS.local.md.\n'
	fi
	if [ "${COPILOT_TRACKED:-no}" = no ]; then
		printf '  %s\n' "$COPILOT_LOCAL"
		printf '                    Copilot CLI loads every instruction source it finds\n'
		printf '                    TOGETHER, so this one displaces nothing — verified on\n'
		printf '                    copilot 1.0.80 against the CLI'\''s own discovery and\n'
		printf '                    prompt-assembly entry points, called directly and so\n'
		printf '                    spending no token, in a repository whose git status was\n'
		printf '                    empty: this file'\''s block reached the model-visible\n'
		printf '                    custom-instruction section while the repository'\''s own\n'
		printf '                    AGENTS.md, CLAUDE.md and .github/copilot-instructions.md\n'
		printf '                    all stayed in it. Copilot does NOT read CLAUDE.local.md\n'
		printf '                    or AGENTS.local.md — neither name exists anywhere in its\n'
		printf '                    shipped build.\n'
	else
		printf '  %s is Copilot CLI'\''s\n' "$COPILOT_LOCAL"
		printf '                    additive local surface and it was NOT written: this\n'
		printf '                    repository TRACKS it, and appending would be a\n'
		printf '                    modification git shows to everyone. The section to place\n'
		printf '                    there — or in any other file under .github/instructions/,\n'
		printf '                    which Copilot reads whole — is in the report above.\n'
	fi
	printf 'Skills are read off disk by all five, tracked or not: Devin lists the\n'
	printf 'conventions from .agents/skills/ while that directory is untracked and\n'
	printf 'excluded, Codex lists them from the same place in the same state, Copilot\n'
	printf 'lists them from .agents/skills/ AND .claude/skills/ in that state with no\n'
	printf 'trust gate of any kind, and pi loads both .pi/skills/ and .agents/skills/\n'
	printf 'from there once the project is trusted — see the caveat above, which is the\n'
	printf 'same gate, and which is pi'\''s alone.\n'
	printf 'A user-global rules file is no fallback on any of the five, and that was\n'
	printf 'checked rather than assumed: global rules load in every project, and the only\n'
	printf 'directory-keyed global state any of these harnesses has carries a TRUST\n'
	printf 'decision, which cannot carry an instruction.\n'
else
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
fi

# --- what this installer OFFERS, and does not write ---------------------------
# `bin/remit-exposure` records nothing until Claude Code is told to call it, and
# telling it means editing a settings file — which is the practitioner's, and his
# decision. The two lines are stated ONCE, in that script's own header, and are
# printed here straight out of it, so there is no second copy to fall out of step
# with the first. Nothing below is written anywhere by this installer.
wiring=$(sed -n '/^# wiring:begin$/,/^# wiring:end$/p' "$SRC/bin/remit-exposure" |
	sed '1d;$d;s/^#\{1\} \{0,1\}//')
if [ -n "$wiring" ]; then
	printf '\nexposure — the lines you MAY add to your Claude Code settings. This installer\n'
	printf 'writes none of them and touches no settings file: what your harness runs is\n'
	printf 'yours. The .gitignore line is the one write it makes on its own — its outcome\n'
	printf 'is in the report above — so the record stays on the machine that made it. Take\n'
	printf 'that line out and re-running this will not put it back.\n\n'
	printf '%s\n' "$wiring"
else
	printf '\nnote: bin/remit-exposure carries no wiring block — the settings lines it\n'
	printf 'offers could not be read out of it, so nothing is offered here.\n'
fi
