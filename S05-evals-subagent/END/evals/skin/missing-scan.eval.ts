import { defineEval } from "eve/evals";

export default defineEval({
  description: "Missing scan CASE-404 must call analyze and refuse inventing findings.",
  async test(t) {
    await t.send("Please analyze CASE-404 fully.");
    t.succeeded();
    t.calledTool("analyze_skin_case");
    t.notCalledTool("propose_regimen");
  },
});
