# Compact & Checkpoint Skill

Save state, compact context, verify preservation.

## Purpose

Automatically compact context after milestones while preserving critical state.

## Process

1. Save checkpoint:
```bash
cat > .claude/checkpoint.json <<EOF
{
  "timestamp": "$(date -Iseconds)",
  "phase": "$current_phase",
  "completed_todos": $(jq .completed_todos .claude/agent-state.json),
  "pending_todos": $(jq .pending_todos .claude/agent-state.json),
  "metrics": {
    "iteration": $iteration,
    "cost": $cost,
    "time": "$time_elapsed"
  },
  "context": {
    "current_task": "$current_task",
    "last_action": "$last_action",
    "next_action": "$next_action"
  }
}
EOF
```

2. Compact context:
```
User executes: /compact
```

3. Verify critical info:
```bash
# Check checkpoint file exists
test -f .claude/checkpoint.json || echo "ERROR: Checkpoint lost"

# Verify agent state preserved
test -f .claude/agent-state.json || echo "ERROR: Agent state lost"
```

4. Report:
```
[12:35] Checkpoint saved
[12:35] Compacting...
[12:36] Compact complete. State preserved.
```

## What to Preserve

Critical (MUST survive compaction):
- Current phase/iteration
- Completed vs pending TODOs
- Cost/time metrics
- Current plan
- Unresolved questions
- Learnings from this session

Can discard:
- Detailed exploration results
- Intermediate file contents
- Old error messages
- Verbose logs

## Communication

Report only: "Compacted. State preserved."
