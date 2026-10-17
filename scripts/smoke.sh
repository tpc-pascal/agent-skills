#!/usr/bin/env bash
# smoke.sh — kiểm tra nhanh, chạy locally và trên CI
set -euo pipefail
cd "$(dirname "$0")/.."

echo "== kiểm tra cú pháp bash"
bash -n scripts/fetch-session.sh
bash -n scripts/smoke.sh
bash -n scripts/install.sh
bash -n scripts/tag-release.sh

echo "== kiểm tra frontmatter SKILL"
python3 - <<'PY'
import glob, sys
try:
    import yaml
except ImportError:
    sys.exit("pyyaml required: pip install pyyaml")
for f in sorted(glob.glob("skills/*/*/SKILL.md")):
    fm = open(f, encoding="utf-8").read().split("---", 2)[1]
    d = yaml.safe_load(fm)
    for k in ("name", "description", "license"):
        assert d.get(k), f"{f}: missing {k}"
    print("ok", f, d["name"], len(d["description"]))
PY

echo "== kiểm tra mọi bộ skill phải nằm trong skills/ (bắt buộc)"
stray=$(git ls-files | grep -E '(^|/)SKILL\.md$' | grep -v '^skills/' || true)
if [ -n "$stray" ]; then
  echo "FAIL: SKILL.md ngoài skills/:" >&2
  echo "$stray" >&2
  exit 1
fi

echo "== chạy fetch-session --list (offline)"
./scripts/fetch-session.sh --list | grep -q watch

echo "== secret scan"
if git grep -nE "ghp_[A-Za-z0-9]{20,}|sk-[A-Za-z0-9]{8,}|AKIA[0-9A-Z]{16}|xox-[A-Za-z-]+|/home/[a-z]+"; then
  echo "có thể có secret hoặc đường dẫn cá nhân" >&2
  exit 1
fi
echo "== kiểm tra parity song ngữ (mỗi file VI phải có bản .en.md)"
for f in README.md CHANGELOG.md CONTRIBUTING.md SECURITY.md AGENTS.md $(find skills -name '*.md' ! -name '*.en.md' | sort); do
	[ ! -f "$f" ] || [ -f "${f%.md}.en.md" ] || { echo "thiếu ${f%.md}.en.md" >&2; exit 1; }
done

echo "== kiểm tra hợp đồng báo cáo và changelog"
python3 - <<'PY'
from pathlib import Path
import re

paper = Path("skills/research/paper")
for language in ("", ".en"):
  skill = (paper / f"SKILL{language}.md").read_text(encoding="utf-8")
  for phrase in ("report-academic.md", "report-template.md", "output-format.md", "reporting-principles-sources.md"):
    assert phrase in skill, f"SKILL{language}.md: missing {phrase}"
  for ref in ("report-academic", "report-template", "output-format", "reporting-principles-sources"):
    assert (paper / "references" / f"{ref}{language}.md").is_file(), f"missing {ref}{language}.md"

versions = []
for changelog in (Path("CHANGELOG.md"), Path("CHANGELOG.en.md")):
  headings = re.findall(r"^## (.+)$", changelog.read_text(encoding="utf-8"), re.MULTILINE)
  versions.append([heading for heading in headings if re.match(r"v\d+\.\d+\.\d+", heading)])
assert versions[0] == versions[1], "CHANGELOG.md and CHANGELOG.en.md release headings differ"
PY

python3 - <<'PY'
import importlib.util
import os
from pathlib import Path
import sys
import tempfile
from unittest.mock import patch

script = Path("skills/research/diagram/scripts/mmd2png.py")
spec = importlib.util.spec_from_file_location("mmd2png", script)
module = importlib.util.module_from_spec(spec)
sys.modules[spec.name] = module
spec.loader.exec_module(module)

with tempfile.TemporaryDirectory() as directory:
  source = Path(directory, "input.mmd")
  output = Path(directory, "output.png")
  source.write_text("graph TD\nA-->B\n", encoding="utf-8")
  for backend in (None, "auto", "local"):
    if backend is None:
      os.environ.pop("MMD2PNG_BACKEND", None)
    else:
      os.environ["MMD2PNG_BACKEND"] = backend
    with patch.object(module, "render_mmdc", return_value=(None, "local unavailable")), \
       patch.object(module, "render_kroki", side_effect=AssertionError("unexpected network backend")), \
       patch.object(module, "render_ink", side_effect=AssertionError("unexpected network backend")), \
       patch.object(sys, "argv", [str(script), str(source), str(output)]):
      assert module.main() == 1, f"{backend}: expected local failure"
  os.environ.pop("MMD2PNG_BACKEND", None)
PY

echo "smoke OK"
