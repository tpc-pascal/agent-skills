#!/usr/bin/env python3
"""Biểu đồ số liệu CSV (2 cột: nhan, gia tri) -> PNG.

Chay: uv run --with matplotlib python3 chart.py <f>.csv <f>.png <bar|pie|line>
Offline khi matplotlib da co trong Python environment dang dung; uv co the can mang de tai package neu chua co cache.
Font DejaVu Sans (mac dinh matplotlib) du dau tieng Viet.
"""
import csv
import sys


def main(csv_path: str, out_path: str, kind: str) -> int:
    import matplotlib
    matplotlib.use("Agg")
    import matplotlib.pyplot as plt

    labels, values = [], []
    with open(csv_path, encoding="utf-8") as f:
        for row in csv.reader(f):
            if not row or row[0].strip().startswith("#"):
                continue
            labels.append(row[0].strip())
            values.append(float(row[1].strip()))

    fig, ax = plt.subplots(figsize=(8, 4.5), dpi=150)
    if kind == "bar":
        ax.bar(labels, values, color="#4C72B0")
    elif kind == "pie":
        ax.pie(values, labels=labels, autopct="%1.1f%%")
    elif kind == "line":
        ax.plot(labels, values, marker="o", color="#4C72B0")
        ax.grid(True, alpha=0.3)
    else:
        print("kind phai la bar|pie|line", file=sys.stderr)
        return 2
    if kind != "pie":
        ax.tick_params(axis="x", rotation=20)
    fig.tight_layout()
    fig.savefig(out_path)
    print(f"OK -> {out_path}")
    return 0


if __name__ == "__main__":
    if len(sys.argv) != 4:
        print("dung: chart.py <f>.csv <f>.png bar|pie|line")
        sys.exit(2)
    sys.exit(main(sys.argv[1], sys.argv[2], sys.argv[3]))
