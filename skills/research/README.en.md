# research — research skills

> Vietnamese version: [`README.md`](README.md)

A collection for document extraction, media processing, web research, diagrams, and report writing. Each skill can be used independently; `orchestrator` routes workflows with multiple steps.

## Skills

| Skill | Role |
|---|---|
| [`orchestrator`](orchestrator/SKILL.en.md) | Identify needs and coordinate skills |
| [`doc`](doc/SKILL.en.md) | Read/convert PDF, DOCX, and XLSX |
| [`media`](media/SKILL.en.md) | Process video, audio, and images |
| [`web`](web/SKILL.en.md) | Read and search online sources |
| [`paper`](paper/SKILL.en.md) | Write international-standard or Vietnamese public-facing reports |
| [`diagram`](diagram/SKILL.en.md) | Create diagrams and charts |

## Install

```bash
npx skills add tpc-pascal/agent-skills --skill orchestrator --skill doc --skill media --skill paper --skill web --skill diagram
```

Replace the skill list with the names of the skills to install individually.

## General flow

```text
Request ▸ orchestrator ▸ doc / media / web ▸ paper ▸ diagram or docx if needed ▸ verify
```

`▸` means hand off to the next step; `/` means choose the relevant skill, not necessarily run all of them. Web/API sources require connectivity; local-file processing prefers local tools and can continue offline when required tools are available.

## Reports

The `paper` skill supports exactly two forms:

- **International-standard report:** follow the requirements of the relevant field, journal, or organization and guidance for the study type.
- **Vietnamese public-facing report:** explain content to general readers in clear Vietnamese; this is an editorial form, not an official national standard.

Before writing, confirm purpose, audience, report form, language, output, and source scope when not already clear. Keep the main report focused on content; put long extractions, raw data, and supporting assets in separate files when useful.

## Checks

Run `bash scripts/smoke.sh` from the repository root to check syntax, frontmatter, structure, and bilingual files.
