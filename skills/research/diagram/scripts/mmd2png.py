#!/usr/bin/env python3
"""Mermaid -> PNG.

Backend (mac dinh local-only; remote chi khi chon ro qua env
MMD2PNG_BACKEND=remote|kroki|ink):
  1. mmdc       — mermaid-cli local, offline (mmdc tren PATH hoac
                  `npx --no-install @mermaid-js/mermaid-cli`, can cache npm;
                  cai: npm i -g @mermaid-js/mermaid-cli). Chrome/Chromium
                  duoc tu tim de trinh phoi (puppeteer config tam).
    2. kroki.io   — remote, retry 2 lan (chi khi chon remote).
    3. mermaid.ink — remote (chi khi chon remote).

Output phai la PNG that: magic + >= 1024 byte. JPEG tu backend remote duoc
convert sang PNG bang ImageMagick (magick/convert); thieu converter -> ghi
<f>.jpg + canh bao ro (khong gia lam .png). Tat ca backend loi -> exit 1
va in ro ly tung backend, khong doan output.

Do: mmd2png.py <f>.mmd <f>.png [--scale N] [--size N] [--theme T]
  --scale : ty le pixel mmdc (mac dinh 2, chi backend mmdc hieu)
  --size  : max chieu rong/cao cua PNG mmdc (mac dinh 1600)
  --theme : mermaid theme (default/forest/neutral/...; mmdc + mermaid.ink)
"""
import argparse
import base64
import json
import os
import pathlib
import shutil
import subprocess
import sys
import tempfile
import time
import urllib.request
import zlib

UA = {"User-Agent": "Mozilla/5.0 (X11; Linux x86_64)"}
PNG_MAGIC = b"\x89PNG\r\n\x1a\n"
JPEG_MAGIC = b"\xff\xd8"
MIN_BYTES = 1024
HTTP_TIMEOUT = 30
KROKI_TRIES = 2


def fetch(url: str, tries: int = 1) -> bytes:
    last: Exception | None = None
    for i in range(tries):
        try:
            return urllib.request.urlopen(
                urllib.request.Request(url, headers=UA), timeout=HTTP_TIMEOUT).read()
        except Exception as e:
            last = e
            if i + 1 < tries:
                time.sleep(1.5)
    raise last


def chrome_path() -> str | None:
    env = os.environ.get("PUPPETEER_EXECUTABLE_PATH")
    if env and pathlib.Path(env).exists():
        return env
    for name in ("google-chrome-stable", "google-chrome", "chromium",
                 "chromium-browser", "chrome", "microsoft-edge"):
        p = shutil.which(name)
        if p:
            return p
    return None


def render_mmdc(src: str, out: pathlib.Path, scale: int, size: int,
                theme: str | None) -> tuple[bytes | None, str]:
    exe = shutil.which("mmdc")
    if exe:
        cmd = [exe]
    elif shutil.which("npx"):
        cmd = [shutil.which("npx"), "--no-install", "@mermaid-js/mermaid-cli"]
    else:
        return None, "khong tim thay mmdc va khong co npx (cai: npm i -g @mermaid-js/mermaid-cli)"
    with tempfile.TemporaryDirectory() as td:
        in_f = pathlib.Path(td, "in.mmd")
        in_f.write_text(src, encoding="utf-8")
        args = cmd + ["-i", str(in_f), "-o", str(out.resolve()),
                      "-s", str(scale), "--size", str(size),
                      "-b", "white", "-q"]
        if theme:
            args += ["-t", theme]
        ch = chrome_path()
        if ch:
            pptr = pathlib.Path(td, "pptr.json")
            pptr.write_text(json.dumps({
                "executablePath": ch,
                "args": ["--no-sandbox", "--disable-gpu", "--disable-dev-shm-usage"],
            }), encoding="utf-8")
            args += ["-p", str(pptr)]
        try:
            r = subprocess.run(args, capture_output=True, text=True, timeout=180)
        except subprocess.TimeoutExpired:
            return None, "mmdc qua 180s (syntax .mmd?)"
    if r.returncode == 0 and out.exists():
        return out.read_bytes(), "mmdc"
    err = ((r.stderr or r.stdout or "").strip().splitlines() or [f"rc={r.returncode}"])
    return None, "mmdc loi: " + err[-1][:200]


def render_kroki(src: str) -> bytes:
    url = ("https://kroki.io/mermaid/png/"
           + base64.urlsafe_b64encode(zlib.compress(src.encode(), 9)).decode())
    return fetch(url, tries=KROKI_TRIES)


def render_ink(src: str, theme: str | None) -> bytes:
    payload = {"code": src, "mermaid": {"theme": theme or "default"}}
    url = ("https://mermaid.ink/img/"
           + base64.urlsafe_b64encode(json.dumps(payload).encode()).decode())
    return fetch(url)


def jpeg_to_png(data: bytes, out: pathlib.Path) -> tuple[bool, str]:
    for exe in ("magick", "convert"):
        p = shutil.which(exe)
        if not p:
            continue
        with tempfile.TemporaryDirectory() as td:
            src_jpg = pathlib.Path(td, "in.jpg")
            dst_png = pathlib.Path(td, "out.png")
            src_jpg.write_bytes(data)
            r = subprocess.run([p, str(src_jpg), str(dst_png)],
                               capture_output=True, timeout=60)
            if r.returncode == 0 and dst_png.exists():
                out.write_bytes(dst_png.read_bytes())
                return True, "convert JPEG->PNG qua " + exe
        return False, f"{exe} loi khi convert JPEG"
    return False, "khong co ImageMagick (magick/convert) de convert JPEG->PNG"


def verify(data: bytes) -> str | None:
    if data[:8] == PNG_MAGIC:
        if len(data) < MIN_BYTES:
            return f"PNG qua nho ({len(data)} byte < {MIN_BYTES})"
        return None
    if data[:2] == JPEG_MAGIC:
        return "khong phai PNG (la JPEG)"
    return "khong phai anh (khong dung magic PNG/JPEG)"


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("mmd_path")
    ap.add_argument("out_path")
    ap.add_argument("--scale", type=int, default=2)
    ap.add_argument("--size", type=int, default=1600)
    ap.add_argument("--theme", default=None)
    a = ap.parse_args()

    src = pathlib.Path(a.mmd_path).read_text(encoding="utf-8")
    out = pathlib.Path(a.out_path)

    backend_env = os.environ.get("MMD2PNG_BACKEND", "local")
    if backend_env in ("local", "auto", "mmdc"):
        order = ["mmdc"]
    elif backend_env == "kroki":
        order = ["kroki"]
    elif backend_env == "ink":
        order = ["ink"]
    elif backend_env == "remote":
        order = ["kroki", "ink"]
    else:
        print(f"backend khong hop le: {backend_env}; dung local|mmdc|kroki|ink|remote",
              file=sys.stderr)
        return 2

    fails: list[str] = []
    for name in order:
        data: bytes | None = None
        try:
            if name == "mmdc":
                data, note = render_mmdc(src, out, a.scale, a.size, a.theme)
                if data is None:
                    fails.append(note)
                    continue
            elif name == "kroki":
                data = render_kroki(src)
                note = "kroki.io"
            else:
                data = render_ink(src, a.theme)
                note = "mermaid.ink"
        except Exception as e:
            fails.append(f"{name}: {e}")
            continue

        problem = verify(data)
        if problem == "khong phai PNG (la JPEG)":
            ok, conv_note = jpeg_to_png(data, out)
            if ok:
                print(f"OK {out.stat().st_size} byte -> {out} ({note}; {conv_note})")
                return 0
            alt = out.with_suffix(".jpg")
            alt.write_bytes(data)
            print(f"WARN: {note} tra ve JPEG, khong co converter — ghi {alt} "
                  f"(khong gia lam .png)", file=sys.stderr)
            return 0
        if problem:
            fails.append(f"{name}: {problem}")
            continue
        out.write_bytes(data)
        print(f"OK {len(data)} byte -> {out} ({note})")
        return 0

    for f in fails:
        print("  - " + f, file=sys.stderr)
    print("khong render duoc — xem ly do tung backend o tren, khong doan output",
          file=sys.stderr)
    return 1


if __name__ == "__main__":
    sys.exit(main())
