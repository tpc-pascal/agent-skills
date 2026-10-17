#!/usr/bin/env bash
# Đưa tag + release duy nhất của một bộ skill tới commit mới nhất chạm vào
# folder của bộ đó. Không có tham số = liệt kê các bộ hiện có.
# Move a skill collection's single tag + release to the newest commit
# touching its folder. No arguments = list available collections.
set -euo pipefail
cd "$(dirname "$0")/.."

git config user.name >/dev/null 2>&1 || git config user.name "agent-skills"
git config user.email >/dev/null 2>&1 || git config user.email "agent-skills@localhost"

list_collections() {
  find skills -mindepth 1 -maxdepth 1 -type d -printf '%f\n' | sort
}

if [[ $# -eq 0 ]]; then
  echo "Bộ hiện có / Available collections:" >&2
  list_collections >&2
  exit 0
fi

collection="$1"
if [[ ! -d "skills/$collection" ]]; then
  echo "Không tìm thấy bộ '$collection' / collection not found. Available:" >&2
  list_collections >&2
  exit 1
fi

sha="$(git log -1 --format=%H -- "skills/$collection")"
if [[ -z "$sha" ]]; then
  echo "Bộ '$collection' chưa có commit nào / no commits yet" >&2
  exit 1
fi

repo="$(gh repo view --json nameWithOwner -q .nameWithOwner)"

if [[ -n "${SIGN_KEY:-}" ]]; then
  git -c gpg.format=ssh -c user.signingkey="$SIGN_KEY" tag -s -f "$collection" "$sha" \
    -m "Bộ $collection / $collection set"
  verify_flag=(--verify-tag)
elif git config user.signingkey >/dev/null 2>&1; then
  git tag -s -f "$collection" "$sha" -m "Bộ $collection / $collection set"
  verify_flag=(--verify-tag)
else
  git tag -a -f "$collection" "$sha" -m "Bộ $collection / $collection set"
  verify_flag=()
fi

if git ls-remote --exit-code --tags origin "refs/tags/$collection" >/dev/null 2>&1; then
  git push origin ":refs/tags/$collection"
fi
git push origin "refs/tags/$collection"

if gh release view "$collection" --repo "$repo" >/dev/null 2>&1; then
  gh release delete "$collection" --repo "$repo" --yes
fi
gh release create "$collection" \
  --repo "$repo" \
  "${verify_flag[@]}" \
  --title "$collection" \
  --notes "Bộ $collection tại commit $sha / $collection set at commit $sha." \
  --target "$sha"

echo "ok: $collection -> $sha"
