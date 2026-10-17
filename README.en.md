# agent-skills

> Compatibility depends on the operating system, agent, and tools required by each skill. Check the skill guide before running it.

> [`README.md`](README.md) (tiếng Việt)

[![skills.sh](https://skills.sh/b/tpc-pascal/agent-skills)](https://skills.sh/tpc-pascal/agent-skills)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

A repository collecting agent skill sets for OpenCode/Claude/Cursor. Each collection lives under the root `skills/` directory, is self-contained, and can be installed on its own. The next collection (if any) will be added under `skills/` the same way.

Current collection: [`skills/research/`](skills/research/README.en.md).

## Install

Each collection = one directory under `skills/`; the repo installs per collection, not as a whole — one command:

```bash
# <collection> is a directory under skills/; append -g to install at user level
npx -y github:tpc-pascal/agent-skills <collection>
```

Omit the collection name to list them.

## Packaging a collection

Each collection has exactly one tag + one release of the same name, pointing to the newest commit touching `skills/<collection>/`. CI moves them automatically on every push to `main`; run manually with `bash scripts/tag-release.sh <collection>`.

## Features

- **Self-contained, routed by name** — each collection/skill installs independently, no inter-dependencies.
- **Session-scoped third-party skills**: `scripts/fetch-session.sh` pins commit-SHAs, fetches to a temp directory, never installs permanently into `~/.agents/skills/`.
- **100% bilingual**: every `.md` has an `.en.md`; `scripts/smoke.sh` + CI verify this automatically.
- **Local-first**: prefer local CLIs for local files; web sources, APIs, and external services require connectivity unless a cache/local backend is available.
- **Verified output**: checked with local tools before delivery, no invention.

## Repo structure

```text
skills/
  <collection>/       # one skill collection (e.g. research/) — one directory under skills/
    <skill>/          # each skill in its own subdirectory
      SKILL.md        # skill in Vietnamese
      SKILL.en.md     # skill in English (bilingual is mandatory)
      references/     # reference material (optional)
scripts/              # smoke.sh, fetch-session.sh, install.sh, tag-release.sh
.github/workflows/    # CI running smoke + bilingual parity
```

In workflow documentation, `▸` means hand off to the next step, `→` means the flow continues, and `[]` in a diagram describes a source/result type. These symbols are not report source labels.

## Adding a new collection

1. Create a new directory under `skills/` (`skills/<collection>/`); each skill gets its own subdirectory with `SKILL.md` + `SKILL.en.md` (frontmatter `name`/`description`/`license`).
2. Document the collection in `README.md` and `README.en.md`.
3. Run `scripts/smoke.sh`, then open a PR.

Contribution details: [`CONTRIBUTING.md`](CONTRIBUTING.md).

## License

MIT — see [LICENSE](LICENSE). Third-party skills keep their upstream license.
