# Installation Guide

## Installation Patterns

| Pattern | Scope | Use Case |
|---------|-------|----------|
| **Global** | All projects | You want workflow commands everywhere |
| **Project** | Single project | You want workflow in one repo only |
| **Hybrid** | Mixed | Global agents, project-specific commands |

---

## Pattern 1: Global Installation

Install base-claude for all Claude Code projects.

### Option A: Fresh Install (No existing ~/.claude)

```bash
# Clone directly
git clone https://github.com/dafu-zhu/base-claude.git ~/.claude

# Run setup script
~/.claude/scripts/setup.sh
```

### Option B: Existing ~/.claude (Recommended)

```bash
# 1. Backup existing data
cp -r ~/.claude ~/.claude.backup

# 2. Clone base-claude to a separate location
git clone https://github.com/dafu-zhu/base-claude.git ~/base-claude

# 3. Run merge script (preserves your data)
~/base-claude/scripts/install-global.sh

# 4. Verify
ls ~/.claude/commands/  # Should show workflow.md, etc.
```

### What Gets Installed Globally

```
~/.claude/
├── commands/           # NEW: /workflow, /prepare-task, /compact, /milestone
├── agents/             # NEW: Symlinks to base-claude agents
├── skills/             # NEW: Symlinks to base-claude skills
├── templates/          # NEW: Task document template
├── examples/           # NEW: Example task documents
├── rules/              # NEW: GPT delegator rules
│
├── settings.json       # MERGED: Your settings + base-claude plugins
├── history.jsonl       # PRESERVED: Your history
├── projects/           # PRESERVED: Your project data
├── cache/              # PRESERVED: Your cache
└── ...                 # PRESERVED: Other user data
```

---

## Pattern 2: Project Installation

Install base-claude for a single project only.

```bash
# 1. Navigate to your project
cd /path/to/your/project

# 2. Clone base-claude (or add as submodule)
git clone https://github.com/dafu-zhu/base-claude.git .base-claude-src

# 3. Run project setup
.base-claude-src/scripts/install-project.sh

# 4. Add to .gitignore (optional - if you don't want to commit)
echo ".claude/" >> .gitignore
```

### What Gets Installed in Project

```
your-project/
├── .claude/
│   ├── commands/       # Slash commands
│   ├── agents/         # Symlinks → .base-claude-src/...
│   ├── skills/         # Symlinks → .base-claude-src/...
│   ├── templates/      # Symlinks
│   ├── examples/       # Symlinks
│   ├── rules/          # Symlinks
│   └── settings.local.json
│
└── .base-claude-src/   # Source (can be submodule)
```

---

## Pattern 3: Hybrid Installation

Global agents, project-specific customization.

```bash
# 1. Install globally first
~/base-claude/scripts/install-global.sh

# 2. In specific project, add overrides
cd /path/to/your/project
mkdir -p .claude/commands

# 3. Create project-specific command overrides
cat > .claude/commands/workflow.md << 'EOF'
---
description: Project-specific workflow with custom settings
---
# Custom workflow for this project
...
EOF
```

Project `.claude/` overrides global `~/.claude/` for same-named files.

---

## Manual Installation

If you prefer manual setup:

### Step 1: Create Directory Structure

```bash
# For global
mkdir -p ~/.claude/{commands,agents,skills,templates,examples,rules}

# For project
mkdir -p .claude/{commands,agents,skills,templates,examples,rules}
```

### Step 2: Copy or Symlink Commands

```bash
# Option A: Copy (static)
cp base-claude/.claude/commands/*.md ~/.claude/commands/

# Option B: Symlink (live updates)
ln -sf /path/to/base-claude/.claude/commands/workflow.md ~/.claude/commands/
ln -sf /path/to/base-claude/.claude/commands/prepare-task.md ~/.claude/commands/
ln -sf /path/to/base-claude/.claude/commands/compact.md ~/.claude/commands/
ln -sf /path/to/base-claude/.claude/commands/milestone.md ~/.claude/commands/
```

### Step 3: Symlink Agents

```bash
# Workflow agents
for agent in orchestrator supervisor task-executor outer-ralph; do
  ln -sf /path/to/base-claude/workflow/agents/${agent}.md ~/.claude/agents/
done

# Task writer agent
ln -sf /path/to/base-claude/task-writer/agents/task-refiner.md ~/.claude/agents/

# Shared agents
for agent in /path/to/base-claude/shared/agents/*.md; do
  ln -sf "$agent" ~/.claude/agents/
done
```

### Step 4: Symlink Skills

```bash
ln -sf /path/to/base-claude/workflow/skill.md ~/.claude/skills/workflow.md
ln -sf /path/to/base-claude/task-writer/skill.md ~/.claude/skills/prepare-task.md
ln -sf /path/to/base-claude/shared/skills/compact-checkpoint.md ~/.claude/skills/
ln -sf /path/to/base-claude/shared/skills/milestone-issue.md ~/.claude/skills/
```

### Step 5: Symlink Templates and Examples

```bash
ln -sf /path/to/base-claude/workflow/task-template.md ~/.claude/templates/
ln -sf /path/to/base-claude/workflow/examples/simple-example.md ~/.claude/examples/
ln -sf /path/to/base-claude/workflow/examples/complex-example.md ~/.claude/examples/
```

### Step 6: Symlink Rules

```bash
ln -sf /path/to/base-claude/rules/delegator ~/.claude/rules/
```

### Step 7: Update Settings (Optional)

Merge into `~/.claude/settings.json`:

```json
{
  "model": "sonnet",
  "enabledPlugins": {
    "claude-delegator@jarrodwatts-claude-delegator": true,
    "ralph-loop@claude-plugins-official": true
  }
}
```

---

## Verification

After installation, verify:

```bash
# Check commands exist
ls ~/.claude/commands/
# Expected: compact.md  milestone.md  prepare-task.md  workflow.md

# Check agents symlinked correctly
ls -la ~/.claude/agents/orchestrator.md
# Expected: symlink to base-claude/workflow/agents/orchestrator.md

# Test a command (in Claude Code)
/workflow --help
```

---

## Uninstallation

### Global

```bash
# Remove symlinks only (preserves user data)
rm -rf ~/.claude/commands ~/.claude/agents ~/.claude/skills
rm -rf ~/.claude/templates ~/.claude/examples ~/.claude/rules

# Or restore backup
rm -rf ~/.claude
mv ~/.claude.backup ~/.claude
```

### Project

```bash
rm -rf .claude .base-claude-src
```

---

## Troubleshooting

| Issue | Solution |
|-------|----------|
| Commands not appearing | Restart Claude Code session |
| Symlinks broken | Check paths, recreate with absolute paths |
| Conflicts with existing | Backup first, then merge manually |
| Permission denied | Check file permissions, use `chmod` |

---

## Updating

```bash
# If using symlinks (recommended)
cd /path/to/base-claude
git pull

# If using copies
cp -r base-claude/.claude/commands/* ~/.claude/commands/
```
