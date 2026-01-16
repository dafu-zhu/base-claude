# Installation

## Quick Install

```bash
# Clone
git clone https://github.com/dafu-zhu/base-claude.git ~/base-claude

# Copy to ~/.claude (merges with existing)
cp -r ~/base-claude/.claude/* ~/.claude/
```

## Installation Options

| Method | Command | Updates |
|--------|---------|---------|
| **Copy** | `cp -r base-claude/.claude/* ~/.claude/` | Manual |
| **Symlink** | `ln -sf ~/base-claude/.claude ~/.claude` | Auto (`git pull`) |

## What Gets Installed

```
~/.claude/
├── agents/       # 20 agents
├── commands/     # /workflow, /prepare-task, /compact, /milestone
├── skills/       # Skill definitions
├── templates/    # Task template
├── examples/     # Example tasks
├── rules/        # GPT delegation
└── CLAUDE.md     # Behavioral preferences
```

## Global vs Project

| Location | Scope | Priority |
|----------|-------|----------|
| `~/.claude/` | All projects | Lower |
| `.claude/` (in project) | Single project | Higher (overrides global) |

Project-level files override global.

## CLAUDE.md (Behavioral Preferences)

Defines communication style, planning rules, tool choices.

```bash
# Copy for customization
cp ~/base-claude/.claude/CLAUDE.md ~/.claude/

# Or symlink for auto-updates
ln -sf ~/base-claude/.claude/CLAUDE.md ~/.claude/CLAUDE.md
```

## Verify

```bash
ls ~/.claude/commands/
# Expected: compact.md  milestone.md  prepare-task.md  workflow.md
```

## Uninstall

```bash
rm -rf ~/.claude/{agents,commands,skills,templates,examples,rules,CLAUDE.md}
```

## Update

```bash
cd ~/base-claude && git pull
cp -r .claude/* ~/.claude/  # if using copy method
# symlink method updates automatically
```
