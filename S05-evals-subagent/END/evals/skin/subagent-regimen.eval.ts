import { defineEval } from "eve/evals";

export default defineEval({
  description: "Regimen wording may be delegated to regimen_writer; root still owns HITL.",
  timeoutMs: 180_000,
  async test(t) {
    await t.send(
      "For CASE-101, analyze first. Then ask the regimen_writer subagent to draft gentle AM/PM wording. After the draft, call propose_regimen for human approval before sharing as approved.",
    );
    t.parked();
    t.calledTool("analyze_skin_case");
    t.calledSubagent("regimen_writer");
    t.calledTool("propose_regimen", { status: "pending", count: 1 });

    await t.respondAll("approve");
    t.succeeded();
  },
});
