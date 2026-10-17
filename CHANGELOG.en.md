# Release history

This repository releases by **collection**, not through a SemVer version sequence. Each directory under `skills/` has exactly one tag and one GitHub Release with the same name. That tag/release is the collection's current snapshot; CI moves it to the latest commit that changes the collection directory. Detailed development history remains in the [Git log](https://github.com/tpc-pascal/agent-skills/commits/main/).

## [`research`](https://github.com/tpc-pascal/agent-skills/releases/tag/research)

The research collection contains six independent skills that can be coordinated when a workflow needs multiple steps:

- `orchestrator`: routes requests to the appropriate skill and asks only for missing report requirements.
- `doc`: extracts, OCRs, converts, and verifies documents with local tools when available.
- `media`: inspects and processes audio/video/image files; URL operations require network access and third-party skills are fetched per session.
- `web`: reads and searches online sources; offline use is limited to supplied local content.
- `paper`: writes international-standard or Vietnamese public-facing reports, with clear citations and separate support data when useful.
