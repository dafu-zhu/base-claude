# Workflow State Schema

**Version**: 1.0
**Last Updated**: 2026-01-15

---

## Overview

The workflow system uses `.claude/agent-state.json` to track execution state across all phases, tasks, and agent invocations. This file is the single source of truth for workflow progress, supervisor activity, safety bounds, and learnings.

---

## Schema

### Complete Example

```json
{
  "orchestrator": {
    "status": "executing",
    "task_doc": "/Users/you/.claude/tasks/user-auth.md",
    "current_phase": 2,
    "total_phases": 4,
    "current_task": "3/5",
    "ralph_iteration": 2,
    "outer_ralph": false,
    "start_time": "2026-01-15T12:00:00Z",
    "end_time": null
  },
  "supervisor": {
    "enabled": true,
    "checks_performed": 15,
    "conflicts_detected": 3,
    "auto_fixes_applied": 7,
    "re_plans_triggered": 2,
    "last_check": "2026-01-15T12:30:00Z",
    "interventions": [
      {
        "timestamp": "2026-01-15T12:15:00Z",
        "check_type": "pre_task",
        "task": "1.2",
        "conflict_type": "architecture",
        "severity": "high",
        "action": "re_plan",
        "resolution": "Updated plan to use existing auth module"
      },
      {
        "timestamp": "2026-01-15T12:25:00Z",
        "check_type": "post_task",
        "task": "2.1",
        "conflict_type": "pattern",
        "severity": "low",
        "action": "auto_fix",
        "resolution": "Fixed naming conventions in 3 files"
      }
    ]
  },
  "active_agents": [
    {
      "type": "task-executor",
      "task": "2.1",
      "started": "2026-01-15T12:30:00Z",
      "iteration": 2,
      "status": "in_progress"
    }
  ],
  "completed_tasks": [
    {
      "task": "1.1",
      "name": "Update User model and database schema",
      "completed": "2026-01-15T12:10:00Z",
      "iterations": 1,
      "time_elapsed": "15m 23s",
      "cost": "$0.20",
      "files_modified": [
        "src/models/user.ts",
        "src/db/migrations/001_add_auth_fields.sql"
      ],
      "success_criteria_met": {
        "user_model_updated": true,
        "migration_created": true,
        "migration_tested": true,
        "model_tests_passing": true
      }
    },
    {
      "task": "1.2",
      "name": "Implement JWT authentication",
      "completed": "2026-01-15T12:28:00Z",
      "iterations": 3,
      "time_elapsed": "18m 45s",
      "cost": "$0.55",
      "files_modified": [
        "src/auth/jwt.ts",
        "src/middleware/auth.ts",
        "tests/auth/jwt.test.ts"
      ],
      "success_criteria_met": {
        "jwt_generation_working": true,
        "tokens_expire_1h": true,
        "validation_middleware_created": true,
        "refresh_flow_implemented": true,
        "tests_passing": true
      }
    }
  ],
  "pending_tasks": [
    {
      "phase": 2,
      "task": "2.1",
      "name": "Create auth endpoints"
    },
    {
      "phase": 2,
      "task": "2.2",
      "name": "Add role-based access control"
    },
    {
      "phase": 3,
      "task": "3.1",
      "name": "Protect existing endpoints"
    }
  ],
  "safety_bounds": {
    "max_iterations_per_task": 30,
    "max_cost": "$10",
    "max_time": "2h",
    "cost_so_far": "$0.75",
    "elapsed_time": "0h 34m 8s",
    "warnings": []
  },
  "learnings": [
    {
      "timestamp": "2026-01-15T12:15:00Z",
      "task": "1.2",
      "iteration": 1,
      "type": "pattern",
      "lesson": "JWT tokens must be validated with existing auth middleware pattern",
      "pattern": "Always check for existing patterns before implementing new ones",
      "context": "Authentication implementation"
    },
    {
      "timestamp": "2026-01-15T12:20:00Z",
      "task": "1.2",
      "iteration": 2,
      "type": "antipattern",
      "lesson": "Hardcoding JWT secret in code failed security scan",
      "pattern": "NEVER hardcode secrets, always use environment variables",
      "context": "JWT secret management"
    }
  ],
  "milestones": [
    {
      "phase": 1,
      "name": "Foundation",
      "completed": "2026-01-15T12:28:00Z",
      "issue_url": "https://github.com/user/repo/issues/123"
    }
  ],
  "checkpoints": [
    {
      "timestamp": "2026-01-15T12:10:00Z",
      "phase": 1,
      "task": "1.1",
      "git_sha": "abc123def456",
      "state_snapshot": "checkpoint-001.json"
    },
    {
      "timestamp": "2026-01-15T12:28:00Z",
      "phase": 1,
      "task": "1.2",
      "git_sha": "def456ghi789",
      "state_snapshot": "checkpoint-002.json"
    }
  ]
}
```

---

## Field Definitions

### orchestrator

**status** (string, required)
- Values: `"planning"`, `"executing"`, `"reviewing"`, `"completed"`, `"failed"`
- Indicates current workflow state

**task_doc** (string, required)
- Absolute path to the task document being executed

**current_phase** (integer, required)
- 0-indexed phase number currently executing
- Example: `2` means Phase 3 (0-indexed)

**total_phases** (integer, required)
- Total number of phases in task document

**current_task** (string, required)
- Format: `"N/M"` where N is current task number, M is total tasks in current phase
- Example: `"3/5"` means task 3 out of 5 in current phase

**ralph_iteration** (integer, required)
- Current Ralph loop iteration for active task
- Resets to 0 for each new task

**outer_ralph** (boolean, required)
- `true` if outer Ralph loop is currently running, `false` otherwise

**start_time** (ISO 8601 timestamp, required)
- When workflow execution started

**end_time** (ISO 8601 timestamp, nullable)
- When workflow completed (null if still running)

---

### supervisor

**enabled** (boolean, required)
- Whether supervisor checks are enabled for this workflow

**checks_performed** (integer, required)
- Total number of supervisor checks run (pre-task + post-task + on-demand)

**conflicts_detected** (integer, required)
- Total number of conflicts detected across all checks

**auto_fixes_applied** (integer, required)
- Number of minor conflicts auto-fixed autonomously

**re_plans_triggered** (integer, required)
- Number of times supervisor triggered re-planning (major conflicts)

**last_check** (ISO 8601 timestamp, nullable)
- Timestamp of most recent supervisor check

**interventions** (array, required)
- List of supervisor interventions (conflicts detected and resolved)

#### Intervention Object

**timestamp** (ISO 8601 timestamp, required)
- When the intervention occurred

**check_type** (string, required)
- Values: `"pre_task"`, `"post_task"`, `"on_demand"`

**task** (string, required)
- Task identifier (e.g., `"1.2"`, `"2.1"`)

**conflict_type** (string, required)
- Values: `"architecture"`, `"dependency"`, `"api"`, `"security"`, `"pattern"`

**severity** (string, required)
- Values: `"critical"`, `"high"`, `"low"`

**action** (string, required)
- Values: `"re_plan"`, `"auto_fix"`, `"pass"`

**resolution** (string, required)
- Description of how conflict was resolved

---

### active_agents

Array of currently running agents.

#### Agent Object

**type** (string, required)
- Values: `"task-executor"`, `"supervisor"`, `"outer-ralph"`, `"code-improvement-scanner"`

**task** (string, required)
- Task identifier this agent is working on

**started** (ISO 8601 timestamp, required)
- When agent was spawned

**iteration** (integer, required)
- Current iteration (for Ralph loop agents)

**status** (string, required)
- Values: `"in_progress"`, `"waiting"`, `"blocked"`

---

### completed_tasks

Array of tasks that have completed successfully.

#### Completed Task Object

**task** (string, required)
- Task identifier (e.g., `"1.1"`)

**name** (string, required)
- Task name from task document

**completed** (ISO 8601 timestamp, required)
- When task completed

**iterations** (integer, required)
- Number of Ralph loop iterations used

**time_elapsed** (string, required)
- Human-readable time (e.g., `"15m 23s"`)

**cost** (string, required)
- Estimated cost for this task (e.g., `"$0.20"`)

**files_modified** (array of strings, required)
- List of file paths modified by this task

**success_criteria_met** (object, required)
- Key-value pairs where key is criterion name, value is boolean
- Example: `{"tests_passing": true, "coverage_80": true}`

---

### pending_tasks

Array of tasks not yet started.

#### Pending Task Object

**phase** (integer, required)
- 0-indexed phase number

**task** (string, required)
- Task identifier (e.g., `"2.1"`)

**name** (string, required)
- Task name from task document

---

### safety_bounds

Limits to prevent runaway execution.

**max_iterations_per_task** (integer, required)
- Maximum Ralph loop iterations per task (default: 30)

**max_cost** (string, required)
- Maximum total cost for workflow (e.g., `"$10"`)

**max_time** (string, required)
- Maximum total time for workflow (e.g., `"2h"`)

**cost_so_far** (string, required)
- Cumulative cost across all tasks (e.g., `"$0.75"`)

**elapsed_time** (string, required)
- Cumulative time since start (e.g., `"0h 34m 8s"`)

**warnings** (array of strings, required)
- Warnings when approaching limits (e.g., `["Cost at 75% of limit"]`)

---

### learnings

Array of learnings recorded during execution (also appended to `learnings.jsonl`).

#### Learning Object

**timestamp** (ISO 8601 timestamp, required)
- When learning was recorded

**task** (string, required)
- Task identifier where learning occurred

**iteration** (integer, required)
- Ralph iteration where learning occurred

**type** (string, required)
- Values: `"pattern"`, `"antipattern"`, `"insight"`

**lesson** (string, required)
- What was learned

**pattern** (string, required)
- Reusable pattern for future tasks

**context** (string, required)
- Specific situation where this applies

---

### milestones

Array of phase milestone issues created.

#### Milestone Object

**phase** (integer, required)
- 0-indexed phase number

**name** (string, required)
- Phase name from task document

**completed** (ISO 8601 timestamp, required)
- When phase completed

**issue_url** (string, required)
- URL to GitHub milestone issue

---

### checkpoints

Array of checkpoints created during execution.

#### Checkpoint Object

**timestamp** (ISO 8601 timestamp, required)
- When checkpoint was created

**phase** (integer, required)
- 0-indexed phase number

**task** (string, required)
- Task identifier

**git_sha** (string, required)
- Git commit SHA at checkpoint

**state_snapshot** (string, required)
- Filename of state snapshot (e.g., `"checkpoint-001.json"`)

---

## State Transitions

### Status Lifecycle

```
null (no file)
  ↓
"planning" (orchestrator started, in plan mode)
  ↓
"executing" (plan approved, executing phases/tasks)
  ↓
"reviewing" (all phases complete, outer Ralph running)
  ↓
"completed" (outer Ralph complete, PR created)
```

**Failure states**:
- `"failed"` - Unrecoverable error or user abort

---

## State Updates

### When to Update

**After every**:
- Phase transition
- Task completion
- Ralph iteration
- Supervisor check
- Safety bound warning
- Learning recorded
- Checkpoint created

**Update atomically**:
```typescript
// Read current state
const state = JSON.parse(readFile('.claude/agent-state.json'))

// Modify state
state.orchestrator.current_task = "4/5"
state.completed_tasks.push({...})

// Write back atomically
writeFile('.claude/agent-state.json', JSON.stringify(state, null, 2))
```

---

## Querying State

### CLI Queries

**Check current status**:
```bash
jq '.orchestrator.status' .claude/agent-state.json
```

**Check progress**:
```bash
jq '{phase: .orchestrator.current_phase, task: .orchestrator.current_task, status: .orchestrator.status}' .claude/agent-state.json
```

**Check cost and time**:
```bash
jq '.safety_bounds | {cost: .cost_so_far, time: .elapsed_time, max_cost, max_time}' .claude/agent-state.json
```

**List completed tasks**:
```bash
jq '.completed_tasks[] | {task, name, iterations, time: .time_elapsed}' .claude/agent-state.json
```

**List supervisor interventions**:
```bash
jq '.supervisor.interventions[]' .claude/agent-state.json
```

**List learnings**:
```bash
jq '.learnings[] | {task, type, lesson}' .claude/agent-state.json
```

---

## Migration from Old State Format

**Old format** (automated-workflow):
```json
{
  "status": "executing",
  "current_step": 5,
  "total_steps": 10
}
```

**New format** (workflow):
```json
{
  "orchestrator": {
    "status": "executing",
    "current_phase": 1,
    "total_phases": 3,
    "current_task": "2/4",
    ...
  },
  "supervisor": {...},
  "completed_tasks": [...],
  ...
}
```

**Migration not automatic** - Old workflows must complete under old system. New workflows use new state format.

---

## Related Files

**learnings.jsonl**: Append-only log of learnings (also in state.learnings)
**locks.json**: File locks for parallel agent coordination
**checkpoint.json**: Latest checkpoint snapshot
**checkpoint-XXX.json**: Historical checkpoint snapshots

---

## Best Practices

1. **Never manually edit during execution** - Let orchestrator manage state
2. **Query read-only** - Use `jq` to inspect, don't modify
3. **Checkpoint before major changes** - Allows rollback if needed
4. **Clean up after completion** - Archive state for post-mortem analysis
5. **Monitor safety bounds** - Check cost/time regularly during long workflows

---

## Troubleshooting

**State file corrupted**:
- Restore from latest checkpoint: `cp .claude/checkpoint-XXX.json .claude/agent-state.json`

**State out of sync with git**:
- Check `checkpoints` array for last known good state
- Restore to that git SHA: `git reset --hard <sha>`

**Stale active_agents**:
- Manually remove from `active_agents` array if agent crashed
- Orchestrator will re-spawn if needed

**Safety bounds exceeded but not caught**:
- Manually check `safety_bounds.cost_so_far` and `elapsed_time`
- Pause workflow and extend bounds if justified

---

## Schema Version History

**v1.0** (2026-01-15):
- Initial workflow state schema
- Replaces old automated-workflow state format
- Adds supervisor tracking, learnings, checkpoints
