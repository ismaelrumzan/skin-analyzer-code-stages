import { defineTool } from "eve/tools";
import { z } from "zod";
import { listCases } from "../../lib/skin-clinic/index.js";

export default defineTool({
  description: "List synthetic skin/face scan cases available in the workshop clinic.",
  inputSchema: z.object({}),
  async execute() {
    return { cases: listCases() };
  },
});
