---
description: Execute structured workflow with plan mode, supervisor, and quality pass
argument-hint: <task-doc.md>
allowed-tools: Read, Write, Edit, Bash, Task, TodoWrite, AskUserQuestion, EnterPlanMode, ExitPlanMode, Glob, Grep
---

# Workflow Execution

Execute the automated workflow for task document: $ARGUMENTS

## Step 1: Read and Validate Task Document

Read the task document at: $ARGUMENTS

Validate it has required sections:
- Goal
- Context
- Success Criteria
- Phases with tasks
- Safety bounds

If invalid, report what's missing and stop.

## Step 2: Initialize State

Create `.claude/agent-state.json` with initial state:
```json
{
  "orchestrator": {
    "status": "planning",
    "task_doc": "$ARGUMENTS",
    "current_phase": 0,
    "total_phases": <from task doc>,
    "start_time": "<now>"
  },
  "supervisor": {
    "enabled": true,
    "conflicts_detected": 0,
    "interventions": []
  },
  "active_agents": [],
  "completed_tasks": [],
  "pending_tasks": <from task doc>,
  "safety_bounds": <from task doc>,
  "learnings": []
}
```

## Step 3: Spawn Orchestrator Agent

Use the Task tool to spawn the orchestrator agent:

```
Task({
  subagent_type: "general-purpose",
  prompt: "Read .claude/agents/orchestrator.md for your instructions.

TASK: Execute workflow for task document at: $ARGUMENTS

INSTRUCTIONS:
1. MUST enter plan mode first (EnterPlanMode tool)
2. Explore codebase to understand context
3. Ask ALL clarifying questions upfront (AskUserQuestion tool)
4. Wait for user approval (ExitPlanMode tool)
5. Execute phases → tasks with Ralph loops
6. Supervisor checks mandatory (pre/post each task)
7. Outer Ralph loop mandatory at end
8. Create PR when complete

STATE FILE: .claude/agent-state.json
LEARNINGS FILE: .claude/learnings.jsonl
LOCKS FILE: .claude/locks.json
CHECKPOINT FILE: .claude/checkpoint.json

GPT DELEGATION: Use rules/delegator for Architect, Security Analyst, Code Reviewer when needed.

Read the orchestrator agent instructions and begin.",
  description: "Workflow orchestrator"
})
```

## Execution Flow (for reference)

```
orchestrator
├─→ Enter plan mode
├─→ Ask ALL questions upfront
├─→ Get user approval
├─→ FOR EACH phase:
│   └─→ FOR EACH task:
│       ├─→ supervisor (pre-check) → PASS/AUTO_FIX/RE_PLAN
│       ├─→ task-executor (Ralph loop)
│       ├─→ supervisor (post-check)
│       └─→ Commit & checkpoint
│   └─→ Create milestone issue
├─→ outer-ralph (final quality pass)
├─→ Generate report
└─→ Create PR
```

## State Files

| File | Purpose |
|------|---------|
| `.claude/agent-state.json` | Workflow execution state |
| `.claude/learnings.jsonl` | Append-only learning log |
| `.claude/locks.json` | File locking for parallel agents |
| `.claude/checkpoint.json` | Recovery checkpoints |

## Required Agents

Read from `.claude/agents/`:
- `orchestrator.md` - Top-level coordinator
- `supervisor.md` - Conflict detection
- `task-executor.md` - Task Ralph loop
- `outer-ralph.md` - Final quality pass

## GPT Expert Integration

Via `rules/delegator/`:
- Architect - System design decisions
- Security Analyst - Security review
- Code Reviewer - Code quality
- Plan Reviewer - Plan validation
