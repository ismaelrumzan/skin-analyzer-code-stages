import { defineEval } from "eve/evals";

export default defineEval({
  description: "CASE-101 analysis should call analyze_skin_case.",
  async test(t) {
    await t.send("Analyze skin case CASE-101 and summarize findings.");
    t.succeeded();
    t.calledTool("analyze_skin_case");
  },
});
