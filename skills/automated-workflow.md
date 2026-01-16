# Automated Workflow Skill

Launch fully autonomous workflow execution.

## Purpose

Execute automated task from document without human intervention until success criteria met or safety bounds exceeded.

## Usage

```
/automated-workflow path/to/task-doc.md
```

Or:
```
User: "Run automated workflow for task-doc.md"
```

## Process

### 1. Parse Task Document
```
[12:00] Loading task document...
[12:00] Parsed:
  - Goal: [goal]
  - Phases: X
  - Success criteria: X conditions
  - Safety: max_iter=50, max_cost=$10, max_time=2h
```

### 2. Initialize Environment
```bash
# Check/create branch
current_branch=$(git branch --show-current)
if [[ "$current_branch" =~ ^(main|master)$ ]]; then
  task_name=$(basename "$task_doc" .md)
  git checkout -b "feature/$task_name"
fi

# Initialize state file
cat > .claude/agent-state.json <<EOF
{
  "orchestrator": {
    "status": "initializing",
    "task": "$task_name",
    "start_time": "$(date -Iseconds)",
    "iteration": 0,
    "cost": 0
  },
  "completed_todos": [],
  "pending_todos": []
}
EOF

# Initialize locks file
echo "{}" > .claude/locks.json
```

### 3. Launch Orchestrator
```
[12:01] Launching workflow-orchestrator agent...
```

Delegate to workflow-orchestrator subagent:
```python
Task(
    subagent_type="workflow-orchestrator",
    prompt=f"""
Execute automated workflow from task document.

Task document: {task_doc_path}
Contents:
{task_doc_contents}

Follow all steps in workflow-orchestrator agent definition.
Report progress with timestamps.
Stop when success criteria met or safety bounds exceeded.
    """,
    run_in_background=False  # Block until complete
)
```

### 4. Monitor Progress
While orchestrator running:
- Read `.claude/agent-state.json` for progress
- Display key updates
- Alert if approaching limits

### 5. Handle Completion
On success:
```
[14:30] Workflow complete.
[14:30] PR created: https://github.com/user/repo/pull/123
[14:30] Milestone issues: #120, #121, #122, #123
[14:30] Metrics: 2h 30m, $8.45, 38 iterations
```

On failure:
```
[13:45] Workflow stopped: Max cost exceeded
[13:45] Rolled back to last checkpoint
[13:45] Partial progress saved in issue #125
```

## Safety

Orchestrator enforces all safety bounds from preferences.md:
- Max iterations: 50
- Max cost: $10
- Max time: 2h
- Max files per iteration: 10

## Task Document Format

Required structure:
```markdown
# Automated Task: [Name]

## Goal
[Specific, measurable outcome]

## Context
- Current state: [...]
- Problem: [...]
- Constraints: [...]

## Success Criteria (machine-verifiable)
- [ ] All tests pass (pytest exit code 0)
- [ ] No lint errors (ruff check exit code 0)
- [ ] Coverage >= 80%
- [ ] [Custom criteria]

## Safety Bounds (optional, uses defaults from preferences.md)
- max_iterations: 30
- max_cost: $5
- max_time: 1h

## Behavioral Overrides (optional)
[Any overrides to global preferences]

## Strategy (optional)
- Prefer: [patterns]
- Avoid: [patterns]
- When uncertain: [action]
```

## Communication

Extremely concise. Timestamp format only.
