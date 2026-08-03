import { defineEval } from "eve/evals";

export default defineEval({
  description: "Happy path should load skin_analysis_protocol skill.",
  timeoutMs: 180_000,
  async test(t) {
    await t.send(
      "Analyze CASE-101 using the skin analysis protocol skill, then summarize observations with the protocol disclaimer. Do not propose a regimen yet.",
    );
    t.succeeded();
    t.calledTool("analyze_skin_case");
    t.loadedSkill("skin_analysis_protocol");
    t.notCalledTool("propose_regimen");
  },
});
