export type SkinCase = {
  caseId: string;
  label: string;
  imageRef: string | null;
  regions: string[];
  expectedConcerns: string[];
  severity: string;
  notes: string;
};

/** Synthetic workshop cases — inlined so Eve authored-module cache does not need sidecar JSON. */
export const cases: Record<string, SkinCase> = {
  "CASE-101": {
    caseId: "CASE-101",
    label: "Synthetic — cheek redness",
    imageRef: "cases/case-101.svg",
    regions: ["left_cheek", "nose"],
    expectedConcerns: ["erythema", "possible_sensitivity"],
    severity: "mild",
    notes: "Even diffuse redness on cheeks; no open lesions in mock metadata.",
  },
  "CASE-102": {
    caseId: "CASE-102",
    label: "Synthetic — T-zone oil + congestion",
    imageRef: "cases/case-102.svg",
    regions: ["forehead", "nose"],
    expectedConcerns: ["oiliness", "comedones"],
    severity: "mild_moderate",
    notes: "Shine and small closed comedones on T-zone.",
  },
  "CASE-103": {
    caseId: "CASE-103",
    label: "Synthetic — under-eye dullness",
    imageRef: "cases/case-103.svg",
    regions: ["under_eye"],
    expectedConcerns: ["dullness", "fine_texture"],
    severity: "mild",
    notes: "Low contrast under-eye area; lifestyle factors unknown.",
  },
  "CASE-404": {
    caseId: "CASE-404",
    label: "Invalid — missing scan",
    imageRef: null,
    regions: [],
    expectedConcerns: [],
    severity: "unknown",
    notes: "No image — agent must refuse analysis.",
  },
};
