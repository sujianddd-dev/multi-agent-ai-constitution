#!/usr/bin/env python3
"""Build the standalone ai-constitution skill package.

Layout inside the zip (Agensi / manual distribution):
    SKILL.md
    templates/...
    LICENSE
    README.md

Usage:
    python scripts/package-skill.py --version 0.3.1
    python scripts/package-skill.py            # version from the latest git tag
"""

from __future__ import annotations

import argparse
import subprocess
import sys
import zipfile
from pathlib import Path

if hasattr(sys.stdout, "reconfigure"):
    sys.stdout.reconfigure(encoding="utf-8", errors="replace")

ROOT = Path(__file__).resolve().parent.parent
SKILL_ROOT = ROOT / "ai-constitution.skill"
DIST = ROOT / "dist"


def latest_tag() -> str:
    try:
        out = subprocess.check_output(
            ["git", "-C", str(ROOT), "describe", "--tags", "--abbrev=0"],
            text=True,
            stderr=subprocess.DEVNULL,
        ).strip()
        return out[1:] if out.startswith("v") else out
    except Exception:
        return "dev"


def collect() -> list[tuple[Path, str]]:
    skill_md = SKILL_ROOT / "SKILL.md"
    tpl = SKILL_ROOT / "templates"
    if not skill_md.is_file():
        sys.exit(f"missing {skill_md}")
    if not tpl.is_dir():
        sys.exit(f"missing {tpl}")

    files: list[tuple[Path, str]] = [(skill_md, "SKILL.md")]
    for path in sorted(tpl.rglob("*")):
        if not path.is_file():
            continue
        if "__pycache__" in path.parts or path.name in {".DS_Store", "Thumbs.db"}:
            continue
        arc = (Path("templates") / path.relative_to(tpl)).as_posix()
        files.append((path, arc))

    for name in ("LICENSE", "README.md"):
        path = ROOT / name
        if path.is_file():
            files.append((path, name))
    return files


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--version", default="", help="version without the leading v (default: latest git tag)")
    args = parser.parse_args()

    version = (args.version or latest_tag()).lstrip("v") or "dev"
    out = DIST / f"ai-constitution-skill-v{version}.zip"
    DIST.mkdir(exist_ok=True)
    if out.exists():
        out.unlink()

    files = collect()
    with zipfile.ZipFile(out, "w", zipfile.ZIP_DEFLATED) as archive:
        for src, arc in files:
            archive.write(src, arc)

    with zipfile.ZipFile(out) as archive:
        names = archive.namelist()
        if "SKILL.md" not in names:
            sys.exit("package check failed: SKILL.md is not at the zip root")
        if not any(n.startswith("templates/") for n in names):
            sys.exit("package check failed: templates/ is missing")
        bad = [n for n in names if n.startswith("/") or ".." in Path(n).parts]
        if bad:
            sys.exit(f"package check failed: unsafe paths: {bad[:3]}")
        frontmatter = archive.read("SKILL.md").decode("utf-8", errors="replace")[:400]
        if not frontmatter.startswith("---") or "\nname:" not in frontmatter or "\ndescription:" not in frontmatter:
            sys.exit("package check failed: SKILL.md frontmatter needs name and description")

    size_kib = out.stat().st_size / 1024
    print(f"✅ {out}")
    print(f"   {len(files)} files · {size_kib:.1f} KiB · SKILL.md at zip root")
    if size_kib > 50 * 1024:
        sys.exit("package is larger than Agensi's 50 MB upload limit")


if __name__ == "__main__":
    main()
