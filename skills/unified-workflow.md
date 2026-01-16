# Unified Workflow Skill

**Name**: `unified-workflow`
**Invocation**: `/unified-workflow <task-doc-path>`
**Purpose**: Execute comprehensive automated workflow with plan mode, phase/task hierarchy, Ralph loops, supervisor oversight, and outer Ralph quality pass

---

## Overview

The unified workflow skill replaces and unifies:
- `automated-workflow` (deprecated)
- `ralph` (deprecated)

It provides a complete end-to-end workflow system that:
1. Enters plan mode and asks ALL questions upfront
2. Executes phases → tasks → Ralph-loop hierarchy
3. Monitors for conflicts with supervisor agent
4. Coordinates parallel agents per task
5. Runs outer Ralph loop for final quality pass
6. Creates PR with comprehensive report

---

## Usage

```bash
# Basic usage
/unified-workflow path/to/task-doc.md

# With custom state file (advanced)
/unified-workflow path/to/task-doc.md --state=custom-state.json
```

---

## Prerequisites

**Required files**:
- Task document (see template: `~/.claude/templates/unified-task-template.md`)

**Required agents**:
- `~/.claude/agents/unified-orchestrator.md`
- `~/.claude/agents/supervisor.md`
- `~/.claude/agents/task-executor.md`
- `~/.claude/agents/outer-ralph.md`

**Optional agents** (invoked by task executor as needed):
- `~/.claude/agents/code-improvement-scanner.md`

**Required skills**:
- `~/.claude/skills/compact-checkpoint.md` (context compaction)
- `~/.claude/skills/milestone-issue.md` (phase milestones)

**State files** (auto-created):
- `.claude/agent-state.json` (orchestrator state)
- `.claude/learnings.jsonl` (append-only learning log)
- `.claude/locks.json` (file locking for parallel agents)
- `.claude/checkpoint.json` (checkpoints)

---

## Workflow Phases

### Phase 1: Plan Mode (Mandatory Upfront)

```
Parse task document
  ↓
Validate structure
  ↓
Enter plan mode (EnterPlanMode tool)
  ↓
Explore codebase
  ↓
Identify ALL unclear requirements
  ↓
Ask ALL questions in ONE interaction (AskUserQuestion tool)
  ↓
Wait for user approval
  ↓
Exit plan mode (ExitPlanMode tool)
  ↓
Proceed to execution
```

**CRITICAL**: No execution starts until user approves plan.

### Phase 2: Execution (Phase → Task → Ralph-Loop)

```
FOR EACH phase in task_doc.phases:
  ↓
  FOR EACH task in phase.tasks:
    ↓
    [Supervisor Pre-Check]
    ├─ Spawn supervisor agent
    ├─ Check for conflicts
    └─ IF conflict: Re-plan → Resume
    ↓
    [Task Ralph Loop]
    ├─ Spawn task-executor agent
    ├─ Implement → Verify → Review → Learn → Retry
    ├─ Enforce safety bounds (max iterations, cost, time)
    └─ Success OR escalate to user
    ↓
    [Supervisor Post-Check]
    ├─ Spawn supervisor agent
    └─ IF conflict: Re-plan → Fix → Continue
    ↓
    Commit changes
    Checkpoint
  ↓
  Create phase milestone issue
  ↓
Next phase
```

### Phase 3: Outer Ralph Loop (Final Quality Pass)

```
All phases complete
  ↓
Spawn outer-ralph agent
  ↓
Scan all changes
  ↓
Apply improvements (code quality, docs, security, tests)
  ↓
Verify success criteria
  ↓
Generate final report
```

### Phase 4: Completion

```
Push all changes
  ↓
Create PR
  ├─ Summary of phases and tasks
  ├─ Links to milestone issues
  ├─ Metrics (iterations, cost, time)
  └─ Outer Ralph improvements
  ↓
Return PR URL
```

---

## Invocation Flow

**When user runs `/unified-workflow task-doc.md`**:

```typescript
// 1. Read and validate task document
const taskDoc = Read({ file_path: taskDocPath })
validateTaskDoc(taskDoc)

// 2. Initialize state
initializeState({
  orchestrator: {
    status: "planning",
    task_doc: taskDocPath,
    current_phase: 0,
    total_phases: taskDoc.phases.length,
    // ...
  }
})

// 3. Spawn unified-orchestrator agent
Task({
  subagent_type: "unified-orchestrator",
  prompt: `
TASK: Execute unified workflow for: ${taskDoc.goal}

TASK DOCUMENT: ${taskDocPath}

INSTRUCTIONS:
1. MUST enter plan mode first
2. Ask ALL questions upfront
3. Wait for user approval
4. Execute phases → tasks → ralph-loop
5. Supervisor checks mandatory (pre/post task)
6. Outer Ralph loop mandatory at end
7. Create PR when complete

CONTEXT:
- Task document: ${taskDoc}
- Safety bounds: ${taskDoc.safety_bounds}
- Global success criteria: ${taskDoc.success_criteria}
  `,
  description: `Unified workflow: ${taskDoc.goal}`
})

// 4. Monitor execution
// (orchestrator handles all sub-agent spawning)

// 5. Return result
```

---

## State Management

### agent-state.json Schema

```json
{
  "orchestrator": {
    "status": "planning|executing|reviewing|completed",
    "task_doc": "/path/to/task-doc.md",
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
    "conflicts_detected": 3,
    "auto_fixes_applied": 7,
    "re_plans_triggered": 2,
    "last_check": "2026-01-15T12:30:00Z",
    "interventions": [
      {
        "timestamp": "2026-01-15T12:15:00Z",
        "task": "1.2",
        "conflict_type": "architecture",
        "severity": "high",
        "action": "re_plan",
        "resolution": "Updated plan to use existing auth module"
      }
    ]
  },
  "active_agents": [
    {
      "type": "task-executor",
      "task": "2.1",
      "started": "2026-01-15T12:30:00Z",
      "iteration": 2
    }
  ],
  "completed_tasks": [
    {
      "task": "1.1",
      "completed": "2026-01-15T12:10:00Z",
      "iterations": 1,
      "files_modified": ["src/db/schema.sql"]
    }
  ],
  "pending_tasks": [
    {"phase": 2, "task": "2.1", "name": "Implement user CRUD"}
  ],
  "safety_bounds": {
    "max_iterations_per_task": 30,
    "max_cost": "$10",
    "max_time": "2h",
    "cost_so_far": "$2.50",
    "elapsed_time": "0h 30m"
  },
  "learnings": [
    {
      "timestamp": "2026-01-15T12:15:00Z",
      "task": "1.2",
      "lesson": "Always check for existing patterns before implementing",
      "pattern": "Reuse existing modules"
    }
  ]
}
```

### State Queries

**Check status**:
```bash
cat .claude/agent-state.json | jq '.orchestrator.status'
# Output: "executing"
```

**Check current progress**:
```bash
cat .claude/agent-state.json | jq '{phase: .orchestrator.current_phase, task: .orchestrator.current_task, cost: .safety_bounds.cost_so_far}'
# Output: {"phase": 2, "task": "3/5", "cost": "$2.50"}
```

**Check supervisor interventions**:
```bash
cat .claude/agent-state.json | jq '.supervisor.interventions'
```

---

## Safety Bounds Enforcement

**Per-task limits** (enforced by task-executor):
- `max_iterations_per_task`: 30 (default)
- `max_cost`: From task doc
- `max_time`: From task doc

**Global limits** (enforced by orchestrator):
- Total cost across all tasks
- Total time across all phases

**On limit exceeded**:
```
Pause workflow
  ↓
Save state
  ↓
Report to user:
  ├─ Which limit exceeded
  ├─ Current progress (phases, tasks completed)
  ├─ Cost/time so far
  └─ Options: Continue (extend limits) or Abort
  ↓
Wait for user decision
```

---

## Supervisor Integration

**When supervisor runs**:
- Pre-task: Before each task starts
- Post-task: After each task completes
- On-demand: If structural changes detected during execution

**Supervisor actions**:
- **PASS**: Continue execution
- **AUTO_FIX**: Minor issues fixed autonomously (naming, style)
- **RE_PLAN**: Major conflict detected → pause → re-enter plan mode → update plan → resume

**Conflict types**:
- Architecture violations (new patterns when existing ones available)
- Cross-task dependencies (task depends on incomplete task)
- API contract changes (breaking interface changes)
- Security vulnerabilities (SQL injection, XSS, etc.)
- Pattern inconsistencies (naming, imports, error handling)

---

## Outer Ralph Loop

**When it runs**: After all phases complete

**What it does**:
1. Scan all changes from entire workflow
2. Identify improvements:
   - Code quality (complexity, duplication)
   - Documentation (missing docstrings, README updates)
   - Security (vulnerabilities, best practices)
   - Test coverage (uncovered critical paths)
   - Pattern consistency (error handling, logging)
3. Apply improvements (iterate until success criteria met)
4. Verify all global success criteria
5. Generate final quality report

**Success criteria**:
- No code smells (from task doc)
- Documentation complete
- Consistent patterns
- Security best practices
- Test coverage >= target

---

## Compaction & Checkpoints

**Compaction triggers** (use `compact-checkpoint` skill):
- After each phase completion
- Every 5 tasks completed
- When context exceeds 100k tokens
- Before supervisor re-planning
- Before outer Ralph loop

**Checkpoints**:
- After each task completion
- After each phase completion
- Before/after supervisor interventions

**Checkpoint data**:
```json
{
  "timestamp": "2026-01-15T12:30:00Z",
  "phase": 2,
  "task": "2.1",
  "git_sha": "abc123...",
  "state": {...},
  "learnings": [...]
}
```

---

## Reporting

### Progress Updates

**After each task**:
```
[Phase 2/4] Task 2.1/3 complete: Implement user CRUD
├─ Iterations: 3
├─ Files modified: 5
├─ Time: 12m 34s
├─ Cost: $0.45
└─ Success criteria: ✅ All met
```

**After each phase**:
```
Phase 2 complete: Core Features
├─ Tasks completed: 3/3
├─ Supervisor interventions: 1 (auto-fix)
├─ Total time: 45m
├─ Total cost: $1.20
└─ Milestone issue: [URL]
```

### Final Report

```markdown
# Unified Workflow Complete: [Task Name]

## Summary
- Total phases: 4
- Total tasks: 12
- Tasks completed: 12
- Tasks skipped: 0
- Total time: 2h 15m
- Total cost: $8.50

## Phase Breakdown
- Phase 1: Foundation (3 tasks, 30m, $1.50)
- Phase 2: Core Features (3 tasks, 45m, $2.00)
- Phase 3: Integration (4 tasks, 35m, $3.00)
- Phase 4: Testing (2 tasks, 25m, $2.00)

## Supervisor Activity
- Checks performed: 24 (12 pre-task, 12 post-task)
- Conflicts detected: 3
- Auto-fixes applied: 7
- Re-plans triggered: 2

Interventions:
1. Task 1.2 - Architecture violation - Re-planned to use existing auth
2. Task 2.2 - API contract change - Updated dependent tasks
3. Task 3.1 - Cross-task dependency - Reordered execution

## Outer Ralph Improvements
- Iterations: 5/10
- Improvements applied: 21
- Improvements skipped: 2 (low impact)

Categories:
- Code quality: 5 (reduced complexity, removed duplication)
- Documentation: 10 (docstrings, README, API docs)
- Security: 2 (SQL injection fix, XSS fix)
- Test coverage: 3 (edge cases, integration tests)
- Pattern consistency: 1 (error handling standardization)

Metrics:
- Complexity: 8.2 → 4.5 (↓45%)
- Coverage: 78% → 92% (↑14%)
- Vulnerabilities: 2 → 0 (↓100%)

## Files Modified
- Total: 45 files
- New: 12
- Modified: 33
- Deleted: 0

## Pull Request
[PR #123: Implement user management system](https://github.com/...)

## Milestone Issues
- [Phase 1: Foundation](https://github.com/.../issues/1)
- [Phase 2: Core Features](https://github.com/.../issues/2)
- [Phase 3: Integration](https://github.com/.../issues/3)
- [Phase 4: Testing](https://github.com/.../issues/4)

## Learnings
- Total learnings recorded: 15
- Patterns discovered: 8
- Antipatterns avoided: 7

Top patterns:
1. Reuse existing modules before implementing new ones
2. Parameterized queries prevent SQL injection
3. Repository pattern for database access

## Success Criteria Verification
✅ All tests pass
✅ Linting clean
✅ Test coverage >= 80% (achieved 92%)
✅ Security scan clean
✅ Documentation updated
✅ All phases complete
✅ PR created
```

---

## Error Handling

### Task Failure

**When task executor fails after max iterations**:
```
Orchestrator receives failure report
  ↓
Pause workflow
  ↓
Present options to user:
  ├─ Retry with adjusted approach
  ├─ Skip task and continue
  ├─ Abort workflow
  └─ Manual intervention required
  ↓
Wait for user decision
  ↓
Resume or abort based on decision
```

### Supervisor Conflict

**When supervisor detects major conflict**:
```
Orchestrator receives RE_PLAN verdict
  ↓
Pause current task executor
  ↓
Save current state
  ↓
Re-enter plan mode
  ↓
Present conflict details to user
  ↓
Propose plan updates
  ↓
Ask for user approval
  ↓
Update plan
  ↓
Resume execution from paused task
```

### Safety Bound Exceeded

**When cost/time limit reached**:
```
Orchestrator pauses all agents
  ↓
Save state
  ↓
Report to user:
  ├─ Bound exceeded (cost or time)
  ├─ Progress: X/Y phases, A/B tasks complete
  ├─ Work completed so far
  └─ Options: Continue (extend bounds) or Abort
  ↓
Wait for user decision
  ↓
Update bounds and resume OR abort
```

---

## Examples

### Example 1: Simple Task (Input Validation)

```bash
/unified-workflow ~/.claude/examples/unified-simple-example.md
```

**Expected flow**:
1. Plan mode: Ask about validation rules, error format
2. Phase 1, Task 1.1: Create validation middleware (1 iteration)
3. Phase 1, Task 1.2: Apply to endpoints (2 iterations, tests fail → fix → pass)
4. Outer Ralph: Add docstrings, improve error messages (2 iterations)
5. PR created

**Time**: ~30 minutes
**Cost**: ~$1

### Example 2: Complex Task (Multi-Tenant SaaS)

```bash
/unified-workflow ~/.claude/examples/unified-complex-example.md
```

**Expected flow**:
1. Plan mode: Ask about multi-tenancy approach, analytics storage, webhook retry strategy
2. Delegate to Architect (GPT): Review multi-tenant schema design
3. Phase 1: Multi-tenant foundation (3 tasks, supervisor intervenes on audit logging)
4. Phase 2: Subscription & billing (2 tasks, delegate to Security Analyst for Stripe review)
5. Phase 3: Analytics (3 tasks, supervisor intervenes on query performance, delegate to Architect)
6. Phase 4: Webhooks (3 tasks, supervisor intervenes on security, delegate to Security Analyst)
7. Phase 5: Performance testing (2 tasks, delegate to Architect for optimization)
8. Outer Ralph: Security hardening, documentation, test coverage (15 iterations)
9. PR created

**Time**: ~6-8 hours (across multiple sessions)
**Cost**: ~$15-20 (including GPT delegations)

---

## Best Practices

1. **ALWAYS enter plan mode first** - No exceptions, even for "simple" tasks
2. **Ask ALL questions upfront** - One AskUserQuestion call with all questions
3. **Trust the supervisor** - If conflict detected, re-plan without hesitation
4. **Enforce safety bounds** - Pause and ask if limits approached
5. **Checkpoint frequently** - After each phase, every 5 tasks
6. **Compact context** - Use compact-checkpoint skill when context grows
7. **Run outer Ralph** - Mandatory final quality pass, never skip
8. **Track learnings** - Every task, every iteration
9. **Report progress** - Concise updates after each task/phase
10. **Create atomic commits** - One commit per task completion

---

## Anti-Patterns to Avoid

- ❌ Skipping plan mode "because task is simple"
- ❌ Ignoring supervisor conflicts
- ❌ Exceeding safety bounds without user approval
- ❌ Batch committing multiple tasks
- ❌ Skipping outer Ralph to save time
- ❌ Not updating state after changes
- ❌ Continuing after repeated failures
- ❌ Making assumptions instead of asking questions
- ❌ Not recording learnings
- ❌ Showing raw agent output (always synthesize)

---

## Troubleshooting

**Issue**: Workflow stuck in plan mode
- **Cause**: User hasn't approved plan
- **Fix**: Review plan, answer questions, approve

**Issue**: Task executor fails repeatedly
- **Cause**: Unclear success criteria or missing dependencies
- **Fix**: Re-enter plan mode, clarify requirements, update plan

**Issue**: Supervisor keeps triggering re-plans
- **Cause**: Fundamental architecture mismatch
- **Fix**: Delegate to Architect (GPT) for design review, major plan revision

**Issue**: Outer Ralph not finding improvements
- **Cause**: Code quality already high from task-level reviews
- **Fix**: This is success! Outer Ralph will report "no issues found"

**Issue**: Cost exceeded before completion
- **Cause**: Too many GPT delegations or complex tasks
- **Fix**: Review delegation strategy, consider simpler approaches, extend budget if justified

---

## Comparison with Deprecated Skills

| Feature | Old (automated-workflow) | Old (ralph) | New (unified-workflow) |
|---------|-------------------------|-------------|------------------------|
| Plan mode upfront | Optional | No | Mandatory |
| Phase/task hierarchy | Yes | No | Yes |
| Ralph loop per task | No | Yes (whole-work) | Yes (per task + outer) |
| Supervisor checks | No | No | Yes |
| Parallel agents | No | Limited | Yes |
| Outer Ralph loop | No | Yes | Yes |
| GPT delegation | No | No | Yes (integrated) |
| State management | Basic | None | Comprehensive |
| Checkpointing | Yes | No | Yes |
| Safety bounds | Basic | No | Strict |

---

## Migration from Deprecated Skills

**If you used `/automated-workflow` before**:
- Now use: `/unified-workflow task-doc.md`
- Benefits: Supervisor oversight, Ralph loops per task, outer Ralph, GPT integration

**If you used `/ralph` before**:
- Now use: `/unified-workflow task-doc.md`
- Benefits: Phase/task structure, plan mode, supervisor, safety bounds

**Task document required**:
- Old skills used simple prompts
- New skill requires structured task document (use template)
- Benefits: Clear success criteria, agent coordination, delegation strategy

---

## Dependencies

**Required**:
- Agents: unified-orchestrator, supervisor, task-executor, outer-ralph
- Skills: compact-checkpoint, milestone-issue
- Tools: TodoWrite, Bash, Read/Write/Edit, Task, AskUserQuestion, EnterPlanMode/ExitPlanMode

**Optional**:
- Agents: code-improvement-scanner
- Delegator: GPT experts via Codex MCP (architect, code-reviewer, security-analyst, etc.)
- GitHub: PR creation, milestone issues

---

## Future Enhancements

**Planned**:
- [ ] Cost estimation before execution
- [ ] Parallel phase execution (if tasks independent)
- [ ] Automatic rollback on critical failure
- [ ] Learning database for cross-workflow patterns
- [ ] Metrics dashboard for workflow analytics

**Experimental**:
- [ ] AI-generated task documents from natural language descriptions
- [ ] Automatic task decomposition (break large tasks into smaller ones)
- [ ] Predictive supervisor (detect conflicts before they happen)
