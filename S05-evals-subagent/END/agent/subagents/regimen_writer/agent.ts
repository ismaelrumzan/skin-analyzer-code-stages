import { defineAgent } from "eve";

export default defineAgent({
  description:
    "Draft a gentle skincare regimen from structured analysis findings. Educational only — not medical advice.",
  model: "anthropic/claude-sonnet-5",
});
