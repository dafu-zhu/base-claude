# Base Claude - Workflow System

Comprehensive automation framework for Claude Code with plan mode, supervisor oversight, Ralph loops, and GPT expert integration.

---

## Quick Start

```bash
# 1. Create task document from template
cp templates/task-template.md ~/my-task.md

# 2. Fill in task details (see examples/)

# 3. Run workflow
/workflow ~/my-task.md
```

---

## Overview

The workflow system provides:
- **Plan mode** - Mandatory upfront question-gathering
- **Phase/task hierarchy** - Structured execution
- **Ralph loops** - Task-level improvement + outer quality pass
- **Supervisor oversight** - Conflict detection and resolution
- **Parallel agents** - Efficient multi-agent coordination
- **GPT experts** - Architecture, security, code review integration

---

## Repository Structure

```
base-claude/
├── agents/                    # Agent definitions
│   ├── orchestrator.md   # Top-level coordinator
│   ├── supervisor.md              # Conflict detection
│   ├── task-executor.md           # Single-task Ralph loop
│   ├── outer-ralph.md             # Whole-work quality improvement
│   └── ...                        # Other agents
├── templates/                 # Task document templates
│   ├── task-template.md   # Main template
│   └── ...
├── examples/                  # Example task documents
│   ├── simple-example.md   # Simple task (input validation)
│   ├── complex-example.md  # Complex task (multi-tenant SaaS)
│   └── ...
├── skills/                    # Invocable skills
│   ├── workflow.md        # Main workflow skill
│   ├── compact-checkpoint.md      # Context compaction
│   ├── milestone-issue.md         # Milestone tracking
│   └── ...
├── docs/                      # Documentation
│   ├── WORKFLOW-GUIDE.md          # Comprehensive user guide
│   ├── STATE-SCHEMA.md            # State management schema
│   └── ...
├── rules/                     # Delegator system (GPT experts)
│   └── ...
├── hooks/                     # Event hooks
│   └── ...
├── preferences.md             # Global behavioral preferences
├── settings.json              # Claude Code settings
└── README.md                  # This file
```

---

## Core Components

### Agents

| Agent | Role | Invoked By |
|-------|------|------------|
| **orchestrator** | Top-level coordinator for entire workflow | workflow skill |
| **supervisor** | Detects conflicts (architecture, dependencies, API) | Orchestrator (pre/post task) |
| **task-executor** | Executes single task with Ralph loop | Orchestrator (per task) |
| **outer-ralph** | Improves whole-work quality after phases complete | Orchestrator (at end) |

### Skills

| Skill | Command | Purpose |
|-------|---------|---------|
| **workflow** | `/workflow task-doc.md` | Execute complete workflow |
| **compact-checkpoint** | `/compact` | Compact context and checkpoint state |
| **milestone-issue** | (automatic) | Create GitHub milestone issues |

### Templates

- **task-template.md** - Comprehensive task document template with:
  - Goal, context, success criteria
  - Phases and tasks
  - Supervisor configuration
  - Outer Ralph configuration
  - Delegation strategy

### Examples

- **simple-example.md** - Input validation (1 phase, 2 tasks)
- **complex-example.md** - Multi-tenant SaaS platform (5 phases, 12 tasks)

---

## Workflow Phases

### 1. Plan Mode (Mandatory)
- Parse task document
- Explore codebase
- Identify ALL questions
- Ask user ALL questions upfront
- Wait for approval

### 2. Execution (Phase → Task → Ralph Loop)
```
FOR EACH phase:
  FOR EACH task:
    Supervisor pre-check → Task Ralph loop → Supervisor post-check → Commit
  Create phase milestone issue
```

### 3. Outer Ralph Loop (Final Quality Pass)
- Scan all changes
- Fix code quality, docs, security, tests
- Verify success criteria
- Generate report

### 4. Completion
- Push changes
- Create PR with comprehensive report
- Link milestone issues

---

## Supervisor System

**Pre-task checks**:
- Architecture violations
- Cross-task dependencies
- API contract changes

**Post-task checks**:
- Pattern consistency
- Security vulnerabilities
- Conflicts with pending tasks

**Actions**:
- **PASS** - Continue
- **AUTO_FIX** - Fix minor issues autonomously
- **RE_PLAN** - Major conflict detected, re-enter plan mode

---

## Ralph Loop Pattern

### Task-Level Ralph
```
Implement → Verify → Review → Learn → Retry (until success or max iterations)
```

### Outer Ralph
```
Scan all changes → Prioritize improvements → Fix → Verify → Commit
```

---

## GPT Expert Integration

Available experts via delegator system:
- **Architect** - System design, tradeoffs, complex debugging
- **Security Analyst** - Vulnerabilities, threat modeling, hardening
- **Code Reviewer** - Code quality, bugs, maintainability
- **Plan Reviewer** - Plan validation before execution
- **Scope Analyst** - Pre-planning, catching ambiguities

Configure in task document:
```markdown
## Delegation Strategy

### Proactive Delegations
**Architect**: [x] Consult before Phase 1
**Security Analyst**: [x] Review after Phase 2
**Code Reviewer**: [x] Review after each phase

### Reactive Delegations
- After 2+ failed iterations → Architect
- Security issue detected → Security Analyst
```

---

## State Management

**agent-state.json** - Single source of truth:
- Orchestrator status (planning/executing/reviewing/completed)
- Current phase and task
- Supervisor interventions
- Completed/pending tasks
- Safety bounds (cost, time, iterations)
- Learnings (patterns, antipatterns)

See `docs/STATE-SCHEMA.md` for full schema.

---

## Safety Bounds

Default limits (configurable in task document):
- **Max iterations per task**: 30
- **Max cost**: $10
- **Max time**: 2 hours

Workflow pauses and asks for approval if limits approached.

---

## Usage Examples

### Simple Task: Input Validation

```bash
# Use simple example as reference
cp examples/simple-example.md ~/input-validation.md

# Customize for your needs

# Run workflow
/workflow ~/input-validation.md
```

**Expected**:
- Plan mode: Ask about validation rules
- Phase 1, Task 1.1: Create validation middleware (1 iteration)
- Phase 1, Task 1.2: Apply to endpoints (2 iterations)
- Outer Ralph: Add docstrings (2 iterations)
- PR created

**Time**: ~30 minutes
**Cost**: ~$1

---

### Complex Task: Multi-Tenant SaaS

```bash
# Use complex example as reference
cp examples/complex-example.md ~/multi-tenant-saas.md

# Customize for your needs

# Run workflow
/workflow ~/multi-tenant-saas.md
```

**Expected**:
- Plan mode: Ask about multi-tenancy approach, analytics storage, etc.
- Delegate to Architect for schema design
- 5 phases, 12 tasks with supervisor oversight
- Multiple GPT expert consultations
- Outer Ralph with 15+ improvements
- PR created with comprehensive report

**Time**: ~6-8 hours (across sessions)
**Cost**: ~$15-20

---

## Documentation

- **WORKFLOW-GUIDE.md** - Comprehensive user guide (architecture, execution flow, troubleshooting, FAQ)
- **STATE-SCHEMA.md** - State management schema and query commands
- **preferences.md** - Global behavioral preferences and defaults

---

## Best Practices

✅ **Do**:
- Write clear, specific success criteria per task
- Break large tasks into smaller ones (< 2h each)
- Enable supervisor for multi-phase work
- Enable outer Ralph for quality-critical work
- Ask ALL questions upfront in plan mode
- Trust supervisor verdicts
- Learn from each Ralph iteration

❌ **Don't**:
- Skip plan mode "because it's simple"
- Make assumptions instead of asking
- Ignore supervisor warnings
- Skip outer Ralph to save time
- Continue past max iterations hoping for success
- Break functionality with improvements

---

## Migration Guide

**From deprecated skills**:

| Old | New |
|-----|-----|
| `/automated-workflow "task"` | Create task doc → `/workflow task.md` |
| `/ralph` | Create task doc → `/workflow task.md` |

**Benefits**:
- Supervisor oversight (catch conflicts early)
- Ralph loop per task + outer Ralph (quality assurance)
- GPT expert integration (better decisions)
- Comprehensive reporting and learning

---

## Troubleshooting

**Workflow stuck in plan mode**:
- Review plan, answer questions, approve explicitly

**Task executor fails repeatedly**:
- Supervisor should trigger re-plan after 2 failures
- Clarify success criteria, update plan

**Cost exceeded**:
- Review delegation strategy (reduce proactive delegations)
- Simplify approach (avoid over-engineering)
- Extend budget if justified

**Outer Ralph finds no improvements**:
- This is success! Code quality already high

See `docs/UNIFIED-WORKFLOW-GUIDE.md` for comprehensive troubleshooting.

---

## Installation

**Copy to global Claude directory**:

```bash
# Copy agents
cp agents/{orchestrator,supervisor,task-executor,outer-ralph}.md ~/.claude/agents/

# Copy templates
cp templates/task-template.md ~/.claude/templates/

# Copy examples
cp examples/{simple,complex}-example.md ~/.claude/examples/

# Copy skills
cp skills/workflow.md ~/.claude/skills/

# Copy documentation
cp docs/{STATE-SCHEMA,WORKFLOW-GUIDE}.md ~/.claude/

# Copy preferences
cp preferences.md ~/.claude/
```

**Or symlink**:

```bash
# Symlink entire directory (advanced)
ln -s /Users/zdf/Documents/GitHub/base-claude ~/.claude
```

---

## Contributing

Learnings recorded in `.claude/learnings.jsonl` feed future enhancements. Report issues or request features via GitHub issues.

---

## License

MIT

---

## Support

- **Documentation**: `docs/UNIFIED-WORKFLOW-GUIDE.md`
- **Examples**: `examples/`
- **FAQ**: See guide
- **Issues**: GitHub issues

---

**Happy Automating!** 🚀
