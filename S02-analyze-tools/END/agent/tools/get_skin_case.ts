import { defineTool } from "eve/tools";
import { z } from "zod";
import { getCase } from "../../lib/skin-clinic/index.js";

export default defineTool({
  description: "Get metadata for a synthetic skin case (not the analysis itself).",
  inputSchema: z.object({ caseId: z.string().min(1) }),
  async execute({ caseId }) {
    return getCase(caseId);
  },
});
