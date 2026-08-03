---
description: Optional playbook for richer skin-analysis wording after tools return findings. Do not use this skill as a blocker before propose_regimen.
---

# Skin analysis protocol

1. Confirm a scan exists (tool result `ok: true`). If missing → refuse and ask for recapture.  
2. Restate findings as **observations** with severity band — not diagnoses.  
3. Always include disclaimer: not medical advice / not a diagnosis.  
4. Map concerns to gentle routine categories (cleanse / treat / moisturize / protect) without prescription drugs.  
5. Escalate to “see a clinician” if severity is moderate+ or user reports pain/infection signs (workshop: if user mentions pain).  
6. For anything shared as a formal plan, the root agent must call `propose_regimen` (HITL) — loading this skill is not a substitute for that tool.
