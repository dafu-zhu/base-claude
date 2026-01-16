# Base Claude

Modular automation system for Claude Code with task writing, workflow execution, and shared utilities.

---

## Quick Start

### 1. Create Task Document

```bash
# Interactive task creation (recommended)
/prepare-task "Add user authentication to the API"

# Or copy template manually
cp workflow/task-template.md ~/my-task.md
```

### 2. Run Workflow

```bash
/workflow ~/my-task.md
```

---

## Architecture

This repository is organized into three modules:

```
base-claude/
├── task-writer/       # Module 1: Task document creation
│   ├── agents/
│   │   └── task-refiner.md
│   └── skill.md (/prepare-task)
│
├── workflow/          # Module 2: Workflow execution
│   ├── agents/
│   │   ├── orchestrator.md
│   │   ├── supervisor.md
│   │   ├── task-executor.md
│   │   └── outer-ralph.md
│   ├── examples/
│   │   ├── simple-example.md
│   │   └── complex-example.md
│   ├── task-template.md
│   ├── skill.md (/workflow)
│   └── WORKFLOW-GUIDE.md
│
├── shared/            # Module 3: Shared utilities
│   ├── agents/        # General-purpose agents
│   │   ├── code-improvement-scanner.md
│   │   ├── ai-engineer.md
│   │   └── ... (15+ agents)
│   ├── skills/        # General-purpose skills
│   │   ├── compact-checkpoint.md
│   │   └── milestone-issue.md
│   └── hooks/         # Event hooks
│       ├── check-milestone.sh
│       └── format-python.sh
│
├── docs/              # Documentation
│   ├── STATE-SCHEMA.md
│   ├── QUICK-REFERENCE.md
│   └── SYSTEM-SUMMARY.md
│
├── rules/             # Delegator system (GPT experts)
├── preferences.md     # Global behavioral preferences
└── settings.json      # Claude Code settings
```

---

## Module 1: Task Writer

**Purpose**: Transform raw task descriptions into complete, workflow-ready task documents.

### Agent
- **task-refiner** - Interviews you, asks clarifying questions, generates task.md

### Skill
- **`/prepare-task <description>`** - Interactive task document creation

### What It Does
1. Asks systematic questions (goal, context, phases, criteria)
2. Suggests best practices (supervisor, outer Ralph, agents)
3. Generates complete task.md
4. Validates before saving

### Example

```bash
# Start with rough idea
/prepare-task "Add JWT authentication with role-based access"

# Agent asks questions
Agent: What exists today? No auth at all, or partial?
You: No auth currently.

Agent: What needs protection? All endpoints or specific ones?
You: All endpoints except /health and /docs

# Agent generates complete task.md
Agent: ✓ Task document saved: ~/auth-task.md

# Ready to execute
/workflow ~/auth-task.md
```

### When to Use
- Have rough idea, need structure
- Unsure how to break down complex task
- Want guidance on best practices
- First time using workflow system

---

## Module 2: Workflow

**Purpose**: Execute structured workflows with plan mode, supervisor oversight, and quality assurance.

### Agents

| Agent | Role |
|-------|------|
| **orchestrator** | Top-level coordinator, manages phases/tasks |
| **supervisor** | Detects conflicts (architecture, dependencies, API) |
| **task-executor** | Executes single task with Ralph loop |
| **outer-ralph** | Final quality pass (code, docs, security, tests) |

### Skill
- **`/workflow <task-doc.md>`** - Execute complete workflow

### What It Does

**Phase 1: Plan Mode** (mandatory)
- Parse task document
- Explore codebase
- Ask ALL questions upfront
- Wait for user approval

**Phase 2: Execution** (phase → task → Ralph loop)
- Supervisor pre-check (architecture, dependencies)
- Task Ralph loop (implement → verify → review → learn)
- Supervisor post-check (conflicts, patterns)
- Commit and checkpoint

**Phase 3: Outer Ralph** (final quality)
- Scan all changes
- Fix code quality, docs, security, tests
- Verify success criteria
- Generate report

**Phase 4: Completion**
- Create milestone issues per phase
- Generate comprehensive report
- Create PR

### Example

```bash
# Run workflow with task document
/workflow ~/auth-task.md

# System asks questions upfront
System: [Plan mode]
- Should JWT tokens expire? If yes, how long?
- What user roles: just authenticated/unauthenticated, or admin/user?

# After approval, executes automatically
System: [Phase 1/3] Task 1.1: Create User model... ✓
System: [Phase 1/3] Task 1.2: Implement JWT auth... ✓
System: [Supervisor] Checking for conflicts... PASS
System: [Phase 2/3] Task 2.1: Add auth middleware... ✓
...
System: [Outer Ralph] Improving code quality... 7 improvements applied
System: [Complete] PR created: https://github.com/.../pull/123
```

### Key Features

**Supervisor Oversight**:
- Pre-task: Catches architecture violations, dependency conflicts
- Post-task: Ensures pattern consistency, security
- Auto-fixes minor issues (naming, imports)
- Triggers re-planning for major conflicts

**Ralph Loops**:
- Task-level: Each task iterates until success criteria met
- Outer Ralph: Final quality pass for entire workflow

**Safety Bounds**:
- Max iterations per task (default: 30)
- Max cost (e.g., $10)
- Max time (e.g., 2h)
- Pauses and asks if limits approached

**Learning System**:
- Records patterns discovered
- Records antipatterns avoided
- Applies learnings to future tasks

---

## Module 3: Shared

**Purpose**: Reusable agents, skills, and hooks used by task-writer and workflow modules (and available for general use).

### Agents (15+ general-purpose)

**Code & Engineering**:
- `code-improvement-scanner` - Scans for code quality issues
- `ai-engineer` - AI/ML development specialist
- `cli-developer` - CLI tool development
- `build-engineer` - Build systems and CI/CD

**Documentation & Analysis**:
- `documentation-engineer` - Technical documentation
- `api-documenter` - API documentation
- `research-analyst` - Research and analysis

**Domain-Specific**:
- `fintech-engineer` - Financial systems
- `quant-analyst` - Quantitative analysis
- `risk-manager` - Risk assessment

**Review & Quality**:
- `code-reviewer` - Code review
- `architect-reviewer` - Architecture review
- `debugger` - Debugging assistance

**Workflow Management**:
- `git-workflow-manager` - Git workflow automation
- `dependency-manager` - Dependency management

### Skills

- **`/compact`** - Compact context and checkpoint state
- **`/milestone`** - Create GitHub milestone issues

### Hooks

- **check-milestone.sh** - Verify milestone completion
- **format-python.sh** - Auto-format Python code

### When to Use

These are available for:
- Direct invocation (e.g., `/compact`)
- Use by workflow and task-writer modules
- Custom workflows and automation
- General development tasks

---

## Usage Patterns

### Pattern 1: Structured Workflow (Recommended)

```bash
# 1. Create task document
/prepare-task "Build user management system"

# 2. Execute workflow
/workflow ~/user-management-task.md

# Result: Complete implementation with quality assurance
```

### Pattern 2: Manual Task Document

```bash
# 1. Copy template
cp workflow/task-template.md ~/my-task.md

# 2. Fill in manually (see examples/)

# 3. Execute workflow
/workflow ~/my-task.md
```

### Pattern 3: Quick Task (Skip Task Document)

```bash
# For simple, well-defined tasks
/workflow --inline "Add input validation to /api/users endpoint"

# System generates minimal task.md and executes
```

### Pattern 4: Use Shared Agents Directly

```bash
# Scan code quality without full workflow
Task({
  subagent_type: "code-improvement-scanner",
  prompt: "Scan src/ for code quality issues"
})

# Create milestone issue
/milestone "Phase 1 Complete"
```

---

## Installation

### Option 1: Use from Repository

```bash
# Clone repository
git clone https://github.com/yourusername/base-claude.git ~/.claude

# Skills will be available as /prepare-task and /workflow
```

### Option 2: Copy to Global Directory

```bash
# Copy task-writer module
cp -r task-writer ~/.claude/

# Copy workflow module
cp -r workflow ~/.claude/

# Copy shared module
cp -r shared ~/.claude/

# Copy docs and preferences
cp -r docs preferences.md settings.json ~/.claude/
```

### Option 3: Symlink (Advanced)

```bash
# Symlink entire repo
ln -s /path/to/base-claude ~/.claude
```

---

## Documentation

### Task Writer
- **task-writer/skill.md** - `/prepare-task` documentation
- **task-writer/agents/task-refiner.md** - Agent specification

### Workflow
- **workflow/WORKFLOW-GUIDE.md** - Comprehensive workflow guide
- **workflow/task-template.md** - Task document template
- **workflow/examples/** - Example task documents

### Shared
- **docs/STATE-SCHEMA.md** - State management schema
- **docs/QUICK-REFERENCE.md** - Quick reference guide
- **preferences.md** - Global behavioral preferences

---

## Key Concepts

### Task Document
Structured markdown file defining:
- Goal (one clear sentence)
- Context (current state, problem, constraints)
- Phases and tasks
- Success criteria (global and per-task)
- Agents needed
- Supervisor configuration
- Outer Ralph configuration
- Safety bounds

### Plan Mode
Mandatory upfront phase:
- Explore codebase
- Identify ALL unclear requirements
- Ask ALL questions in ONE interaction
- Wait for user approval
- Then execute

### Supervisor
Conflict detection system:
- Pre-task: Check for architecture violations, dependencies
- Post-task: Verify pattern consistency, security
- Actions: PASS, AUTO_FIX (minor), RE_PLAN (major)

### Ralph Loop
Iterative improvement cycle:
- Task-level: Implement → Verify → Review → Learn → Retry
- Outer Ralph: Final quality pass for entire workflow

### Safety Bounds
Prevent runaway execution:
- Max iterations per task
- Max cost (API usage)
- Max time
- Pause and ask if limits approached

---

## Examples

### Simple: Input Validation

**Time**: 30 minutes
**Cost**: ~$1

```bash
/prepare-task "Add input validation to API endpoints"
# Agent asks: Which endpoints? What validation?
# Generates: 1 phase, 2 tasks

/workflow ~/input-validation-task.md
# Executes, runs outer Ralph, creates PR
```

### Medium: User Authentication

**Time**: 2-3 hours
**Cost**: ~$5

```bash
/prepare-task "Add JWT authentication with role-based access"
# Agent asks about: Auth method, roles, protected routes
# Generates: 3 phases, 6 tasks

/workflow ~/auth-task.md
# Executes with security audits, creates PR
```

### Complex: Multi-Tenant SaaS

**Time**: 6-8 hours (multiple sessions)
**Cost**: ~$15-20

```bash
/prepare-task "Build multi-tenant SaaS platform with analytics"
# Agent asks 15+ questions, suggests Architect consultation
# Generates: 5 phases, 12 tasks, comprehensive plan

/workflow ~/saas-task.md
# Executes with supervisor oversight, GPT expert consultations
# Multiple checkpoints, outer Ralph with 15+ improvements
# Creates PR with detailed report
```

---

## Best Practices

1. **Start with /prepare-task** - Don't write task.md manually
2. **Answer questions thoroughly** - Better input = better task document
3. **Review task document before executing** - It's editable markdown
4. **Trust the supervisor** - Re-plan when major conflicts detected
5. **Enable outer Ralph** - Final quality pass catches issues
6. **Use safety bounds** - Prevent runaway costs/time
7. **Learn from workflows** - Check learnings.jsonl for patterns

---

## Troubleshooting

### Task Document Issues

**Problem**: Task document rejected by workflow
**Solution**: Use `/prepare-task` to generate valid document

**Problem**: Success criteria too vague
**Solution**: Make them specific and testable (e.g., "tests pass" not "works well")

### Workflow Issues

**Problem**: Stuck in plan mode
**Solution**: Answer questions and explicitly approve

**Problem**: Task executor fails repeatedly
**Solution**: Supervisor should trigger re-plan after 2 failures

**Problem**: Cost exceeded
**Solution**: Reduce proactive GPT delegations or extend budget

### Module Confusion

**Problem**: Which agent to use?
**Solution**:
- Task-writer agents: Creating task documents
- Workflow agents: Executing workflows
- Shared agents: General-purpose tasks

---

## Migration Guide

### From Old Structure

If you have the old flat structure:

```bash
# Old (flat)
~/.claude/
├── agents/          # Mixed
├── skills/          # Mixed
├── templates/       # Mixed
└── ...

# New (modular)
~/.claude/
├── task-writer/     # Task creation
├── workflow/        # Workflow execution
├── shared/          # Utilities
└── ...
```

**Steps**:
1. Backup old structure: `cp -r ~/.claude ~/.claude.backup`
2. Clone new structure: `git clone ... ~/.claude`
3. Migrate custom agents to `shared/agents/`
4. Update any custom skills to reference new paths

---

## Contributing

This repository is modular by design:

- **Add agents**: Place in appropriate module (task-writer, workflow, or shared)
- **Add skills**: Place in module-specific directory or shared/skills/
- **Add examples**: workflow/examples/
- **Update docs**: Keep module-specific docs in module, global docs in docs/

---

## License

MIT

---

## Support

- **Task Writer Guide**: task-writer/skill.md
- **Workflow Guide**: workflow/WORKFLOW-GUIDE.md
- **State Schema**: docs/STATE-SCHEMA.md
- **Examples**: workflow/examples/
- **Issues**: GitHub issues

---

**Get Started**:

```bash
# Create your first task
/prepare-task "your task description"

# Execute it
/workflow ~/your-task.md
```

🚀 Happy Automating!
