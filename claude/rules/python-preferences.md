---
description: Python coding standards — proper typing, Zen of Python, modern idioms
globs: "**/*.py"
alwaysApply: false
---

# Python Preferences

## Typing is Non-Negotiable

- **Type-annotate every function signature** — parameters and return types. No exceptions.
- Use **built-in generics** (Python 3.9+): `list[str]`, `dict[str, int]`, `tuple[int, ...]`, `set[str]`. Never import `List`, `Dict`, `Tuple`, `Set`, or `Optional` from `typing`.
- Use **`X | None`** instead of `Optional[X]`. Use **`X | Y`** instead of `Union[X, Y]`.
- Use `collections.abc` for abstract container types: `Sequence`, `Mapping`, `Iterable`, `Callable`.
- Use `TypeAlias` or plain assignment for complex type aliases:
  ```python
  type UserId = str  # Python 3.12+
  TransactionMap = dict[str, list[Transaction]]  # 3.9+
  ```
- Use `Protocol` for structural subtyping instead of ABCs when you only need a few methods.
- Use `TypeVar` and `ParamSpec` for generic functions and decorators that preserve caller types.
- Use `Final` for constants that should never be reassigned.
- Use `@dataclass(slots=True)` or Pydantic `BaseModel` for data containers — not raw dicts or NamedTuples with untyped fields.
- Run `mypy` or `pyright` in strict mode. Treat type errors as bugs.

## The Zen of Python, Applied

These are not suggestions — they are design constraints.

### "Beautiful is better than ugly."
- Write code that is pleasant to read. Consistent formatting (Ruff), clear naming, and logical structure matter.

### "Explicit is better than implicit."
- No magic. Type your functions. Name your variables. Make dependencies visible through parameters, not hidden global state.
- Prefer explicit keyword arguments for functions with more than two parameters.
- Use `**kwargs` sparingly and only when genuinely needed for forwarding.

### "Simple is better than complex. Complex is better than complicated."
- Reach for the simplest construct that works: a function before a class, a class before a metaclass, a loop before a recursive generator.
- If the simple approach has a real, measured limitation — then add complexity. Not before.

### "Flat is better than nested."
- Use early returns and guard clauses to avoid deep nesting.
- Prefer comprehensions over nested loops with conditionals when the result is still readable.
- Factor out nested logic into well-named helper functions.

### "Readability counts."
- Code is read far more than it is written. Optimize for the next reader.
- Avoid clever one-liners that sacrifice clarity. A readable three-line version beats a cryptic one-liner.

### "Errors should never pass silently."
- Never use bare `except:`. Always catch specific exceptions.
- Never write `except Exception: pass`. Handle, log, or re-raise.
- Use `ExceptionGroup` (Python 3.11+) for operations that can produce multiple errors.

### "There should be one — and preferably only one — obvious way to do it."
- Pick one pattern per project and be consistent. If the project uses Pydantic for validation, use Pydantic everywhere — don't mix in ad-hoc dict checks.
- Standardize on one async framework, one HTTP client, one serialization approach.

### "If the implementation is hard to explain, it's a bad idea."
- If you can't describe what a function does in one sentence, it does too much. Split it.

### "Namespaces are one honking great idea."
- Use modules and packages to organize code. Avoid polluting the module namespace.
- Prefer absolute imports. Use relative imports only within a tightly coupled package.

## Pythonic Idioms

- Use **context managers** (`with`) for resource management — files, DB connections, locks.
- Use **`pathlib.Path`** over `os.path` for file system operations.
- Use **f-strings** for all string formatting. No `.format()`, no `%`.
- Use **`enumerate`** instead of manual index tracking.
- Use **`zip`** (with `strict=True` in 3.10+) instead of index-based parallel iteration.
- Use **structural pattern matching** (`match`/`case`) for complex branching on data shapes.
- Use **generators and `itertools`** for memory-efficient processing of large sequences.
- Use **`functools.lru_cache`** or `functools.cache` for pure-function memoization.
- Prefer **`datetime.datetime` with timezone awareness** (`datetime.now(tz=UTC)`) over naive datetimes.

## Project Structure

- Keep modules focused. One module, one responsibility.
- Separate **pure logic** from **I/O and side effects**. Business rules should be testable without mocking the filesystem, database, or network.
- Place shared types in a `types.py` or `models.py` within each package — not in a giant project-wide types file.
