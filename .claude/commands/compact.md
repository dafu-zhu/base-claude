---
description: Save checkpoint and compact context while preserving critical state
allowed-tools: Read, Write, Bash, TodoWrite
---

# Compact & Checkpoint

Save state, compact context, and verify preservation.

## Step 1: Save Checkpoint

Create `.claude/checkpoint.json` with current state:

```bash
cat > .claude/checkpoint.json <<EOF
{
  "timestamp": "$(date -Iseconds)",
  "phase": <current phase from agent-state.json>,
  "completed_todos": <from agent-state.json>,
  "pending_todos": <from agent-state.json>,
  "metrics": {
    "iteration": <current iteration>,
    "cost": <cost so far>,
    "time": <elapsed time>
  },
  "context": {
    "current_task": <current task>,
    "last_action": <what was just done>,
    "next_action": <what comes next>
  }
}
EOF
```

## Step 2: Read Current State

Before compacting, read and preserve:
- `.claude/agent-state.json` - Workflow state
- `.claude/checkpoint.json` - Just created
- `.claude/learnings.jsonl` - Learning log

## Step 3: Identify What to Preserve

**Critical (MUST survive compaction):**
- Current phase/iteration
- Completed vs pending TODOs
- Cost/time metrics
- Current plan
- Unresolved questions
- Learnings from this session

**Can discard:**
- Detailed exploration results
- Intermediate file contents
- Old error messages
- Verbose logs

## Step 4: Compact Context

Summarize the current conversation state in a concise format that preserves critical information while reducing context size.

## Step 5: Verify Preservation

```bash
# Check checkpoint file exists
test -f .claude/checkpoint.json || echo "ERROR: Checkpoint lost"

# Verify agent state preserved
test -f .claude/agent-state.json || echo "ERROR: Agent state lost"
```

## Step 6: Report

Output only:
```
Checkpoint saved. Context compacted. State preserved.
```

## When to Use

- After each phase completion
- Every 5 tasks completed
- When context exceeds 100k tokens
- Before supervisor re-planning
- Before outer Ralph loop
