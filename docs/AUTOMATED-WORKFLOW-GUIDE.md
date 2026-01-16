# Automated Workflow System Guide

Complete autonomous workflow execution with multi-agent coordination, Ralph loops, and GPT expert delegation.

## Quick Start

### Option 1: Ralph Self-Improvement
```bash
/ralph
```

Autonomously scans and fixes code quality issues.

### Option 2: Custom Automated Task
```bash
# 1. Create task document from template
cp ~/.claude/templates/automated-task-template.md my-task.md

# 2. Fill in details (goal, criteria, bounds)

# 3. Launch
/automated-workflow my-task.md
```

### Option 3: Interactive with Plan Mode
```bash
# Just describe what you want
"Add user authentication feature"

# System will:
# 1. Enter plan mode (automatic)
# 2. Create multi-phased plan
# 3. List unresolved questions
# 4. Wait for approval
# 5. Execute autonomously
```

---

## System Architecture

```
Global Preferences (~/.claude/preferences.md)
         ↓
    ┌────────────────────┐
    │ Claude (Main)      │
    │ - Enforces prefs   │
    │ - Routes tasks     │
    └─────┬──────────────┘
          │
    ┌─────┴─────────────────────────┐
    │                               │
    ▼                               ▼
┌─────────────┐            ┌──────────────┐
│ Stand-by    │            │ Automated    │
│ Mode        │            │ Mode         │
│             │            │              │
│ Interactive │            │ Autonomous   │
│ Exploration │            │ Execution    │
└─────────────┘            └──────┬───────┘
                                  │
                    ┌─────────────┼─────────────┐
                    │             │             │
                    ▼             ▼             ▼
            ┌───────────┐  ┌──────────┐  ┌─────────┐
            │Workflow   │  │Ralph     │  │Custom   │
            │Orchestr.  │  │Improver  │  │Agents   │
            └─────┬─────┘  └────┬─────┘  └────┬────┘
                  │             │             │
                  └─────────────┴─────────────┘
                                │
                    ┌───────────┼────────────┐
                    │           │            │
                    ▼           ▼            ▼
            ┌──────────┐  ┌─────────┐  ┌──────────┐
            │GPT       │  │GPT Code │  │GPT Sec   │
            │Architect │  │Reviewer │  │Analyst   │
            └──────────┘  └─────────┘  └──────────┘
```

---

## Key Components

### 1. Global Preferences
**File**: `~/.claude/preferences.md`

Defines behavior across all sessions:
- Communication style (extreme conciseness)
- Workflow patterns (always plan mode)
- GitHub integration (CLI, branch naming, milestone issues)
- Context management (auto-compact at milestones)
- Multi-agent coordination (delegation rules)

### 2. Agents

**Workflow Orchestrator** (`workflow-orchestrator.md`)
- Manages end-to-end automated execution
- Coordinates subagents
- Enforces safety bounds
- Creates milestone issues
- Delegates to experts

**Ralph Improver** (`ralph-improver.md`)
- Self-improving code quality loop
- Scans → Prioritizes → Fixes → Verifies → Reviews
- Learns from outcomes
- Adapts strategy based on feedback

**Code Improvement Scanner** (user-created)
- Finds code quality issues
- Returns prioritized list

### 3. Skills

**`/automated-workflow`** - Launch full workflow from task doc
**`/ralph`** - Start Ralph self-improvement loop
**`/milestone-issue`** - Create GitHub milestone issue
**`/compact-checkpoint`** - Save state and compact context

### 4. Hooks

**Post-Edit** - Auto-format Python files
**Post-TodoWrite** - Check milestone conditions

---

## Workflow Modes

### Stand-by Mode (Default)
Interactive. You control the flow.

Use when:
- Exploring codebase
- Asking questions
- Reviewing code
- Making quick edits

### Automated Mode
Autonomous. AI runs until done.

Use when:
- Clear goal defined
- Success criteria known
- Can run unsupervised
- Want hands-off execution

Switch modes:
```bash
# Enter automated
/automated-workflow task.md

# Return to stand-by
User interrupts or workflow completes
```

---

## Planning System

### Automatic Plan Mode

Every implementation task triggers plan mode:
1. System detects implementation request
2. Enters plan mode automatically
3. Explores codebase
4. Creates multi-phased plan
5. Lists unresolved questions
6. Waits for approval

### Plan Structure

```markdown
# Implementation Plan

## Phase 1: Foundation
- [ ] Setup
- [ ] Dependencies

## Phase 2: Core
- [ ] Feature A
- [ ] Feature B

## Phase 3: Testing
- [ ] Unit tests
- [ ] Integration tests

## Phase 4: Documentation
- [ ] API docs
- [ ] Examples

## Unresolved Questions
1. Should we use JWT or sessions?
2. Redis or in-memory cache?

[If none: "None. Ready to proceed."]
```

---

## GitHub Integration

### Branch Management (Automatic)

Before any edit:
```bash
# Check branch
current=$(git branch --show-current)

# Create if on main
if [[ "$current" == "main" ]]; then
  git checkout -b "feature/task-name"
fi
```

Naming convention:
- `feature/` - New features
- `fix/` - Bug fixes
- `docs/` - Documentation
- `refactor/` - Code refactoring
- `test/` - Tests

### Milestone Issues (Automatic)

Created at:
- Each plan phase completion
- Every 5 TODOs complete
- Major checkpoints

Format:
```markdown
# Milestone: Phase 2 Complete

## Current Plan
[Relevant section]

## Completed
- [x] TODO 1
- [x] TODO 2

## Next Steps
- [ ] TODO 3
- [ ] TODO 4

## Metrics
Time: 45m | Cost: $3.20 | Files: 5
```

### Pull Requests (Automatic)

Created at workflow completion:
```bash
gh pr create \
  --title "feat: add authentication" \
  --body "Summary\n\nTesting\n\nMilestones: #120, #121, #122"
```

---

## Context Management

### Auto-Compaction

Triggers after:
- TODO completion
- Phase completion
- Every 10 tool calls
- Before expert delegation
- Before milestone issue

Process:
1. Save checkpoint to `.claude/checkpoint.json`
2. Run `/compact`
3. Verify state preserved

### What's Preserved
- Current phase/iteration
- Completed vs pending TODOs
- Cost/time metrics
- Plan structure
- Unresolved questions
- Learnings

### What's Discarded
- Detailed exploration
- Intermediate file contents
- Old error messages
- Verbose logs

---

## Multi-Agent Coordination

### Agent State File
`.claude/agent-state.json`:
```json
{
  "orchestrator": {
    "status": "executing",
    "phase": 2,
    "iteration": 15,
    "cost": 3.45
  },
  "completed_todos": ["Fixed auth", "Added tests"],
  "pending_todos": ["Update docs"]
}
```

Updated in real-time.

### Resource Locking
`.claude/locks.json`:
```json
{
  "src/auth.py": {
    "agent": "code-improver",
    "timestamp": "2026-01-15T12:30:00Z"
  }
}
```

Prevents conflicts when multiple agents run in parallel.

### Delegation Protocol

Auto-delegate to GPT experts:
- Architecture decision → Architect
- Security concern → Security Analyst
- Code quality → Code Reviewer
- After 2+ failures → Architect

Process:
1. Detect trigger
2. Read expert prompt file
3. Build 7-section delegation prompt
4. Call `mcp__codex__codex`
5. Synthesize response
6. Apply recommendation

---

## Learning System

### Learning Database
`~/.claude/learnings.jsonl` (append-only):
```json
{"action": "Fixed SQL injection", "pattern": "Parameterize queries", "success": true}
{"action": "Refactored auth", "pattern": "Extract to separate module", "success": false}
```

### Query Before Action
```bash
grep "SQL injection" ~/.claude/learnings.jsonl
```

If match found → Apply learned pattern.

### Update After Action
Record outcome. Mark pattern as "use" or "avoid".

---

## Safety System

### Bounds (Enforced Automatically)
- Max iterations: 50
- Max cost: $10
- Max time: 2h
- Max files per iteration: 10

### Checkpointing
Before each phase:
```bash
git stash push -m "checkpoint-phase-2"
```

On failure:
```bash
git stash pop  # Rollback
```

### Escalation
Pause and ask if:
- Security vulnerability
- 3+ test failures
- Ambiguous requirements
- 80% budget used
- Time limit approaching

---

## Communication Style

**Extreme conciseness. Sacrifice grammar.**

Format:
```
[12:30] Scanning...
[12:31] Found 5 issues
[12:32] Fixing auth.py:45
[12:33] Tests passed. Committed.
```

Commit messages:
```
feat: add auth
fix: SQL injection in auth
docs: update API guide
```

No explanations unless asked.

---

## Example Workflows

### Example 1: Ralph Self-Improvement
```bash
$ /ralph

[12:00] Scanning...
[12:01] Found 12 issues: 3 high, 5 med, 4 low
[12:02] Fixing: SQL injection (auth.py:45)
[12:03] Tests passed
[12:04] Code review: APPROVED
[12:04] Committed: abc123
[12:04] Compacted. 1/12 complete
[12:05] Next: Input validation (api.py:120)
...
[14:30] All 12 issues fixed
[14:30] PR created: #123
[14:30] Time: 2h 30m | Cost: $7.45
```

### Example 2: Feature Implementation
```bash
$ cat add-auth.md
# Goal: Add JWT authentication

$ /automated-workflow add-auth.md

[12:00] Entering plan mode...
[12:05] Plan complete:
  Phase 1: Setup (JWT lib, config)
  Phase 2: Auth routes
  Phase 3: Middleware
  Phase 4: Tests
  Questions: Redis for tokens?
[User answers questions]
[12:10] Approved. Starting Phase 1...
[12:15] Phase 1 complete. Issue #120
[12:15] Compacted
[12:16] Starting Phase 2...
...
[14:00] All phases complete
[14:00] PR created: #124
[14:00] Milestones: #120, #121, #122, #123
```

### Example 3: Bug Fix with Expert Delegation
```bash
User: "Fix authentication bug"

[12:00] Entering plan mode...
[12:01] Analyzing auth flow...
[12:02] Detected: Complex security issue
[12:02] Delegating to Security Analyst...
[12:05] Analyst found: Token validation flaw
[12:05] Implementing fix...
[12:06] Tests passed
[12:07] Delegating to Code Reviewer...
[12:08] Reviewer: APPROVED
[12:08] Committed: fix: token validation
[12:08] Compacted
[12:08] Complete
```

---

## Troubleshooting

### Workflow Stuck
Check agent state:
```bash
cat .claude/agent-state.json
```

### Context Too Large
Manually compact:
```
/compact
```

### Hooks Not Running
Make executable:
```bash
chmod +x ~/.claude/hooks/*.sh
```

Verify settings.json has hooks configured.

### Expert Delegation Failing
Check MCP server:
```bash
# Verify codex MCP running
mcp list
```

### Learnings Not Applied
Check file:
```bash
tail ~/.claude/learnings.jsonl
```

Ensure append-only log working.

---

## Configuration

### Override Global Preferences

**Project-level**: `.claude/project-preferences.md`
**Task-level**: In automated task doc under "Behavioral Overrides"

Priority: Task > Project > Global

### Custom Agents

Create in `.claude/agents/my-agent.md`

### Custom Skills

Create in `.claude/skills/my-skill.md`

### Custom Hooks

Create in `~/.claude/hooks/my-hook.sh`
Add to `.claude/settings.json`

---

## Tips

1. **Use Ralph for maintenance** - Regular code quality sweeps
2. **Use automated workflow for features** - Clear goal, known criteria
3. **Use stand-by for exploration** - Unknown territory
4. **Let plan mode happen** - Don't skip planning
5. **Trust the compaction** - Checkpoints preserve critical state
6. **Check milestone issues** - Track progress
7. **Review learnings** - Build institutional memory
8. **Set realistic bounds** - Start conservative, increase gradually

---

## Status

Workflow system active. All components loaded.

Run `/ralph` or `/automated-workflow` to start.
