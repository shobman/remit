#!/bin/sh
# remit's agent-tool guard — installed by remit's installer at
# `.remit/hooks/no-agent-tool.sh` and registered by every harness here that has
# a pre-tool hook, so that ONE script carries the rule and no second copy of it
# can drift.
#
# THE RULE IT ENFORCES IS NOT STATED HERE. It is one sentence in the managed
# `AGENTS.md` section, which says it for every harness and names which of them
# enforce it by hook and which by instruction. This file is the enforcement.
#
# HOW IT DECIDES. It reads the whole pre-tool payload on stdin and refuses when
# a NAME field in it is one of the harness's agent-tool names. It matches the
# field, not the text, so a file being edited that happens to contain the word
# `Task` is not a sub-agent call and is not blocked.
#
#   Claude Code   `PreToolUse`, payload key `tool_name`. Its agent tool has
#                 shipped as `Task` and as `Agent`; both are refused, and so is
#                 `AgentTool`.
#   Copilot CLI   `preToolUse`, matcher `.*`. Whether this CLI exposes a
#                 sub-agent tool at all, and what it would be called, is NOT
#                 something this repository has probed. So this arm is a guard
#                 against those names and NOT an attestation that copilot has
#                 such a tool. Said here rather than implied by its presence.
#
# WHAT IT CANNOT DO, said rather than implied away: it matches NAMES. A harness
# that renames its agent tool, or reaches a sub-agent through some other tool,
# walks past this. The guard is the cheap half; the durable half is that the
# registry decides every seat and `bin/remit-invoke` is the only thing that
# raises one.
#
# Exit 0 lets the call through. Exit 2 blocks it and shows this script's stderr
# to the model.

payload=$(cat)

# Fails CLOSED. A hook that could not read the call it was asked to check does
# not pass what it cannot read — the same rule as remit's git guard.
if [ -z "$payload" ]; then
	printf 'remit: this hook could not read the tool call to check it, and it does not pass what it cannot read.\n' >&2
	exit 2
fi

if printf '%s\n' "$payload" |
	grep -Eq '"(tool_name|toolName|tool|name)"[[:space:]]*:[[:space:]]*"(Task|Agent|AgentTool)"'; then
	printf 'remit: raise contexts through bin/remit-invoke — settings.json decides the seat\n' >&2
	exit 2
fi

exit 0
