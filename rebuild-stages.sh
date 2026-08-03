#!/usr/bin/env bash
# Rebuild cooking-show S00–S05 for Skin Analyzer (Eve docs order:
# instructions → tools → HITL → skill → evals → subagent).
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
AGENT="$ROOT/my-agent"
STAGES="$ROOT/trainer-package/12-code-stages"

echo "ROOT=$ROOT"
rm -rf "$STAGES"/S0[0-9]*

copy_tree() {
  local src="$1" dest="$2"
  mkdir -p "$dest"
  rsync -a --delete \
    --exclude node_modules --exclude .eve --exclude .DS_Store \
    "$src" "$dest"
}

WORK="$(mktemp -d)"
trap 'rm -rf "$WORK"' EXIT
mkdir -p "$WORK/agent" "$WORK/lib" "$WORK/evals"
rsync -a "$AGENT/agent/" "$WORK/agent/"
rsync -a "$AGENT/lib/" "$WORK/lib/"
rsync -a "$AGENT/evals/" "$WORK/evals/"

snapshot() {
  local dest="$1"
  mkdir -p "$dest"
  rsync -a --delete "$WORK/agent/" "$dest/agent/"
  rsync -a --delete "$WORK/lib/" "$dest/lib/"
  rsync -a --delete "$WORK/evals/" "$dest/evals/"
}

# --- S05 END: full (tools + HITL + skill + evals + subagent) ---
snapshot "$STAGES/S05-evals-subagent/END"

# --- S04 END: skill present; no subagent; evals config only ---
snapshot "$STAGES/S04-protocol-skill/END"
rm -rf "$STAGES/S04-protocol-skill/END/agent/subagents"
mkdir -p "$STAGES/S04-protocol-skill/END/agent/subagents"
rm -rf "$STAGES/S04-protocol-skill/END/evals/skin"

# S05 START = S04 END
copy_tree "$STAGES/S04-protocol-skill/END/" "$STAGES/S05-evals-subagent/START/"

# --- S03 END: HITL + tools; no skill yet ---
copy_tree "$STAGES/S04-protocol-skill/END/" "$STAGES/S03-hitl-regimen/END/"
rm -rf "$STAGES/S03-hitl-regimen/END/agent/skills"
mkdir -p "$STAGES/S03-hitl-regimen/END/agent/skills"

# S04 START = S03 END
copy_tree "$STAGES/S03-hitl-regimen/END/" "$STAGES/S04-protocol-skill/START/"

# --- S02 END: analyze tools only (no propose_regimen, no skill) ---
copy_tree "$STAGES/S03-hitl-regimen/END/" "$STAGES/S02-analyze-tools/END/"
rm -f "$STAGES/S02-analyze-tools/END/agent/tools/propose_regimen.ts"

# S03 START = S02 END
copy_tree "$STAGES/S02-analyze-tools/END/" "$STAGES/S03-hitl-regimen/START/"

# --- S01 END: full instructions; no tools, no lib, no skill ---
copy_tree "$STAGES/S02-analyze-tools/END/" "$STAGES/S01-instructions/END/"
rm -rf "$STAGES/S01-instructions/END/agent/tools"
mkdir -p "$STAGES/S01-instructions/END/agent/tools"
rm -rf "$STAGES/S01-instructions/END/lib"
rm -rf "$STAGES/S01-instructions/END/agent/skills"
mkdir -p "$STAGES/S01-instructions/END/agent/skills"

# S02 START = S01 END
copy_tree "$STAGES/S01-instructions/END/" "$STAGES/S02-analyze-tools/START/"

# --- S00 END: stub identity ---
mkdir -p "$STAGES/S00-scaffold/END/agent/channels" \
  "$STAGES/S00-scaffold/END/agent/tools" \
  "$STAGES/S00-scaffold/END/agent/skills" \
  "$STAGES/S00-scaffold/END/agent/subagents" \
  "$STAGES/S00-scaffold/END/evals"
cp "$AGENT/agent/agent.ts" "$STAGES/S00-scaffold/END/agent/agent.ts"
cp "$AGENT/agent/channels/eve.ts" "$STAGES/S00-scaffold/END/agent/channels/eve.ts"
cat > "$STAGES/S00-scaffold/END/agent/instructions.md" <<'EOF'
# Identity

You are **Skin Analyzer Copilot** (workshop stub).

Next: expand instructions → tools → HITL → protocol skill → evals → subagent.

Educational only — not a medical diagnosis. Analysis comes from tools (mock CV stand-in), not invented findings.
EOF
cp "$AGENT/evals/evals.config.ts" "$STAGES/S00-scaffold/END/evals/evals.config.ts"

# S01 START = S00 END
copy_tree "$STAGES/S00-scaffold/END/" "$STAGES/S01-instructions/START/"

# --- S00 START: stock hello ---
mkdir -p "$STAGES/S00-scaffold/START/agent/channels" \
  "$STAGES/S00-scaffold/START/agent/tools" \
  "$STAGES/S00-scaffold/START/agent/skills" \
  "$STAGES/S00-scaffold/START/agent/subagents" \
  "$STAGES/S00-scaffold/START/evals"
cp "$AGENT/agent/agent.ts" "$STAGES/S00-scaffold/START/agent/agent.ts"
cp "$AGENT/agent/channels/eve.ts" "$STAGES/S00-scaffold/START/agent/channels/eve.ts"
cat > "$STAGES/S00-scaffold/START/agent/instructions.md" <<'EOF'
# Instructions

You are a helpful assistant.
EOF
cp "$AGENT/evals/evals.config.ts" "$STAGES/S00-scaffold/START/evals/evals.config.ts"

# Golden binder
mkdir -p "$ROOT/trainer-package/08-evals/golden/skin"
rsync -a --delete "$AGENT/evals/skin/" "$ROOT/trainer-package/08-evals/golden/skin/"
cp "$AGENT/evals/evals.config.ts" "$ROOT/trainer-package/08-evals/golden/evals.config.ts"

echo "OK stages:"
ls -d "$STAGES"/S0*
echo "S02 END tools:"; ls "$STAGES/S02-analyze-tools/END/agent/tools"
echo "S03 END tools:"; ls "$STAGES/S03-hitl-regimen/END/agent/tools"
echo "S03 END skills (expect empty):"; ls "$STAGES/S03-hitl-regimen/END/agent/skills" || true
echo "S04 END skills:"; ls "$STAGES/S04-protocol-skill/END/agent/skills"
echo "S05 END subagent:"; ls "$STAGES/S05-evals-subagent/END/agent/subagents"
