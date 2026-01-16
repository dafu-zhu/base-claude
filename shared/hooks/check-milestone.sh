#!/bin/bash
# Check if milestone reached after TODO completion

set -euo pipefail

STATE_FILE=".claude/agent-state.json"

if [[ ! -f "$STATE_FILE" ]]; then
    exit 0  # Not in automated workflow
fi

# Read state
completed=$(jq -r '.completed_todos | length' "$STATE_FILE" 2>/dev/null || echo 0)
phase=$(jq -r '.orchestrator.current_phase // 0' "$STATE_FILE" 2>/dev/null || echo 0)

# Check if milestone condition met
# Create issue every 5 completed TODOs or at phase completion
if (( completed % 5 == 0 && completed > 0 )); then
    echo "[Hook] Milestone detected: $completed TODOs complete"
    echo "[Hook] Trigger: Create milestone issue"
    # Orchestrator will handle issue creation
fi
