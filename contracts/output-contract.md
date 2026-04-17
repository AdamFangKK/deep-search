# Deep Search Output Contract

This document freezes the user-facing report structure for architecture refactors.

## Required Report Shape

Every full deep-search report should preserve these sections:

1. `执行摘要 / Executive Summary`
2. `研究方法 / Methodology`
3. `全景分析 / Universal Analysis`
4. `实证数据 / Empirical Evidence`
5. `垂直分析 / Domain Analysis`
6. `综合评估 / Synthesis`
7. `行动建议 / Recommendations`
8. `附录 / Appendices`

## Required Top-Level Metadata

- report title
- generation timestamp
- data point count
- source domain count
- overall confidence

## Required Behavioral Guarantees

- reports must remain multi-source
- reports must state limitations
- reports must expose confidence, not hide uncertainty
- reports must separate evidence from synthesis
- reports must preserve actionable recommendations

## Allowed Variation

Allowed:

- wording
- ordering inside a section
- richer evidence formatting
- more explicit gaps or caveats

Not allowed:

- removing sections
- collapsing the report into a short summary by default
- hiding evidence provenance
- replacing confidence with vague language
