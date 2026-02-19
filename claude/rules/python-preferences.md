---
description: Python standards — strict typing, Zen of Python principles
globs: "**/*.py"
alwaysApply: false
---

# Python Preferences

## Typing — non-negotiable
- IMPORTANT: Type-annotate every function signature (parameters AND return type). No exceptions.
- Use built-in generics: `list[str]`, `dict[str, int]`, `set[str]`. Never import their `typing` aliases (`List`, `Dict`, `Tuple`, `Set`, `Optional`).
- Use `X | None` not `Optional[X]`. Use `X | Y` not `Union[X, Y]`.
- Use `collections.abc` for abstract types: `Sequence`, `Mapping`, `Iterable`, `Callable`.
- Use `Protocol` for structural subtyping over ABCs when you only need a few methods.
- Use `@dataclass(slots=True)` or Pydantic `BaseModel` for data containers — never raw dicts with stringly-typed keys.
- Use `Final` for constants. Use `TypeVar`/`ParamSpec` for generic functions and typed decorators.
- Treat type-checker errors as bugs.

## Zen of Python — as design constraints
- **Explicit over implicit**: type your functions, name your variables, pass dependencies as parameters instead of hiding them in global state. Use keyword arguments for functions with >2 params. Avoid `**kwargs` unless genuinely forwarding.
- **Simple over complex**: reach for a function before a class, a class before a metaclass. Add complexity only when the simple approach has a proven limitation.
- **Flat over nested**: early returns, guard clauses, well-named helper functions. Factor out nested logic.
- **One obvious way**: pick one pattern per project and be consistent (one validation lib, one HTTP client, one serialization approach). Don't mix Pydantic validation with ad-hoc dict checks.
- **Errors never pass silently**: never bare `except:`, never `except Exception: pass`. Catch specific exceptions; handle, log, or re-raise.
- **If it's hard to explain, it's a bad idea**: if you can't describe a function in one sentence, it does too much — split it.

## Idioms that matter
- `pathlib.Path` over `os.path`
- Context managers (`with`) for all resource management
- `zip(strict=True)` for parallel iteration (3.10+)
- `match`/`case` for complex branching on data shapes
- **Assumes Python 3.10+** (built-in generics, `X | Y` unions, `match`/`case`, `zip(strict=True)`, `slots=True`)
- Timezone-aware datetimes (`datetime.now(tz=UTC)`)
- Separate pure logic from I/O — business rules should be testable without mocking filesystem, DB, or network
