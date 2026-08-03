import { defineTool } from "eve/tools";
import { z } from "zod";
import { analyzeSkinCase } from "../../lib/skin-clinic/index.js";

export default defineTool({
  description:
    "Run structured skin analysis for a case id. Uses workshop mock vision scoring (stand-in for partner CV/API).",
  inputSchema: z.object({ caseId: z.string().min(1) }),
  async execute({ caseId }) {
    return analyzeSkinCase(caseId);
  },
});
