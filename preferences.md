# Global Behavioral Preferences

## Communication Style

**CRITICAL: Extreme conciseness. Sacrifice grammar.**

### Format Rules
- Fragments only. No full sentences.
- No articles (a, an, the)
- No filler words
- Immediate action verbs
- Timestamp format for updates

### Examples
❌ "I will now proceed to scan the codebase"
✓ "Scanning..."

❌ "I have found 5 issues that need attention"
✓ "Found 5 issues"

### Commit Messages
- Format: `type: brief description`
- No periods, no explanations
- Examples:
  - `feat: add auth`
  - `fix: SQL injection in auth.py`
  - `docs: update API guide`

### Status Updates
```
[12:30] Scanning...
[12:31] Found 5 issues
[12:32] Fixing auth.py:45
[12:33] Tests passed. Committed.
```

---

## Workflow Patterns

### Planning Requirement
**MANDATORY: Always enter plan mode before implementation.**

Process:
1. User requests implementation
2. Enter plan mode (use EnterPlanMode tool)
3. Explore codebase
4. Create multi-phased plan
5. List unresolved questions at end
6. Get user approval
7. ONLY THEN implement

Exceptions (ONLY):
- Single-line typo
- Adding debug log
- User says "skip planning"

### Plan Structure (REQUIRED)
```markdown
# Implementation Plan

## Phase 1: [Foundation/Setup]
- [ ] Task 1
- [ ] Task 2

## Phase 2: [Core Implementation]
- [ ] Task 1
- [ ] Task 2

## Phase 3: [Testing/Verification]
- [ ] Task 1
- [ ] Task 2

## Phase 4: [Documentation/Cleanup]
- [ ] Task 1
- [ ] Task 2

## Unresolved Questions
1. Question 1?
2. Question 2?

[If no questions: "None. Ready to proceed."]
```

---

## GitHub Workflow

### Primary Tool
**Use GitHub CLI (gh) for all GitHub operations.**

Never use web UI or git remote commands when gh available.

### Branch Naming (MANDATORY)
```
feature/[description]  - New features
fix/[description]      - Bug fixes
docs/[description]     - Documentation
refactor/[description] - Code refactoring
test/[description]     - Test additions
chore/[description]    - Maintenance
```

Before any codebase edit:
1. Check current branch
2. If on main/master → Create new branch
3. Use appropriate prefix

### Milestone Issues (AUTOMATIC)
Create GitHub issue at each milestone:
- Completed TODO
- Completed plan phase
- Major checkpoint

Issue format:
```markdown
# Milestone: [Name]

## Current Plan
[Copy relevant plan section]

## Completed TODOs
- [x] Task 1
- [x] Task 2

## Next Steps
- [ ] Task 3
- [ ] Task 4

## Status
Phase X/Y complete. [Brief status]
```

Command:
```bash
gh issue create --title "Milestone: [name]" --body "$(cat milestone.md)"
```

---

## Context Management

### Compaction Triggers (AUTOMATIC)
Run `/compact` after:
- Completed TODO
- Completed plan phase
- Created milestone issue
- Before delegating to expert
- After 10+ tool calls

### Before Compaction
1. Save state to `.claude/checkpoint.json`
2. Run compact
3. Verify state preserved

---

## Decision-Making Patterns

### Delegation Rules
Auto-delegate to GPT expert when:
- Architecture decision → Architect
- Security concern → Security Analyst
- Code quality review → Code Reviewer
- Plan validation → Plan Reviewer
- Ambiguous requirements → Scope Analyst

After 2+ failed attempts → Architect

### Tool Preferences
1. gh (GitHub operations)
2. uv (Python package management)
3. ruff (formatting/linting)
4. pytest (testing)

Never use: pip, setuptools, black, flake8

---

## Automated Workflow System (Default)

**IMPORTANT: Use `/workflow` for all complex implementation tasks.**

### When to Use Workflow
- Complex tasks (3+ steps, multi-file changes)
- New features requiring architecture decisions
- Tasks requiring security review
- Multi-phase implementations
- When quality assurance critical

### Task Document Required
Template: `~/.claude/templates/task-template.md`
Examples: `~/.claude/examples/`

### Workflow Phases (Automatic)
1. **Plan Mode** (mandatory upfront)
   - Explore codebase
   - Ask ALL questions in ONE interaction
   - Get user approval
2. **Execution** (phase → task → Ralph loop)
   - Supervisor checks (pre/post task)
   - Parallel agents as needed
   - Checkpoints after each task
3. **Outer Ralph** (final quality pass)
   - Code quality scan
   - Documentation completeness
   - Security hardening
   - Test coverage improvements
4. **Completion**
   - Create milestone issues per phase
   - Generate comprehensive report
   - Create PR

### Supervisor Oversight (Automatic)
**Pre-task checks**:
- Architecture violations
- Cross-task dependencies
- API contract changes

**Post-task checks**:
- Pattern consistency (auto-fix minor issues)
- Security vulnerabilities
- Conflicts with pending tasks

**Actions**:
- PASS → Continue
- AUTO_FIX → Fix minor issues autonomously
- RE_PLAN → Major conflict, re-enter plan mode

### Safety Bounds (Default)
- Max iterations per task: 30
- Max cost: $10
- Max time: 2 hours
- Safety checks before each task

### Checkpointing (Automatic)
After:
- Each task completion
- Each phase completion
- Before supervisor interventions
- Before outer Ralph loop

### Learning (Automatic)
After each action, log to `.claude/learnings.jsonl`:
```json
{
  "timestamp": "2026-01-15T12:30:00Z",
  "task": "1.2",
  "iteration": 2,
  "type": "pattern",
  "lesson": "Always check existing patterns before implementing",
  "pattern": "Reuse existing modules",
  "context": "Authentication implementation"
}
```

Query before attempting similar tasks.

---

## Multi-Agent Coordination

### Agent Hierarchy
```
Orchestrator (you in automated mode)
├─ Task Agents (parallel)
│  ├─ code-improvement-scanner
│  ├─ test-runner
│  └─ security-auditor
└─ Expert Consultants (GPT via MCP)
   ├─ Architect
   ├─ Code Reviewer
   └─ Security Analyst
```

### Communication Protocol
Agents write to `.claude/agent-state.json`:
```json
{
  "agent_id": "code-improver",
  "status": "in_progress",
  "working_on": "src/auth.py",
  "completed": ["Fixed SQL injection"],
  "next_target": "src/api.py"
}
```

### Resource Locking
Before editing file:
1. Check `.claude/locks.json`
2. Add lock: `{"file": "auth.py", "agent": "code-improver", "timestamp": "..."}`
3. Edit
4. Remove lock

Other agents skip locked files.

---

## Ralph Loop Integration

### Self-Improvement Process
1. Scan with code-improvement-scanner
2. Prioritize issues
3. For each issue:
   - Create plan (if complex)
   - Implement fix
   - Run tests
   - Delegate to Code Reviewer
   - If approved → commit, next issue
   - If rejected → learn from feedback, retry
4. Compact context after each issue
5. Create milestone issue every 5 issues
6. Stop when success criteria met

### Learning Feedback
After each iteration:
- Record what worked
- Record what failed
- Update strategy for next iteration
- Apply learnings to similar issues

---

## Hooks (Automatic Behaviors)

### Post-Edit Hook
After Edit/Write on .py files:
```bash
ruff format "$file" && ruff check --fix "$file"
```

### Post-Commit Hook
After successful commit:
```bash
# Update milestone tracking
# Check if phase complete → create issue
# Compact context if needed
```

### Pre-Push Hook
Before push:
```bash
pytest && ruff check .
```

Only push if all pass.
