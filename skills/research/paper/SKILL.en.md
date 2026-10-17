---
name: paper
description: Write reports in one of two forms: international-standard or Vietnamese popular. Synthesize cited sources, keep the main report focused, separate supporting data when useful, and export `.report.md` or `.report.docx`.
license: MIT
metadata:
  audience: reporting
  origin: custom
---

> Vietnamese version: [`SKILL.md`](SKILL.md)

# paper — report writing

This skill writes reports from collected sources. Choose **one** of the two forms; do not combine both frameworks in one report.

## Two report forms

|Form|Reference|Use when|
|---|---|---|
|International-standard report|[`references/report-academic.md`](references/report-academic.md)|A research structure, assessable methods, and full citations are needed. Select guidance for the study type; do not claim compliance without checking its checklist.|
|Vietnamese popular report|[`references/report-template.md`](references/report-template.md)|Findings need to be explained to a general Vietnamese audience while preserving evidence and limitations.|

Shared rules are in [`references/output-format.md`](references/output-format.md). Extract documents or media with the relevant skill first when needed.

## Workflow rules

1. Use the `orchestrator` question gate to confirm report form, audience, purpose, language, and delivery format. Do not re-ask answered questions.
2. Use only the selected report framework. Match the requested/contextual language; do not force bilingual output.
3. Keep `.report.md` focused on findings and reasoning. Put raw extracts, large data tables, technical metadata, tool logs, and nonessential appendices in separate support files; retain necessary citations in the report.
4. Prefer local tools. Reports from local sources must be writable and checkable offline; access URLs/APIs or external services only when the source or request requires network access. Never switch to a remote service silently.
5. Save `<source_name>.report.md` next to the source without overwriting it. Use clear sidecar suffixes such as `.sources.md`, `.extract.txt`, `.data.csv`, `.transcript.md`, or `.diagram.png`.
6. Do not invent data, citations, or page numbers. Cite claims and distinguish facts, observations, and inferences when the wording alone is not clear.
7. Check citations, consistency, and report content. For DOCX/PDF export, verify text and pages with available local tools; disclose when a tool is unavailable.
8. Respond in the user's language and name every file created.

## DOCX and PDF export

Prefer installed local tools. For complex conversion, see the `doc` skill — [`doc-recipes.md`](../doc/references/doc-recipes.md). Verify output with `pdfinfo` and `pdftotext` when available.

## Research sources

Sources used to develop the reporting principles are listed in [`references/reporting-principles-sources.md`](references/reporting-principles-sources.md). This is skill documentation, not content that must be copied into every report.
