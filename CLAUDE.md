# Development Workflow

**Project uses `uv` for dependency management. Always use `ruff` for linting/formatting, `pytest` for tests.**

## CRITICAL: Plan Mode First

**ALWAYS propose entering plan mode for ANY implementation task.** This includes:
- Creating or modifying features (even small ones like "add a button")
- Bug fixes beyond single-line typos
- Multi-file changes or refactors
- Performance optimizations
- ANY change that will result in a PR

**How to enter plan mode:** Proactively ask the user "Should I enter plan mode to plan this implementation?" or use the EnterPlanMode tool when appropriate.

**Exception:** Only skip plan mode for trivial tasks (single-line typo fixes, adding debug logs, pure research questions).

**Why:** Planning prevents wasted implementation effort. Exploring the codebase and drafting an approach takes 30 seconds but saves 5+ minutes of fixing incorrect implementations.

## Initial Setup (for new projects)
```sh
# Initialize project with uv
uv init
uv add --dev ruff pytest mypy

# Or use existing pyproject.toml
uv sync
```

## Daily Development
```sh
# 1. Activate environment
source .venv/bin/activate  # or: . .venv/bin/activate

# 2. Make changes

# 3. Format & Lint (auto-runs on save via hooks)
ruff format .
ruff check --fix .

# 4. Run tests
uv run pytest -x                       # Stop on first fail
uv run pytest -k "test_name"           # Single test
uv run pytest path/to/test.py          # Specific file

# 5. Type check (if using mypy)
uv run mypy .

# 6. Before PR
uv run ruff check . && uv run pytest
```

## Adding Dependencies
```sh
# Add runtime dependency
uv add requests

# Add dev dependency
uv add --dev pytest-cov

# Update all dependencies
uv lock --upgrade
```

## Project Notes

<!-- Add project-specific notes here. Examples: -->
<!-- - API keys are in .env (never commit) -->
<!-- - Use `aws sso login` before AWS commands -->
<!-- - Main branch is `main`, PR required for merge -->
