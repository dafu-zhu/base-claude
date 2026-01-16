# Base Claude

Modular automation system for Claude Code with task writing, workflow execution, and shared utilities.

## Quick Start

```bash
# 1. Create task document (interactive)
/prepare-task "Add user authentication to the API"

# 2. Execute workflow
/workflow ~/auth-task.md
```

## Architecture

```
base-claude/
├── task-writer/       # Task document creation
├── workflow/          # Workflow execution
├── shared/            # Shared utilities
├── docs/              # Documentation
└── rules/             # GPT expert integration
```

## Modules

| Module | Purpose | Command | Key Components |
|--------|---------|---------|----------------|
| **task-writer** | Transform raw descriptions → complete task.md | `/prepare-task <description>` | Agent: task-refiner<br>Skill: /prepare-task |
| **workflow** | Execute structured workflows with quality assurance | `/workflow <task.md>` | Agents: orchestrator, supervisor, task-executor, outer-ralph<br>Skill: /workflow<br>Template, examples, guide |
| **shared** | Reusable utilities for all modules | Direct invocation | 15+ agents, 2 skills, 2 hooks |

## Module Details

### Task Writer

**Purpose**: Interview you about requirements, generate complete task.md file

**What it does**:
1. Asks systematic questions (goal, context, phases, success criteria)
2. Suggests best practices (supervisor, outer Ralph, agents)
3. Validates completeness
4. Saves workflow-ready task.md

**When to use**:
- Have rough idea, need structure
- Unsure how to break down complex task
- Want guidance on best practices

**Example**:
```bash
/prepare-task "Add JWT authentication with role-based access"
# Agent: What exists today?
# You: No auth currently
# Agent: What needs protection?
# You: All endpoints except /health
# Agent: ✓ Task saved: ~/auth-task.md
```

### Workflow

**Purpose**: Execute multi-phase workflows with supervisor oversight and quality assurance

**Agents**:

| Agent | Role |
|-------|------|
| orchestrator | Top-level coordinator, manages phases/tasks |
| supervisor | Detects conflicts (architecture, dependencies, API) |
| task-executor | Executes single task with Ralph loop |
| outer-ralph | Final quality pass (code, docs, security, tests) |

**Execution phases**:
1. **Plan Mode** - Explore codebase, ask questions, get approval
2. **Execution** - Supervisor checks → Task Ralph loops → Commit/checkpoint
3. **Outer Ralph** - Final quality improvements
4. **Completion** - Create milestone issues, generate report, create PR

**Key features**:
- **Supervisor**: Catches conflicts early, auto-fixes minor issues, triggers re-planning for major conflicts
- **Ralph Loops**: Task-level iteration + outer quality pass
- **Safety Bounds**: Max iterations, cost, time limits
- **Learning System**: Records patterns, applies to future tasks

**Example**:
```bash
/workflow ~/auth-task.md
# [Plan mode] Should tokens expire? How long?
# [Phase 1/3] Task 1.1: Create User model... ✓
# [Supervisor] Checking conflicts... PASS
# [Outer Ralph] 7 improvements applied
# ✓ PR created
```

### Shared

**Purpose**: General-purpose utilities used by all modules

**Agents (15+)**:

| Category | Agents |
|----------|--------|
| **Code & Engineering** | code-improvement-scanner, ai-engineer, cli-developer, build-engineer |
| **Documentation** | documentation-engineer, api-documenter, research-analyst |
| **Domain-Specific** | fintech-engineer, quant-analyst, risk-manager |
| **Review & Quality** | code-reviewer, architect-reviewer, debugger |
| **Workflow Management** | git-workflow-manager, dependency-manager |

**Skills**: `/compact` (context compaction), `/milestone` (GitHub milestones)

**Hooks**: check-milestone.sh, format-python.sh

## Usage Patterns

| Pattern | Command | Use When | Example |
|---------|---------|----------|---------|
| **Structured Workflow**<br>(Recommended) | `/prepare-task` → `/workflow` | Most tasks | `/prepare-task "Build user mgmt"`<br>`/workflow ~/task.md` |
| **Manual Task Doc** | Copy template → edit → `/workflow` | Familiar with format | `cp workflow/task-template.md ~/task.md`<br>`/workflow ~/task.md` |
| **Quick Inline** | `/workflow --inline` | Simple, well-defined tasks | `/workflow --inline "Add validation"` |
| **Direct Agents** | Invoke agent directly | Single-purpose utility | `Task({subagent: "code-scanner", ...})` |

## Installation

### Quick Install (Global)

```bash
# Clone base-claude to a permanent location
git clone https://github.com/dafu-zhu/base-claude.git ~/Documents/GitHub/base-claude

# Run installer (preserves existing ~/.claude data, creates symlinks)
~/Documents/GitHub/base-claude/scripts/install-global.sh
```

**Note**: Keep the source directory - symlinks point to it.

### Project-Only Install

```bash
# In your project directory
git clone https://github.com/dafu-zhu/base-claude.git .base-claude-src
.base-claude-src/scripts/install-project.sh
```

### What Gets Installed

| Location | Contents |
|----------|----------|
| `commands/` | `/workflow`, `/prepare-task`, `/compact`, `/milestone` |
| `agents/` | 20 agents (orchestrator, supervisor, task-executor, etc.) |
| `skills/` | Skill documentation |
| `templates/` | Task document template |
| `examples/` | Simple and complex examples |
| `rules/` | GPT expert delegation rules |

See [INSTALL.md](docs/INSTALL.md) for detailed installation options.

## Examples

| Complexity | Task | Time | Cost | Command |
|------------|------|------|------|---------|
| **Simple** | Input validation | 30 min | ~$1 | `/prepare-task "Add validation"`<br>→ 1 phase, 2 tasks |
| **Medium** | User authentication | 2-3 hrs | ~$5 | `/prepare-task "Add JWT auth"`<br>→ 3 phases, 6 tasks |
| **Complex** | Multi-tenant SaaS | 6-8 hrs | ~$15-20 | `/prepare-task "Build SaaS platform"`<br>→ 5 phases, 12 tasks |

## Key Concepts

| Concept | Description |
|---------|-------------|
| **Task Document** | Structured markdown defining goal, phases, tasks, success criteria, agents, supervisor config, safety bounds |
| **Plan Mode** | Mandatory upfront phase: explore codebase, ask ALL questions, get approval, then execute |
| **Supervisor** | Conflict detection system: pre/post-task checks, auto-fix minor issues, trigger re-plan for major conflicts |
| **Ralph Loop** | Iterative improvement: Implement → Verify → Review → Learn → Retry (task-level + outer quality pass) |
| **Safety Bounds** | Prevent runaway execution: max iterations/cost/time, pause and ask if limits approached |

## Documentation

| Topic | Location |
|-------|----------|
| **Task Writer** | task-writer/skill.md, task-writer/agents/task-refiner.md |
| **Workflow** | docs/WORKFLOW-GUIDE.md, workflow/task-template.md, workflow/examples/ |
| **Shared** | docs/STATE-SCHEMA.md |
| **Architecture** | docs/ARCHITECTURE.md |

## Best Practices

1. **Start with /prepare-task** - Don't write task.md manually
2. **Answer questions thoroughly** - Better input = better task document
3. **Review before executing** - Task.md is editable markdown
4. **Trust the supervisor** - Re-plan when conflicts detected
5. **Enable outer Ralph** - Final quality pass catches issues
6. **Use safety bounds** - Prevent runaway costs/time

## Troubleshooting

| Problem | Solution |
|---------|----------|
| Task document rejected | Use `/prepare-task` to generate valid document |
| Success criteria too vague | Make specific and testable ("tests pass" not "works well") |
| Stuck in plan mode | Answer questions and explicitly approve |
| Task executor fails repeatedly | Supervisor should trigger re-plan after 2 failures |
| Cost exceeded | Reduce proactive GPT delegations or extend budget |
| Module confusion | task-writer = create docs, workflow = execute, shared = utilities |

## Migration from Old Structure

```bash
# Backup old structure
cp -r ~/.claude ~/.claude.backup

# Clone new modular structure
git clone <repo> ~/.claude

# Migrate custom agents
mv ~/.claude.backup/custom-agent.md ~/.claude/shared/agents/

# Update custom skills to reference new paths
```

## Contributing

| Add | Location |
|-----|----------|
| Agents | task-writer/agents/, workflow/agents/, or shared/agents/ |
| Skills | Module-specific or shared/skills/ |
| Examples | workflow/examples/ |
| Docs | Module-specific or docs/ |

## Support

- **Guides**: task-writer/skill.md, docs/WORKFLOW-GUIDE.md
- **Reference**: docs/STATE-SCHEMA.md, docs/ARCHITECTURE.md
- **Examples**: workflow/examples/
- **Issues**: GitHub issues

## License

MIT

**Get Started**:

```bash
/prepare-task "your task description"
/workflow ~/your-task.md
```

🚀 Happy Automating!
