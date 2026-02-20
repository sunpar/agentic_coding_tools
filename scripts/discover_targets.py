#!/usr/bin/env python3
"""Discover TASKS.md generation targets from a file or directory input."""

from __future__ import annotations

import argparse
import json
from dataclasses import asdict, dataclass
from pathlib import Path
from typing import Iterable

PREFERRED_DOC_ORDER = (
    "PRD.md",
    "USER_FLOW.md",
    "BACKEND_ARCHITECTURE.md",
    "FRONTEND_DESIGN.md",
    "README.md",
    "prompt.md",
    "initial_plan.md",
)

TARGET_SIGNAL_DOCS = (
    "PRD.md",
    "USER_FLOW.md",
    "BACKEND_ARCHITECTURE.md",
    "FRONTEND_DESIGN.md",
    "prompt.md",
    "initial_plan.md",
    "FEATURE_PROMPT.md",
)


@dataclass(frozen=True)
class Target:
    """A single TASKS.md generation target."""

    target_dir: str
    output_file: str
    source_docs: list[str]


def _is_markdown_file(path: Path) -> bool:
    return path.is_file() and path.suffix.lower() == ".md"


def _markdown_docs(directory: Path) -> list[Path]:
    return sorted(
        [
            doc
            for doc in directory.iterdir()
            if _is_markdown_file(doc) and doc.name != "TASKS.md"
        ],
        key=lambda item: item.name.lower(),
    )


def _ordered_docs(directory: Path) -> list[Path]:
    docs = _markdown_docs(directory)
    docs_by_name = {doc.name: doc for doc in docs}

    ordered = [docs_by_name[name] for name in PREFERRED_DOC_ORDER if name in docs_by_name]
    ordered_names = {doc.name for doc in ordered}
    ordered.extend([doc for doc in docs if doc.name not in ordered_names])
    return ordered


def _has_planning_docs(directory: Path) -> bool:
    names = {doc.name for doc in _markdown_docs(directory)}
    return any(name in names for name in TARGET_SIGNAL_DOCS)


def _to_target(directory: Path) -> Target:
    ordered_docs = _ordered_docs(directory)
    return Target(
        target_dir=str(directory),
        output_file=str(directory / "TASKS.md"),
        source_docs=[str(doc) for doc in ordered_docs],
    )


def _dedupe_targets(targets: Iterable[Target]) -> list[Target]:
    seen_outputs: set[str] = set()
    deduped: list[Target] = []
    for target in targets:
        if target.output_file in seen_outputs:
            continue
        seen_outputs.add(target.output_file)
        deduped.append(target)
    return deduped


def discover(path: Path) -> list[Target]:
    """Discover target directories for TASKS.md generation."""
    if path.is_file():
        if not _is_markdown_file(path):
            raise ValueError("Input file must be a markdown document (.md).")
        parent = path.parent
        docs = [path] + [doc for doc in _ordered_docs(parent) if doc != path]
        return [
            Target(
                target_dir=str(parent),
                output_file=str(parent / "TASKS.md"),
                source_docs=[str(doc) for doc in docs],
            )
        ]

    if not path.is_dir():
        raise ValueError("Input path must be an existing file or directory.")

    candidate_targets: list[Target] = []

    if _has_planning_docs(path):
        candidate_targets.append(_to_target(path))

    child_dirs = sorted(
        [item for item in path.iterdir() if item.is_dir()],
        key=lambda item: item.name.lower(),
    )
    for child in child_dirs:
        if _has_planning_docs(child):
            candidate_targets.append(_to_target(child))

    if not candidate_targets and _markdown_docs(path):
        candidate_targets.append(_to_target(path))

    return _dedupe_targets(candidate_targets)


def _format_path(path: str, cwd: Path) -> str:
    path_obj = Path(path)
    try:
        return str(path_obj.relative_to(cwd))
    except ValueError:
        return str(path_obj)


def _print_human(targets: list[Target]) -> None:
    cwd = Path.cwd()
    print(f"Found {len(targets)} target(s).")
    for index, target in enumerate(targets, start=1):
        print()
        print(f"{index}. Target directory: {_format_path(target.target_dir, cwd)}")
        print(f"   Output: {_format_path(target.output_file, cwd)}")
        print("   Source docs:")
        if not target.source_docs:
            print("   - (none)")
            continue
        for source in target.source_docs:
            print(f"   - {_format_path(source, cwd)}")


def parse_args() -> argparse.Namespace:
    """Parse CLI arguments."""
    parser = argparse.ArgumentParser(
        description="Discover TASKS.md generation targets for a file or directory input.",
    )
    parser.add_argument("path", help="Path to a markdown file or directory")
    parser.add_argument(
        "--json",
        action="store_true",
        help="Emit JSON for machine processing",
    )
    return parser.parse_args()


def main() -> int:
    """Run CLI."""
    args = parse_args()
    input_path = Path(args.path).resolve()

    try:
        targets = discover(input_path)
    except ValueError as error:
        print(f"[ERROR] {error}")
        return 2

    if args.json:
        print(json.dumps([asdict(target) for target in targets], indent=2))
    else:
        _print_human(targets)

    return 0


if __name__ == "__main__":
    raise SystemExit(main())
