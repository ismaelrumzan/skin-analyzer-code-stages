# Windows — copy files (no bash / rsync)

You do **not** need `restore.sh`. Use either PowerShell or File Explorer copy.

## Option A — PowerShell (recommended)

Clone this repo **next to** your Eve app:

```text
parent\
  my-agent\
  skin-analyzer-code-stages\
```

Then:

```powershell
cd skin-analyzer-code-stages
.\restore.ps1 S03 end
# or
.\restore.ps1 S03 end -AgentRoot C:\path\to\my-agent
```

## Option B — Manual copy (File Explorer or `robocopy`)

For stage **S03 end** (Gate A), copy from:

`skin-analyzer-code-stages\S03-hitl-regimen\END\`

into your Eve app `my-agent\` as follows:

| From stage END | Into your my-agent |
|----------------|--------------------|
| `agent\*` (all files/folders) | `my-agent\agent\` (overwrite) |
| `lib\*` (if present) | `my-agent\lib\` (overwrite) |
| `evals\*` (if present) | `my-agent\evals\` (overwrite) |

**Before copying**, delete these folders in your agent if they exist (avoids leftover tools from a later stage):

- `my-agent\agent\tools`
- `my-agent\agent\skills`
- `my-agent\agent\subagents`
- `my-agent\agent\connections` (if any)

Then paste the stage’s `agent`, `lib`, and `evals` contents in.

### Per-stage folders

| Catch up to | Copy FROM |
|-------------|-----------|
| S00 start | `S00-scaffold\START\` |
| S00 end | `S00-scaffold\END\` |
| S01 end | `S01-instructions\END\` |
| S02 end (tools) | `S02-analyze-tools\END\` |
| S03 end (**Gate A** HITL) | `S03-hitl-regimen\END\` |
| S04 end (skill) | `S04-protocol-skill\END\` |
| S05 end (evals + subagent) | `S05-evals-subagent\END\` |

### Example `robocopy` (S03 end)

```powershell
$src = "C:\path\to\skin-analyzer-code-stages\S03-hitl-regimen\END"
$dst = "C:\path\to\my-agent"

Remove-Item -Recurse -Force "$dst\agent\tools","$dst\agent\skills","$dst\agent\subagents" -ErrorAction SilentlyContinue
robocopy "$src\agent" "$dst\agent" /E
robocopy "$src\lib"   "$dst\lib"   /E
robocopy "$src\evals" "$dst\evals" /E
```

Then:

```powershell
cd C:\path\to\my-agent
npm run typecheck
npm run dev
```

## Gate A smoke prompt

```text
Analyze CASE-101, then call propose_regimen with a gentle 3-step plan for approval. Skip skills and subagents.
```
