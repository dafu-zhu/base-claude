#!/bin/bash
# Install base-claude globally to ~/.claude
# Preserves existing user data (history, projects, cache, etc.)

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BASE_CLAUDE_DIR="$(dirname "$SCRIPT_DIR")"
TARGET_DIR="$HOME/.claude"

echo "Installing base-claude globally..."
echo "Source: $BASE_CLAUDE_DIR"
echo "Target: $TARGET_DIR"
echo ""

# Create directories
echo "Creating directories..."
mkdir -p "$TARGET_DIR"/{commands,agents,skills,templates,examples,rules}

# Install commands (copy, not symlink - for portability)
echo "Installing commands..."
cp "$BASE_CLAUDE_DIR/.claude/commands/"*.md "$TARGET_DIR/commands/" 2>/dev/null || {
  # If .claude/commands doesn't exist, create from source
  for cmd in workflow prepare-task compact milestone; do
    if [[ -f "$BASE_CLAUDE_DIR/.claude/commands/${cmd}.md" ]]; then
      cp "$BASE_CLAUDE_DIR/.claude/commands/${cmd}.md" "$TARGET_DIR/commands/"
    fi
  done
}

# Symlink agents
echo "Symlinking agents..."

# Workflow agents
for agent in orchestrator supervisor task-executor outer-ralph; do
  ln -sf "$BASE_CLAUDE_DIR/workflow/agents/${agent}.md" "$TARGET_DIR/agents/${agent}.md"
done

# Task writer agent
ln -sf "$BASE_CLAUDE_DIR/task-writer/agents/task-refiner.md" "$TARGET_DIR/agents/task-refiner.md"

# Shared agents
for agent in "$BASE_CLAUDE_DIR/shared/agents/"*.md; do
  if [[ -f "$agent" ]]; then
    ln -sf "$agent" "$TARGET_DIR/agents/$(basename "$agent")"
  fi
done

# Symlink skills
echo "Symlinking skills..."
ln -sf "$BASE_CLAUDE_DIR/workflow/skill.md" "$TARGET_DIR/skills/workflow.md"
ln -sf "$BASE_CLAUDE_DIR/task-writer/skill.md" "$TARGET_DIR/skills/prepare-task.md"
for skill in "$BASE_CLAUDE_DIR/shared/skills/"*.md; do
  if [[ -f "$skill" ]]; then
    ln -sf "$skill" "$TARGET_DIR/skills/$(basename "$skill")"
  fi
done

# Symlink templates
echo "Symlinking templates..."
ln -sf "$BASE_CLAUDE_DIR/workflow/task-template.md" "$TARGET_DIR/templates/task-template.md"

# Symlink examples
echo "Symlinking examples..."
for example in "$BASE_CLAUDE_DIR/workflow/examples/"*.md; do
  if [[ -f "$example" ]]; then
    ln -sf "$example" "$TARGET_DIR/examples/$(basename "$example")"
  fi
done

# Symlink rules
echo "Symlinking rules..."
ln -sf "$BASE_CLAUDE_DIR/rules/delegator" "$TARGET_DIR/rules/delegator"

# Merge settings.json if exists
echo "Checking settings..."
if [[ -f "$TARGET_DIR/settings.json" ]]; then
  echo "Existing settings.json found. Please merge manually if needed:"
  echo "  Source: $BASE_CLAUDE_DIR/settings.json"
  echo "  Target: $TARGET_DIR/settings.json"
else
  cp "$BASE_CLAUDE_DIR/settings.json" "$TARGET_DIR/settings.json"
  echo "Settings installed."
fi

echo ""
echo "Installation complete!"
echo ""
echo "Installed:"
echo "  - Commands: $(ls "$TARGET_DIR/commands/" | wc -l | tr -d ' ') files"
echo "  - Agents: $(ls "$TARGET_DIR/agents/" | wc -l | tr -d ' ') files"
echo "  - Skills: $(ls "$TARGET_DIR/skills/" | wc -l | tr -d ' ') files"
echo ""
echo "Available commands:"
echo "  /prepare-task <description>  - Create task documents"
echo "  /workflow <task.md>          - Execute workflows"
echo "  /compact                     - Save checkpoint, compact context"
echo "  /milestone                   - Create milestone issue"
echo ""
echo "Restart Claude Code to use the new commands."
