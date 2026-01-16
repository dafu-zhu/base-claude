# Base Claude Workflow Configuration

This project uses the modular automation system for Claude Code.

## Slash Commands

| Command | Description |
|---------|-------------|
| `/prepare-task <description>` | Create task documents interactively via task-refiner agent |
| `/workflow <task.md>` | Execute structured workflows with plan mode, supervisor, quality pass |
| `/compact` | Save checkpoint and compact context while preserving critical state |
| `/milestone` | Create GitHub issue documenting workflow milestone |

## Available Agents

### Workflow Agents
- `orchestrator` - Top-level workflow coordinator
- `supervisor` - Conflict detection and oversight
- `task-executor` - Task-level Ralph loop execution
- `outer-ralph` - Final quality pass

### Task Writer Agents
- `task-refiner` - Interactive task document generation

### Shared Agents
- `code-improvement-scanner` - Proactive code quality improvements
- `ai-engineer` - AI/ML implementation
- `build-engineer` - Build systems and CI/CD
- `cli-developer` - CLI tool development
- `code-reviewer` - Code review and quality
- `architect-reviewer` - Architecture review
- `debugger` - Debugging assistance
- `documentation-engineer` - Documentation
- `api-documenter` - API documentation
- `git-workflow-manager` - Git operations
- `dependency-manager` - Dependency management
- `fintech-engineer` - Financial technology
- `quant-analyst` - Quantitative analysis
- `risk-manager` - Risk assessment
- `research-analyst` - Research tasks

## Quick Start

```bash
# Create a task document
/prepare-task "Add user authentication to the API"

# Execute the workflow
/workflow ~/auth-task.md
```

## Directory Structure

```
.claude/
├── commands/         # Slash commands
│   ├── workflow.md       # /workflow
│   ├── prepare-task.md   # /prepare-task
│   ├── compact.md        # /compact
│   └── milestone.md      # /milestone
├── agents/           # Symlinks to all available agents
├── skills/           # Symlinks to skill documentation
├── templates/        # Task document template
├── examples/         # Example task documents
├── rules/            # Delegator rules for GPT experts
└── settings.local.json
```

## State Files (Auto-created during workflow)

- `agent-state.json` - Workflow execution state
- `learnings.jsonl` - Append-only learning log
- `locks.json` - File locking for parallel agents
- `checkpoint.json` - Recovery checkpoints

## Documentation

- [README](../README.md) - Overview and quick start
- [Architecture](../ARCHITECTURE.md) - System design
- [Workflow Guide](../workflow/WORKFLOW-GUIDE.md) - Detailed workflow documentation
- [Agent Catalog](../workflow/AGENT-CATALOG.md) - Agent descriptions
- [State Schema](../docs/STATE-SCHEMA.md) - State file schemas
