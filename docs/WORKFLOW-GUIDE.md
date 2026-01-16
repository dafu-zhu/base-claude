# Workflow Guide

**Version**: 1.0
**Last Updated**: 2026-01-15

---

## Table of Contents

1. [Overview](#overview)
2. [Quick Start](#quick-start)
3. [Architecture](#architecture)
4. [Task Document Format](#task-document-format)
5. [Execution Flow](#execution-flow)
6. [Supervisor System](#supervisor-system)
7. [Ralph Loop Pattern](#ralph-loop-pattern)
8. [State Management](#state-management)
9. [GPT Expert Integration](#gpt-expert-integration)
10. [Best Practices](#best-practices)
11. [Troubleshooting](#troubleshooting)
12. [Migration Guide](#migration-guide)

---

## Overview

The workflow system is a comprehensive automation framework that combines:
- **Plan mode** (mandatory upfront question-gathering)
- **Phase/task hierarchy** (structured execution)
- **Ralph loops** (task-level improvement cycles + outer quality pass)
- **Supervisor oversight** (conflict detection and resolution)
- **Parallel agent coordination** (efficient multi-agent execution)
- **GPT expert integration** (architecture, security, code review)

### What It Replaces

- ❌ `automated-workflow` skill (deprecated)
- ❌ `ralph` skill (deprecated)
- ✅ `workflow` skill (new, unified approach)

### Key Benefits

1. **Upfront planning**: Ask ALL questions before starting (no mid-execution surprises)
2. **Supervisor oversight**: Catch conflicts early (architecture, dependencies, API contracts)
3. **Quality assurance**: Ralph loop per task + outer Ralph for whole-work quality
4. **Expert consultation**: Automatic delegation to GPT experts for complex decisions
5. **Safety bounds**: Strict limits prevent runaway execution
6. **Comprehensive reporting**: Detailed metrics, learnings, milestone tracking

---

## Quick Start

### Step 1: Create Task Document

Use the template:

```bash
cp ~/.claude/templates/task-template.md ~/my-task.md
```

Fill in:
- Goal (one sentence)
- Context (current state, problem, constraints)
- Success criteria (global)
- Phases & tasks (with success criteria per task)
- Supervisor checks (enabled/disabled, frequency)
- Outer Ralph loop (enabled/disabled, success criteria)

See examples:
- Simple: `~/.claude/examples/simple-example.md`
- Complex: `~/.claude/examples/complex-example.md`

### Step 2: Run Workflow

```bash
/workflow ~/my-task.md
```

### Step 3: Monitor Progress

The system will:
1. Enter plan mode automatically
2. Ask ALL questions upfront (one interaction)
3. Wait for your approval
4. Execute phases → tasks → Ralph loops
5. Run supervisor checks (pre/post task)
6. Run outer Ralph loop at end
7. Create PR with comprehensive report

### Step 4: Review Results

Check:
- `.claude/agent-state.json` (execution state)
- `.claude/learnings.jsonl` (patterns discovered)
- Milestone issues (per phase)
- Final PR (with complete report)

---

## Architecture

### Component Hierarchy

```
User
  ↓
/workflow skill
  ↓
orchestrator agent (top-level coordinator)
  ↓
  ├─ FOR EACH phase:
  │   ├─ FOR EACH task:
  │   │   ├─ supervisor agent (pre-task check)
  │   │   ├─ task-executor agent (Ralph loop)
  │   │   │   ├─ Parallel agents (code-improver, test-runner, etc.)
  │   │   │   └─ GPT experts (architect, security-analyst, code-reviewer)
  │   │   └─ supervisor agent (post-task check)
  │   └─ milestone-issue skill (phase completion)
  └─ outer-ralph agent (final quality pass)
      └─ code-improvement-scanner agent
```

### Agent Descriptions

| Agent | Role | When Invoked |
|-------|------|--------------|
| **orchestrator** | Top-level coordinator | Once per workflow |
| **supervisor** | Conflict detection | Pre/post each task |
| **task-executor** | Single-task execution with Ralph loop | Once per task |
| **outer-ralph** | Whole-work quality improvement | Once at end |
| **code-improvement-scanner** | Code quality scan | By outer-ralph |

---

## Available Agents

The workflow system has access to 15 shared agents for specialized tasks. For complete details, see [AGENT-CATALOG.md](./AGENT-CATALOG.md).

### Agent Quick Reference

| Category | Agents | Use For |
|----------|--------|---------|
| **Quality** | `code-reviewer`, `code-improvement-scanner`, `debugger` | Code review, quality scans, bug diagnosis |
| **Infrastructure** | `build-engineer`, `dependency-manager`, `git-workflow-manager`, `cli-developer` | Build optimization, packages, git, CLI tools |
| **Architecture** | `architect-reviewer` | Design validation, tech decisions |
| **Documentation** | `documentation-engineer`, `api-documenter` | Technical docs, API specs |
| **Specialized** | `ai-engineer`, `fintech-engineer`, `quant-analyst`, `risk-manager` | AI/ML, financial systems, risk |
| **Research** | `research-analyst` | Information gathering, analysis |

### Spawning Agents

```typescript
Task({
  subagent_type: "code-reviewer",
  prompt: `Review changes in src/auth/ for security issues`,
  description: "Security review"
})
```

### Common Patterns

- **Code changes**: `code-reviewer` + `code-improvement-scanner`
- **Build updates**: `build-engineer` + `dependency-manager`
- **Documentation**: `documentation-engineer` + `api-documenter`
- **Financial features**: `fintech-engineer` + `quant-analyst` + `risk-manager`

---

## Task Document Format

### Required Sections

```markdown
# Unified Task: [Name]

## Goal
[One sentence outcome]

## Context
### Current State
[What exists now]

### Problem
[What needs solving]

### Constraints
[Limitations]

## Success Criteria (Global)
- [ ] All tests pass
- [ ] Linting clean
- [ ] Coverage >= 80%
[...]

## Safety Bounds
**Maximum iterations per task**: 30
**Maximum cost**: $10
**Maximum time**: 2 hours

## Phases & Tasks

### Phase 1: [Name]

#### Task 1.1: [Name]
**Description**: [What to do]
**Success Criteria**:
- [ ] [Criterion 1]
- [ ] [Criterion 2]
**Agents Needed**: [List or "None"]
**Complexity**: Simple | Medium | High
**Dependencies**: [Task IDs or "None"]

[...more tasks...]

## Supervisor Checks
**Enable Supervisor**: Yes | No
**Check Frequency**: Pre-task, Post-task, On-demand
**Check For**: Architecture, Dependencies, API, Security, Patterns
**Auto-Fix Minor Issues**: Yes | No

## Outer Ralph Loop
**Enable Outer Ralph**: Yes | No
**Success Criteria**:
- [ ] No code smells
- [ ] Documentation complete
- [ ] Consistent patterns
- [ ] Security best practices
[...]
```

### Optional Sections

- **Delegation Strategy**: Proactive/reactive GPT expert consultations
- **Verification Requirements**: Automated and manual checks
- **Rollback Plan**: What to do if task fails
- **Learning Objectives**: Patterns to discover, antipatterns to avoid

---

## Execution Flow

### Phase 1: Plan Mode (Mandatory)

```
Parse task document
  ↓
Enter plan mode (EnterPlanMode tool)
  ↓
Explore codebase
  ├─ Read relevant files
  ├─ Understand architecture
  ├─ Map dependencies
  └─ Identify integration points
  ↓
Analyze task document
  ├─ Identify unclear requirements
  ├─ Find technical decisions needed
  ├─ Detect potential conflicts
  └─ List ALL questions
  ↓
Ask user ALL questions in ONE interaction
  ├─ Use AskUserQuestion tool
  ├─ Group by category
  └─ Include options for each question
  ↓
Wait for user approval
  ↓
Exit plan mode (ExitPlanMode tool)
  ↓
Proceed to execution
```

**CRITICAL**: No execution starts until plan approved.

### Phase 2: Phase/Task Execution

```
FOR EACH phase in phases:
  ↓
  Initialize phase state
  ↓
  FOR EACH task in phase.tasks:
    ↓
    [SUPERVISOR PRE-CHECK]
    ├─ Check for conflicts
    └─ Conflict? → Re-plan → Resume
    ↓
    [TASK RALPH LOOP]
    ├─ Iteration 1..N:
    │   ├─ Implement changes
    │   ├─ Verify success criteria
    │   ├─ Review (self or GPT expert)
    │   ├─ Learn from results
    │   └─ Pass? → Exit : Adjust & retry
    └─ Success OR escalate to user
    ↓
    [SUPERVISOR POST-CHECK]
    ├─ Check changes
    └─ Conflict? → Fix → Continue
    ↓
    Commit changes
    Checkpoint
  ↓
  Create phase milestone issue
  ↓
Next phase
```

### Phase 3: Outer Ralph Loop

```
All phases complete
  ↓
Spawn outer-ralph agent
  ↓
Scan all changes
  ├─ Code quality (complexity, duplication)
  ├─ Documentation (docstrings, README)
  ├─ Security (vulnerabilities)
  ├─ Test coverage (gaps)
  └─ Pattern consistency (error handling, logging)
  ↓
Prioritize improvements (critical → high → medium → low)
  ↓
FOR EACH improvement:
  ├─ Implement fix
  ├─ Verify (tests pass, no breaks)
  ├─ Review (GPT expert if needed)
  └─ Commit atomically
  ↓
Verify outer Ralph success criteria
  ↓
Generate final quality report
```

### Phase 4: Completion

```
Push all changes
  ↓
Create PR
  ├─ Summary (phases, tasks, metrics)
  ├─ Milestone issue links
  ├─ Supervisor interventions
  ├─ Outer Ralph improvements
  └─ Learnings
  ↓
Return PR URL
```

---

## Supervisor System

### What Supervisor Checks

**Pre-task** (before task starts):
- Architecture violations (new patterns when existing ones available)
- Cross-task dependencies (task depends on incomplete task)
- API contract alignment (interfaces match expectations)

**Post-task** (after task completes):
- Pattern consistency (naming, imports, error handling)
- Security vulnerabilities (SQL injection, XSS, etc.)
- Conflicts with pending tasks (breaking changes)

**On-demand** (during task execution):
- Structural changes detected (architecture shifts)

### Supervisor Verdicts

| Verdict | Meaning | Action |
|---------|---------|--------|
| **PASS** | No conflicts | Continue execution |
| **AUTO_FIX** | Minor issues (style, naming) | Fix autonomously, continue |
| **RE_PLAN** | Major conflict (architecture, security) | Pause → re-enter plan mode → update plan → resume |

### Example: Architecture Violation

```
Task: 1.2 - Add authentication

Supervisor Pre-Check:
❌ CONFLICT - Architecture Violation
- Task plans custom JWT validation
- Existing auth middleware in src/auth/jwt.ts
- Recommendation: Use existing module

Action: RE_PLAN
1. Pause task executor
2. Re-enter plan mode
3. Update plan: "Extend src/auth/jwt.ts"
4. Resume execution
```

### Example: Pattern Inconsistency (Auto-Fix)

```
Task: 2.1 - Implement user CRUD

Supervisor Post-Check:
⚠️ MINOR ISSUE - Pattern Inconsistency
- Code uses snake_case (user_id)
- Codebase uses camelCase (userId)

Action: AUTO_FIX
1. Rename user_id → userId (5 occurrences)
2. Update tests
3. Commit: "chore(supervisor): fix naming conventions"
4. Continue
```

---

## Ralph Loop Pattern

### Task-Level Ralph Loop

Every task uses Ralph loop:

```
Iteration 1..N (max 30):
  ↓
  [IMPLEMENT]
  ├─ Analyze requirements
  ├─ Spawn parallel agents if needed
  └─ Make changes
  ↓
  [VERIFY]
  ├─ Check success criteria
  ├─ Run tests
  ├─ Run linting
  └─ Record pass/fail
  ↓
  [REVIEW]
  ├─ Self-review OR delegate to GPT expert
  └─ Identify improvements
  ↓
  [LEARN]
  ├─ What worked? → Pattern
  ├─ What failed? → Antipattern
  └─ Update strategy
  ↓
  [DECIDE]
  ├─ Success criteria met? → EXIT (success)
  ├─ Iteration < max? → CONTINUE
  └─ Iteration >= max? → EXIT (failure, escalate)
```

### Outer Ralph Loop

After all phases, outer Ralph improves whole work:

```
Iteration 1..N (max 10):
  ↓
  [SCAN]
  ├─ All files modified
  ├─ Code quality issues
  ├─ Documentation gaps
  ├─ Security vulnerabilities
  └─ Test coverage gaps
  ↓
  [PRIORITIZE]
  ├─ Critical (security)
  ├─ High (functionality, tests)
  ├─ Medium (quality, docs)
  └─ Low (style)
  ↓
  [IMPROVE]
  ├─ Implement fixes
  ├─ Verify (tests pass)
  ├─ Review (GPT expert)
  └─ Commit atomically
  ↓
  [VERIFY]
  ├─ Outer Ralph success criteria met? → EXIT
  └─ Continue improving
```

---

## State Management

### agent-state.json

Single source of truth for workflow state.

**Key fields**:
- `orchestrator.status`: planning | executing | reviewing | completed
- `orchestrator.current_phase`: Phase number (0-indexed)
- `orchestrator.current_task`: Task progress (e.g., "3/5")
- `supervisor.interventions`: List of conflicts and resolutions
- `completed_tasks`: Tasks done (iterations, time, cost, files)
- `pending_tasks`: Tasks remaining
- `safety_bounds`: Cost/time tracking
- `learnings`: Patterns discovered

See full schema: `~/.claude/STATE-SCHEMA.md`

### Querying State

```bash
# Check status
jq '.orchestrator.status' .claude/agent-state.json

# Check progress
jq '{phase: .orchestrator.current_phase, task: .orchestrator.current_task}' .claude/agent-state.json

# Check cost and time
jq '.safety_bounds | {cost: .cost_so_far, time: .elapsed_time}' .claude/agent-state.json

# List supervisor interventions
jq '.supervisor.interventions[]' .claude/agent-state.json

# List learnings
jq '.learnings[] | {task, type, lesson}' .claude/agent-state.json
```

---

## GPT Expert Integration

### Available Experts

| Expert | Use For | Mode |
|--------|---------|------|
| **Architect** | System design, tradeoffs, complex debugging | Advisory or Implementation |
| **Security Analyst** | Vulnerabilities, threat modeling, hardening | Advisory or Implementation |
| **Code Reviewer** | Code quality, bugs, maintainability | Advisory or Implementation |
| **Plan Reviewer** | Plan validation before execution | Advisory |
| **Scope Analyst** | Pre-planning, catching ambiguities | Advisory |

### Proactive Delegation

Configure in task document:

```markdown
## Delegation Strategy

### Proactive Delegations

**Architect**:
- [x] Consult before Phase 1 (architecture design)
- [x] Review after Phase 3 (architecture validation)

**Security Analyst**:
- [x] Review after Phase 2 (auth implementation)
- [x] Final audit after all phases

**Code Reviewer**:
- [x] Review after each phase
```

### Reactive Delegation

Automatic based on signals:
- After 2+ failed task iterations → Architect
- Security issue detected → Security Analyst
- Complex design decision → Architect
- Code quality concerns → Code Reviewer

### Delegation Cost

GPT expert consultations incur API costs (~$0.20-$1.00 per call). Track in `safety_bounds.cost_so_far`.

---

## Best Practices

### 1. Task Document Design

✅ **Do**:
- Write clear, specific success criteria per task
- Break large tasks into smaller ones (< 2h each)
- Specify agents needed for complex tasks
- Enable supervisor for multi-phase work
- Enable outer Ralph for quality-critical work

❌ **Don't**:
- Vague success criteria ("make it better")
- Massive tasks (> 4h)
- Skip supervisor (even for "simple" tasks)
- Skip outer Ralph to save time

### 2. Plan Mode

✅ **Do**:
- Ask ALL questions upfront (one interaction)
- Explore codebase thoroughly before asking
- Present options to user (not just yes/no)
- Wait for explicit approval

❌ **Don't**:
- Skip plan mode "because it's simple"
- Make assumptions instead of asking
- Ask questions in multiple rounds
- Proceed without approval

### 3. Supervisor Usage

✅ **Do**:
- Trust supervisor verdicts
- Re-plan when major conflict detected
- Let supervisor auto-fix minor issues
- Record interventions for learning

❌ **Don't**:
- Ignore supervisor warnings
- Retry without re-planning after conflict
- Disable supervisor to save time
- Override supervisor without good reason

### 4. Ralph Loops

✅ **Do**:
- Learn from each iteration
- Apply patterns to similar tasks
- Verify success criteria rigorously
- Fail gracefully after max iterations

❌ **Don't**:
- Skip verification to save time
- Continue past max iterations hoping for success
- Ignore learnings from failures
- Give up before max iterations

### 5. Outer Ralph

✅ **Do**:
- Prioritize critical issues (security, functionality)
- Verify tests pass after each fix
- Delegate to GPT expert for complex issues
- Skip low-impact improvements if time-constrained

❌ **Don't**:
- Fix everything (even trivial)
- Break functionality with improvements
- Skip final verification
- Commit all fixes in one giant commit

---

## Troubleshooting

### Issue: Workflow stuck in plan mode

**Symptoms**: Orchestrator waiting indefinitely

**Causes**:
- User hasn't approved plan
- AskUserQuestion timeout

**Fix**:
1. Review plan in conversation
2. Answer questions
3. Explicitly approve: "Approved, proceed"

---

### Issue: Task executor fails repeatedly

**Symptoms**: Same task fails 5+ iterations

**Causes**:
- Unclear success criteria
- Missing dependencies
- Impossible requirement

**Fix**:
1. Supervisor should trigger re-plan after 2 failures
2. If not, manually re-enter plan mode
3. Clarify success criteria
4. Update plan
5. Resume

---

### Issue: Supervisor triggers excessive re-plans

**Symptoms**: 5+ re-plans in one workflow

**Causes**:
- Fundamental architecture mismatch
- Task dependencies out of order
- Unclear requirements

**Fix**:
1. Delegate to Architect (GPT) for design review
2. Major plan revision (consider scrapping and restarting)
3. Break task into smaller, independent tasks

---

### Issue: Cost exceeded before completion

**Symptoms**: Hit max_cost with tasks remaining

**Causes**:
- Too many GPT delegations
- Complex tasks requiring many iterations
- Inefficient approach

**Fix**:
1. Review delegation strategy (reduce proactive delegations)
2. Simplify approach (avoid over-engineering)
3. Extend budget if work is critical
4. Pause and complete manually

---

### Issue: Outer Ralph finds no improvements

**Symptoms**: Outer Ralph reports "no issues found"

**Causes**:
- Code quality already high (good!)
- Task-level reviews very thorough

**Fix**:
- This is success, not failure
- Review final report to confirm
- Proceed to PR creation

---

## Migration Guide

### From `automated-workflow` Skill

**Old**:
```bash
/automated-workflow "Implement user auth"
```

**New**:
```bash
# 1. Create task document
cp ~/.claude/templates/task-template.md ~/user-auth-task.md

# 2. Fill in task document
# - Goal: Implement user authentication
# - Phases, tasks, success criteria

# 3. Run workflow
/workflow ~/user-auth-task.md
```

**Benefits**:
- Supervisor oversight (catch conflicts)
- Ralph loop per task (quality improvement)
- Outer Ralph (final quality pass)
- GPT expert integration (better decisions)

---

### From `ralph` Skill

**Old**:
```bash
/ralph
```

**New**:
```bash
# Ralph loop now automatic in workflow
# - Task-level Ralph: Every task
# - Outer Ralph: After all phases

# Create task document specifying what to improve
/workflow ~/improvement-task.md
```

**Benefits**:
- Structured task definition
- Supervisor conflict detection
- Safety bounds enforcement
- Comprehensive reporting

---

### From Manual Workflow

**Old**:
1. User gives requirements
2. You ask questions over multiple rounds
3. Implement
4. User finds issues mid-implementation
5. Re-implement
6. Repeat

**New**:
1. User creates task document (or you help)
2. `/workflow task.md`
3. System asks ALL questions upfront
4. User approves plan
5. System executes with supervisor oversight
6. Outer Ralph ensures quality
7. Done

**Benefits**:
- No mid-execution surprises
- Structured execution (phases, tasks)
- Automatic quality assurance
- Comprehensive reporting and learning

---

## Advanced Topics

### Custom Agents

Add task-specific agents to `agents_needed`:

```markdown
**Agents Needed**:
- `my-custom-validator` (validates domain-specific rules)
- `performance-benchmarker` (runs load tests)
```

Create agent file: `~/.claude/agents/my-custom-validator.md`

### Custom Success Criteria

Go beyond standard criteria:

```markdown
**Success Criteria**:
- [ ] Tests pass
- [ ] Performance: API p95 < 200ms (benchmark required)
- [ ] Accessibility: WCAG 2.1 AA compliant (audit required)
- [ ] Documentation: All functions have examples
```

### Nested Workflows

Run workflow within workflow:

```markdown
**Task 2.1**: Implement payment processing

**Agents Needed**:
- `orchestrator` (run sub-workflow for Stripe integration)

**Sub-task document**: `~/payment-stripe-task.md`
```

### Parallel Phase Execution

(Experimental - not yet implemented)

```markdown
## Phases (Parallel)

### Phase 1: Frontend (can run in parallel with Phase 2)
[...]

### Phase 2: Backend (can run in parallel with Phase 1)
[...]
```

---

## Resources

**Templates**:
- Task document: `~/.claude/templates/task-template.md`

**Examples**:
- Simple: `~/.claude/examples/simple-example.md`
- Complex: `~/.claude/examples/complex-example.md`

**Documentation**:
- State schema: `~/.claude/STATE-SCHEMA.md`

**Agents**:
- `~/.claude/agents/orchestrator.md`
- `~/.claude/agents/supervisor.md`
- `~/.claude/agents/task-executor.md`
- `~/.claude/agents/outer-ralph.md`

**Skills**:
- `~/.claude/skills/workflow.md`
- `~/.claude/skills/compact-checkpoint.md`
- `~/.claude/skills/milestone-issue.md`

---

## FAQ

**Q: Do I need to use workflow for simple tasks?**
A: No. For trivial tasks (typo fix, single-line change), use direct implementation. For anything complex (3+ steps, multi-file), use workflow.

**Q: Can I disable supervisor?**
A: Yes, set `Enable Supervisor: No` in task document. Not recommended except for very simple tasks.

**Q: Can I skip plan mode?**
A: No. Plan mode is mandatory. It prevents mid-execution surprises.

**Q: How much do GPT delegations cost?**
A: ~$0.20-$1.00 per call. Track in `safety_bounds.cost_so_far`. Set `max_cost` to limit.

**Q: What if task fails after max iterations?**
A: Orchestrator escalates to user with options: retry (adjusted approach), skip task, abort workflow, manual intervention.

**Q: Can I resume paused workflow?**
A: Yes. State saved in `.claude/agent-state.json`. Restart from checkpoint.

**Q: What if I need to change plan mid-execution?**
A: Supervisor will detect conflicts and trigger re-plan automatically. Or manually re-enter plan mode.

**Q: How long does workflow take?**
A: Depends on task complexity. Simple (1-2 tasks): 30m-1h. Complex (10+ tasks): 4-8h across multiple sessions.

---

## Support

**Issues**: Report bugs or request features in GitHub issues
**Questions**: Check FAQ first, then ask in conversations
**Improvements**: Learnings recorded in `.claude/learnings.jsonl` feed future enhancements

---

**Happy Automating!** 🚀
