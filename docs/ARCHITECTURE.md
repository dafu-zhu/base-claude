# Architecture Overview

## Repository Structure

```
base-claude/
│
├── task-writer/              # Module 1: Task Document Creation
│   ├── agents/
│   │   └── task-refiner.md   # Interviews user, generates task.md
│   └── skill.md              # /prepare-task command
│
├── workflow/                 # Module 2: Workflow Execution
│   ├── agents/
│   │   ├── orchestrator.md   # Top-level coordinator
│   │   ├── supervisor.md     # Conflict detection
│   │   ├── task-executor.md  # Task Ralph loop
│   │   └── outer-ralph.md    # Final quality pass
│   ├── examples/
│   │   ├── simple-example.md
│   │   └── complex-example.md
│   ├── task-template.md
│   ├── skill.md              # /workflow command
│   └── WORKFLOW-GUIDE.md
│
├── shared/                   # Module 3: Shared Utilities
│   ├── agents/               # 15+ general-purpose agents
│   ├── skills/               # Reusable skills
│   └── hooks/                # Event hooks
│
├── docs/                     # Global Documentation
├── rules/                    # Delegator (GPT experts)
└── settings.json
```

---

## Data Flow

### Happy Path: Raw Idea → Complete Implementation

```
┌─────────────────────────────────────────────────────────────────┐
│ 1. USER INPUT                                                   │
│    "Add JWT authentication to the API"                          │
└──────────────────┬──────────────────────────────────────────────┘
                   │
                   ▼
┌─────────────────────────────────────────────────────────────────┐
│ 2. TASK WRITER MODULE                                           │
│    /prepare-task "Add JWT authentication"                       │
│                                                                  │
│    ┌────────────────┐                                           │
│    │ task-refiner   │ Asks questions:                           │
│    │ agent          │ - What exists today?                      │
│    └────────────────┘ - What needs protection?                  │
│                       - What user roles?                         │
│                       - Success criteria?                        │
│                                                                  │
│    Generates: ~/auth-task.md (complete task document)           │
└──────────────────┬──────────────────────────────────────────────┘
                   │
                   ▼
┌─────────────────────────────────────────────────────────────────┐
│ 3. WORKFLOW MODULE                                              │
│    /workflow ~/auth-task.md                                     │
│                                                                  │
│    ┌────────────────┐                                           │
│    │ orchestrator   │ Parses task.md                            │
│    └────────────────┘ Enters plan mode                          │
│            │          Asks clarifying questions                 │
│            │          Waits for approval                         │
│            ▼                                                     │
│    ┌────────────────────────────────────────────┐               │
│    │ PHASE EXECUTION                            │               │
│    │                                            │               │
│    │  FOR EACH phase:                          │               │
│    │    FOR EACH task:                         │               │
│    │                                            │               │
│    │      ┌────────────┐                       │               │
│    │      │ supervisor │ Pre-check             │               │
│    │      └────────────┘ (conflicts?)          │               │
│    │            │                               │               │
│    │            ▼                               │               │
│    │      ┌──────────────┐                     │               │
│    │      │ task-        │ Ralph loop:         │               │
│    │      │ executor     │ Implement → Verify  │               │
│    │      └──────────────┘ → Review → Learn    │               │
│    │            │                               │               │
│    │            ▼                               │               │
│    │      ┌────────────┐                       │               │
│    │      │ supervisor │ Post-check            │               │
│    │      └────────────┘ (conflicts?)          │               │
│    │            │                               │               │
│    │            ▼                               │               │
│    │        Commit & checkpoint                │               │
│    │                                            │               │
│    └────────────────────────────────────────────┘               │
│            │                                                     │
│            ▼                                                     │
│    ┌────────────────┐                                           │
│    │ outer-ralph    │ Final quality pass:                       │
│    └────────────────┘ - Code quality                            │
│                       - Documentation                            │
│                       - Security                                 │
│                       - Test coverage                            │
│            │                                                     │
│            ▼                                                     │
│    Create milestone issues                                      │
│    Generate report                                              │
│    Create PR                                                    │
└──────────────────┬──────────────────────────────────────────────┘
                   │
                   ▼
┌─────────────────────────────────────────────────────────────────┐
│ 4. OUTPUT                                                        │
│    ✓ PR created: https://github.com/.../pull/123                │
│    ✓ All tests pass, coverage 92%                               │
│    ✓ 7 improvements applied by outer Ralph                      │
│    ✓ 3 phases, 6 tasks complete                                 │
└─────────────────────────────────────────────────────────────────┘
```

---

## Module Interactions

### Task Writer → Workflow

```
task-writer/
    └── task-refiner → Generates task.md
                            ↓
                       (hands off)
                            ↓
workflow/
    └── orchestrator → Reads task.md
                     → Executes workflow
```

### Workflow → Shared

```
workflow/
    ├── orchestrator → Uses shared/skills/milestone-issue
    ├── task-executor → Uses shared/skills/compact-checkpoint
    └── outer-ralph → Uses shared/agents/code-improvement-scanner
```

### All Modules → GPT Experts

```
task-writer/task-refiner → rules/delegator → Scope Analyst
workflow/orchestrator → rules/delegator → Architect
workflow/supervisor → rules/delegator → Security Analyst
workflow/task-executor → rules/delegator → Code Reviewer
workflow/outer-ralph → rules/delegator → Security Analyst
```

---

## Agent Communication

### State Files

```
.claude/
├── agent-state.json       # Workflow execution state
│   ├── orchestrator: {status, phase, task, ...}
│   ├── supervisor: {conflicts, interventions, ...}
│   ├── completed_tasks: [...]
│   ├── pending_tasks: [...]
│   └── learnings: [...]
│
├── learnings.jsonl        # Append-only learning log
├── locks.json             # File locking (parallel agents)
└── checkpoint.json        # Latest checkpoint
```

### Message Flow

```
orchestrator
    ├─→ supervisor (pre-check)
    │   └─→ verdict: PASS/AUTO_FIX/RE_PLAN
    ├─→ task-executor
    │   ├─→ parallel agents (if needed)
    │   └─→ result: success/failure
    ├─→ supervisor (post-check)
    │   └─→ verdict: PASS/AUTO_FIX/RE_PLAN
    └─→ outer-ralph
        └─→ improvements: [list]
```

---

## Decision Trees

### When to Use Task Writer

```
Do you have a complete task.md?
    │
    ├─ Yes → Use /workflow directly
    │
    └─ No → Need help?
        │
        ├─ No (experienced) → Copy template, fill manually
        │
        └─ Yes → Use /prepare-task
            │
            └─→ task-refiner asks questions
                └─→ Generates task.md
```

### Supervisor Decision Tree

```
Task completes
    │
    ▼
Supervisor checks
    │
    ├─ No conflicts → PASS
    │       └─→ Continue to next task
    │
    ├─ Minor issue (naming, style) → AUTO_FIX
    │       ├─→ Fix autonomously
    │       └─→ Continue
    │
    └─ Major conflict (architecture, API, security) → RE_PLAN
            ├─→ Pause workflow
            ├─→ Re-enter plan mode
            ├─→ Update plan
            └─→ Resume execution
```

### Ralph Loop Decision

```
Task executor starts
    │
    ▼
Iteration 1..N
    │
    ├─ Implement changes
    ├─ Verify success criteria
    ├─ Review (self or GPT)
    ├─ Learn from results
    │
    ▼
Success criteria met?
    │
    ├─ Yes → Exit loop (success)
    │       └─→ Commit
    │
    ├─ No, iteration < max → Continue loop
    │       └─→ Adjust approach, retry
    │
    └─ No, iteration >= max → Exit loop (failure)
            └─→ Escalate to user
```

---

## Key Design Patterns

### 1. Separation of Concerns

- **Task Writer**: Knows how to ask questions, doesn't execute
- **Workflow**: Knows how to execute, doesn't interview
- **Shared**: Reusable utilities, no assumptions about usage

### 2. Dependency Injection

- Agents specify what they need (tools, other agents)
- Orchestrator provides dependencies
- Loose coupling, easy to test

### 3. State Machine

```
orchestrator.status:
    planning → executing → reviewing → completed
                             ↓
                          (if error)
                             ↓
                          failed
```

### 4. Chain of Responsibility

```
orchestrator
    → supervisor (checks)
        → task-executor (executes)
            → parallel agents (specialize)
                → GPT experts (consult)
```

### 5. Command Pattern

Skills are commands:
- `/prepare-task <args>` → Invokes task-refiner
- `/workflow <args>` → Invokes orchestrator
- `/compact` → Invokes compaction
- `/milestone` → Invokes milestone creation

---

## Extension Points

### Adding New Module

```
new-module/
├── agents/
│   └── specialized-agent.md
├── skill.md                # /new-command
└── MODULE-GUIDE.md

# Can use shared/ utilities
# Can integrate with workflow/ and task-writer/
```

### Adding New Agent to Shared

```
shared/agents/
└── my-specialist.md        # Reusable by all modules
```

### Adding New GPT Expert

```
rules/delegator/
└── experts/
    └── my-expert-prompt.md # Available to all agents
```

---

## Performance Considerations

### Parallel Execution

```
task-executor can spawn multiple agents in parallel:
    ├─→ code-improver (file A)
    ├─→ test-runner (file B)
    └─→ security-auditor (file C)

File locks prevent conflicts:
    locks.json: {"fileA": "code-improver", ...}
```

### Context Management

```
Long workflows use compaction:
    1. Execute 5 tasks
    2. Compact context (/compact)
    3. Save checkpoint
    4. Continue with fresh context
```

### Cost Optimization

```
Safety bounds limit costs:
    - Max iterations per task (avoid infinite loops)
    - Max cost (budget for GPT experts)
    - Max time (prevent runaway execution)
```

---

## Security Considerations

### Input Validation

```
task-refiner validates:
    - Goal is clear
    - Success criteria testable
    - No command injection in task.md
```

### Supervisor Checks

```
supervisor scans for:
    - SQL injection patterns
    - XSS vulnerabilities
    - Hardcoded secrets
    - Missing auth checks
```

### Delegation Safety

```
GPT expert calls:
    - Stateless (no memory)
    - Sandboxed (read-only or workspace-write)
    - Cost-tracked
```

---

## Monitoring & Observability

### State Queries

```bash
# Check workflow status
jq '.orchestrator.status' .claude/agent-state.json

# Check supervisor interventions
jq '.supervisor.interventions[]' .claude/agent-state.json

# Check learnings
jq '.learnings[] | {task, lesson}' .claude/agent-state.json
```

### Logs

```
Each agent logs to:
    - agent-state.json (structured state)
    - learnings.jsonl (append-only learnings)
    - checkpoint.json (recovery points)
```

---

## Failure Modes & Recovery

### Task Executor Fails

```
task-executor fails after max iterations
    │
    ▼
orchestrator pauses
    │
    ├─→ Saves state
    ├─→ Reports to user
    └─→ Waits for decision
        │
        ├─ Retry (adjusted approach)
        ├─ Skip task
        └─ Abort workflow
```

### Supervisor Detects Conflict

```
supervisor detects major conflict
    │
    ▼
orchestrator pauses
    │
    ├─→ Saves state
    ├─→ Re-enters plan mode
    ├─→ Updates plan
    └─→ Resumes from paused point
```

### Safety Bound Exceeded

```
Cost/time limit reached
    │
    ▼
orchestrator pauses ALL agents
    │
    ├─→ Saves state
    ├─→ Reports progress
    └─→ Waits for approval to continue or abort
```

---

## Future Enhancements

### Planned

- [ ] Workflow templates (common patterns)
- [ ] Learning database (cross-workflow patterns)
- [ ] Parallel phase execution
- [ ] Automatic rollback on failure
- [ ] Metrics dashboard
- [ ] AI-generated task documents from NL

### Experimental

- [ ] Predictive supervisor (detect conflicts before they happen)
- [ ] Automatic task decomposition
- [ ] Self-healing workflows
- [ ] Workflow analytics and optimization
