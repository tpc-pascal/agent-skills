# AGENTS.md

> Vietnamese version: [`AGENTS.md`](AGENTS.md)

A repository collecting agent skill sets. Each collection lives under root `skills/`, is self-contained, installable on its own. Conventions for working in this repo:

## Structure

- Each collection lives at `<collection>/`; every skill inside has `SKILL.md` (VI) + `SKILL.en.md` (EN), bilingual is mandatory; `references/` (if present) must have `.en.md` counterparts too.
- The skill list of each collection and how to install: see that collection's `README.md` (e.g. [`skills/research/README.en.md`](skills/research/README.en.md)).
- Mandatory: every new skill collection must live under `skills/<collection>/<skill>/` — no collections at repo root. `scripts/smoke.sh` fails if any `SKILL.md` is found outside `skills/`.

## Bilingual rule

- Every `*.md` must have a matching `*.en.md` (except raw roots like `LICENSE`, `.gitignore`). CI checks parity and fails on missing files.
- The frontmatter `name:` must be identical in both versions.

## Third-party skills

- Loaded per session, never installed permanently into `~/.agents/skills/`. Use `scripts/fetch-session.sh`:

```bash
./scripts/fetch-session.sh --list
./scripts/fetch-session.sh --skill <skill-name>
./scripts/fetch-session.sh --all <commit-SHA>
```

- Never commit downloaded files; only pin URL + commit-SHA inside the skill.

## Local-first

- Prefer local tools for local files; state when required CLIs, models, and data must already be installed/cached.
- URLs, search, APIs, third-party skill downloads, and external renderers require connectivity. Do not describe them as offline-capable unless the repository has a real local cache/backend.
- Do not send input to external services through automatic fallback. Network backends must be explicitly selected, and that dependency must be disclosed.

## Checks

- Run `./scripts/smoke.sh` before committing/PR: frontmatter validity, bilingual parity, secret scan, script checks.
