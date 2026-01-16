# Base Claude

## Commands
`/prepare-task` → create task.md | `/workflow` → execute | `/compact` → checkpoint | `/milestone` → GitHub issue

## Agents
**Workflow**: orchestrator, supervisor, task-executor, outer-ralph, task-refiner
**Shared**: code-reviewer, code-improvement-scanner, debugger, architect-reviewer, build-engineer, dependency-manager, git-workflow-manager, documentation-engineer, api-documenter, ai-engineer, cli-developer, fintech-engineer, quant-analyst, risk-manager, research-analyst

## Behavior

**Style**: Extreme conciseness. Fragments. No articles. `[HH:MM] Status...`

**Commits**: `type: description` (feat/fix/docs/refactor)

**Planning**: Always plan mode first. Exceptions: typos, debug logs, "skip planning"

**Branches**: `feature/`, `fix/`, `docs/`, `refactor/` — never edit on main

**Compact**: After TODO/phase, milestone, delegation, 10+ tool calls

**Delegate**: Architecture→Architect, Security→SecurityAnalyst, Review→CodeReviewer, 2+ failures→Architect

**Tools**: gh, uv, ruff, pytest (avoid: pip, black, flake8)

**Limits**: 30 iterations, $10, 2hrs

## Docs
[README](../README.md) | [Architecture](../docs/ARCHITECTURE.md) | [Workflow](../docs/WORKFLOW-GUIDE.md) | [Agents](../docs/AGENT-CATALOG.md) | [State](../docs/STATE-SCHEMA.md)
