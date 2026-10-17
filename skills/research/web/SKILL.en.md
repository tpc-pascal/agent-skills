---
name: web
description: Read web pages/news/social media and search — uses agent-reach + upstream CLIs (Jina Reader, yt-dlp, bili, gh, exa, twitter, opencli) to pull text from web URLs, articles, social media (Twitter/Reddit/XHS/FB/IG/Bilibili), YouTube, and topic web search. Use for web lookups, reading articles/social posts, targeted search.
license: MIT
metadata:
  audience: web/social/search reading
  origin: custom
---

> Vietnamese version: [`SKILL.md`](SKILL.md)

# web — web, social media and search reader

Thin self-written skill: **no code of its own** — takes a URL/topic, fetches text with existing CLIs (agent-reach, Jina Reader, exa), returns the source to read or hands it to skill `paper` for report writing. URL access and search require connectivity; offline work is limited to local content supplied by the user.

## Routing table by need

|Need|Tool|
|---|---|
|Read a web page/article (incl. paywalled)|`curl -s https://r.jina.ai/URL` (agent-reach web channel)|
|Read social media (Twitter/Reddit/XHS/FB/IG/Bilibili)|agent-reach upstream CLI: `twitter` / `opencli` / `bili` / `rdt`|
|YouTube/Bilibili → text/auto-captions|`yt-dlp --write-auto-sub --skip-download` / `bili`; paywalled → skill `media` (`watch`)|
|Web search by topic|mcp `exa.web_search_exa query="…" numResults=5`; Exa free has a rate limit|
|Broken/slow internet|agent-reach docxorf / ember Github strong open code.md|

## Rules

1. **Match the input language** — answer in the language the user used.
2. **Name the output of every source URL**: fetched file → cache/`<name>.extract.md|.txt` (if saved); never overwrite sources. Summaries/voice-overs → `<name>.digest.md`.
3. **Never invent input** — only process real content; no fake URLs or quotes.
4. **Summaries/voice-overs from web/social/paid URLs** → `curl -s https://r.jina.ai/URL` first; if it's media (video/image) → skill `media`.
5. **Locked content** (social media, paywalls) → let agent-reach/Jina read it; do not log in, do not bypass — tell the user when it cannot be read.
6. **Offline**: URLs, search, and social APIs require connectivity. Offline, read only local files/saved content supplied by the user; this repository does not create or query a web cache.
7. **Always report the file written** (name + path) — never silently.
8. **Writing a report from web results** → hand off to `paper` after confirming requirements with `orchestrator`.

## Common combined flows

```text
URL web/social [network required] ▸ jina/agent-reach ▸ text ▸ paper (if a report is needed)
Topic search [network required] ▸ exa ▸ URL list ▸ jina ▸ text ▸ paper (if a report is needed)
URL media [network required] ▸ skill media ▸ digest + frame ▸ paper (if a report is needed)
```
