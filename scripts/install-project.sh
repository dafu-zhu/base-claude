#!/bin/bash
# Install base-claude to current project's .claude directory
# Uses symlinks to base-claude source for easy updates

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BASE_CLAUDE_DIR="$(dirname "$SCRIPT_DIR")"
TARGET_DIR="$(pwd)/.claude"

echo "Installing base-claude to project..."
echo "Source: $BASE_CLAUDE_DIR"
echo "Target: $TARGET_DIR"
echo ""

# Create directories
echo "Creating directories..."
mkdir -p "$TARGET_DIR"/{commands,agents,skills,templates,examples,rules}

# Copy commands (not symlink - commands should be portable)
echo "Installing commands..."
if [[ -d "$BASE_CLAUDE_DIR/.claude/commands" ]]; then
  cp "$BASE_CLAUDE_DIR/.claude/commands/"*.md "$TARGET_DIR/commands/"
else
  echo "Warning: No commands found in $BASE_CLAUDE_DIR/.claude/commands"
fi

# Symlink agents (relative paths for portability)
echo "Symlinking agents..."

# Calculate relative path from target to source
REL_PATH=$(python3 -c "import os.path; print(os.path.relpath('$BASE_CLAUDE_DIR', '$TARGET_DIR/agents'))")

# Workflow agents
for agent in orchestrator supervisor task-executor outer-ralph; do
  ln -sf "$REL_PATH/workflow/agents/${agent}.md" "$TARGET_DIR/agents/${agent}.md"
done

# Task writer agent
ln -sf "$REL_PATH/task-writer/agents/task-refiner.md" "$TARGET_DIR/agents/task-refiner.md"

# Shared agents
for agent in "$BASE_CLAUDE_DIR/shared/agents/"*.md; do
  if [[ -f "$agent" ]]; then
    ln -sf "$REL_PATH/shared/agents/$(basename "$agent")" "$TARGET_DIR/agents/$(basename "$agent")"
  fi
done

# Symlink skills
echo "Symlinking skills..."
REL_PATH_SKILLS=$(python3 -c "import os.path; print(os.path.relpath('$BASE_CLAUDE_DIR', '$TARGET_DIR/skills'))")
ln -sf "$REL_PATH_SKILLS/workflow/skill.md" "$TARGET_DIR/skills/workflow.md"
ln -sf "$REL_PATH_SKILLS/task-writer/skill.md" "$TARGET_DIR/skills/prepare-task.md"
for skill in "$BASE_CLAUDE_DIR/shared/skills/"*.md; do
  if [[ -f "$skill" ]]; then
    ln -sf "$REL_PATH_SKILLS/shared/skills/$(basename "$skill")" "$TARGET_DIR/skills/$(basename "$skill")"
  fi
done

# Symlink templates
echo "Symlinking templates..."
REL_PATH_TPL=$(python3 -c "import os.path; print(os.path.relpath('$BASE_CLAUDE_DIR', '$TARGET_DIR/templates'))")
ln -sf "$REL_PATH_TPL/workflow/task-template.md" "$TARGET_DIR/templates/task-template.md"

# Symlink examples
echo "Symlinking examples..."
REL_PATH_EX=$(python3 -c "import os.path; print(os.path.relpath('$BASE_CLAUDE_DIR', '$TARGET_DIR/examples'))")
for example in "$BASE_CLAUDE_DIR/workflow/examples/"*.md; do
  if [[ -f "$example" ]]; then
    ln -sf "$REL_PATH_EX/workflow/examples/$(basename "$example")" "$TARGET_DIR/examples/$(basename "$example")"
  fi
done

# Symlink rules
echo "Symlinking rules..."
REL_PATH_RULES=$(python3 -c "import os.path; print(os.path.relpath('$BASE_CLAUDE_DIR', '$TARGET_DIR/rules'))")
ln -sf "$REL_PATH_RULES/rules/delegator" "$TARGET_DIR/rules/delegator"

# Create settings.local.json
echo "Creating settings..."
cat > "$TARGET_DIR/settings.local.json" << 'EOF'
{
  "permissions": {
    "allow": []
  }
}
EOF

echo ""
echo "Installation complete!"
echo ""
echo "Installed to: $TARGET_DIR"
echo ""
echo "Available commands:"
echo "  /prepare-task <description>  - Create task documents"
echo "  /workflow <task.md>          - Execute workflows"
echo "  /compact                     - Save checkpoint, compact context"
echo "  /milestone                   - Create milestone issue"
echo ""
echo "Note: Restart Claude Code to use the new commands."
