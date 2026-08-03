import { cases, type SkinCase } from "./cases.js";

export type { SkinCase };

const regimens: Record<string, unknown>[] = [];

export function getCase(caseId: string) {
  const c = cases[caseId.toUpperCase()] ?? cases[caseId];
  if (!c) return { error: `Unknown case ${caseId}` };
  return c;
}

export function listCases() {
  return Object.values(cases).map(({ caseId, label, severity, imageRef }) => ({
    caseId,
    label,
    severity,
    hasImage: Boolean(imageRef),
  }));
}

/** Deterministic mock “vision” scoring for workshop — stands in for a partner CV/API. */
export function analyzeSkinCase(caseId: string) {
  const c = getCase(caseId);
  if ("error" in c) return c;
  if (!c.imageRef) {
    return {
      ok: false,
      caseId: c.caseId,
      error: "No scan image on file — refuse analysis; ask for a new capture.",
    };
  }
  return {
    ok: true,
    caseId: c.caseId,
    disclaimer:
      "Educational mock analysis only — not a medical diagnosis or treatment plan.",
    regions: c.regions,
    findings: c.expectedConcerns.map((concern) => ({
      concern,
      confidence: concern === "erythema" ? 0.82 : 0.74,
      evidence: c.notes,
    })),
    severity: c.severity,
    imageRef: c.imageRef,
    nextStepHint: "Load skin_analysis_protocol skill, then propose_regimen with HITL.",
  };
}

export function recordRegimen(entry: Record<string, unknown>) {
  regimens.push({ ...entry, at: new Date().toISOString() });
  return { ok: true, entry };
}

export function listRegimens() {
  return regimens;
}
