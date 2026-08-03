# Cooking-Show Stage Map — Skin Analyzer

| Stage | Beat | START | END |
|-------|------|-------|-----|
| S00 | Kickoff / honesty | Stock Eve hello | Skin stub + env |
| S01 | Instructions | S00 END | Full instructions |
| S02 | Analyze tools | S01 END | + clinic lib + list/get/analyze |
| S03 | HITL regimen | S02 END | + `propose_regimen` (**Gate A**) |
| S04 | Protocol skill | S03 END | + `skin_analysis_protocol` |
| S05 | Evals + subagent | S04 END | + evals (**Gate B**) + `regimen_writer` (**Gate C1**) |

## Restore rules

1. Cook forward; open END only at checkpoint or stuck >10 min.  
2. `./restore.sh S0N` → START; `./restore.sh S0N end` → END.  
3. Optional: `MY_AGENT_ROOT=/path/to/agent ./restore.sh S0N end`  
4. Snapshots omit `node_modules` and `.eve`.  
5. After editing the live agent (facilitator monorepo): `./rebuild-stages.sh`.  

## Classroom notes

- **Vision:** mock scoring = partner CV stand-in; Eve ≠ native face scanner.  
- **Subagents:** inherit nothing from root; draft ≠ approve.  
- **Evals:** capability asserts; HITL needs `parked` + `respondAll("approve")`.  
- **Gate A prompt:** analyze then `propose_regimen`; skip skills/subagents.
