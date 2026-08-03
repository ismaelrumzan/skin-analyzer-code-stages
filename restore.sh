#!/usr/bin/env bash
set -euo pipefail
STAGE="${1:-}"
WHICH="${2:-start}"
ROOT="$(cd "$(dirname "$0")" && pwd)"

usage() {
  echo "Usage: ./restore.sh S03 [start|end]"
  echo "Optional: MY_AGENT_ROOT=/path/to/my-agent ./restore.sh S03 end"
  echo "Stages:"; ls -d "$ROOT"/S0* 2>/dev/null | xargs -n1 basename
  exit 1
}

resolve_agent_root() {
  if [[ -n "${MY_AGENT_ROOT:-}" ]]; then
    echo "$(cd "$MY_AGENT_ROOT" && pwd)"
    return
  fi
  # Cloned next to the Eve app: ../my-agent
  if [[ -d "$ROOT/../my-agent/agent" ]]; then
    echo "$(cd "$ROOT/../my-agent" && pwd)"
    return
  fi
  # Monorepo layout: trainer-package/12-code-stages → ../../my-agent
  if [[ -d "$ROOT/../../my-agent/agent" ]]; then
    echo "$(cd "$ROOT/../../my-agent" && pwd)"
    return
  fi
  echo "Could not find my-agent." >&2
  echo "Set MY_AGENT_ROOT to your Eve project, e.g.:" >&2
  echo "  MY_AGENT_ROOT=~/Code/my-agent ./restore.sh S03 end" >&2
  exit 1
}

[[ -z "$STAGE" ]] && usage
AGENT_ROOT="$(resolve_agent_root)"

STAGE_DIR=""
for d in "$ROOT"/S0*; do
  [[ -d "$d" ]] || continue
  base="$(basename "$d")"
  if [[ "$base" == "$STAGE" || "$base" == "$STAGE"* ]]; then
    STAGE_DIR="$d"
    break
  fi
done

[[ -z "$STAGE_DIR" || ! -d "$STAGE_DIR" ]] && echo "Unknown stage: $STAGE" && usage

case "$WHICH" in
  start|START) SRC="$STAGE_DIR/START" ;;
  end|END) SRC="$STAGE_DIR/END" ;;
  *) echo "Second arg must be start or end"; exit 1 ;;
esac

[[ -d "$SRC" ]] || { echo "Missing $SRC"; exit 1; }

echo "Restoring $SRC → $AGENT_ROOT"
rm -rf "$AGENT_ROOT/agent/tools" "$AGENT_ROOT/agent/skills" \
  "$AGENT_ROOT/agent/connections" "$AGENT_ROOT/agent/subagents"
mkdir -p "$AGENT_ROOT/agent/tools" "$AGENT_ROOT/agent/skills" \
  "$AGENT_ROOT/agent/subagents"

if [[ -d "$SRC/agent" ]]; then
  rsync -a "$SRC/agent/" "$AGENT_ROOT/agent/"
fi
if [[ -d "$SRC/lib" ]]; then
  mkdir -p "$AGENT_ROOT/lib"
  rsync -a --delete "$SRC/lib/" "$AGENT_ROOT/lib/"
elif [[ -d "$AGENT_ROOT/lib" ]]; then
  # Early stages have no lib — clear clinic so learners add it in S02
  rm -rf "$AGENT_ROOT/lib/skin-clinic"
fi
if [[ -d "$SRC/evals" ]]; then
  mkdir -p "$AGENT_ROOT/evals"
  rsync -a --delete "$SRC/evals/" "$AGENT_ROOT/evals/"
fi

echo "Done. cd \"$AGENT_ROOT\" && npm run typecheck && npm run dev"
