import { defineEval } from "eve/evals";

/**
 * Gate B HITL path: propose_regimen must park for approval, then resume on approve.
 * Do not call t.succeeded() before responding — unanswered HITL fails succeeded().
 */
export default defineEval({
  description: "propose_regimen parks for HITL; approve resumes.",
  timeoutMs: 180_000,
  async test(t) {
    await t.send(
      "For CASE-101, analyze the case, then call propose_regimen with a gentle care plan for approval. Do not skip the approval tool.",
    );
    t.parked();
    t.calledTool("analyze_skin_case");
    t.calledTool("propose_regimen", { status: "pending", count: 1 });

    await t.respondAll("approve");
    t.succeeded();
    t.calledTool("propose_regimen", { status: "completed", count: 1 });
  },
});
