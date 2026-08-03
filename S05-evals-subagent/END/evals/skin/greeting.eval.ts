import { defineEval } from "eve/evals";

export default defineEval({
  description: "Greeting should not propose a regimen or analyze a case.",
  async test(t) {
    await t.send("Hi there!");
    t.succeeded();
    t.notCalledTool("propose_regimen");
    t.notCalledTool("analyze_skin_case");
  },
});
