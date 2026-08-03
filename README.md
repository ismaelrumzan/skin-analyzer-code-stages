# Skin Analyzer — cooking-show code stages

Cookbook snapshots for the **Face Scanning & Skin Analyzer** Eve workshop (2×3h).

Teach order: **instructions → tools → HITL → skill → evals → subagent**

## Prerequisites

- Your own Eve agent from the basic Eve setup guide (e.g. `my-agent`)
- Node **24+**
- `AI_GATEWAY_API_KEY` in the agent’s `.env.local`
- `rsync` available (macOS/Linux)

## Quick start

```bash
# clone next to your Eve app (recommended)
cd /path/to/parent
git clone https://github.com/ismaelrumzan/skin-analyzer-code-stages.git
# layout:
#   parent/my-agent
#   parent/skin-analyzer-code-stages

cd skin-analyzer-code-stages
chmod +x restore.sh
./restore.sh S00 start          # stock hello
# …live-code with facilitator…
./restore.sh S03 end            # catch up to Gate A (HITL)
```

Or point at any agent path:

```bash
MY_AGENT_ROOT=~/Code/my-agent ./restore.sh S02 end
```

## Stages

| Stage | Beat | Gate |
|-------|------|------|
| S00 | Scaffold / honesty | — |
| S01 | Instructions | — |
| S02 | Analyze tools + mock clinic | — |
| S03 | HITL `propose_regimen` | **A** |
| S04 | Protocol skill | — |
| S05 | Evals + `regimen_writer` subagent | **B / C1** |

See [STAGE_MAP.md](./STAGE_MAP.md).

## Gate A smoke prompt

```text
Analyze CASE-101, then call propose_regimen with a gentle 3-step plan for approval. Skip skills and subagents.
```

Approve the `? propose_regimen` prompt in the Eve TUI.

## Notes

- Clinic data is inlined in `lib/skin-clinic/cases.ts` (do **not** reintroduce `readFileSync` + sidecar `cases.json` — Eve’s authored-module cache will break).
- Snapshots omit `node_modules` and `.eve`.
- `rebuild-stages.sh` is for facilitators with a monorepo checkout; learners only need `restore.sh`.
