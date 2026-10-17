---
name: media
description: Process media — ffprobe metadata, ffmpeg cut/concat/transcode/GIF, extract frames, split audio, subtitles (shift/convert/burn), SMPTE timecode, shot detection, OCR frames/images, download from URL (yt-dlp), music (genre/mood/BPM/lyrics). Use when given video/audio/image/URL media and you need a content summary, text extraction, cutting/concatenation, subtitles, frames, or downloading.
license: MIT
metadata:
  audience: media processing
  origin: custom
---

> Vietnamese version: [`SKILL.md`](SKILL.md)

# media — video / audio / image / URL

Thin skill, **no code of its own**: routes to local CLIs (`ffprobe`, `ffmpeg`, `yt-dlp`) and third-party skills fetched per session (mediaskills, `watch`, `music-listener`) — see the fetch section below.

## Routing table by input type

Identify with `ffprobe`/`file`; for URLs inspect the returned filename.

|Input + need|Tool|Notes|
|---|---|---|
|Media file metadata|`ffprobe` (local)|no session skill needed|
|Video/URL content summary|skill `watch` (claude-video)|`--engine local`|
|Video/URL text extraction (SRT/VTT)|skill `speech-captions`|`transcribe.py --model tiny`; bigger model for long audio|
|Subtitles: shift/convert/burn|skill `subtitles`|`shift.py` `convert.py` `extract.py` `burn.py`|
|Cut/concat/transcode, GIF, frames/audio|skill `video-transformation`|`trim.py` `trim_multi.py` `concat.py` …|
|Shot/cut detection|skill `shots`|`detect.py` `extract-frames.py`|
|Frame content analysis (on-screen text)|skill `vision-analysis`|agent reads frames + script merges JSON|
|Images/screenshots: OCR/resize/convert|skill `image`|`ocr.py` (tesseract)|
|Audio: trim/normalize/silence|skill `audio`||
|Listen to music from URL/file with lyrics|skill `music-listener`|fetch per session, see `music-listener/scripts/`|
|Download media from URL|skill `download`|`url.py` (yt-dlp)|
|SMPTE timecode, broadcast captions|skill `timecode`, skill `captions-compliance`|sync captions to TC|
|Missing ffprobe/tesseract/uv…|skill `install-media-tools`|`doctor.sh` checks, `install.sh` installs|

## Session-scoped third-party skills (fetch, never install permanently)

This repo **does not contain** third-party skills. Fetch into session temp:

1. `scripts/fetch-session.sh --list` → see names; `--skill <name>` or `--all` — the script sparse-clones each source repo at the pinned commit SHA, copies into session temp.
2. Use from `~/.agents/skills/<name>/scripts/` (or `~/.config/opencode/skills/<name>/…`).
3. Offline/no network: operations on local files work when the required CLIs and models are available. Fetching session skills, downloading URLs, and downloading uncached models require network; `yt-dlp` cannot download a URL offline.

Commit SHA + license per skill: the `TABLE` in `scripts/fetch-session.sh`.

## Rules

1. **Output next to source**: summary `<name>.digest.md`, subtitles `<name>.srt|.vtt`, clips `<name>.clip-<t1>-<t2>.mp4`. Never overwrite the source.
2. **Timestamps/clips from real frames** — verify with `ffprobe`, never estimate.
3. **Verify before delivering**: output files must open in `ffprobe` with correct duration/codec.
4. **Match the input language** — answer in the language the user used.
