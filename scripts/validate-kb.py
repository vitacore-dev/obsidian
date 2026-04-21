#!/usr/bin/env python3
"""Validate support knowledge base markdown files.

Checks:
- frontmatter presence and required fields
- required section headers by knowledge type
"""

from __future__ import annotations

import re
import sys
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]

REQUIRED_FRONTMATTER_FIELDS = ["title", "owner", "last_updated", "product_version", "tags"]
RUNBOOK_SECTIONS = [
    "## Symptoms",
    "## Scope",
    "## Diagnosis",
    "## Resolution / Workaround",
    "## Escalation",
]
REQUIRED_SECTIONS = {
    "01_Runbooks": RUNBOOK_SECTIONS,
    "02_Known-Issues": ["## Issue Summary", "## Symptoms", "## Root Cause", "## Workaround", "## Permanent Fix Status"],
    "03_Product-FAQ": ["## Question", "## Short Answer", "## Steps for Customer"],
}

# Runbooks may live outside 01_Runbooks; only files named RUNBOOK*.md get runbook section checks.
RUNBOOK_EXTRA_FOLDERS = ("07_MS-SQL", "08_PostgreSQL")


def split_frontmatter(text: str) -> tuple[str | None, str]:
    """Return (frontmatter, body)."""
    if not text.startswith("---\n"):
        return None, text
    marker = "\n---\n"
    end_idx = text.find(marker, 4)
    if end_idx == -1:
        return None, text
    frontmatter = text[4:end_idx]
    body = text[end_idx + len(marker) :]
    return frontmatter, body


def has_frontmatter_field(frontmatter: str, field: str) -> bool:
    pattern = rf"(?m)^{re.escape(field)}\s*:\s*.+$"
    return re.search(pattern, frontmatter) is not None


def validate_file(path: Path) -> list[str]:
    errors: list[str] = []
    text = path.read_text(encoding="utf-8")
    frontmatter, body = split_frontmatter(text)

    if frontmatter is None:
        errors.append("missing yaml frontmatter")
    else:
        for field in REQUIRED_FRONTMATTER_FIELDS:
            if not has_frontmatter_field(frontmatter, field):
                errors.append(f"missing frontmatter field: {field}")

    folder = path.parent.name
    required_sections: list[str] = []
    if folder in REQUIRED_SECTIONS:
        required_sections = REQUIRED_SECTIONS[folder]
    elif folder in RUNBOOK_EXTRA_FOLDERS and path.name.startswith("RUNBOOK"):
        required_sections = RUNBOOK_SECTIONS
    for section in required_sections:
        if section not in body:
            errors.append(f"missing section: {section}")

    return errors


def target_files() -> list[Path]:
    paths: list[Path] = []
    for folder in REQUIRED_SECTIONS:
        directory = ROOT / folder
        if not directory.exists():
            continue
        for file_path in directory.glob("*.md"):
            paths.append(file_path)
    for folder in RUNBOOK_EXTRA_FOLDERS:
        directory = ROOT / folder
        if not directory.exists():
            continue
        for file_path in directory.glob("*.md"):
            paths.append(file_path)
    return sorted(paths)


def main() -> int:
    files = target_files()
    if not files:
        print("No KB markdown files found to validate.")
        return 0

    total_errors = 0
    for path in files:
        errors = validate_file(path)
        if not errors:
            continue
        rel = path.relative_to(ROOT)
        total_errors += len(errors)
        print(f"[ERROR] {rel}")
        for err in errors:
            print(f"  - {err}")

    if total_errors > 0:
        print(f"\nValidation failed with {total_errors} issue(s).")
        return 1

    print(f"Validation passed for {len(files)} file(s).")
    return 0


if __name__ == "__main__":
    sys.exit(main())
