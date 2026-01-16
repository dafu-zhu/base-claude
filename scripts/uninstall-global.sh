#!/bin/bash
# Uninstall base-claude from ~/.claude
# Removes only base-claude files, preserves user data

set -e

TARGET_DIR="$HOME/.claude"

echo "Uninstalling base-claude from $TARGET_DIR..."
echo ""

# Remove commands
if [[ -d "$TARGET_DIR/commands" ]]; then
  echo "Removing commands..."
  rm -f "$TARGET_DIR/commands/workflow.md"
  rm -f "$TARGET_DIR/commands/prepare-task.md"
  rm -f "$TARGET_DIR/commands/compact.md"
  rm -f "$TARGET_DIR/commands/milestone.md"
  rmdir "$TARGET_DIR/commands" 2>/dev/null || true
fi

# Remove agent symlinks
if [[ -d "$TARGET_DIR/agents" ]]; then
  echo "Removing agent symlinks..."
  for agent in orchestrator supervisor task-executor outer-ralph task-refiner \
               code-improvement-scanner ai-engineer build-engineer cli-developer \
               code-reviewer architect-reviewer debugger documentation-engineer \
               api-documenter git-workflow-manager dependency-manager \
               fintech-engineer quant-analyst risk-manager research-analyst; do
    rm -f "$TARGET_DIR/agents/${agent}.md"
  done
  rmdir "$TARGET_DIR/agents" 2>/dev/null || true
fi

# Remove skill symlinks
if [[ -d "$TARGET_DIR/skills" ]]; then
  echo "Removing skill symlinks..."
  rm -f "$TARGET_DIR/skills/workflow.md"
  rm -f "$TARGET_DIR/skills/prepare-task.md"
  rm -f "$TARGET_DIR/skills/compact-checkpoint.md"
  rm -f "$TARGET_DIR/skills/milestone-issue.md"
  rmdir "$TARGET_DIR/skills" 2>/dev/null || true
fi

# Remove templates
if [[ -d "$TARGET_DIR/templates" ]]; then
  echo "Removing templates..."
  rm -f "$TARGET_DIR/templates/task-template.md"
  rmdir "$TARGET_DIR/templates" 2>/dev/null || true
fi

# Remove examples
if [[ -d "$TARGET_DIR/examples" ]]; then
  echo "Removing examples..."
  rm -f "$TARGET_DIR/examples/simple-example.md"
  rm -f "$TARGET_DIR/examples/complex-example.md"
  rmdir "$TARGET_DIR/examples" 2>/dev/null || true
fi

# Remove rules
if [[ -d "$TARGET_DIR/rules" ]]; then
  echo "Removing rules..."
  rm -f "$TARGET_DIR/rules/delegator"
  rmdir "$TARGET_DIR/rules" 2>/dev/null || true
fi

echo ""
echo "Uninstallation complete!"
echo ""
echo "Preserved user data:"
echo "  - history.jsonl"
echo "  - projects/"
echo "  - cache/"
echo "  - settings.json"
echo ""
echo "To fully remove, delete ~/.claude manually."
