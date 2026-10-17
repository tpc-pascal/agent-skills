---
name: orchestrator
description: Orchestration — take input, identify the type, route it to the sibling skills in this repo — doc (documents), media (video/audio/image), paper (reports), web (web/social/search reading) — and open the mandatory question gate before writing any report. Use when unsure which skill handles the current input, or when a workflow spans several skills.
license: MIT
metadata:
  audience: orchestration
  origin: custom
---

> Vietnamese version: [`SKILL.md`](SKILL.md)

# orchestrator — input orchestration

Thin self-written skill: **no code of its own** — takes input, identifies the type, routes it to the right place.

## Skills in this repo

|Skill|Use when|
|---|---|
|`doc`|PDF/DOCX/XLSX: extract text, OCR, convert, merge/split pages|
|`media`|video/audio/image/URL: summarize, extract text, subtitles, cut/concat, frames, download|
|`paper`|write an international-standard or Vietnamese public-facing report|
|`web`|read web pages/news/social media + search (Jina, agent-reach, exa)|
|`diagram`|draw Mermaid diagrams / matplotlib charts for reports|
|`orchestrator` (this skill)|dispatching the skills above + question gate before reports|

Install everything so orchestration works: `npx skills add tpc-pascal/agent-skills --all` (or `--skill orchestrator web doc media paper diagram`).

## Routing table by input type

|Input + need|Where to go|
|---|---|
|PDF/DOCX/XLSX (text, OCR, convert, merge/split)|skill `doc`|
|video/audio/image/URL media (summary, subtitles, cut, frames, download)|skill `media`|
|Web/social/search (URLs, articles, exa)|skill `web`|
|Write a report from sources|**Question gate** (below) → choose one `paper` format|
|Diagrams/charts for reports|skill `diagram`|

## Confirm report requirements

**Trigger:** the user asks to create or rewrite a report; extraction/conversion-only requests do not trigger it.

Before in-depth research or drafting, ask once, up to four questions, and only ask for missing information:

- **Form:** international-standard or Vietnamese public-facing report?
- **Purpose and audience:** who will read it, and what should it answer?
- **Delivery:** language, format, and length limit if any?
- **Sources and scope:** which sources/sections to use; may outside sources be added?

- Do not re-ask what is already stated in the request/conversation. If the user delegates decisions, choose a suitable option and briefly state assumptions that affect the result.
- Do not block on nonessential details or require a detailed outline before reviewing the sources.
- Extract with the relevant skill, then write using exactly one `paper` format.

## Orchestration rules

1. **Match the input language** — answer in the language the user used.
2. **Name the output of every source file**: `<name>.<suffix>`. Never overwrite sources. Suffixes: documents `.extract.md|.txt|.csv`, digests `.digest.md`, subtitles `.srt|.vtt`, clips `.clip-<t1>-<t2>.mp4`, reports `.report.md|.report.docx`.
3. **Never invent input** — only process real files; output next to or inside the source; never add fake files.
4. **Web/social/search input** → skill `web` (Jina/agent-reach/exa) reads first; media input → skill `media`.
5. **Locked content** (social media, paywalls) → let skill `web` (agent-reach/Jina) read it; do not log in, do not bypass — tell the user when it cannot be read.
6. **Any report / `.report.docx`** → verify per skill `paper` — `pdfinfo` + `pdftotext`, no invention.
7. **Media skills need per-session fetch** → see skill `media` (fetch section) or `scripts/fetch-session.sh --list`.
8. **Local-first**: prefer local tools for local files. Web/API access requires connectivity; offline, use only an actual local cache or sources supplied by the user, and disclose inaccessible material.
9. **Always report the file written** (name + path) — never silently.

## Flow notation

In the diagram below, `▸` means hand off to the next step; `→` means the flow continues; brackets describe a source or result type. These are flow symbols, not source labels or output formats.

## Common combined flows

```text
PDF scan ▸ skill doc ▸ text/table ▸ skill paper ▸ report
URL web/social ▸ skill web ▸ text ▸ skill paper (when a report is needed)
URL/file video ▸ skill media ▸ digest + frame ▸ skill paper (when a report is needed)
SRT/mm:ss ▸ skill media ▸ trim ▸ concat
```
