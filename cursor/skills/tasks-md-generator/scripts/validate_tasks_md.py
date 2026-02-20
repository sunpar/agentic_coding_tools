#!/usr/bin/env python3
"""Validate structural expectations for generated TASKS.md files."""

from __future__ import annotations

import argparse
import re
from dataclasses import dataclass
from pathlib import Path

TASK_HEADING_RE = re.compile(r"^### T(\d+):", re.MULTILINE)
TIER_HEADING_RE = re.compile(r"^## TIER\s+(\d+)\s+-\s+", re.MULTILINE)
COUNT_LINE_RE = re.compile(r"^(\d+)\s+tasks\s+organized\s+into\s+(\d+)\s+tiers", re.MULTILINE)
TITLE_RE = re.compile(r"^#\s+.+\s+-\s+Implementation Tasks\s*$", re.MULTILINE)
FIELD_RE_TEMPLATE = r"^\|\s*{field}\s*\|\s*(.*?)\s*\|\s*$"
TASK_REF_RE = re.compile(r"T(\d+)")


@dataclass(frozen=True)
class TaskRange:
    """Offsets for a task block in the source text."""

    number: int
    start: int
    end: int


def _extract_task_ranges(text: str) -> list[TaskRange]:
    matches = list(TASK_HEADING_RE.finditer(text))
    ranges: list[TaskRange] = []
    for index, match in enumerate(matches):
        number = int(match.group(1))
        start = match.start()
        end = matches[index + 1].start() if index + 1 < len(matches) else len(text)
        ranges.append(TaskRange(number=number, start=start, end=end))
    return ranges


def _extract_field(task_text: str, field: str) -> str | None:
    pattern = re.compile(FIELD_RE_TEMPLATE.format(field=re.escape(field)), re.MULTILINE)
    match = pattern.search(task_text)
    if not match:
        return None
    return match.group(1).strip()


def _extract_task_refs(value: str | None) -> list[int]:
    if not value:
        return []
    return [int(match) for match in TASK_REF_RE.findall(value)]


def _record_violation(
    *,
    strict: bool,
    message: str,
    errors: list[str],
    warnings: list[str],
) -> None:
    """Record a violation as error (strict) or warning (relaxed)."""
    if strict:
        errors.append(message)
    else:
        warnings.append(message)


def validate(text: str, *, strict: bool = False) -> tuple[list[str], list[str]]:
    """Validate tasks markdown content and return (errors, warnings)."""
    errors: list[str] = []
    warnings: list[str] = []

    if not TITLE_RE.search(text):
        errors.append("Missing or invalid title. Expected '# <Feature> - Implementation Tasks'.")

    if "## Dependency Graph" not in text:
        errors.append("Missing required section: '## Dependency Graph'.")

    if "## Summary" not in text:
        errors.append("Missing required section: '## Summary'.")

    task_ranges = _extract_task_ranges(text)
    if not task_ranges:
        errors.append("No task headings found. Expected headings like '### T1: ...'.")
        return errors, warnings

    task_numbers = [task.number for task in task_ranges]
    unique_numbers = sorted(set(task_numbers))
    if len(unique_numbers) != len(task_numbers):
        errors.append("Task IDs must be unique. Duplicate task IDs detected.")

    if task_numbers != sorted(task_numbers):
        _record_violation(
            strict=strict,
            message=(
                "Task headings are not in ascending numeric order. "
                f"Found order: {task_numbers}"
            ),
            errors=errors,
            warnings=warnings,
        )

    contiguous_expected = list(range(1, (max(unique_numbers) if unique_numbers else 0) + 1))
    if unique_numbers != contiguous_expected:
        _record_violation(
            strict=strict,
            message=(
                "Task numbering is not contiguous from T1..Tn. "
                f"Found IDs: {unique_numbers}"
            ),
            errors=errors,
            warnings=warnings,
        )

    count_match = COUNT_LINE_RE.search(text)
    if count_match:
        declared_tasks = int(count_match.group(1))
        declared_tiers = int(count_match.group(2))

        allowed_task_counts = {len(unique_numbers)}
        if unique_numbers:
            allowed_task_counts.add(max(unique_numbers))

        if declared_tasks not in allowed_task_counts:
            _record_violation(
                strict=strict,
                message=(
                    "Declared task count is inconsistent with detected task IDs. "
                    f"Declared {declared_tasks}, headings {len(unique_numbers)}, "
                    f"max task ID {max(unique_numbers) if unique_numbers else 0}."
                ),
                errors=errors,
                warnings=warnings,
            )

        tier_numbers = [int(match.group(1)) for match in TIER_HEADING_RE.finditer(text)]
        unique_tiers = sorted(set(tier_numbers))
        if unique_tiers and declared_tiers != len(unique_tiers):
            _record_violation(
                strict=strict,
                message=(
                    "Declared tier count does not match tier headings. "
                    f"Declared {declared_tiers}, found {len(unique_tiers)} ({unique_tiers})."
                ),
                errors=errors,
                warnings=warnings,
            )
    else:
        errors.append("Missing line '<N> tasks organized into <M> tiers ...'.")

    defined_tasks = set(unique_numbers)
    for task in task_ranges:
        snippet = text[task.start:task.end]
        blocked_by = _extract_field(snippet, "Blocked by")
        blocks = _extract_field(snippet, "Blocks")

        if blocked_by is None:
            errors.append(f"T{task.number}: missing 'Blocked by' field.")
        if blocks is None:
            errors.append(f"T{task.number}: missing 'Blocks' field.")

        for ref in _extract_task_refs(blocked_by):
            if ref not in defined_tasks:
                errors.append(f"T{task.number}: Blocked by references unknown task T{ref}.")
            if ref >= task.number:
                errors.append(
                    f"T{task.number}: Blocked by must reference earlier tasks only (found T{ref})."
                )

        for ref in _extract_task_refs(blocks):
            if ref not in defined_tasks:
                errors.append(f"T{task.number}: Blocks references unknown task T{ref}.")
            if ref <= task.number:
                errors.append(
                    f"T{task.number}: Blocks should reference later tasks only (found T{ref})."
                )

    return errors, warnings


def parse_args() -> argparse.Namespace:
    """Parse CLI arguments."""
    parser = argparse.ArgumentParser(
        description="Validate TASKS.md structure and dependency references.",
    )
    parser.add_argument("tasks_file", help="Path to TASKS.md")
    parser.add_argument(
        "--strict",
        action="store_true",
        help="Treat numbering/count consistency issues as errors instead of warnings.",
    )
    return parser.parse_args()


def main() -> int:
    """Run CLI."""
    args = parse_args()
    tasks_path = Path(args.tasks_file).resolve()

    if not tasks_path.is_file():
        print(f"[ERROR] File not found: {tasks_path}")
        return 2

    content = tasks_path.read_text(encoding="utf-8")
    errors, warnings = validate(content, strict=args.strict)

    if warnings:
        print(f"[WARN] {tasks_path}")
        for warning in warnings:
            print(f"  - {warning}")

    if errors:
        print(f"[FAIL] {tasks_path}")
        for error in errors:
            print(f"  - {error}")
        return 1

    print(f"[OK] {tasks_path}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
