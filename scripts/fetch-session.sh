#!/usr/bin/env bash
# fetch-session.sh — lấy skill từ repo nguồn chính thức vào thư mục session TẠM.
# Không cài đặt vĩnh viễn gì cả: thư mục sẽ bị xoá khi reboot / tmp bị dọn.
# Mỗi nguồn ghim bằng commit SHA (không dùng tag/branch để tránh đổi ngầm).
set -euo pipefail

MS_URL="https://github.com/timelapsetech/mediaskills.git"
MS_SHA="e7b62ca5dff71dfb4a4cf9bb9523367b76cf1ebd"
CV_URL="https://github.com/bradautomates/claude-video.git"
CV_SHA="03ceb42f7fa2c4439aca01752118044baabffb8f"
AR_URL="https://github.com/Panniantong/Agent-Reach.git"
AR_SHA="94f06c1969dfc1834001269d79d3ad0972d9dee6"
AL_URL="https://github.com/Iroli007/Aliceloop.git"
AL_SHA="fc21712e0f2cfca92e9af5b735f5f13a1beb2dd8"
AS_URL="https://github.com/anthropics/skills.git"
AS_SHA="dbd4588f9e1033efb41dad4bef2f7947c8993d44"
DL_URL="https://github.com/docling-project/docling.git"
DL_SHA="dd477a9f5feb3c505caeb6e73931bf93cecc79f4"

# name|url|sha|đường dẫn skill trong repo
TABLE='
audio|$MS_URL|$MS_SHA|skills/audio
captions-compliance|$MS_URL|$MS_SHA|skills/captions-compliance
download|$MS_URL|$MS_SHA|skills/download
forced-narrative-exact|$MS_URL|$MS_SHA|skills/forced-narrative-exact
image|$MS_URL|$MS_SHA|skills/image
inspect|$MS_URL|$MS_SHA|skills/inspect
install-media-tools|$MS_URL|$MS_SHA|skills/install-media-tools
program-master|$MS_URL|$MS_SHA|skills/program-master
shots|$MS_URL|$MS_SHA|skills/shots
speech-captions|$MS_URL|$MS_SHA|skills/speech-captions
subtitles|$MS_URL|$MS_SHA|skills/subtitles
timecode|$MS_URL|$MS_SHA|skills/timecode
video-transformation|$MS_URL|$MS_SHA|skills/video-transformation
vision-analysis|$MS_URL|$MS_SHA|skills/vision-analysis
watch|$CV_URL|$CV_SHA|skills/watch
agent-reach|$AR_URL|$AR_SHA|agent_reach/skill
music-listener|$AL_URL|$AL_SHA|skills/music-listener
docx|$AS_URL|$AS_SHA|skills/docx
pdf|$AS_URL|$AS_SHA|skills/pdf
docling|$DL_URL|$DL_SHA|docling/.agents/skills/docling
'

OUT="" PICK=()
while [ $# -gt 0 ]; do
  case "$1" in
    --list)   awk -F'|' '$1{gsub(/ /,"",$1);print $1}' <<<"$TABLE"; exit 0 ;;
    --all)    mapfile -t PICK < <(awk -F'|' '$1{gsub(/ /,"",$1);print $1}' <<<"$TABLE") ;;
    --skill)  PICK+=("$2"); shift ;;
    --out)    OUT="$2"; shift ;;
    *) echo "dùng: $0 [--list|--all|--skill TÊN] [--out DIR]" >&2; exit 2 ;;
  esac
  shift
done
[ ${#PICK[@]} -gt 0 ] || { echo "cần --all hoặc --skill TÊN (xem --list)" >&2; exit 2; }
OUT="${OUT:-$(mktemp -d "${TMPDIR:-/tmp}/agent-skills.XXXXXX")}"
mkdir -p "$OUT"
WORK=$(mktemp -d) ; trap 'rm -rf "$WORK"' EXIT

# clone+fetch đúng SHA, sparse chỉ phần cần, copy vào $OUT/<tên>
grab() { # url sha path dest
  local url=$1 sha=$2 path=$3 dest=$4
  local key="${url##*/}-$sha" dir="$WORK/${url##*/}-$sha"
  if [ ! -d "$dir" ]; then
    git clone -q --filter=blob:none --no-checkout "$url" "$dir"
    git -C "$dir" sparse-checkout init --no-cone
    git -C "$dir" fetch -q --depth 1 origin "$sha"
  fi
  git -C "$dir" sparse-checkout set "$path"
  git -C "$dir" checkout -q FETCH_HEAD
  rm -rf "$OUT/$dest"
  cp -R "$dir/$path" "$OUT/$dest"
}

for name in "${PICK[@]}"; do
  line=$(grep -E "^$name\|" <<<"$TABLE") || { echo "không có skill '$name' (--list để xem)" >&2; exit 1; }
  IFS='|' read -r _ url sha path <<<"$line"
  url="${url//\$MS_URL/$MS_URL}"; url="${url//\$CV_URL/$CV_URL}"
  url="${url//\$AR_URL/$AR_URL}"; url="${url//\$AL_URL/$AL_URL}"
 url="${url//\$AS_URL/$AS_URL}"; url="${url//\$DL_URL/$DL_URL}"
  sha="${sha//\$MS_SHA/$MS_SHA}"; sha="${sha//\$CV_SHA/$CV_SHA}"
  sha="${sha//\$AR_SHA/$AR_SHA}"; sha="${sha//\$AL_SHA/$AL_SHA}"
 sha="${sha//\$AS_SHA/$AS_SHA}"; sha="${sha//\$DL_SHA/$DL_SHA}"
  grab "$url" "$sha" "$path" "$name"
  echo "✓ $name → $OUT/$name"
done
echo "SESSION DIR: $OUT (${#PICK[@]} skill) — chỉ sống trong phiên này, không cài gì cả"
