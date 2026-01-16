# Base Claude

Automation system for Claude Code.

## Quick Start

```bash
# Clone and copy to ~/.claude
git clone https://github.com/dafu-zhu/base-claude.git
cp -r base-claude/.claude/* ~/.claude/

# Or symlink for auto-updates
ln -sf /path/to/base-claude/.claude ~/.claude
```

## Commands

| Command | Purpose |
|---------|---------|
| `/prepare-task <desc>` | Create task document interactively |
| `/workflow <task.md>` | Execute structured workflow |
| `/compact` | Checkpoint and compact context |
| `/milestone` | Create GitHub milestone issue |

## Structure

```
base-claude/
├── .claude/
│   ├── agents/      # 20 agents
│   ├── commands/    # Slash commands
│   ├── skills/      # Skill definitions
│   ├── templates/   # Task template
│   ├── examples/    # Example tasks
│   ├── rules/       # GPT delegation
│   └── CLAUDE.md    # Behavioral config
├── docs/            # Documentation
└── scripts/         # Install scripts
```

## Agents

**Workflow**: orchestrator, supervisor, task-executor, outer-ralph, task-refiner

**Utility**: code-reviewer, code-improvement-scanner, debugger, architect-reviewer, build-engineer, dependency-manager, git-workflow-manager, documentation-engineer, api-documenter, ai-engineer, cli-developer, fintech-engineer, quant-analyst, risk-manager, research-analyst

## Usage

```bash
# Interactive task creation
/prepare-task "Add user authentication"

# Execute workflow
/workflow ~/auth-task.md
```

## Docs

- [INSTALL.md](docs/INSTALL.md) - Installation options
- [ARCHITECTURE.md](docs/ARCHITECTURE.md) - System design
- [WORKFLOW-GUIDE.md](docs/WORKFLOW-GUIDE.md) - Workflow details
- [AGENT-CATALOG.md](docs/AGENT-CATALOG.md) - Agent reference
- [STATE-SCHEMA.md](docs/STATE-SCHEMA.md) - State file formats
