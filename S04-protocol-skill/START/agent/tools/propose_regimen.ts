import { defineTool } from "eve/tools";
import { always } from "eve/tools/approval";
import { z } from "zod";
import { recordRegimen } from "../../lib/skin-clinic/index.js";

export default defineTool({
  description:
    "Propose a care regimen to share with the user. Requires human approval. Not a medical prescription.",
  inputSchema: z.object({
    caseId: z.string().min(1),
    summary: z.string().min(10),
    steps: z.array(z.string()).min(1),
    disclaimer: z
      .string()
      .default("Not a medical diagnosis or treatment plan. Consult a clinician for concerns."),
  }),
  approval: always(),
  async execute(input) {
    return recordRegimen(input);
  },
});
