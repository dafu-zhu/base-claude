# Base Claude

Automation system for Claude Code.

## Install

**Global** (all projects):
```bash
git clone https://github.com/dafu-zhu/base-claude.git ~/base-claude && \
rsync -av ~/base-claude/.claude/ ~/.claude/ && echo "Done. Restart Claude Code."
```

**Project** (single repo):
```bash
git clone https://github.com/dafu-zhu/base-claude.git .base-claude && \
rsync -av .base-claude/.claude/ .claude/ && echo "Done. Restart Claude Code."
```

## Commands

| Command | Purpose |
|---------|---------|
| `/prepare-task <desc>` | Create task document interactively |
| `/workflow <task.md>` | Execute structured workflow |
| `/compact` | Checkpoint and compact context |
| `/milestone` | Create GitHub milestone issue |

## Usage

```bash
/prepare-task "Add user authentication"
/workflow ~/auth-task.md
```

## Structure

```
.claude/
├── agents/      # 20 agents
├── commands/    # Slash commands
├── skills/      # Skill definitions
├── templates/   # Task template
├── examples/    # Example tasks
├── rules/       # GPT delegation
└── CLAUDE.md    # Behavioral config
```

## Docs

[INSTALL](docs/INSTALL.md) | [ARCHITECTURE](docs/ARCHITECTURE.md) | [WORKFLOW-GUIDE](docs/WORKFLOW-GUIDE.md) | [AGENT-CATALOG](docs/AGENT-CATALOG.md)
